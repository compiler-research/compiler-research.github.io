---
title: "Process High-Impact clang-tidy and Clang Static Analyzer Requests: Final Results"
layout: post
excerpt: |
  A CppAlliance Fellowship 2026 wrap-up: nine merged PRs in clang-tidy and clangd,
  three Clang Static Analyzer patches in review, and the cases behind them.
sitemap: true
author: Peiqi Li
permalink: blogs/cppalliance26_peiqi_li_clang_tidy_wrapup/
thumbnail_image: /images/cppalliance-logo.svg
date: 2026-11-24
tags: [cppalliance, clang-tidy, clang, llvm, static-analyzer, clangd]
---

{% include dual-banner.html
left_logo="/images/cppalliance-logo.svg"
right_logo="/images/cr-logo.png"
caption=""
height="20vh" %}

Over the past six months I worked on clang-tidy and the Clang Static Analyzer as
a CppAlliance Fellow. The project started from a simple problem: both tools have
a long backlog of diagnostics that are wrong in practice — false positives,
missed bugs, and fix-its that break code. When a check is noisy, people add
`NOLINT` or turn it off, and the tool stops being useful. I spent the fellowship
fixing the cases that caused the most friction and getting the fixes merged
upstream.

## clang-tidy

Most of the merged work is in clang-tidy. The first group was about false
positives. [`modernize-use-using` #199189](https://github.com/llvm/llvm-project/pull/199189)
was rewriting typedefs inside `extern "C"` into `using`, which is invalid C in
mixed-language headers. [`bugprone-use-after-move` #199905](https://github.com/llvm/llvm-project/pull/199905)
missed the `DerivedToBase` cast hidden inside `std::forward` and reported a
partial move as a full move. [`misc-redundant-expression` #198085](https://github.com/llvm/llvm-project/pull/198085)
compared distinct aliases after desugaring and called them redundant.
[`readability-trailing-comma` #220548](https://github.com/llvm/llvm-project/pull/220548)
looked at the semantic form of empty initializer lists instead of what the user
wrote. And [`modernize-use-nullptr` #225585](https://github.com/llvm/llvm-project/pull/225585)
started warning on every C++20 spaceship comparison after libstdc++ 16 renamed
an internal type.

The second group was fix-its. [clangd #208682](https://github.com/llvm/llvm-project/pull/208682)
used to apply clang-tidy edits naively, so two adjacent removals could glue
tokens together:

```cpp
return (0);   // two removals
return0;      // what clangd applied before
```

I moved `mergeFixits()` from `DiagnosticRenderer` into `clang::edit`, and clangd
now uses the same merge logic as the compiler. The other fix-it issue was
[#227984](https://github.com/llvm/llvm-project/pull/227984): a fix-it on a
one-character string from a macro replaced the macro with a raw literal. The
check now keeps the warning and drops the fix-it. In both cases the diagnostic
is still useful; only the unsafe edit is gone.

## clangd

Most people don't run clang-tidy from the command line; they see it through
clangd. Query-based custom checks let projects write their own rules as
clang-query matchers in `.clang-tidy`, but they only ran in the CLI. In
[#216336](https://github.com/llvm/llvm-project/pull/216336) I wired them into
clangd. The feature is off by default and only runs when `FastCheckFilter` is
`Loose` or `None`, so a slow matcher cannot slow down a session that has not
opted in. The option is documented on the clangd website
([clangd-www #146](https://github.com/llvm/clangd-www/pull/146)).

LineFilter ([#202575](https://github.com/llvm/llvm-project/pull/202575)) did
not end as a patch. I implemented the requested option, but review showed that
the request was a workaround. What users actually need is filtering by where a
macro is defined. That is new configuration surface, so the next step is an RFC
for `ExcludeMacroExpansionRegex`, not a narrow feature hidden in a config file.

## The analyzer

The second half was the Clang Static Analyzer, where the bug is usually in how a
checker models program state, not in a matcher. I have three patches in review:
[NewDeleteLeaks #221587](https://github.com/llvm/llvm-project/pull/221587) was a
false negative — pointers stored in heap fields were treated as escaped, so real
leaks were not reported. [unix.Malloc #225048](https://github.com/llvm/llvm-project/pull/225048)
was a false positive — `LocAsInteger` was lost through identity operations, so
the allocation looked leaked. [CStringChecker #231736](https://github.com/llvm/llvm-project/pull/231736)
is the one I want to explain.

```cpp
struct container { int *head; };

void test(struct container *c) {
  int *tail = 0;
  memset(c, 0, sizeof(*c));
  clang_analyzer_eval(c->head == 0);
  // before: TRUE and FALSE
  // after:  TRUE
  if (c->head != 0)
    *tail = 1;   // null-dereference false positive
}
```

Before the fix, the analyzer says both TRUE and FALSE. Both paths stay alive, so
it reports a null dereference on code that cannot run. `c` is a pointer
parameter, so the extent is only known to be at least `sizeof(*c)`, not exactly
that size. The checker cannot model the zeroing, falls back to invalidation, and
throws away everything it knew about `*c`. The fix binds a zeroed value whenever
the length provably covers the pointee; non-zero fills and symbolic extents keep
the old behavior.

## What changed

Nine PRs are merged: eight in `llvm/llvm-project` and one in `llvm/clangd-www`.
Six widely used clang-tidy checks are corrected, two cases that were breaking
builds or upgrades are fixed, and clangd now applies fix-its safely and can show
custom checks in the editor. The merged fixes reach users through tools they
already run; no new tool or configuration is required.

The three analyzer patches are still in review. When they land, they will report
heap-field leaks that used to be silent and remove some false leak and
null-dereference reports. I also presented the work at
[CompilerResearchCon 2026](https://compiler-research.org/crcon2026/); the
[slides](https://compiler-research.org/assets/presentations/Peiqi_Li-CRCon26_Process_High-Impact_clang-tidy_and_Clang_Static_Analyzer.pdf)
are a shorter overview of the same work.

## Next

Next is landing the three analyzer patches and writing the
`ExcludeMacroExpansionRegex` RFC that came out of the LineFilter review. After
that I would like to keep contributing upstream.

Thanks to my mentors, Vassil Vassilev, Aaron Jomy, and Martin Vassilev, for their
guidance, and to the LLVM reviewers for their careful feedback.
