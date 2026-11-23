---
title: "Implementing Missing C and C++ Language Features in Clang: Final Report"
layout: post
excerpt: "A wrap-up of my C++ Alliance Fellowship 2026: what landed in Clang (C2y if/switch declarations and C++2d defaulted postfix operators), what got blocked (CTAD for alias templates and constexpr math) and why, and how the work impacted Clang."
sitemap: false
author: Muhammad Bassiouni
permalink: blogs/Implement_missing_C++26_features_in_Clang_Muhammad_Bassiouni_final_blog/
thumbnail_image: /images/cppalliance-logo.svg
date: 2026-11-23
tags: cppalliance Clang LLVM C C++ C2y C++20 C++2d if-declaration CTAD-alias-templates constexpr-math defaulted-postfix-operators
---

{% include dual-banner.html
left_logo="/images/cppalliance-logo.svg"
right_logo="/images/cr-logo_old.png"
caption=""
height="20vh" %}

## Introduction

I am Muhammad Bassiouni, a maintainer of [LLVM libc](https://libc.llvm.org/)
and a C++ Alliance Fellowship 2026 contributor. During the fellowship I worked
on implementing standards papers that `Clang` was still missing. This post
wraps up the project that I introduced in my
[announcement blog post](/blogs/Implement_missing_C++26_features_in_Clang_Muhammad_Bassiouni_blog/),
and follows the talk I gave at
[CompilerResearchCon 2026](/crcon2026/)
([slides](/assets/presentations/Muhammad_Bassiouni-CRCon26_Missing_C_and_CXX_Features_in_Clang.pdf)).

**Mentors**: Vassil Vassilev, Aaron Jomy

## The Fellowship at a Glance

The project was candidate-driven: I proposed the papers to implement, and
adjusted the plan as the upstream situation of each paper became clear. In the
end I worked on four papers:

| # | Paper | Feature | Outcome |
|---|-------|---------|---------|
| 1 | [C2y N3356](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n3356.htm) | Declarations in `if` / `switch` conditions | **Landed upstream** |
| 2 | [C++20 P1814R0](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2019/p1814r0.html) | CTAD for alias templates | Blocked: open core issue |
| 3 | C++23/26 constexpr `<cmath>` | constexpr math in `Clang` | Blocked: pending design |
| 4 | [C++2d P3668R4](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2026/p3668r4.html) | Defaulted postfix `++` / `--` | **Landed upstream** |

Two papers landed, and two were blocked for reasons outside of the
fellowship's control. When I presented the work at CRCon, the P3668R4 PR was
still under review; it has been merged since.

## C2y N3356: Declarations in `if` and `switch` Conditions

### What the paper adds

N3356 allows a declaration in the condition of `if` and `switch` statements in
`C`. It looks similar to the `C++17` feature, but it is not the same: the first
clause must be a declaration and can't be empty, and the second clause can only
be an expression. Because the first clause is a declaration, attributes and
declaration specifiers come along with it:

```c
if (bool x = true; x) {}
if (bool x = false) return x;
if ([[maybe_unused]] bool x = true) {}
if (int x = 3; x > 0) {}
if (struct A { int x; } a = {.x = 1}; a.x) {}
if (int arr[] = {1, 2, 3}; arr[1]) {}
if (static_assert(true); true) {}
if ([[]]; true) {}
if (auto x __attribute__((deprecated)) = 3) {}
if (__extension__ [[maybe_unused]] int x = 3;
    x > 0) {}

switch (int x = 1) {}
switch (auto x = 3) { default: x += 1; }
```

### How it was built

Rather than writing a new parser path, I reused the existing `C++17`
`if (init; cond)` and `switch (init; cond)` code paths in `Clang` and then
specialized them for `C`:

- the first clause must be a declaration, so expression statements are
  rejected there with dedicated diagnostics;
- the second clause is an expression only;
- `C` attributes, declaration specifiers and `__extension__` are supported.

### What landed in Clang

- **Merged upstream** in [#198244](https://github.com/llvm/llvm-project/pull/198244)
  (commit `226b0b5`) and [#209920](https://github.com/llvm/llvm-project/pull/209920)
  (commit `1387002`). The feature is complete per the paper wording and is part
  of `Clang` 24.
- **Available back to C89**: the new syntax works in every `C` mode `Clang`
  supports, with the appropriate compatibility warnings and extension
  diagnostics in modes older than `C2y`.
- **`__extension__` in C and C++ conditions**: it silences the extension
  diagnostics for the rest of the condition. This wasn't available in `C++`
  conditions before.
- **A new way to handle compatibility diagnostics**: the follow-up commit
  `1387002` introduced a new approach to emitting compatibility diagnostics in
  the parser.

One thing did not make it: GNU attribute declarations such as
`if (__attribute__((...)); true)`. `GCC` doesn't follow the paper wording here
yet, so we couldn't decide on the right behavior. `C23`-style attribute
declarations (`[[...]];`) did make it.

### Impact and follow-ups

Despite the heavy parser changes, the feature has held up well:

- **C89 to C2y**: the new syntax works in every `C` mode `Clang` supports.
- **No performance regressions**: Ezzeldin Ibrahim, who tracked `Clang`
  compile-time regressions during
  [his fellowship](/blogs/cppalliance26_ezzeldin_ibrahim_improve_clang_performance/),
  found that the new code performs as well as the old one.
- **Few user issues**: the first one,
  [#233839](https://github.com/llvm/llvm-project/issues/233839), pointed out
  that the shared condition parsing also accepted declarations in `while`
  loops, which N3356 does not allow. I fixed it in
  [#233908](https://github.com/llvm/llvm-project/pull/233908). Recently a
  second one, [#243727](https://github.com/llvm/llvm-project/issues/243727),
  reported a crash on `if (::0);` in `C`, because `C` conditions now reach a
  `C++`-only code path. The fix is under review in
  [#244055](https://github.com/llvm/llvm-project/pull/244055).

## What Got Blocked, and Why

### C++20 P1814R0: CTAD for alias templates

Class template argument deduction (CTAD), introduced in `C++17`, lets the
compiler work out a class template's arguments from its initializer, as it
already did for function templates:

```cpp
std::pair p(1, 2.0);       // std::pair<int, double>
std::vector v = {1, 2, 3}; // std::vector<int>
std::lock_guard lk(m);     // std::lock_guard<std::mutex>
```

Each constructor becomes an implicit deduction guide, the initializer goes
through overload resolution against those guides, and libraries can add
user-written guides for rules that constructors can't express.

P1814R0 extends CTAD to alias templates in `C++20`:

```cpp
template <typename T> struct A { A(T) {} };
template <typename T> using Proxy = T;
template <typename T> using C = Proxy<A<T>>;

C test{42}; // deduce C<int>
```

`Clang` had a basic implementation that was not stable: it rejected valid code
or crashed in some cases, and there were many reported issues that needed
triage. I opened [#193056](https://github.com/llvm/llvm-project/pull/193056) to
close the gap with `GCC` and set the `__cpp_deduction_guides` feature test
macro accordingly, and [#222215](https://github.com/llvm/llvm-project/pull/222215)
to handle alias templates with nested aliases such as the example above.

The work got blocked for three reasons:

1. **The PR got blocked**: there was a debate on the equivalence of alias
   templates, and only `GCC` implements it.
2. **An open core issue, [CWG2186](https://cplusplus.github.io/CWG/issues/2186.html)**:
   fixing it needs new wording from the committee.
3. **Not a priority**: the wording wouldn't be discussed soon, so it didn't fit
   the fellowship schedule.

### Pivot: C++23/26 constexpr math

Making `<cmath>` constexpr was a natural next step for me, since half of the
work is in `Clang` built-ins and I had already done the `LLVM libc` side.

This work is part of **Hand-in-Hand++**. Hand-in-Hand started by
sharing `LLVM libc` internals with `libc++`; Hand-in-Hand++ extends this to the
whole LLVM tree. `libc/shared/` exposes header-only, correctly rounded math
that `LLVM`, `Clang` and `libc++` can include, so every layer uses one
implementation instead of rewriting it. Implementing constexpr math spans four
LLVM projects:

| Layer | Component | Role | Status |
|-------|-----------|------|--------|
| `LLVM libc` | `libc/shared/math.h` | Header-only, correctly rounded math, written once | Done |
| `LLVM APFloat` | `llvm/Support` | Reuses the shared libc math for software floating point | - |
| `Clang` | constant evaluator | Folds `__builtin_exp` and friends at compile time via `APFloat` | Waiting |
| `LLVM libc++` | `<cmath>` | constexpr `std::exp`, `std::log`, ... on top of the built-ins | - |

On the `libc` side, the math functions are qualified to be usable in constant
evaluation (for example [#184745](https://github.com/llvm/llvm-project/pull/184745)
and [#184948](https://github.com/llvm/llvm-project/pull/184948)).

However, the chain is held up at `Clang`: an open PR,
[#199808](https://github.com/llvm/llvm-project/pull/199808), makes
`__builtin_exp` constexpr, but the maintainers first need to agree on the
approach. With the design still open, this was too slow for the fellowship, so
I picked another paper to implement.

## C++2d P3668R4: Defaulted Postfix `++` and `--`

P3668R4 allows the postfix increment and decrement operators to be explicitly
defaulted. The postfix form is generated from the prefix one:

```cpp
struct Counter {
  int v = 0;
  Counter &operator++() { ++v; return *this; }
  Counter operator++(int) = default;
  // same as:
  //   Counter tmp = *this;
  //   ++*this; return tmp;
};
```

I implemented the paper wording in
[#229560](https://github.com/llvm/llvm-project/pull/229560), which was
**merged upstream** after several rounds of review with the `Clang`
maintainers. The implementation:

- checks the declaration requirements of `[over.inc.default]`, such as the
  parameter and return types, and defines the operator as deleted, with notes
  explaining why, when the class has no usable copy constructor, destructor or
  prefix operator;
- computes the exception specification from the implicit definition, and
  makes the operator implicitly `constexpr` when it is suitable, following the
  rules for other defaulted functions;
- performs the lookup of the prefix operator from the context of the function
  body, also for `= default` at namespace scope;
- is available in all `C++` language modes as an extension, down to `C++03`.
  Porting it down required accounting for language features like `constexpr`
  and other qualifiers not being available in older modes.

After it landed, a crash was reported when instantiating functions defaulted
outside class templates under non-default floating-point features
([#240351](https://github.com/llvm/llvm-project/issues/240351)). I fixed it in
[#240376](https://github.com/llvm/llvm-project/pull/240376), which also fixed
the same problem for a defaulted postfix operator.

## How I Used AI

I used AI as an assistant in two areas:

1. **Navigating Clang's code**: explaining unfamiliar parser and `Sema` code
   paths, and finding where a change should go in a large codebase.
2. **Writing tests**: drafting test cases and listing the edge cases to cover,
   such as attributes, `__extension__` and the different `C` modes.

## Summary of Contributions

| PR | Description | Status |
|----|-------------|--------|
| [#198244](https://github.com/llvm/llvm-project/pull/198244) | `[Clang][C2y]` Add support for if declarations (N3356) | Merged |
| [#209920](https://github.com/llvm/llvm-project/pull/209920) | `[Clang][NFC]` Update diagnostic handling for C2y compatibility in parser | Merged |
| [#233908](https://github.com/llvm/llvm-project/pull/233908) | `[Clang][C2y]` Reject declarations in the condition of a while loop | Merged |
| [#244055](https://github.com/llvm/llvm-project/pull/244055) | `[Clang][Parse]` Do not treat `::` as a decl-specifier outside C++ | In review |
| [#229560](https://github.com/llvm/llvm-project/pull/229560) | `[Clang][C++2d]` Implement defaulted postfix increment and decrement operators (P3668R4) | Merged |
| [#240376](https://github.com/llvm/llvm-project/pull/240376) | `[Clang]` Fix crash instantiating functions defaulted outside class templates | Merged |
| [#193056](https://github.com/llvm/llvm-project/pull/193056) | `[Clang][C++17/20]` Add full support to deduction guides and CTAD alias templates | Blocked |
| [#222215](https://github.com/llvm/llvm-project/pull/222215) | `[Clang][CTAD]` Implement deduction guides for alias templates with nested aliases | Blocked |

## What's Next

- Land the fix for [#243727](https://github.com/llvm/llvm-project/issues/243727)
  in [#244055](https://github.com/llvm/llvm-project/pull/244055).
- Pick CTAD for alias templates back up once CWG2186 gets new wording.
- Continue the constexpr math chain once the `__builtin_exp` approach is
  agreed on in `Clang`.

## Acknowledgments

I would like to thank my mentors, Vassil Vassilev and Aaron Jomy, for their
guidance throughout the fellowship, the `Clang` maintainers and reviewers for
their time and feedback, and the C++ Alliance for supporting this work.

## Related Links

- [LLVM project](https://github.com/llvm/llvm-project)
- [Announcement blog post](/blogs/Implement_missing_C++26_features_in_Clang_Muhammad_Bassiouni_blog/)
- [CRCon26 slides](/assets/presentations/Muhammad_Bassiouni-CRCon26_Missing_C_and_CXX_Features_in_Clang.pdf)
- [Fellowship midterm presentation](/assets/presentations/Muhammad_Bassiouni_CppAlliance_Fellowship2026_midterm_presentation.pdf)
- [Fellowship final presentation](/assets/presentations/Muhammad_Bassiouni_CppAlliance_Fellowship2026_final_presentation.pdf)
- [N3356: if declarations in C2y](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n3356.htm)
- [P1814R0: CTAD for alias templates](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2019/p1814r0.html)
- [P3668R4: Defaulted postfix operators](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2026/p3668r4.html)
- [My GitHub profile](https://github.com/bassiounix)
