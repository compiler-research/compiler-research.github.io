---
title: "Enable CUDA Compilation on Cppyy-Numba generated IR"
layout: post
excerpt: "Enable CUDA Compilation on Cppyy-Numba generated IR project, part of Google Summer of Code 2024, aims to demonstrate Cppyy's capability to provide CUDA paradigms to Python users without any compromise in performance."
sitemap: false
author: Riya Bisht
permalink: blogs/gsoc24_riya_bisht_introduction_blog/
date: 2024-05-30
tags: gsoc cuda numba llvm cppyy
---

### Introduction

I'm Riya Bisht, a third-year Computer Science & Engineering undergrad at Graphic Era University, India, and a Google Summer of Code 2024 contributor for a project related to Cppyy, an automatic, runtime Python-C++ binding generator developed by the Compiler Research Group. I am interested in low-level systems, particularly compilers, and runtimes, and also love to stay updated with science, CERN, and the mysteries of the universe. My hobbies include writing blogs and reading technoculture stuff on the web.

**Mentors**: Wim Lavrijsen, Aaron Jomy, Vassil Vassilev, Jonas Rembser

### Personal Motivation

I got introduced to this project while researching on my personal research project related to WebGPUs/WASM and low-level systems. I wanted to gain experience and technical skills in GPU programming and low-level systems mainly Compilers because this will help me in contributing to my research project and the wider Scientific Community in general. Based on my research and experience as a part of other open-source projects, I found that not many people are aware of compilers and low-level systems due to the strong belief that they are hard to understand so the goal for the future is to remove this barrier to entry and make low-level systems more accessible for beginners. 

### Introduction to Cppyy and the problem statement

Cppyy is an automatic python-C++ runtime binding generator that helps to call C++ code from Python and vice-versa. This enables interoperability between two different language ecosystems, avoids the cross-language overhead, and promotes heterogeneous computing. The initial support for Numba, a Python JIT Compiler has been added which compiles looped code containing C++ objects/methods/functions defined via Cppyy into fast machine code. This proposed project seeks to leverage Cppyy's integration with Numba, a high-performance Python compiler, to enable the compilation of CUDA C++ code defined via Cppyy into efficient machine code. 

### Importance of this project

As we know, heterogeneous computing is the future. The scientific community heavily rely on GPGPU(General-Purpose Graphics Processing Unit)computations, that incorporate CPUs as well as GPUs for running workloads based on their requirements. This architecture of GPGPUs generates a need for scientists to understand the low-level graphics APIs like CUDA(Compute Unified Device Architecture) which comes with a whole new learning curve, instead, we can use Python language which is more familiar to the scientific ecosystem. Cppyy can help provide efficient Python-CUDA C++ bindings during runtime. This enables scientists to leverage GPU acceleration in a much more user-friendly language, Python, with a rich ecosystem without compromising on performance. Based on research, Python can be slow as compared to other performant systems programming languages like C++ so we will use Numba, a high-performance Python JIT compiler that will produce fast machine code out of Python code.

### Implementation Approach and Plans

Milestones of this project include:
1. **Implementing the support of parsing and declaration of CUDA code defined in Cppyy**: Cppyy is a Python frontend that utilizes the concept of `proxies` and `reflections`. C++ objects and functions are exposed to the Python side using proxies. In the context of cppyy, `reflex` allows Python code to inspect and interact with C++ classes and functions as if they were Python objects. C++ reflection consists of type information like return types, member offsets, aggregate types(classes, structs), and namespaces. As the result of my evaluation task for this project, the CUDA code defined using cppyy was able to provide the CUDA version and CUDA device properties, such as device name and memory clock rate, by utilizing CUDA APIs. This functionality was enabled by setting the environment variable `CLING_ENABLE_CUDA` to `1` which activates Cling's CUDA backend. However, based on recent findings, `cppyy-backend`(`cppyy-cling`) is not able to handle the CUDA Kernel invocation from `cppdef`. Hence,  to add CUDA support, it is necessary to implement a cppyy helper function called `cudadef`, which is similar to `cppdef`. This is crucial for isolating CUDA code from C++ code in cppyy. Furthermore, this implementation will allow the backend to pull Cling only once with the CUDA headers enabled in the precompiled header (PCH). This approach can eliminate irrelevant errors that might occur when calling Cling twice: once with CUDA headers enabled for executing GPU kernels, and another time without CUDA headers in the PCH for executing CPU code.
By separating the CUDA and C++ code execution paths, cppyy can provide a more stable and efficient environment for integrating CUDA functionality into Python.

2. **Designing and developing CUDA compilation pipeline**: At present, the CUDA compilation is supported by adding CUDA headers to PCH(Pre-compiled headers) during runtime but this provides control to Cling, which is an interactive C++ interpreter. We want to take control from Cling and provide it to Numba using numba decorators while it invokes GPU kernels from Cppyy. Numba uses the proxies to obtain function pointers and then runs the LLVM compilation passes using `llvmlite`. That's why the scope of the project is to utilize numba so we don’t have to deal with Cling. This can include adding:
    - Support of helpers in `numba_ext.py` to simplify the process of launching CUDA kernels directly from Python.
    - Support of CUDA-specific data types in `LLVM IR`. [The research is still ongoing for this part of the project.]

3. **Testing and Documentation support**: Prepare comprehensive tests to ensure functionality and robustness. Create detailed documentation including debugging guides for users and developers.

4. **Future scope**: To provide further optimization techniques for extracting more performance out of GPUs.

Upon successful completion, a possible proof-of-concept can be expected in the below code snippet: 

```python
import cppyy
import cppyy.numba_ext

cppyy.cudadef('''
__global__ void MatrixMul(float* A, float* B, float* out) {
    // kernel logic for matrix multiplication
}
''')

@numba.njit
def run_cuda_mul(A, B, out):
    # Allocate memory for input and output arrays on GPU
    # Define grid and block dimensions
    # Launch the kernel
    MatrixMul[griddim, blockdim](d_A, d_B, d_out)
```
This would allow Python users to utilize CUDA for parallel computing on GPUs while maintaining high performance via Numba, as demonstrated by the above-provided code snippet involving matrix multiplication.

### Conclusion

The impact of this project extends far beyond Cppyy itself, as it empowers the scientific community by providing Python users with direct access to the performance and capabilities of C++ libraries. The CUDA support in the Python ecosystem through Cppyy and Numba can help accelerate the research and development in Scientific Computing domains like Data analysis(ROOT), Machine Learning, and computational sciences like simulating genetic code, protein structures, etc that rely on both languages. The following papers shows the importance of CUDA and GPU acceleration in scientific community:
    - Simulations use GPUs to run the world's largest simulations on the world's largest supercomputer: [Link](https://escholarship.org/content/qt5q63r9ph/qt5q63r9ph_noSplash_29f23cdb21b554ab0457d33f14e9d6e0.pdf)
    - This enables to perform GPU-accelerated modeling and seamless GPU-accelerated, zero-copy extensions of the fast codes from Python. Useful for rapid prototyping of new physics modules, development of in situ analysis as well as coupling multiple codes and codes with ML frameworks and the data science ecosystem: [Link]( https://arxiv.org/abs/2402.17248)

### Related Links

- [Cppyy Repository](https://github.com/wlav/cppyy)
- [Project Description](https://hepsoftwarefoundation.org/gsoc/2024/proposal_Cppyy-Numba-CUDA.html)
- [GSoC Project Proposal](/assets/docs/Riya_Bisht_GSoC2024_Proposal.pdf)
- [My GitHub Profile](https://github.com/chococandy63)