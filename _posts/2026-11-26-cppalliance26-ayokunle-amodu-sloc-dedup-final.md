---
title: "One copy is enough: deduplicating source locations in Clang modules"
layout: post
excerpt: |
  A CppAlliance Fellowship 2026 wrap-up: why modular builds run out of source
  locations, two ways to stop paying for the same header twice, and the 19%
  of address space we got back on ROOT.
sitemap: true
author: Ayokunle Amodu
permalink: blogs/cppalliance26_ayokunle_amodu_sloc_dedup_final/
thumbnail_image: /images/cppalliance-logo.svg
date: 2026-11-26
tags: [cppalliance, clang, llvm, modules, serialization, source-locations]
---

{% include dual-banner.html
left_logo="/images/cppalliance-logo.svg"
right_logo="/images/cr-logo.png"
caption=""
height="20vh" %}

```
fatal error: ran out of source locations
```

That is how a large modular build can end. Clang gives every byte of source it
sees a number, and those numbers live in a single 32-bit space, about two
billion addresses for the whole compilation. When the space is full, the build
stops. I spent my CppAlliance Fellowship with Vassil Vassilev working on one of
the biggest reasons modular builds fill it: the same header being paid for over
and over. My [first post](/blogs/optimize_source_locations_clang_modules_Ayokunle_Amodu_blog/)
introduced the project; this one covers how it turned out.

## Where the space goes

When a module is built, Clang saves it as a PCM, and each file the module saw
gets its own range of source locations inside it. Now take two modules that
both textually include the same header:

```cpp
// module A           // module B
#include "shared.h"   #include "shared.h"
int a_fn();           int b_fn();
```

Each PCM carries its own copy of `shared.h`. Import both and the translation
unit pays for `shared.h` twice. Import fifty modules and it pays fifty times,
even though every copy is byte-for-byte identical.

The clean answer is to make `shared.h` a module of its own, so everyone shares
one copy. But the headers that hurt most are system and third-party headers you
don't own, or config headers that have to stay textual. That is where the
duplication lives.

The other answer on the table was to widen source locations to 64 bits. There
are [RFCs](https://discourse.llvm.org/t/revisiting-64-bit-source-locations/86556)
for it, but it touches a type that is used everywhere in Clang. Removing the
duplicates goes after the same pressure without that change.

## First try: catch it on load

Duplicates only meet when modules are loaded together, so that is where I
started. As each module loads, the patch remembers where every file first
landed. When a later module brings the same file, it reserves no new space for
it and points that copy's locations at the first one.

It worked. At the [midterm](/assets/presentations/Ayokunle_Amodu_CppAlliance_Fellowship2026_midterm_presentation.pdf),
a Boost build pulling in asio, beast, spirit and hana dropped from 47.5 MB to
28.4 MB of loaded source-location space. On [ROOT](https://root.cern), it
reclaimed about a third.

The cost showed up when I measured properly. A module's space is reserved
before any of its files are placed, so the duplicates have to be known first.
That meant scanning every file entry of every module at load time. Clang
normally loads these lazily, and most are never touched. On ROOT, module
writing went up 6.1% in instructions and peak memory went up 5.1%. On top of
that, a single base offset per module became a piecewise map that had to work
in both directions. It was too much machinery for what it bought.

## Second try: never write the copy

So after the midterm I moved the work to the other end. Modules are built in
dependency order, so when module B is being written, the module that already
owns `shared.h` is usually loaded. If it is, B doesn't write its own copy at
all. Every location that would have pointed into B's copy is rewritten to point
into the owner's copy instead.

Nothing is scanned at load, and there are no gaps to remap. The reader just
follows the location to the owner.

On ROOT, with 88 dictionaries and runtime C++ modules:

- loaded source-location space went from **75.33 MB to 61.02 MB**, a **19%** saving
- peak memory went down **3.7%**
- PCM size went down **4.4%**
- compile time stayed flat

The biggest savings came from headers like `c++config.h`, `features.h` and
`sys/cdefs.h`. These are exactly the system headers nobody can turn into
modules, so every PCM used to carry its own copy.

This is [#209795](https://github.com/llvm/llvm-project/pull/209795).

## What review found

Getting numbers is one thing. Getting a serialization change into Clang is
another, and review is where most of the real work happened.

Jonas Hahnfeld tested it on ROOT and Qiongsi Wu on Apple SDK workloads, and
their reports kept me honest. A crash, a dependency-scanning slowdown that
turned out to be path canonicalization on every input file, and two
location-ordering bugs all got fixed at the root, and reproducers from
reviewers became regression tests.

One problem didn't go away. Two copies of a header can be byte-for-byte
identical and still not mean the same thing, because they were compiled under
different preprocessor state. A declaration behind an `#ifdef`, or a
`#pragma diagnostic`, can differ between the two. Sharing their locations
doesn't capture that. Every fix I tried ended up as another band-aid, and I
didn't want to land something I couldn't fully stand behind.

## Narrowing it down: module maps

While working through that, I was looking at
[#116374](https://github.com/llvm/llvm-project/pull/116374), which already
drops module maps that nothing references. Module maps are duplicated the same
way: every PCM built from a shared map carries its own copy. The ones that are
referenced can't be dropped, but they can be redirected to a single copy, the
same idea as before.

A module map is a much easier thing to share than a header. It has no
declarations, no macros and no preprocessor state, so there is far less to
prove equivalent. It also doesn't depend on how bottom-up a codebase is
modularized. If anything, the more you modularize, the more copies there are.

On ROOT it reclaims about **12%** of loaded source-location space, and all 88
dictionaries build with assertions on. It is up for review as
[#240442](https://github.com/llvm/llvm-project/pull/240442).

## Where it stands

- [#240442](https://github.com/llvm/llvm-project/pull/240442), module map
  deduplication, is open and under review.
- [#209795](https://github.com/llvm/llvm-project/pull/209795), header
  deduplication, is open with one question left around preprocessor state.

The header work isn't abandoned. The module map patch stands on its own, and if
per-copy preprocessor state can be handled cleanly, the header saving can stack
on top of it. The work was also featured as a poster at CppCon 2026.

## Related links

- [Announcement blog post](/blogs/optimize_source_locations_clang_modules_Ayokunle_Amodu_blog/)
- [Project proposal](/assets/docs/Ayokunle_Amodu_Proposal_2026.pdf)
- [Fellowship initial presentation](/assets/presentations/Ayokunle_Amodu_CppAlliance_Fellowship2026_initial_presentation.pdf)
- [Fellowship midterm presentation](/assets/presentations/Ayokunle_Amodu_CppAlliance_Fellowship2026_midterm_presentation.pdf)
- [Fellowship final presentation](/assets/presentations/Ayokunle_Amodu_CppAlliance_Fellowship2026_final_presentation.html)
- [CRCon26 slides](/assets/presentations/Ayokunle_Amodu-CRCon26_One_Copy_Is_Enough.html)

## Thanks

Thank you to Vassil Vassilev for his guidance throughout, to Haojian Wu, Jan
Svoboda, Corentin Jabot, Chuanqi Xu and Reid Kleckner for their careful review,
to Jonas Hahnfeld and Qiongsi Wu for testing, and to the C++ Alliance for
supporting the fellowship.
