---
title: "Advanced symbol resolution and re-optimization for Clang-Repl"
layout: post
excerpt: "Advanced symbol resolution and reoptimization for Clang-Repl is a Google Summer of Code 2025 project. It aims to improve Clang-Repl and ORC JIT by adding support for automatically loading dynamic libraries when symbols are missing. This removes the need for users to load libraries manually and makes things work more smoothly."
sitemap: false
author: Sahil Patidar
permalink: blogs/gsoc25_sahil_introduction_blog/
banner_image: /images/blog/gsoc-banner.png
date: 2025-05-18
tags: gsoc llvm clang-repl orc-jit auto-loading
---

### Introduction

I am Sahil Patidar, a student during the 2025 Google Summer of Code. I will be
working on the project "Advanced symbol resolution and re-optimization for Clang-Repl".

**Mentors**: Vassil Vassilev

### Overview of the Project

[Clang-Repl](https://clang.llvm.org/docs/ClangRepl.html) is a powerful interactive C++ interpreter that leverages LLVM’s ORC JIT to support incremental compilation and execution. Currently, users must manually load dynamic libraries when their code references external symbols, as Clang-Repl lacks the ability to automatically resolve symbols from dynamic libraries.
To address this limitation, we propose a solution to enable **auto-loading of dynamic libraries for unresolved symbols** within ORC JIT, which is central to Clang-Repl’s runtime infrastructure.

Another part of this project is to add **re-optimization support** to Clang-Repl. Currently, Clang-Repl does not have the ability to optimize hot functions at runtime. With this feature, Clang-Repl will be able to detect frequently called functions and re-optimize them using a runtime call threshold.

### Objectives

* Implement **auto-loading** of dynamic libraries in ORC JIT.
* Add **re-optimization support** to Clang-Repl for hot functions.


### Implementation Details and Plans

The primary objective of this project is to enable **automatic loading of dynamic libraries for unresolved symbols** in Clang-Repl. Since Clang-Repl heavily relies on LLVM's **ORC JIT** for incremental compilation and execution, our work focuses on extending ORC JIT to support this capability for out-of-process execution enviroment.

Currently, ORC JIT handles dynamic library symbol resolution through the `DynamicLibrarySearchGenerator`, which is registered for each loaded dynamic library. This generator is responsible for symbol lookup and interacts with the **Executor Process Control (EPC)** layer to resolve symbols during execution. Specifically, it uses a `DylibHandle` to identify which dynamic library to search for the unresolved symbol. On the executor side, the `SimpleExecutorDylibManager` API performs the actual lookup using this handle.

To support **auto-loading in out-of-process execution**, Lang Hames proposed a design involving two new components:

* **`ExecutorResolver` API**: This is an abstract interface for resolving symbols on the executor side. It can be implemented in different ways—for example:

  * `PerDylibResolver`, which wraps a native handle for a specific library.
  * `AutoLoadDylibResolver`, which attempts to load libraries automatically when a symbol is unresolved.

  The `SimpleExecutorDylibManager` will be responsible for creating and managing these resolvers, returning a `ResolverHandle` instead of the traditional `DylibHandle`.

* **`ExecutorSymbolResolutionGenerator`**: This generator replaces the existing `EPCDynamicLibrarySearchGenerator` for out-of-process execution. Unlike the previous design that relied on `DylibHandle`, this generator will use the new `ResolverHandle` to resolve symbols via the `ResolverHandle->resolve()` interface.

In out-of-process execution, **per-library lookup** requires an RPC call for each dynamic library when resolving a symbol. If the symbol is in the **(N-1)th** library, **N-1 RPC calls** are made—introducing significant overhead.
In **auto-loading mode**, only one RPC call is made, but it scans all libraries, which is also inefficient if the symbol is missing.

To reduce this overhead, we propose using a **Bloom filter** to quickly check symbol presence in both modes before making costly lookups. The main challenge lies in designing an efficient and accurate filtering approach.

The second goal of this project is to add **re-optimization support** for Clang-Repl. Since ORC JIT is the core component used by Clang-Repl for runtime compilation and execution, we will build on its existing capabilities. ORC JIT supports runtime re-optimization using the `ReOptimizeLayer` and `RedirectableManager`.

At a high level, the `ReOptimizeLayer` emits boilerplate "sugar" code into the IR module. This code triggers a call to `__orc_rt_reoptimize_tag` when a threshold count is exceeded. This call is handled by `ReOptimizeLayer::rt_reoptimize`, which is triggered by the ORC runtime to generate an optimized version of a "hot" function. The `RedirectableManager` then updates the function’s stub pointer to point to the new optimized version. To achieve this, we will implement a custom `ReOptFunc`. If runtime profiling is needed to detect hot functions, we may also need to make small changes to the ORC runtime to collect this data.

### Conclusion

Upon completion of this project, ORC JIT will gain the ability to **automatically load dynamic libraries** to resolve previously unresolved symbols. Additionally, the integration of **filter-based optimizations** on the controller side will significantly reduce the overhead of unnecessary RPC calls.
Overall, this work enhances the flexibility and performance of ORC JIT and improves the user experience in tools like Clang-Repl that rely on it.


### Related Links

- [LLVM Repository](https://github.com/llvm/llvm-project)
- [Project Description](https://discourse.llvm.org/t/gsoc2025-advanced-symbol-resolution-and-reoptimization-for-clang-repl/84624/3)
- [My GitHub Profile](https://github.com/SahilPatidar)
