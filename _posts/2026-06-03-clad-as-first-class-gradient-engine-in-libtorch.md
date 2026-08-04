---
title: "Clad as a First-Class Gradient Engine in LibTorch"
layout: post
excerpt: "A GSoC 2026 project exploring whether Clad-generated gradients can become a practical backend for selected LibTorch C++ workloads."
sitemap: true
author: Kacent Huang
permalink: /blogs/gsoc26_kacent_introduction_blog/
banner_image: /images/blog/banner-clad-gsoc.png
date: 2026-06-03
tags: gsoc c++ clang clad libtorch pytorch machine-learning
---

### Introduction

My name is Kacent Huang, and I am a second-year Computer Science undergraduate student at Nanjing University. During Google Summer of Code 2026, I will be working with the Compiler Research group on **"Clad as a First-Class Gradient Engine in LibTorch"**.

The project explores whether compiler-generated gradients from [Clad](https://github.com/vgvassilev/clad) can be used as a practical backend for selected [LibTorch](https://pytorch.org/cppdocs/) workloads. The goal is not to replace the full PyTorch autograd system. Instead, I want to build a focused C++ prototype that shows where source-transformed derivatives are correct, maintainable, and competitive.

**Mentors**: Aaron Jomy, David Lange, Vassil Vassilev

### Background

LibTorch is the C++ API of PyTorch. It lets C++ applications define tensors, run models, and execute training or inference workflows without moving the main application logic into Python. This is useful for ROOT and HEP workflows where data processing, simulation, and analysis are already deeply rooted in C++.

Clad is a Clang-based automatic differentiation tool. Rather than building a dynamic computation graph at runtime, Clad works through compiler source transformation: it analyzes C++ code and emits derivative code. Recent Compiler Research work has shown that this approach can be promising for machine-learning workloads, especially when the workload is CPU-bound and the differentiated code is carefully scoped.

This project sits at the boundary between these two systems. LibTorch provides the tensor runtime and the user-facing ML framework, while Clad provides a compiler-driven path for generating backward code for selected parts of a workload.

### Project Scope

The first version of the project will be intentionally narrow. LibTorch supports a very large operator ecosystem, dynamic tensor dispatch, and framework-managed autograd. Trying to replace all of that in one GSoC project would be unrealistic and would not produce a useful engineering result.

Instead, the project will focus on a limited proof of concept:

- CPU execution first.
- Contiguous floating-point tensors first.
- A small supported operator or graph subset first.
- Correctness checks against native LibTorch autograd and, where appropriate, finite differences.
- Clear documentation of what is supported and what remains out of scope.

My proposal starts from `torch::autograd::Function` because it is the smallest official LibTorch extension boundary for custom forward and backward code. The forward path can call a reference C++ kernel or component, while the backward path can call Clad-generated derivative code.

In the initial presentation, I also described a longer-term "torch.compile-like" direction for LibTorch C++. In eager LibTorch code, a user function such as:

```cpp
auto my_graph(torch::Tensor x) -> torch::Tensor {
  return (x * x).sum();
}
```

produces an observed graph instance at runtime. A future version of this idea could specialize that observed graph by operator sequence, tensor shape, dtype, and layout assumptions, then lower the supported subset into Clad-friendly C++ code. That is a broader research direction; the GSoC deliverable remains a small, measurable prototype.

### Implementation Plan

The implementation will proceed in stages.

First, I will select a reference workload that is small enough to test rigorously. Candidate workloads include a compact dense layer, an activation-plus-loss path, or a toy training component that can be expressed with source-visible C++ logic and simple tensor access patterns.

Second, I will generate and validate gradients with Clad outside LibTorch. This separates the core AD question from the framework-integration question: before using the generated code inside LibTorch, the derivative itself should be checked against expected results.

Third, I will build the LibTorch integration layer. The main path is a custom `torch::autograd::Function` whose `forward` method runs the selected C++ workload and whose `backward` method calls the Clad-generated derivative. The interface should keep saved tensors and metadata minimal so the data flow stays easy to inspect.

Fourth, I will compare the Clad-backed path with native LibTorch autograd on the same workload. Correctness comes first. Performance measurements and engineering tradeoffs will follow once the end-to-end path is stable.

If the primary path is stable early enough, I will evaluate whether a PyTorch custom-operator route gives a cleaner API or lower overhead. I will treat that as a stretch goal, not a prerequisite for the core project.

### Expected Deliverables

By the end of the project, I aim to deliver:

- A minimal LibTorch C++ example that uses Clad-generated derivative code through `torch::autograd::Function`.
- A documented CPU reference workload chosen to match Clad's strengths.
- Correctness tests against native LibTorch autograd and finite-difference checks where they are useful.
- Benchmark notes explaining runtime behavior, integration overhead, and workload limitations.
- Developer-facing documentation describing the supported scope and possible extension points.

The result should give the Compiler Research and HSF communities a concrete baseline for future work. If the prototype works well, it can motivate broader operator coverage, a cleaner user-facing API, ROOT-facing examples, or GPU support. If some parts do not work well, the project should still document the boundary clearly enough to guide the next attempt.

### Looking Forward

I am interested in this project because it combines compilers, C++, machine-learning systems, and scientific software. The most important outcome is not only a working demo, but also a clear understanding of where compiler-generated derivatives fit naturally into a mature ML framework.

For users, the ideal experience should still feel like LibTorch C++. Clad should act as a compiler backend for supported pieces of the computation, with LibTorch remaining responsible for tensors, execution, and the surrounding training workflow.

### Related Links

- [Project Description](https://hepsoftwarefoundation.org/gsoc/2026/proposal_Clad-Libtorch.html)
- [Clad Repository](https://github.com/vgvassilev/clad)
- [PyTorch C++ Documentation](https://pytorch.org/cppdocs/)
- [GSoC Project Proposal](/assets/docs/Kacent_Proposal_GSOC2026.pdf)
- [Initial Presentation](/assets/presentations/Kacent_Clad_As_Torch_Engine.pdf)
- [My GitHub Profile](https://github.com/fogsong233)
