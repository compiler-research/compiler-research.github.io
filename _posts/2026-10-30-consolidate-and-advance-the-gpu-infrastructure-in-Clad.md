---
title: "Wrapping up GSoC 2026: Consolidate and advance the GPU infrastructure in Clad"
layout: post
excerpt: "A GSoC 2026 project aimed at consolidating the fragmented GPU work and advancing the GPU infrastructure"
sitemap: true
author: Vedant Goyal
permalink: blogs/gsoc26_vedant_final_blog/
banner_image: /images/blog/banner-clad-gsoc.png
date: 2026-10-30
tags: gsoc clad clang cuda c++
---

### Introduction

When I began Google Summer of Code 2026, the goal was ambitious: to make GPU-based automatic differentiation more practical, reliable, and performant in Clad. The idea was to consolidate fragmented GPU support, extend reverse-mode differentiation for CUDA kernels, and validate the infrastructure against real-world High-Performance Computing (HPC) workloads.

This post takes you through that journey. We explore the main technical decisions, results and lessons learned while working on compiler-driven automatic differentiation.


**Mentors:** Aaron Jomy, David Lange, Vassil Vassilev

### Project Overview
Clad is a Clang-based automatic differentiation tool for C++. It leverages Clang's compiler infrastructure to analyze C++ source code and generate derivative computations at compile time.

Although Clad already had CUDA differentiation support, several GPU-related implementations were distributed across different branches and experimental contributions. This made it difficult to maintain consistent functionality and evaluate performance across GPU workloads.

My project focused on strengthening this infrastructure, improving reverse-mode differentiation for CUDA kernels, integrating HPC benchmarks, and addressing correctness issues exposed during development and testing.

### Project Implementation
### Phase1: Strengthening GPU Infrastructure
#### CUDA Shared Memory Support
CUDA shared memory allows threads within a block to cooperate through a low-latency memory region. Supporting shared-memory operations in reverse-mode differentiation is important for differentiating GPU kernels that rely on thread cooperation and block-level computations.

``` cpp
__global__ void sum_shared(int *input, int *output, int N) {
    __shared__ int cache[256];
    int tid = threadIdx.x;
    int idx = blockIdx.x * blockDim.x + tid;
    int stride = blockDim.x * gridDim.x;

    int local_sum = 0;
    for (int i = idx; i < N; i += stride) {
        local_sum += input[i];
    }
    cache[tid] = local_sum;
    __syncthreads();
    for (int s = blockDim.x / 2; s > 0; s /= 2) {
        if (tid < s)
            cache[tid] += cache[tid + s];
        __syncthreads();
    }
    if (tid == 0)
        atomicAdd(output, cache[0]);
}
```

#### Enabling restore_tracker in GPU Device Kernels

The restore tracker saves primal values during the forward sweep so they can be restored during reverse-mode differentiation. CUDA device support was introduced by adapting its storage for device execution, then optimized it by consolidating records into a single contiguous buffer to reduce per-value allocation overhead.

```cpp
#ifdef __CUDACC__
struct MetaData {
    char* addr;
    size_t size;
    size_t off;
};

MetaData m_meta[Max_Records];
uint8_t m_buf[Max_Bytes];
size_t m_cnt = 0, m_off = 0;

public:
    __host__ __device__ restore_tracker() = default;

    template <typename T>
    __host__ __device__ void store(const T& val) {
        for (size_t i = 0; i < m_cnt; ++i) {
            if (m_meta[i].addr == (char*)&val)
                return;
        }

        if (m_cnt >= Max_Records || m_off + sizeof(T) > Max_Bytes) 
            return;
        
        m_meta[m_cnt] = {(char*)&val, sizeof(T), m_off};
        std::memcpy(m_buf + m_off, &val, sizeof(T));
        m_off += sizeof(T);
        m_cnt++;
    }

    __host__ __device__ void restore() {
        for (size_t i = 0; i < m_cnt; ++i) {
            std::memcpy(m_meta[i].addr, m_buf + m_meta[i].off,
                        m_meta[i].size);
        }
        m_cnt = m_off = 0;
    }
#endif
```

#### CUDA Activity Analysis and Varied Analysis
Activity analysis identifies variables that contribute to the differentiated result. CUDA built-ins such as `threadIdx`, `blockIdx`, `blockDim`, and `gridDim` are treated as passive to avoid unnecessary adjoint allocations and tape entries. Kernel-launch handling was also improved to correctly propagate variations through pointer arguments, ensuring that required adjoints and gradient seeds are not missed.

### Phase2: HPC Benchmark Integration

An important part of the project was moving beyond isolated CUDA examples and evaluating Clad against representative HPC workloads.

#### LULESH

It is a proxy application used in the HPC proxy application used to evaluate computational performance. In the tested configurations, Clad was **6.4× faster** at grid size 25 and **8.6× faster** at grid size 35.

![Benchmarks](/images/blog/lulesh_benchmark.png){: width="500px"}

### XSBench

XSBench is an HPC proxy application for Monte Carlo neutron transport simulations. In the tested configurations, results showed Clad running **~2× faster** than Enzyme.

![Benchmarks](/images/blog/xsbench_benchmark.png){: width="500px" }

#### Phase3: Integrating Clad with GradBench
GradBench is a benchmarking suite designed to compare automatic differentiation tools across different programming languages and computational domains. The incorporation of Clad into the GradBench benchmarking workflow exposed several edge cases in its differentiation and code-generation pipelines.

Some important bugs fixed:
- Correct handling of calls inside Clad-generated derivative functions.
- Preventing duplicated tape-pop operations caused by cloning shared adjoint seeds.
- Correcting gradient accumulation for expressions involving side effects such as a[i++]

![Benchmark](/images/blog/gradbench.png){: width="700px"}

### Future Work
- Further develop activity analysis for CUDA device code.
- Optimize GPU diff performance by improving memory management, synchronization, and tape operations to reduce overhead and improve scalability.

### Related Links
- [Project Description](https://hepsoftwarefoundation.org/gsoc/2026/proposal_Clad-GPU.html)
- [Clad Repository](https://github.com/vgvassilev/clad)
- [GSoC Project Proposal](/assets/docs/Vedant_Goyal_Proposal_2026.pdf)
- [My Github Profile](https://github.com/Vedant2005goyal)
