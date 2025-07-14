---
title: "Activity analysis for reverse-mode differentiation of (CUDA) GPU kernels"
layout: post
excerpt: "A GSoC 2025 contributor project aiming to implement Activity Analysis for (CUDA) GPU kernels"
sitemap: false
author: Maksym Andriichuk
permalink: blogs/2025_maksym_andriichuk_introduction_blog/
banner_image: /images/blog/gsoc-banner.png
date: 2025-07-14
tags: gsoc c++ clang root auto-differentiation
---

### Introduction
Hi! I’m Maksym Andriichuk, a third-year student of JMU Wuerzburg studying Mathematics. I am exited to be a part of Clad team fo this year's Google Summer of Code.

### Project description
My project focuses on removing atomic operations when differentiating CUDA kernels. When accessing gpu global memory inside of a gradinet of a kernel data races inevitably occur and atomic operation are used instead, due to how reverse mode differentiation works in Clad. However, in some cases we can guarantee that no data race occur which enables us to drop atomic operations and drastically speeds the execution time of the gradient.

### Project goals
The main goals of this project are:

- Implement a mechanism to check whether data races occur in various scenarios.

- Compare Clad with other tools on benchmarks uncluding RSBench and LULESH.

### Implementation strategy 
- Solve minor CUDA-related issues to get familiar with the codebase.

- Implement series of visitors to distinguish between different types of scenarious where atomic operations could be dropped

- Use the existing benchmarks to compare the speedup from the implemented analysis.

## Conclusion 

By integrating an analysis for (CUDA) GPU kernels we aim to speedup the execution of the gradient by removing atomic operation where posiible. To declare success, we would compare Clad to the other AD tools using different benchmarks. I am exited to be a part of the Clad team this summer and can not wait to share my progress. 

### Related Links

- [My GitHub profile]https://github.com/ovdiiuv