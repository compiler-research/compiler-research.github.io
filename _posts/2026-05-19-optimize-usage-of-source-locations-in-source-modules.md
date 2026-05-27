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

Hi everyone! I am Ayokunle Amodu, joining the Compiler Research team as a CppAlliance
Fellow for the 2026 cycle. I am an MLIR geek at heart. Most of my compiler work has
lived in the middle end, progressive lowering. I love seeing how high-level structure 
survives a full lowering chain and still means something at the bottom.

This project is front-end territory, not my typical residence, but being a comp arch
kid who has spent time with RISC-V assembly means a 32-bit space running out of room
is a very familiar kind of problem. Working under Vassil Vassilev with real upstream
review as the target is exactly the kind of opportunity I wanted.

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

If this works the way we expect, large modular builds that are currently approaching
the limit will complete without exhaustion. Duplicated headers stop eating into the
address space, diagnostics stay correct, and the fix is local enough that nothing
else in the compiler has to change. The address space scales with unique content
instead of module count.

## Relevant Links

- [LLVM Discourse: Revisiting 64-bit source locations](https://discourse.llvm.org/t/revisiting-64-bit-source-locations/86556)
- [LLVM Discourse: RFC: An opt-in CMake option for 64-bit Source Location](https://discourse.llvm.org/t/rfc-an-opt-in-cmake-option-for-64-bit-source-location/87538)

May the blessings of the Dragon be with us.