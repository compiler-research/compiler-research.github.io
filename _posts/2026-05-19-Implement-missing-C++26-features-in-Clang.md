---
title: "Implement missing C++26 features in Clang"
layout: post
excerpt: "Implement missing C and C++ features in Clang in new language modes."
sitemap: false
author: Muhammad Bassiouni
permalink: blogs/Implement_missing_C++26_features_in_Clang_Muhammad_Bassiouni_blog/
thumbnail_image: /images/cppalliance-logo.svg
date: 2026-05-19
tags: Clang LLVM C C++ C2y C++20 if-declaration CTAD-alias-templates
---

{% include dual-banner.html
left_logo="/images/cppalliance-logo.svg"
right_logo="/images/cr-logo_old.png"
caption=""
height="20vh" %}

## Introduction

This project proposes a candidate-driven program to complete Clang’s support for
selected `C++26`-era language papers and closely related `C` proposals. The
project provides a vehicle for applicants to propose a standards paper that is
not yet implemented in `Clang` and then implement that paper within the scope of
the project.

**Mentors**: Vassil Vassilev, Aaron Jomy

## Overview

The `C` and `C++` Working Groups proposed several papers for different standards
of the languages to introduce new features, 2 of which are the _if declaration_
in `C2y` and _CTAD alias templates_ in `C++20`. The _if declaration_ proposes a
`C++`-style if statement with a declaration support; while the
_CTAD alias templates_ propose a way to simplify the use of alias templates to
make CTAD useful for all aspects of `C++`. The goal of this proposal is to
complete the implementation of these features in `Clang`.

## Benefits to Community

### if declaration in `C2y`

This feature makes `C` code easier to read and write. It lets programmers
declare a variable inside an if statement, so the variable is only used where it
is needed. This reduces mistakes and keeps code cleaner. Adding it to `Clang`
helps developers use modern `C` features earlier and keeps `Clang` up to date
with the `C2y` standard. There’s nearly nobody working on `C2y` features in
`Clang`, so this will be a step forward for `C` support in `Clang`.

### CTAD for alias templates in `C++20`

This feature lets the compiler automatically figure out template types even when
using alias templates. Today, this often fails or needs extra code, which is
confusing. Supporting it in `Clang` makes code shorter, simpler, and more
consistent with how normal templates already work. It also improves
compatibility with the `C++20` standard and other compilers.

## Goals

1. Fully support and implement the _if declaration_ feature in `Clang` for `C2y` without affecting existing functionality and performance.
2. Extend the existing support for _CTAD alias templates_ in `Clang` to support as many cases and contexts as possible _as a stretch goal_.

## Related Links

- [LLVM project](https://github.com/llvm/llvm-project)
- [if declaration in C2y](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n3356.htm)
- [CTAD for alias templates](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2019/p1814r0.html)
