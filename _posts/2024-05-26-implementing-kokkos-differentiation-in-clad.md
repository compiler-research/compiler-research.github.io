---
title: "Implementing Differentiation of the Kokkos Framework in Clad"
layout: post
excerpt: "A GSoC 2024 project aimed at implementing the differentiation of the Kokkos framework into Clad"
sitemap: false
author: Atell Yehor Krasnopolski
permalink: blogs/gsoc24_atell_krasnopolsky_introduction_blog/
date: 2024-05-26
---

### Introduction

I'm Atell Krasnopolski, a mathematics student at the University of Wuerzburg, Germany, and a Google Summer of Code 2024 contributor for a project related to Clad, an automatic differentiation tool developed by the Compiler Research group. Specifically, I am going to be implementing the differentiation of the Kokkos framework into Clad. 

**Mentors**: Vaibhav Thakkar, Vassil Vassilev, Petro Zarytskyi

### Briefly about Kokkos and Clad

In mathematics and computer algebra, automatic differentiation (AD) is a set of techniques
to numerically evaluate the derivative of a function specified by a computer program.
Automatic differentiation is an alternative technique to Symbolic differentiation and Numerical
differentiation (the method of finite differences). Clad is based on Clang which provides the
necessary facilities for code transformation. The AD library can differentiate non-trivial
functions, to find a partial derivative for trivial cases and has good unit test coverage.

The Kokkos C++ Performance Portability Ecosystem is a production level solution for writing
modern C++ applications in a hardware-agnostic way. It is part of the US Department of
Energies Exascale Project – the leading effort in the US to prepare the HPC community for
the next generation of supercomputing platforms. The Ecosystem consists of multiple
libraries addressing the primary concerns for developing and maintaining applications in a
portable way. The three main components are the Kokkos Core Programming Model, the
Kokkos Kernels Math Libraries and the Kokkos Profiling and Debugging Tools.

The Kokkos framework is used in several domains including climate modelling where
gradients are an important part of the simulation process. This project aims at teaching Clad
to differentiate Kokkos entities in a performance-portable way.

### Why I Chose This Project

Long story short, I have always been interested in the algorithms at the intersection of computer science and mathematics. In fact, topics like numerical and computational mathematics have sparked my initial interest in mathematics as my university major. Thus, having such an opportunity to work on a project that combines some low-level programming, applied mathematics, and more was a dream from my high school years.

### Implementation Details and Plans

The goal is to implement the differentiation of the Kokkos high-performance computing
framework including the support of:

- Kokkos functors,
- Kokkos lambdas,
- Kokkos methods such as parallel_for, parallel_reduce and deep_copy,
- as well as the general support for Kokkos::View data structures,
- Enhance existing benchmarks demonstrating effectiveness of Clad for Kokkos

The additional aim of the project is to implement a generic approach to support any C++
library (starting with Kokkos) in such a way that the core of Clad is invariant to the internals
of the library, but any Clad user can add it in a pluggable format for individual use cases.
This ensures Clad’s usability for bigger projects that may include a lot of libraries.

To make Kokkos differentiable in Clad, one would need to be able to propagate pullbacks and
pushforwards through its constructs (at least those listed above), which is the goal of this project.

### Conclusion

This project represents a unique intersection of mathematics, computer science, and high-performance computing. By extending Clad to support the differentiation of Kokkos entities, we will not only enhance the capabilities of Clad but also provide a valuable tool for the scientific and engineering communities that rely on Kokkos for their simulations and computations. The successful integration of Kokkos with Clad will allow for more efficient and accurate gradient calculations which are essential in fields such as climate modelling and other simulation-heavy domains.

### Related Links

- [Clad Repository](https://github.com/vgvassilev/clad)
- [Kokkos Framework](https://kokkos.org/)
- [GSoC Project Proposal](https://summerofcode.withgoogle.com/media/user/7bacecfd1611/proposal/gAAAAABmU0YUILyYTMPRrcmjcv31gQbse1K2pvtrZjJbfFJ-BpANfpBikwSOTM52mNTLxKQeOP-rdhfyqu7KSO-pe74cM18zatTIu6VI4EJzPW8FgNbD8l4=.pdf)
- [My GitHub Profile](https://github.com/gojakuch)
