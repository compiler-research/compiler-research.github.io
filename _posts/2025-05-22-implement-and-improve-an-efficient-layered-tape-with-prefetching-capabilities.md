---
title: "Implement and improve an efficient, layered tape with prefetching capabilities"
layout: post
excerpt: "A GSoC 2025 project focussing on optimizing Clad's tape data structure for reverse-mode automatic differentiation, introducing slab-based memory, thread safety, multilayer storage, and future support for CPU-GPU transfers."
sitemap: true
author: Aditi Milind Joshi
permalink: blogs/gsoc25_aditi_introduction_blog/
banner_image: /images/blog/gsoc-clad-banner.png
date: 2025-05-22
tags: gsoc clad clang c++
---

### Introduction

I'm Aditi Joshi, a third-year B.Tech undergraduate student studying Computer Science and Engineering (AIML) at Manipal Institute of Technology, Manipal, India. This summer, I will be contributing to the Clad repository as part of Google Summer of Code 2025, where I will be working on the project "Implement and improve an efficient, layered tape with prefetching capabilities."

**Mentors:** Aaron Jomy, David Lange, Vassil Vassilev

### Briefly about Automatic Differentiation and Clad

Automatic Differentiation (AD) is a computational technique that enables efficient and precise evaluation of derivatives for functions expressed in code. Unlike numerical differentiation, which suffers from approximation errors, or symbolic differentiation, which can be computationally expensive, AD systematically applies the chain rule to compute gradients with minimal overhead.

Clad is a Clang-based automatic differentiation tool that transforms C++ source code to compute derivatives efficiently. By leveraging Clang’s compiler infrastructure, Clad performs source code transformations to generate derivative code for given functions, enabling users to compute gradients without manually rewriting their implementations. It supports both forward-mode and reverse-mode differentiation, making it useful for a range of applications.

### Understanding the Problem

In reverse-mode automatic differentiation (AD), we compute gradients efficiently for functions with many inputs and a single output. To do this, we need to store intermediate results during the forward pass for use during the backward (gradient) pass. This is where the tape comes in — a stack-like data structure that records the order of operations and their intermediate values.

Currently, Clad uses a monolithic memory buffer as the tape. While this approach is lightweight for small problems, it becomes inefficient and non-scalable for larger applications or parallel workloads. Frequent memory reallocations, lack of thread safety, and the absence of support for offloading make it a limiting factor in Clad’s usability in complex scenarios.

### Project Goals

The aim of this project is to design a more efficient, scalable, and flexible tape. Some of the key enhancements include:

- Replacing dynamic reallocation with a slab-based memory structure to minimize copying overhead.
- Introducing Small Buffer Optimization (SBO) for short-lived tapes.
- Making the tape thread-safe by using locks or atomic operations.
- Implementing multi-layer storage, where parts of the tape are offloaded to disk to manage memory better.
- (Stretch Goal) Supporting CPU-GPU memory transfers for future heterogeneous computing use cases.
- (Stretch Goal) Introducing checkpointing for optimal memory-computation trade-offs.

### Implementation Plan

The first phase of the project will focus on redesigning Clad’s current tape structure to use a slab-based memory model instead of a single contiguous buffer. This change will reduce memory reallocation overhead by linking fixed-size slabs dynamically as the tape grows. To improve performance in smaller workloads, I’ll also implement Small Buffer Optimization (SBO) — a lightweight buffer embedded directly in the tape object that avoids heap allocation for short-lived tapes. These improvements are aimed at making the tape more scalable, efficient, and cache-friendly.

Once the core memory model is in place, the next step will be to add thread safety to enable parallel usage. The current tape assumes single-threaded execution, which limits its applicability in multi-threaded scientific workflows. I’ll introduce synchronization mechanisms such as std::mutex to guard access to tape operations and ensure correctness in concurrent scenarios. Following this, I will implement a multi-layered tape system that offloads older tape entries to disk when memory usage exceeds a certain threshold — similar to LRU-style paging — enabling Clad to handle much larger computation graphs.

As stretch goals, I plan to explore CPU-GPU memory transfer support for the slabbed tape and introduce basic checkpointing functionality to recompute intermediate values instead of storing them all, trading memory usage for computational efficiency. Throughout the project, I’ll use benchmark applications like LULESH to evaluate the performance impact of each feature and ensure that the redesigned tape integrates cleanly into Clad’s AD workflow. The final stages will focus on extensive testing, documentation, and contributing the changes back to the main repository.

### Why I Chose This Project

My interest in AD started when I was building a neural network from scratch using CUDA C++. That led me to Clad, where I saw the potential of compiler-assisted differentiation. I’ve since contributed to the Clad repo by investigating issues and raising pull requests, and I’m looking forward to pushing the limits of what Clad’s tape can do.

This project aligns perfectly with my interests in memory optimization, compiler design, and parallel computing. I believe the enhancements we’re building will make Clad significantly more powerful for real-world workloads.

### Looking Ahead

By the end of the summer, I hope to deliver a robust, feature-rich tape that enhances Clad’s reverse-mode AD performance across CPU and GPU environments. I’m excited to contribute to the scientific computing community and gain deeper insights into the world of compilers.

---

### Related Links

- [Clad Repository](https://github.com/vgvassilev/clad)
- [Project Description](https://hepsoftwarefoundation.org/gsoc/2025/proposal_Clad-ImproveTape.html)
- [GSoC Project Proposal](/assets/docs/Aditi_Milind_Joshi_Proposal_2025.pdf)
- [My GitHub Profile](https://github.com/aditimjoshi)
