---
title: "Supporting Thrust API in Clad"
layout: post
excerpt: "This summer, I am working on adding support for Thrust API in Clad, enabling automatic differentiation of GPU-accelerated code. This work bridges the gap between high-performance CUDA parallelism and source-to-source AD transformation."
sitemap: false
author: Abdelrhman Elrawy
permalink: blogs/gsoc25_/
banner_image: /images/blog/gsoc-banner.png
date: 2025-05-18
tags: gsoc llvm clang automatic-differentiation gpu cuda thrust
---

## About Me

Hi! I’m Abdelrhman Elrawy, a graduate student in Applied Computing specializing in Machine Learning and Parallel Programming. I’ll be working on enabling **Thrust API support in Clad**, bringing GPU-accelerated parallel computing to the world of automatic differentiation.

## Project Description

[Clad](https://github.com/vgvassilev/clad) is a Clang-based tool for source-to-source automatic differentiation (AD). It enables gradient computations by transforming C++ code at compile time.

However, many scientific and machine learning applications leverage **NVIDIA’s Thrust**, a C++ parallel algorithms library for GPUs, and currently, Clad doesn’t support differentiating through Thrust constructs. This limits the usability of Clad in high-performance CUDA code.

My project addresses this gap by enabling Clad to:

- Recognize and handle Thrust primitives like `thrust::transform` and `thrust::reduce`
- Implement **custom pullback/pushforward rules** for GPU kernels
- Ensure gradients maintain **parallel performance and correctness**
- Benchmark and validate derivatives in real-world ML and HPC use cases

## Technical Approach

The project begins with a **proof-of-concept**: manually writing derivatives for common Thrust operations like `transform` and `reduce`. These are compared against finite differences to validate correctness.

Following that, I’ll integrate custom differentiation logic inside Clad, building:
- A `ThrustBuiltins.h` header for recognizing Thrust calls
- Visitor pattern extensions in Clad’s AST traversal (e.g., `VisitCallExpr`)
- GPU-compatible derivative utilities (e.g., CUDA-aware `thrust::fill`, `transform`)

I'll also implement **unit tests**, real-world **mini-apps** (e.g., neural networks), and **benchmarks** to validate and demonstrate this feature.

## Expected Outcomes

By the end of GSoC 2025, Clad will be able to:
- Differentiate through key Thrust primitives with GPU execution preserved
- Provide documentation and tutorials for GPU-based automatic differentiation
- Contribute a robust test suite and benchmarks to the Clad ecosystem

## Related Links

- [Clad GitHub](https://github.com/vgvassilev/clad)
- [Project description](https://hepsoftwarefoundation.org/gsoc/2025/proposal_Clad-ThrustAPI.html)
- [My GitHub](https://github.com/a-elrawy)
