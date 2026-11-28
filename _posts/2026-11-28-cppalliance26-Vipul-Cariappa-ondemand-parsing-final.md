---
title: "On-Demand Parsing: Parse C++ only when you have to"
layout: post
excerpt: |
  Warp-up of my CppAlliance Fellowship 2026 project on defered parsing of
  function and class bodies in Clang until something actually needs them,
  what it took to put the parser back together.
sitemap: true
author: Vipul Cariappa
permalink: blogs/cppalliance26_Vipul_Cariappa_ondemand_parsing_final/
thumbnail_image: /images/cppalliance-logo.svg
date: 2026-11-28
tags: [cppalliance, clang, llvm, parsing, clang-repl, performance]
---

{% include dual-banner.html
left_logo="/images/cppalliance-logo.svg"
right_logo="/images/cr-logo_old.png"
caption=""
height="20vh" %}

```c++
#include <memory>   // unique_ptr, shared_ptr, weak_ptr, and everything they drag in

int main() {
    auto x = std::make_unique<int>(1);   // one of them is used
    return *x;
}
```

A typical translation unit pulls in a large number of
headers and uses a small fraction of what they declare, and the rest is still
turned into an AST, at the cost of time and memory, before being thrown away.
I spent my C++ Alliance Fellowship making Clang stop doing that: defer the body
of a function or a class definition until the first time something actually
needs it.

The result is two frontend flags, `-fparse-functions-ondemand` and
`-fparse-records-ondemand` (the second implies the first), both restricted to
incremental processing mode, *clang-repl*. Parsing the whole STL into
clang-repl and doing nothing with it gets **45% faster** and uses **12% less
memory**.

## Functions: borrowing MSVC's lazy templates

Clang already knows how to keep a function body as tokens and parse it later:
that is what `-fdelayed-template-parsing` does for MSVC compatibility. The
machinery is reused and generalized, so what changes is the condition and the
trigger, not the mechanism.

A function declaration is parsed eagerly and goes into the lookup table as
usual; the token range between the braces is recorded and the construct is
marked with `Sema::MarkAsLateParsedTemplate`. `Sema::MarkFunctionReferenced`
fires on first use and schedules the parse, and
`Sema::ActOnEndOfTranslationUnit` performs the parsing. Templated functions are parsed
at instantiation.

```c++
void foo() { printf("foo()\n"); }
void bar() { printf("bar()\n"); }

bar();   // foo keeps its declaration; its body never becomes an AST
```

Methods work the same way, because a method is a function. Virtual methods are
the interesting case: the vtable needs the address of every virtual function,
so `foo` below is parsed as soon as `A` is used, while its non-virtual sibling
still waits.

```c++
struct A {
  virtual void foo() {}
  void bar() {}
};

A a;   // constructing A needs the vtable, and so needs foo
```

## Classes: incomplete until someone asks

Records use the same trick. The declaration is parsed eagerly, inserted into
the lookup table and marked with `Sema::MarkAsLateParsedRecord`; the body,
`final`, the attributes and the base-clause included, is cached as tokens.
That leaves the record an *incomplete type*, which is the useful part: every
path in Clang that needs a complete type already funnels through
`Sema::RequireCompleteType`, so that is the one place where the stored tokens
have to be parsed.

```c++
struct Pointee { int a; };
struct Sized   { int b; };

Pointee *p;              // a pointer does not need the definition
int n = sizeof(Sized);   // sizeof does, and pays for exactly one body
```

Three paths want the members without asking whether the type is complete, and
each needed its own entry point: out-of-line definitions of methods, implicit
and explicit instantiation, and the implicit deduction guides built for CTAD.

## Putting the parser back together

A deferred class body is parsed in the middle of parsing something unrelated,
which turned out to be most of the work. The parser has to be restored to the
state the definition was written in, not the one it happens to be in:

- **Lexical scopes and declaration contexts.** Unqualified lookup walks this
  chain outwards, and the chain at the point of first use is the wrong one.
- **Lookup tables.** A function's local declarations are reachable only through
  the scope chain, so a member of a local class cannot see a local `typedef`
  until those declarations are put back by hand, and taken out again
  afterwards.
- **Floating-point pragma state**, as configured where the member was written.

**Example:**

```c++
#pragma STDC FP_CONTRACT ON
struct Contracted {
  float f(float a, float b, float c) { return a * b + c; }
};
#pragma STDC FP_CONTRACT OFF

__attribute__((used))
float use(Contracted w) { return w.f(1, 2, 3); }
```

`Contracted` is first used at `use`, where `FP_CONTRACT` is off.
Without restoring the pragma stack, `a * b + c` quietly computes something different.

## Name lookup has to pretend nothing moved

A deferred body is parsed after everything below it in the file has been seen,
so the lookup table holds entries the body must not be allowed to use.

```c++
static int foo(int) { return 1; }
static int bar() { return foo(0.0); }   // only foo(int) is visible here
static int foo(double) { return 2; }    // must not take part

__attribute__((used))
int main() { return printf("%d\n", bar()); }   // forces bar to be parsed here
```

