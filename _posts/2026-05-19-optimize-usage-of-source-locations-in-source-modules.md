---
title: "Optimize Usage of Source Locations in Clang Modules"
layout: post
excerpt: "Reducing source-location memory pressure in modular C++ builds through allocation reuse and interval mapping."
sitemap: false
author: Ayokunle Amodu
permalink: blogs/optimize_source_locations_clang_modules_Ayokunle_Amodu_blog/
thumbnail_image: /images/cppalliance-logo.svg
date: 2026-05-20
tags: clang llvm modules source-locations cppalliance
---

{% include dual-banner.html
left_logo="/images/cppalliance-logo.svg"
right_logo="/images/cr-logo.png"
caption=""
height="20vh" %}

## Introduction

Hi everyone! I am incredibly excited to be joining the Compiler Research team as a
CppAlliance Fellow for the 2026 cycle. As an aspiring compiler engineer, finding an
initiative like this felt like exactly the kind of opportunity I had been hoping for,
a chance to do meaningful upstream work on a production compiler and jumpstart my
career, with real mentorship from people who know this codebase deeply. I am genuinely
thrilled to be here.

## A Little About Me

I am an MLIR geek at heart. Most of my compiler work has lived in the middle end,
where you are close enough to the hardware to feel the constraints but still working
at a level where the abstractions are rich and the design space is wide. How high
level structure eventually has to survive a chain of lowerings and still mean the same
thing at the bottom, that is the space I feel most at home in.

So when this project came up, my first reaction was honestly curiosity. This is
front-end territory. `SourceManager`, `ASTReader`, module deserialization, the
machinery Clang uses to track where everything came from before it even becomes an IR.
I do not live here normally but that is exactly what made it interesting. I have spent
enough time at the hardware-software boundary to appreciate what it means when a 32-bit
representation starts running out of room, and I wanted to see what the front end had
to say about it. A real opportunity to stretch.

## The Problem

Clang tracks every position in source code as a 32-bit offset into a global address
space managed by `SourceManager`. That space is finite, and in large modular builds it
fills up faster than you would expect. The issue is not the size of the representation
itself. It is that when multiple modules include the same headers, Clang has no memory
of having already mapped those files and simply maps them again. The address space
grows with the number of modules rather than the number of unique files, and once it
runs out, the build fails.

The community looked seriously at widening `SourceLocation` to 64 bits to buy more
room, but the proposal did not land. The concern was legitimate: `SourceLocation` is
embedded across a huge number of AST nodes, so making it bigger raises memory usage
for every build, not just the ones actually hitting the limit. It is a global cost for
a problem that has a much more local cause.

The cause is at the allocation site. Every module gets its own fresh region of the
address space, unconditionally, with no check for whether the same files have already
been seen.

## The Approach

The core idea is to introduce deduplication at the point of allocation. Before
assigning a new region for a module's input files, we check whether those files have
already been allocated and reuse the existing range if they have. This keeps the
address space from growing proportionally with module count and lets it scale with
unique content instead.

The work starts with a `DenseMap`-based prototype to validate the concept and confirm
the numbers move in the right direction. From there it extends to an
`llvm::IntervalMap` design that handles more complex scenarios, including cases where
different modules serialize different amounts of location data for the same file.
Alongside the implementation, the project covers diagnostic correctness, include-stack
reconstruction, and upstream patch preparation for LLVM review.

## What We Hope to Achieve

If this works the way we expect, duplicated module inputs will no longer cause
proportional growth in source-location allocations. Large modular builds that are
currently approaching the limit will complete without exhaustion, and Clang's
scalability for modern C++ codebases improves without requiring a disruptive global
change to the compiler. Diagnostics stay correct, the design targets upstream review
in the LLVM community, and the address space scales with unique content rather than
module count. That is the goal, and it is a meaningful one.

## Looking Ahead

I am genuinely looking forward to going deep on this. There is something satisfying
about a problem where the root cause is this concrete and the fix, while technically
careful, is conceptually clean. And getting serious time in the front end pushes me
one step closer to knowing my favourite compiler end to end.

May the blessings of the Dragon be with us.