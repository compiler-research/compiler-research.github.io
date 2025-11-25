---
title: "Activity analysis for reverse-mode differentiation of (CUDA) GPU kernels"
layout: post
excerpt: "A summary of my GSoC 2025 project focusing on activity analysis for reverse-mode differentiation of (CUDA) GPU kernels."
sitemap: true
author: Maksym Andriichuk
permalink: blogs/gsoc25_andriichuk_final_blog/
banner_image: /images/blog/gsoc-clad-banner.png
date: 2025-11-14
tags: gsoc clad cuda clang c++
---

**Mentors:** Vassil Vassilev, David Lange

## A Brief Introduction

### Main idea

Over a year ago, we added support for differentiating CUDA kernels using Clad. Read more on that [here](https://compiler-research.org/blogs/gsoc24_christina_koutsou_project_final_blog/). We introduced atomic operations in Clad to prevent race conditions that frequently appear because of how Clad handles statements like ```x=y``` in the reverse mode. Since atomic operations are inefficient, we aim to remove them whenever we are sure no race condition occurs.

Another part of my GSoC project was to unify Varied and TBR analyses in how they store information during the analysis run. This would make the implementation of future analyses easier and remove even more adjoints, since Varied Analysis does not account for variable reassignments.

## Project Implementation

### 1. Removing atomic operations 

Consider the code below:

```cpp
__global__ void kernel_call(double *out, double *in) {
    int index = threadIdx.x + blockIdx.x * blockDim.x;
    out[index] = in[index];
}
}
void fn(double *out, double *in) {
    kernel_call<<<1, 16>>>(out, in);
}
```

The adjoint that corresponds to ```out[index] = in[index]``` is:

```cpp
{
    out[index0] = _t2;
    double _r_d0 = _d_out[index0];
    _d_out[index0] = 0.;
    atomicAdd(&_d_in[index], _r_d0);
}
```

Notice that in this case index is ```injective```, meaning no two threads from any two blocks have the same value of index. This means that when writing to ```_d_in[index]```, no two threads would be able to write to the same memory at the same time.

The implementation involves two static analyzers: one checks whether an index matches some particular form, and the other checks if it was not changed later. The hardest part is accounting for all possible term permutations of, say, ```threadIdx.x + blockIdx.x * blockDim.x``` and for expressions that depend on index linearly, i.e., ```2*index+1```.

### 2. Varied Analysis

The implementation looked very straightforward at first but turned out to be harder. Since the new infrastructure is more detailed, the analyses had to be improved. The tricky parts were supporting variable reassignments and loop handling. Support for pointers and OOP was added, and the analysis was enabled on all gradient tests numerically, which makes it almost default. However, there are more things to be done to produce even less code.

### 3. Benchmarks

To compare how much difference the analysis makes, we used the LULESH benchmark. The difference in execution time was about 5% across all problem sizes, which is pretty good for an analysis this small. 

In trivial cases like the ```kernel_call``` function above, we got up to 5x speedup with a given number of blocks/threads.

## Future Work

- Adding more capabilities to the Varied Analysis
- Adding more indices to consider injective

## Related Links

- [Clad Repository](https://github.com/vgvassilev/clad)
- [My GitHub Profile](https://github.com/ovdiiuv)
