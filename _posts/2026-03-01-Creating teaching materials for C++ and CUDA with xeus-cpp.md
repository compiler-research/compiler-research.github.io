---
title: "Creating teaching materials for C++ and CUDA with xeus-cpp"
layout: post
excerpt: "Exploring how xeus-cpp behaves, porting tutorials for C++ and CUDA and Contribute small and safe improvements"
sitemap: false
author: Hristiyan Shterev
permalink: blogs/xeus_cpp_Hristiyan_Shterev_blog/
date: 2026-03-01
tags: xeus-cpp cuda jupyter c++ xeus
---

{% include dual-banner.html
left_logo="/images/mg-pld-logo.png"
right_logo="/images/cr-logo_old.png"
caption=""
height="20vh" %}

## Introduction

I am Hristiyan Shterev and I`m a high-school student with a strong interest in C++ and systems programming. Through my internship at Compiler Research, I aim to expand my understanding of interactive execution environments and contribute teaching materials with xeus-cpp.

**Mentor**: Vassil Vassilev


## Overview of the Project

`xeus-cpp` project provides a Jupyter kernel that enables interactive **C++** programming in Jupyter notebooks. It allows **C++** code to be compiled and executed cell by cell while preserving state across executions, which makes it useful for experimentation and learning, but also introduces behavior that is not always obvious.

This project starts with contained, simpler tasks that assume prior **C++** experience, rather than beginner-level programming. The initial phase focuses on writing structured **C++** programs in `xeus-cpp` notebooks and observing how they behave when split across multiple cells. These examples are used to explore and explain key aspects of the kernel, such as execution order, state persistence, recompilation, and error handling.

As the project progresses, the focus shifts toward more advanced usage patterns, including modifying existing code, reusing definitions across cells, and understanding how changes affect previously executed code. The goal is to build a clear mental model of how `xeus-cpp` works from a user’s perspective.

With this foundation, the project then moves to a high-level exploration of the `xeus-cpp` codebase to understand its overall structure and execution flow. Based on this understanding, the final stage focuses on small, practical contributions such as improving documentation, adding example notebooks, or clarifying existing behavior.



## Project Goals

The main goal of this project is to understand how `xeus-cpp` and CUDA work and how to use them together to contribute by creating teaching materials with the Jupiter notebook.

More specific goals include:

* Understanding `xeus-cpp` and its state management and differences from normal **C++** compilations

* Learn how the notebook remembers variables and functions from one cell to the next

* Porting different courses to xeus-cpp. For example:
   - C/C++: Tutorial: [Learning resources C/C++](https://researchcomputing.princeton.edu/education/external-online-resources/cplusplus?utm_source=chatgpt.com)
   - OpenMP Tutorial: [An Introduction to Parallel Programming with OpenMP](https://indico.cern.ch/event/1568686/contributions/6608233/attachments/3107963/5508628/OpenMP_CPU.pdf)
   - CUDA Tutorial: [CUDA by example](https://edoras.sdsu.edu/~mthomas/docs/cuda/cuda_by_example.book.pdf?utm_source=chatgpt.com)   


* Trigger and document most possible linking and runtime errors

* Explore the source code of xeus-cpp and learn about how it works. Contribute small and safe improvements

## Example

**CPU - std::sort vs GPU - Merge sort speed test**

The example below shows a C++ benchmark comparing the performance of sorting a large array on a CPU versus a GPU. It provides a clear visual of how parallel processing can drastically outperform traditional sequential execution for data-heavy tasks.

<img src="/images/blog/MergeSortTest.png"/>

## Related links

- [Xeus-cpp repository](https://github.com/compiler-research/xeus-cpp)
- [My github account](https://github.com/HrisShterev)
- [Project proposal](/assets/docs/Hristiyan_Shterev_project_proposal.pdf)
