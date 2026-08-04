---
title: "Enabling Differentiable Rendering via AD of Parallel C++ STL Primitives in Clad"
layout: post
excerpt: "This summer, I am working on enhancing Clad to automatically generate lock-free backward passes for highly parallel differentiable rendering pipelines. This project targets the atomic bottleneck inherent in 3D Gaussian Splatting (3DGS) rasterization."
sitemap: false
author: Abdelrhman Elrawy
permalink: blogs/gsoc26_abdelrhman_elrawy_introduction_blog
banner_image: /images/blog/gsoc-banner.png
date: 2026-06-17
tags: gsoc llvm clang automatic-differentiation gpu cuda thrust rendering 3dgs
---

## About Me

Hi! I’m Abdelrhman Elrawy, a graduate student in Applied Computing specializing in Machine Learning and Parallel Programming. After successfully adding Thrust API support to Clad during GSoC 2025, I’m back this summer to work on **Enabling Differentiable Rendering via AD of Parallel C++ STL Primitives in Clad**.

## Project Description

[Clad](https://github.com/vgvassilev/clad) is a Clang-based automatic differentiation (AD) tool. This project proposes to enhance Clad by leveraging its liveness analysis to automatically generate lock-free backward passes for highly parallel differentiable rendering pipelines. Specifically, the project targets the atomic bottleneck inherent in 3D Gaussian Splatting (3DGS) rasterization.

Modern GPU-based differentiable renderers suffer from heavy use of atomic operations (e.g., `atomicAdd`) during the backward pass because many threads attempt to update the same pixel and gradient buffers simultaneously. This contention overwhelms L2 cache atomic units, stalling execution and causing the gradient computation to consume a significant portion of training time.

## Technical Approach

My approach is twofold:

1. **Redesign the Rendering Pipeline**: I will avoid write conflicts by construction using deterministic sorting, tile-based memory ownership, and local accumulation before a single global write. Crucially, I plan to build this new architecture on top of my previous GSoC work that integrated the Thrust API into Clad. By utilizing Thrust's highly optimized parallel primitives (such as `thrust::sort_by_key` and `thrust::reduce`) for the sorting and tile-based operations, we can provide a clean, high-level C++ structure to the compiler.

2. **Generate the Backward Pass**: I will utilize Clad to automatically generate the backward pass. By relying on Clad's liveness analysis, the compiler will prove exclusive memory ownership and automatically eliminate the need for `atomicAdd` calls. To isolate the compiler complexity from the graphics complexity, the project will use a differentiable geometry path tracer as the foundational stepping stone.

## Expected Outcomes

Beyond differentiable rendering, this work establishes a foundation for compiler-driven automatic differentiation of parallel C++ programs, enabling efficient gradient computation in a wide range of high-performance computing applications.

## Related Links

- [Clad GitHub](https://github.com/vgvassilev/clad)
- [Project Proposal](/assets/docs/Abdelrhman_Elrawy_Proposal_GSoC_2026.pdf)
- [My GitHub](https://github.com/a-elrawy)
