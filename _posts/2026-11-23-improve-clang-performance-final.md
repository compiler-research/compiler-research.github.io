---
title: "Where Clang spends its compile time"
layout: post
excerpt: "A 19-hour bisect pointed me to the wrong Clang commit. I explain how counting instructions changed the way I investigated slow builds, and how measuring memory led to a 581 MB saving on one compilation."
sitemap: false
author: Ezzeldin Ibrahim
permalink: blogs/cppalliance26_ezzeldin_ibrahim_improve_clang_performance_final/
thumbnail_image: /images/cppalliance-logo.svg
date: 2026-11-23
tags: [cppalliance, clang, performance, benchmarking, memory-optimization]
---

{% include dual-banner.html
left_logo="/images/cppalliance-logo.svg"
right_logo="/images/cr-logo_old.png"
caption=""
height="20vh" %}

My first attempt to pin down a Clang regression took about 19 hours and pointed
to the wrong commit. I had been timing SQLite compilations on my laptop. Each
step of the bisect built a fresh Clang, then immediately used it to compile
SQLite. Depending on how hot the laptop was, the same compiler could give me
times several percent apart. That was enough to send the bisect down the wrong
half of the history.

I spent my C++ Alliance Fellowship investigating changes like this with Vassil
Vassilev and Aaron Jomy. By the time I finished on 2 November, I had compared
Clang 18 through 23 on ten C and C++ codebases and identified 20 regressions.
I found practical fixes for eight of them. My [earlier post](/blogs/cppalliance26_ezzeldin_ibrahim_improve_clang_performance/)
describes how the project started.

## Finding the commit that changed the cost

I switched to counting the instructions Clang executed under Callgrind. I could
compile the same source file with two revisions, keep the flags and environment
fixed, and see a small change even while the machine was busy. I also measured
the frontend on its own. A full SQLite build had become faster overall, but
improvements in code generation hid an increase in the cost of parsing and
checking the source.

Building a compiler for every revision was the next bottleneck.
[manyclangs](https://github.com/elfshaker/manyclangs) let me sample prebuilt
compilers across a release and plot the instruction count against the commit.
On Boost.MPL, several small steps added up to the release-level slowdown. A
single first-bad commit would have told only part of that story. I used the
prebuilt compilers to locate the steps, then checked individual changes with
native builds before reporting them.

## When a faster patch made debug builds slower

Clang was collecting documentation comments even in compilations that had no
use for them. My first patch checked whether a feature or warning needed the
comments before adding them to the syntax tree. It helped on comment-heavy
files. After it merged, the LLVM Compile Time Tracker showed a **7.6% increase**
in instructions at `-O0 -g`, and the patch was reverted. The check I had added
was itself expensive enough to erase the savings. [Original patch and regression report](https://github.com/llvm/llvm-project/pull/206363#issuecomment-5479204717)

For the second version I cached whether the documentation warnings were
enabled. The cache had to respect changes in diagnostic settings within a
file, including changes made by pragmas. With that in place, Clang could skip
the comment work without repeatedly looking up the warning policy. The reland
reduced compiler instructions by **0.31%** on the tracker at `-O0 -g`. [Merged fix](https://github.com/llvm/llvm-project/pull/221605)

## What the instruction counter missed

Compiling CTRE, a library that processes regular expressions at compile time,
used almost 9 GB on my test. I added peak-heap measurements with Massif and
traced one source of growth to the key Clang stored in its table of deduced
`auto` types. A small saving per entry mattered because the compiler kept so
many entries alive at once. Shrinking that key reduced peak resident memory
from **8,928 MB to 8,347 MB** on the same compilation, a **6.5%** reduction.
[Merged fix and measurements](https://github.com/llvm/llvm-project/pull/218278)

## The last two weeks

On 31 October my DWARF 5 checksum patch merged. Clang had already hashed the
main source file when it created the debug compile unit. Later, when it needed
a debug file entry for that same file, it read and hashed the contents again.
Reusing the first checksum saved **0.72%** of compiler instructions on SQLite
in the reported debug build. [DWARF checksum fix](https://github.com/llvm/llvm-project/pull/228926)

On 2 November I opened two smaller patches after looking for source-location
lookups on common paths. When parsing a GNU attribute, Clang can check whether
it came from a macro before looking up the presumed filename. When identifying
a language-defined builtin macro, it can check the macro name first. Measured
independently at `-O0 -g`, those changes reduced tracker instruction counts by
**0.08%** and **0.13%**, respectively. [GNU attribute patch](https://github.com/llvm/llvm-project/pull/237803) · [Builtin macro patch](https://github.com/llvm/llvm-project/pull/237805)

## Upstream results

I opened 18 performance PRs. Twelve merged, including the documentation change
that I subsequently reworked, five remained open, and I closed one initial
approach. A few other results illustrate how much the workload matters.

- Clang could spend time finding a spelling correction even when the diagnostic
  that would show it was disabled. Skipping that search saved **1.2%** of
  compiler instructions on Boost.MPL. [Merged typo-correction fix](https://github.com/llvm/llvm-project/pull/209694)
- A user reported a compilation that spent minutes in LLVM's loop optimizer.
  I traced it to repeated invalidation of cached analysis results. Batching
  that work brought the reproducer from **3 min 46 s to 3.9 s**. [Issue investigation](https://github.com/llvm/llvm-project/issues/194308) · [Merged optimizer fix](https://github.com/llvm/llvm-project/pull/219025)
- Two patches under review remove quadratic work. Selecting an element from an
  8,000-element template pack went from **11.9 s to 0.69 s** on the test case.
  Checking a designated initializer with 40,000 fields went from **8.87 s to
  0.07 s**. [Pack indexing](https://github.com/llvm/llvm-project/pull/213790) · [Designated initializers](https://github.com/llvm/llvm-project/pull/225573)

Thank you to Vassil Vassilev and Aaron Jomy for their guidance, to the LLVM
reviewers who helped work through these changes, and to the C++ Alliance for
supporting the fellowship. I presented the benchmarking method and the results
at CompilerResearchCon 2026. [Talk slides](/assets/presentations/Ezzeldin_Ibrahim-CRCon26_Improving_Clang_Performance.pdf)
