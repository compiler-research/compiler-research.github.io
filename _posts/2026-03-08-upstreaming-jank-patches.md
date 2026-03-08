---
title: "Upstreaming jank-lang specific patches back to CppInterOp"
layout: post
sitemap: false
author: Iva Fezova
permalink: blogs/upstreaming_jank_lang_patches_Iva_Fezova_blog/
thumbnail_image: /images/mg-pld-logo.png
date: 2026-03-08
tags: clang llvm diagnostics c++ interop
---

{% include dual-banner.html
left_logo="/images/mg-pld-logo.png"
right_logo="/images/cr-logo_old.png"
caption=""
height="20vh" %}

## Introduction

My name is Iva Fezova, and the goal of this project is to focus on integrating **jank** specific modifications directly into the official **CppInterOp** upstream repository. This will not only simplify the development of jank-lang but also enhance CppInterOp for other projects that require similar advanced interoperability features. The jank project is a native Clojure dialect that compiles to C++ and leverages the power of LLVM.

**Mentor:** Vassil Vasilev

## Overview

Maintaining local patches—often referred to as "downstream patches"—comes with a significant maintenance cost. Every time the upstream CppInterOp library or the underlying Clang/LLVM infrastructure is updated, these patches must be manually re-applied and tested. The current reliance on local patches meets specific immediate requirements, but to ensure long-term stability, we are moving toward this upstream-first approach.

## Technical Implementation

The implementation process involves a deep dive into the existing modifications and the CppInterOp codebase:
* **Analysis of Modifications**: I am currently analyzing the specific jank-lang patches to determine which functionalities are missing from the current CppInterOp implementation.
* **Refactoring and Generalization**: To make these patches acceptable for upstream, they must be refactored from specialized "hacks" into general-purpose, robust components.
* **API Compatibility**: The work involves heavy interaction with LLVM and Clang APIs to ensure that the new CppInterOp features are performant and stable across different compiler versions.
* **Incremental Integration**: Following a review-oriented approach, changes are being prepared as incremental pull requests to allow for thorough peer review and testing.

## Goals

The primary objectives of this project are:
1. **Reduce Maintenance Overhead**: Eliminate the need for jank-lang to maintain separate CppInterOp patches.
2. **Standardize Interoperability**: Provide a well-designed, repeatable process for establishing language interoperability through CppInterOp.
3. **Enhance the Ecosystem**: Contribute improvements that benefit the broader CppInterOp user base and the C++ tooling community.