Cached tokens carry their original source locations, so named-value lookup
became source-location aware: results written after the lookup point are
filtered out. A few things are exempt, because filtering them would change
the meaning of correct code:

- **Members of the class and its bases.** The complete-class rule says a member
  body sees the whole class, however late in it a name appears.
- **The lambda call operator.** The lambda is often written below the body that
  calls through it, and the filter would hide the only `operator()` there is.
- **Dependent names resolved during template argument substitution**, which are
  looked up where the argument is substituted, not where the template was
  written.

## Results

Wall time and peak RSS, net of each binary's start-up floor, mean of 10 runs
(3 for the test suite). *upstream* is a separate build of `release/23.x`, the
base branch of this work; *off* is the same feature branch with the flags disabled, and
it confirms the feature costs nothing when it is not asked for.

| Benchmark | upstream | off | on | delta |
|---|---|---|---|---|
| STL included, unused | 0.627 s / 75.4 MB | 0.628 s / 74.9 MB | **0.347 s / 66.1 MB** | **−45% / −12%** |
| cppjit start-up | 1.260 s / 166.5 MB | 1.270 s / 166.8 MB | **0.651 s / 158.1 MB** | **−48% / −5%** |
| everything used | 0.174 s / 33.0 MB | 0.175 s / 33.3 MB | 0.204 s / 44.5 MB | +17% / +35% |
| cppjit test suite | 41.82 s / 761.1 MB | 41.68 s / 761.1 MB | **38.49 s / 747.4 MB** | **−8% / −2%** |
{: .table .table-bordered}

The third row is the honest one. It is a generated header of ~20,000 lines
whose driver uses every single entity in it, so nothing can be skipped: the
memory goes into caching tokens that are all eventually parsed, and the time
goes into restoring the parser state once per deferred body. A realistic
mixture — cppjit's 674-test suite, the last row — still comes out ahead.

That last row is also the correctness check that mattered most. The benchmark runner
runs the suite all three ways and refuses to report a number unless all the three
reports agree in number of passing tests and expected failures. `check-clang` is green at 52,045 tests, with new lit
tests in `clang/test/Parser/ParseFunctionsOndemand.cpp` and
`ParseRecordsOndemand.cpp`, and the `Interpreter` lit tests run in on-demand
mode.

## Try it

A Compiler Explorer instance running an on-demand-enabled Clang is up at
[godbolt.vipulcariappa.xyz](https://godbolt.vipulcariappa.xyz/z/Y7EdeY). The
link opens a preconfigured session, so the examples above can be tried without
building anything.

## Where it stands

- [#210893](https://github.com/llvm/llvm-project/pull/210893), the main
  on-demand parsing feature, is open as a draft while the design is scoped for
  upstream.
- [#218129](https://github.com/llvm/llvm-project/pull/218129), stopping
  `extern "C"` declarations from being removed twice from the `IdResolver`.
- [#218149](https://github.com/llvm/llvm-project/pull/218149) keeps earlier
  declarations alive when an input fails, fixing the `CleanUpPTU` bug I had
  reported as [#201844](https://github.com/llvm/llvm-project/issues/201844) —
  a regression that broke CppInterOp and cppyy.
- [#219800](https://github.com/llvm/llvm-project/issues/219800), value printing
  a call to a `void` function silently discarding the call, has since been
  fixed by a community PR.

The full work lives on `dev/defered-parsing` in
[my LLVM fork](https://github.com/Vipul-Cariappa/llvm-project/tree/dev/defered-parsing).
Upstreaming it is a months-long endeavour, because it changes how source is
parsed at a fundamental level; the design discussion is anchored on the
[LLVM Discourse RFC](https://discourse.llvm.org/t/gsoc-2024-on-demand-parsing-in-clang/76912)
and has continued in PR review, where the open question is how to scope the
change so it lands non-intrusively in Clang.

**Beyond that:** covering what is still eager, a cheaper way to store and restore
parser state than re-entering every parent declaration for each deferred body.

## Related links

- [Fellowship initial presentation](/assets/presentations/VipulCariappa_OnDemandParsingInClang_IntroPresentation.pdf) (24 June 2026)
- [Fellowship midterm presentation](/assets/presentations/VipulCariappa_OnDemandParsingInClang_MidTermPresentation.pdf) (12 August 2026)
- [Fellowship final presentation](/assets/presentations/VipulCariappa-CRCon26-OnDemandParsingInClang.pdf) (4 November 2026)
- [Project branch](https://github.com/Vipul-Cariappa/llvm-project/tree/dev/defered-parsing)
- [On-demand Clang on Compiler Explorer](https://godbolt.vipulcariappa.xyz/z/Y7EdeY)

## Thanks

Thank you to my mentors, Vassil Vassilev and Aaron Jomy, for their guidance throughout, to the LLVM reviewers
whose feedback reshaped the scope of this work for the better, and to the C++
Alliance for supporting the fellowship.
