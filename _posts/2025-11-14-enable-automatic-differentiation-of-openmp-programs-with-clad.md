---
title: "Wrapping Up GSoC 2025: Enable Automatic Differentiation of OpenMP Programs with Clad"
layout: post
excerpt: "A summary of my GSoC 2025 project focusing on OpenMP support to Clad, enabling automatic differentiation of multi-threaded C++ programs."
sitemap: false
author: Jiayang Li
permalink: blogs/gsoc25_jiayangli_warpup_blog/
banner_image: /images/blog/gsoc-banner.png
date: 2025-11-14
tags: gsoc llvm clad openmp automatic-differentiation
---

## 1. Overview

Clad is a source-to-source AD library, implemented as a Clang plugin, that constructs derivative code directly on the Abstract Syntax Tree (AST), performing AD at compile-time to generate precise C++ derivative functions.

The core goal of this GSoC project was: **To implement automatic differentiation in Clad for OpenMP-parallelized programs, ensuring the generated derivative code also preserves the parallel structure.** This allows for leveraging multi-core parallel acceleration while obtaining derivatives.

## 2. Technical Challenges

Extending automatic differentiation to OpenMP programs presented several key challenges:

1. **Complexity of OpenMP Features and Nodes in Clang AST:** OpenMP is represented in Clang through a series of specialized AST nodes and relies on `CapturedStmt` to capture external variables used within parallel regions. Constructing these nodes requires:
   - Correctly handling various OpenMP directives and clauses.
   - Properly establishing the capture list for the parallel region.
   - Ensuring the newly generated derivative function's AST is compatible with Clang's semantic checks and code generation pipeline.
2. **Variable Scopes and Data Attributes in OpenMP Regions:** In OpenMP, variables can be declared with attributes like `shared`, `private`, `firstprivate`, etc. In the forward and reverse computation paths, each thread's read/write access and variable lifetimes differ. To ensure derivative correctness, we needed to:
   - Accurately model the visibility of each variable in different scopes within the original program.
   - Maintain this scope relationship when generating derivative code.
   - Correctly map forward-pass variables and intermediate results to the reverse-pass.
3. **Thread-Safe Storage of the "Tape" (Intermediate Values):** Reverse-mode AD requires recording intermediate results for use during backpropagation. In a parallel environment:
   - Each thread must maintain its own stack of intermediate values.
   - Threads must not interfere with each other, avoiding race conditions.
   - The design must guarantee the thread-private nature of the tape and consistency in access order.
4. **Determinism of Schedule Replay and Reverse Traversal Order:** Backpropagation for an OpenMP parallel loop demands that the reverse pass strictly reproduces the thread-iteration allocation of the forward pass. Furthermore, each thread must execute its iterations in the *reverse* order to ensure dependencies are met. This requires:
   - Theoretically understanding and formalizing iteration chunking and thread mapping under static scheduling.
   - Implementing a lightweight runtime helper interface to return identical iteration chunks for both forward and reverse passes.
   - Traversing these chunks in reverse order during the reverse pass.

The common theme of these challenges is the need to simultaneously manage Clang AST implementation details, OpenMP's parallel semantics, and the mathematical correctness of automatic differentiation.

## 3. Implementation Methods and Key Designs

### 3.1. Theoretical Basis and Overall Strategy

