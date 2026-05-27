---
title: "Consolidate and advance the GPU infrastructure in Clad"
layout: post
excerpt: "A GSoC 2026 project aimed at consolidating the fragmented GPU work and advancing the GPU infrastructure"
sitemap: true
author: Vedant Goyal
permalink: blogs/gsoc26_vedant_introduction_blog/
banner_image: /images/blog/banner-clad-gsoc.png
date: 2026-05-24
tags: gsoc clad clang cuda c++
---

### Introduction

I am Vedant Goyal, a pre-final year B.E. undergraduate student studying Electrical and Computer Engineering at Thapar Institute of Engineering and Technology. During Google Summer of Code 2026, I will be working on "Consolidating and advancing the GPU infrastructure in Clad" project with Compiler Research group.

**Mentors:** Aaron Jomy, David Lange, Vassil Vassilev

### About Automatic Differentiation and Clad

Automatic Differentiation(AD) is a set of techniques to evaluate the derivative of functions specified by a computer program. Automatic Differentiation is different from symbolic differentiation and numerical differentiation. Symbolic differentiation is computationally expensive whereas Numerical differentiation suffers from round off errors. AD solves all these problems by applying chain rule systematically to compute gradients.

Clad is a Clang-based automatic differentiation tool that transforms C++ source code to compute derivatives. Unlike other AD tools which compute derivatives at runtime by operator overloading, Clad computes derivatives at compile time, by leveraging Clang’s compiler infrastructure. It supports multiple differentiation modes like forward mode, reverse mode and hessian mode, making it suitable for a wide range of applications.

### Overview of the project

In recent years, Clad has gained promising support for GPU-based differentiation, including CUDA kernel differentiation, partial Thrust support, and integrations with several GPU-oriented applications. However, much of this work remains fragmented across older branches and forks, with limited testing, benchmarking, and upstream integration.

The primary goal of this project is to consolidate and strengthen Clad’s GPU infrastructure. The work will begin with auditing and reproducing contributions made by previous contributors to identify what has already been already merged in master, what remains incomplete, and which areas require additional testing or refinement.

The project will further focus on improving correctness, expanding GPU feature support, integrating representative GPU workloads, and establishing reproducible benchmarks and testing infrastructure for GPU-based automatic differentiation in Clad.

### Implementation Plan

The first phase of the project will focus on incorporating the support for the modern Unified Memory APIs and complete host-device boundary tracking. Ex:- Clad does not have support for the `cudaMallocManaged` yet. I'll also be resolving the isolated compiler edge cases identified in previous work.

Once the core GPU work is in place the next step would be to address the concurrency challenges specifically regarding memory spaces. Prior efforts had already provided basic support for the memory qualifiers like `__shared__`, `__managed__` etc. but generating the correct gradients still requires deep architectural changes. Strategies like block level sync and synchronization primitives like `cudaDeviceSynchronize()` needs to be implemented in order to prevent race condition without over relying on the expensive atomic operations.

After all that have been done I will be focusing on integrating the full scale HPC (High Performance Computing) applications like LULESH and RSBench to the current Clad infrastructure. Also to ensure long term maintainability the I will design and implement a CI pipeline that executes GPU-specific tests on capable runners, ensuring future commits do not break CUDA functionality.

As stretch goals, I plan to further integrate XSBench and LBM HPC applications in the clad infrastructure and also establishing a reproducible benchmarking suite that evaluates Clad's performance on HPC applications directly against Enzyme. The final stages will focus on extensive testing, documentation, and contributing the changes back to the main repository.

### Looking Forward

By the end of summer, I hope to deliver a more consolidated, reliable, and better-tested GPU infrastructure for Clad, along with improved benchmarking, workload support, and developer experience for GPU-based automatic differentiation workflows. I'm very excited for this opportunity to contribute to the scientific computing community.

---

### Related Links

-[Project Description](https://hepsoftwarefoundation.org/gsoc/2026/proposal_Clad-GPU.html)
-[Clad Repository](https://github.com/vgvassilev/clad)
-[GSoC Project Proposal](/assets/docs/Vedant_Goyal_Proposal_2026.pdf)
-[My Github Profile](https://github.com/Vedant2005goyal)
