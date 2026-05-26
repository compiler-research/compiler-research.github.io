---
title: "Systematic Triage of clang-tidy & Clang Static Analyzer"
layout: post
excerpt: "Systematically processing and resolving high-impact open requests in clang-tidy and the Clang Static Analyzer to reduce diagnostic noise."
sitemap: false
author: Peiqi Li
permalink: blogs/systematic_triage_clang_tidy_Peiqi_Li_blog/
thumbnail_image: /images/cppalliance-logo.svg
date: 2026-05-22
tags: clang-tidy static-analyzer clang llvm cppalliance
---

{% include dual-banner.html
left_logo="/images/cppalliance-logo.svg"
right_logo="/images/cr-logo.png"
caption=""
height="20vh" %}

## Introduction

Hello everyone! I am thrilled to join the Compiler Research team as a CppAlliance Fellow for the 2026 cycle. Over the next six months, I will be working closely with my mentors to systematically process and resolve the highest-impact open requests in `clang-tidy` and the Clang Static Analyzer (CSA). The ultimate goal is to reduce diagnostic noise—such as high-frequency false positives and unsafe fix-it hints—in modern C++ codebases.

**Mentors**: Vassil Vassilev, Aaron Ballman, Martin Vassilev

## Overview

Static analysis tools are a developer's best friend, but even a small false-positive rate can lead to `NOLINT` fatigue, often causing engineering teams to disable incredibly useful checks altogether. 

Currently, the issue trackers for `clang-tidy` and CSA hold a massive backlog of reports covering false positives, invalid fix-it hints, and performance regressions. Many of these issues are well-motivated and severely affect real-world adoption, but remain unresolved due to limited maintainer bandwidth rather than technical difficulty. This project targets these exact high-friction points to restore trust in automated C++ diagnostics and refactoring.

## Technical Implementation

To guarantee that fixes are conservative and well-tested, the project will rely on a strict standard operating procedure:

1. **Minimal Reproducer Extraction**: Isolating reported bugs into standalone C++ snippets devoid of external library dependencies to bypass environment-specific variables.
2. **Narrowest-Layer Application**: Applying fixes at the narrowest possible layer (e.g., AST matcher refinement vs. check-level logic vs. analyzer state transition) to prevent unintended cross-check regressions.
3. **Fix-it Safety Contracts**: Downgrading or completely removing `fix-it` hints if they cannot be guaranteed 100% safe (for instance, during complex macro expansions).
4. **Targeted Regression Testing**: Backing every patch with `llvm-lit` and `FileCheck` tests, explicitly including negative tests to prove the absence of new false positives.

## Goals

In the coming months, my primary aim is to decrease diagnostic noise and increase the perceived reliability of Clang-based tooling. The roadmap to achieve this includes:

1. Setting up a fully working local LLVM build with `clang-tools-extra`.
2. Systematically triaging the issue backlog to extract a prioritized matrix of high-impact targets.
3. Resolving AST blind spots related to modern C++ constructs (e.g., templates, perfect forwarding, and implicit conversions) using refined AST matchers.
4. Selectively addressing CSA issues where the root cause heavily overlaps with front-end semantics.
5. Providing comprehensive documentation and upstream issue follow-ups for any remaining edge cases.