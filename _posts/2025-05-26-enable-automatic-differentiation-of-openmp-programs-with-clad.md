---
title: "Enable Automatic Differentiation of OpenMP Programs with Clad"
layout: post
excerpt: "This project introduces OpenMP support to Clad, enabling automatic differentiation of multi-threaded C++ programs."
sitemap: false
author: Jiayang Li
permalink: blogs/gsoc25_jiayangli_intro_blog/
banner_image: /images/blog/gsoc-banner.png
date: 2025-05-26
tags: gsoc llvm clad openmp automatic-differentiation
---

## About me

Hi! I’m Jiayang Li, a third-year undergraduate student majoring in Computer Science at Shanghai University. I'm participating in Google Summer of Code 2025, working on enabling automatic differentiation of OpenMP programs in Clad. I have a strong background in high-performance computing and previous experience contributing to open-source projects.

## Project Overview

Clad is a Clang-based plugin for automatic differentiation (AD) of C++ code. It transforms mathematical functions into derivative forms, which is critical in applications like scientific computing, machine learning, and optimization.

However, current Clad capabilities do not fully support multi-threaded programs using OpenMP. This project aims to bridge that gap by adding OpenMP support to Clad's differentiation capabilities. By enabling AD of OpenMP programs, developers can write performant, parallel code without sacrificing derivative information—unlocking new possibilities in physics simulations and large-scale computations.

## Objectives

The main goals of this project include:

* **Parsing OpenMP Directives:** Enhance Clad’s AST visitors to recognize and handle directives like `#pragma omp parallel for`, `reduction`, `critical`, and `atomic`.
* **Scope Analysis:** Properly handle `shared`, `private`, and `reduction` variables and handle their gradients appropriately.
* **Forward and Reverse Mode Support:** Design strategies for AD under both modes. For example, reverse mode must synchronize gradients across threads—similar to [Enzyme](http://enzyme.mit.edu/)'s fork/sync model.

## Implementation Strategy

* **AST Extension:** Extend Clad's AST visitor to recognize and capture OpenMP constructs such as OMPParallelForDirective.

* **Variable Scope Analysis:** Track and manage shared, private, and reduction variables. This ensures correctness in derivative computations across parallel threads.

* **Differentiation Strategy:** Support both Forward Mode and Reverse Mode AD, inspired by how tools like Enzyme handle fork/sync transformations at the LLVM level.

## Conclusion
A a result of this project, Clad will support differentiation of OpenMP programs, significantly increasing its utility in high-performance computing domains. This work not only expands Clad’s technical capabilities but also makes AD more accessible and practical for real-world scientific applications.

## Related links

* [LLVM Project](https://github.com/llvm/llvm-project)
* [Clad Repository](https://github.com/vgvassilev/clad)
* [My GitHub](https://github.com/Errant404)
* [Enzyme](http://enzyme.mit.edu/)