The theoretical foundation for this project was primarily drawn from the [paper](https://arxiv.org/pdf/2111.01861) on OpenMP AD by the Tapenade team. They provided a systematic demonstration and implementation of OpenMP AD on the Fortran platform, offering a complete theoretical framework for designing reverse-mode in a parallel context, including:

- How to organize forward and reverse computation order in a multi-threaded scenario.
- How to handle data attributes corresponding to different OpenMP clauses.
- How to safely replay iteration intervals under static scheduling.

Building on this, the project migrated these concepts to the Clad/Clang ecosystem. Since OpenMP constructs are converted to AST nodes during Clang's semantic analysis phase, the overall strategy was:

- Extend Clad's AST visitors with `Visit` methods for OpenMP-related nodes.
- Use a specialized differentiator for OpenMP loops instead of reusing the logic for standard `for` loops.
- Use Clang's native OpenMP construction interfaces to create new parallel regions and capture lists, allowing the generated derivative function to integrate naturally with the existing compiler pipeline.

### 3.2. Forward-Mode Support ([#1491](github.com/vgvassilev/clad/pull/1491))

A key characteristic of forward-mode is that the derivative propagation's execution order is identical to the original program. Therefore, for forward-mode with OpenMP, there were two crucial observations:

1. **The parallel structure can be directly reused:** The original OpenMP parallel region, loop partitioning, and thread scheduling can all be preserved.
2. **Variable scope relationships** in the derivative function can mirror the original function; we only need to introduce corresponding derivative variables in the same scope.

Based on these observations, the forward-mode implementation primarily involved:

- Adding corresponding derivative variables and accumulation logic to the existing OpenMP parallel loop.
- For variables with a `reduction` clause, synchronously adding a corresponding derivative reduction item in the derivative function. This ensures that derivative accumulation is also parallel-safe in a multi-threaded environment.
- Utilizing existing Clad infrastructure to generate consistent forward-mode derivative functions for different parameter types (scalars, arrays, etc.).

Overall, OpenMP support for forward-mode was structurally-clear, relatively straightforward to implement, and was demonstrated during the midterm presentation.

### 3.3. Reverse-Mode Support ([#1641](https://github.com/vgvassilev/clad/pull/1641))

Reverse-mode was significantly more complex, mainly due to the need for fine-grained control over execution order and intermediate state. To address this, several key designs were implemented within Clad:

1. **Specialized "Canonical Loop" Differentiator for OpenMP Loops:** Stacking OpenMP logic directly onto the existing `VisitForStmt` would be overly intrusive and would not provide good control over loop partitioning among threads. Therefore, we introduced a helper function specifically for processing OpenMP loops, used to construct a canonical `for` loop form suitable for OpenMP task division. This "canonical loop" serves both for forward-pass analysis (e.g., iteration counts, tape layout) and as a structural guarantee for the subsequent reverse-pass replay.
2. **Two-Pass Traversal to Build Forward and Reverse Parallel Regions and Capture Lists:** Because Clang's OpenMP implementation uses `CapturedStmt` to capture external variables, constructing a parallel region requires correctly building its capture list. In reverse-mode, we need to generate *both* a forward-pass OpenMP region and a reverse-pass OpenMP region. We adopted a "two-pass" strategy:
   - **First Pass:** Construct the forward-pass parallel region body according to the differentiation logic and use Clang's OpenMP Sema interface to finalize the region and build its capture list.
   - **Second Pass:** Construct the body of the reverse pass parallel region in a similar manner, but only for capturing variables; the function body still uses the one generated in the first pass.
3. **Scope Transformation and Variable Attribute Mapping:** To correctly set the scope of the differential variable, we needed a clear understanding of variable scope relationships inside and outside OpenMP regions, as well as the correspondence of attributes like `private`, `shared`, and `firstprivate` between the forward and reverse phases. The project used a "scope transformation" mechanism to map the lifecycle of variables from the forward pass to the corresponding structures in the reverse pass, thus ensuring:
   - Each thread in the reverse pass accesses the intermediate values *it* produced during the forward pass.
   - The accumulation of reduction variables in the reverse pass follows correct inter-thread semantics.
4. **Tape Storage and Schedule Replay:** Reverse-mode uses tapes to record intermediate results from each iteration. In the OpenMP context, these tapes were designed to be thread-private to avoid conflicts.
   - Each thread maintains an independent stack for intermediate values.
   - Their isolation is guaranteed using OpenMP's thread-private mechanism.
   - Simultaneously, to make the reverse-pass iteration match the forward pass exactly, the project designed a small runtime helper interface. This interface reproduces the iteration chunks each thread received during the forward pass (based on static scheduling). The reverse pass calls the same interface to get these chunks and traverses them in reverse order, achieving a "schedule replay" without logging the entire schedule.

Through these designs, reverse-mode for OpenMP scenarios was successfully implemented in Clad, migrating the concepts from theory to a practical compiler plugin.

## 4. Future Work

Due to time and project scope limitations, the current implementation primarily focuses on common OpenMP directives and clauses under static scheduling. Several areas can be extended and polished in the future:

1. **Support for Dynamic Scheduling:** The current schedule replay mechanism relies on the assumption of static scheduling. For dynamically scheduled loops, the runtime must record the actual iteration chunks executed by each thread, and the reverse pass must replay this record. 
2. **Support for More OpenMP Clauses and Directives:** The current work focused on common constructs like `parallel`, `for`, and `reduction`. This can be gradually expanded to:
   - More fine-grained parallel directives like `atomic` and `simd`.
   - More complex nested parallel structures.
   - Exploring specialized optimization strategies for these directives while guaranteeing mathematical correctness.
3. **Explore AD for OpenMP Target Offloading Scenarios:** As OpenMP's support for accelerators like GPUs matures, a natural direction is extending AD to OpenMP `target` offloading scenarios, allowing code executed on accelerators to also be automatically differentiated.

## 5. Summary and Acknowledgments

Most of this project's work took place at the Clang AST and semantic analysis level, which is where I learned the most. I had never had the interesting opportunity to develop and debug a compiler before, but this project allowed me to dive deep into a large number of Clang's internal details. At the same time, translating theoretical concepts from papers into a concrete code implementation was an extremely challenging but fascinating task. This GSoC gave me my first systematic experience participating in an open-source compiler project from start to finish, completing the full loop from theory to engineering. This will be of long-term value for my future research and work in compilers, automatic differentiation, and high-performance computing.

Throughout the entire GSoC period, from application to completion, I experienced many things both inside and outside the project. I am extremely grateful to my mentors, Vassil Vassilev and Martin Vassilev, and collaborator, Petro. They remained patient and helpful when I encountered difficulties. I sincerely thank them for their continuous guidance and support!

## Related links

- [LLVM Project](https://github.com/llvm/llvm-project)
- [Clad Repository](https://github.com/vgvassilev/clad)
- [My GitHub](https://github.com/Errant404)
- [Tapenade](https://gitlab.inria.fr/tapenade/tapenade)