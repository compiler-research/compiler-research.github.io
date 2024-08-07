---
title: "Enabling reverse-mode automatic differentiation of GPU kernels"
layout: post
excerpt: "Nowadays, the rise of General Purpose GPU programming has caused more and more tools used by the scientific community to adjust to GPU's architecture. This project aims to allow `Clad` to ride that tide and broaden its use-range by enabling reverse-mode automatic differentiation of CUDA kernels."
sitemap: false
author: Christina Koutsou
permalink: blogs/gsoc24_christina_koutsou_project_introductory_blog/
date: 2024-05-18

---
### Overview of the project

Nowadays, the rise of General Purpose GPU programming has caused more and more tools used by the scientific community to adjust to GPU's architecture. This project aims to allow `Clad` to ride that tide and broaden its use-range by enabling reverse-mode automatic differentiation of CUDA kernels.

Mentors: Vassil Vassilev, Parth Arora, Alexander Penev
[Proposal](/assets/docs/Christina_Koutsou_GSoC_2024.pdf)
[Slides](/assets/presentations/CaaS_Weekly_15_05_2024_Christina_Enbale_reverse_mode_autodiff_for_kernels_first_presentation.pdf)

---
### Current status and end goal

Currently, `Clad` supports differentiation of both host (functions executed by the CPU) and device functions (functions executed by the GPU). However, since the device function resides in the GPU's memory, there's a need for an overlap between the CPU and the GPU. Hence, a global function is used as an intermediary. The global function, also known as a kernel, is executed by the GPU and launched by the CPU. The following example illustrates that interaction:

```cpp
__device__ double fn(double *a) {  
  return *a * *a;  
}  
  
__global__ void compute(double* d_a, double* d_result) {  
  auto fn_grad = clad::gradient(fn, "a");  
  fn_grad.execute(d_x, d_result);  
}  
  
int main(void) {  
  (...) // memory allocations and initializations  
  compute<<<1, 1>>>(d_a, d_result);  
  cudaDeviceSynchronize();  
  // copy back result to CPU  
  cudaMemcpy(result.data(), d_result, N * sizeof(double),  
                                      cudaMemcpyDeviceToHost);  
  return 0;  
}
```

It is evident that if the device function was a global one instead, the program would be much more simple and efficient. Kernels are also more widely used in general.

```cpp
__global__ void fn(double *a) {  
  *a *= *a;  
}  
  
int main(void) {  
  (...) // memory allocations and initializations

  auto fn_grad = clad::gradient(fn, "a");  
  fn_grad.execute(d_x, d_result);  
  cudaDeviceSynchronize();  
  // copy back result to CPU  
  cudaMemcpy(result.data(), d_result, N * sizeof(double),  
                                      cudaMemcpyDeviceToHost);  
  return 0;  
}
```

Thus, the end goal of this project would be to compute the gradient of a basic kernel function using Clad.

### Approach

In order to define what a basic kernel looks like and solidify the project's objectives, it is helpful to research some problems that utilize GPU kernels for their solution. Furthermore, since reverse-mode automatic differentiation is particularly beneficial when the number of inputs exceeds the number of outputs in a function, identifying such problems will be especially advantageous. Gathering such examples provide a concrete framework for the project's goals.
However, it is possible to already identify some problems that will arise during the process. These issues can be broken down into two categories:
1) General Support: The ability to produce and execute a kernel’s derivative function without it necessarily being correct. Essentially, this refers to the handling of the kernel calls.
2) Support of kernel’s nature: Derive the kernel with respect to its characteristics. This refers to correct handling of the function's body and computation of its derivative.
###### General Support: Kernel’s derivative compilation
What differentiates CUDA kernels from device or host functions is that they cannot be called without a provided grid configuration to be used. Hence, any call to them should be accompanied by such an expression. When the function to be derived is identified as a kernel through its global attribute, a default configuration expression is to be created by calling  `clang::Sema::ActOnCUDAExecConfigExpr()`. This is passed to the call expression of the derived function. The configuration is single-threaded to ensure that a single thread computes the gradient.
###### General Support: Kernel’s derivative execution
Similarly to the kernel's compilation, when the derived kernel is to be executed, it too needs to be provided with a grid configuration. For that purpose, the API can be modified to include an overloaded function of `execute()` and its nested calls, `execute_helper()` and `execute_with_default_args()`. The latter will eventually invoke the derived kernel like so:
```cpp
return f<<<grid_size, block_size, shared_mem_size, stream>>>
					(static_cast<Args>(args)..., static_cast<Rest>(nullptr)...);
```
###### General Support: Derivation of a kernel call
To further enhance the support for kernel differentiation, we should ensure that deriving a function that includes a kernel invocation can successfully call the derived kernel. Thus, when the `CUDAKernelCallExpr` is visited during the top level of derivation, we should store its configuration to use for the pullback kernel call. Specifically, a Visit function for kernels calls will be written, that mimics the one used for typical CallExpr nodes. However, it will additionally include storing the specified configuration using `getConfig()` on the kernel node and then passing it to the creation of the pullback kernel call expression through `clang::Sema::ActOnCallExpr()`.
###### Support of kernel’s characteristics: Specify output argument to derive
Kernels are void functions, which means that derivation based on the return statement is not possible. As a result, we need to know the output of the function. This can be accomplished by the expansion of the API to include an overload of the `gradient()` function, where the user can specify the output argument of only void functions. This argument will be passed to the differentiation request of this function and stored to the variable list whose expressions are derived. 
###### Support of kernel’s characteristics: Account for write race conditions in computation of the derivative value
To also account for the multithreaded environment of a kernel, the plus-assign operation to the derived function's output would result to incorrect results, as each thread would add the derivative value. Hence, this operation should be instead replaced with a plain assign operation. Furthermore, if array indexing is involved, the derived variable should also be considered as an array to avoid write race conditions in case the derivative array of the output is not initialized equally.
```cpp
__global__ void compute(double *in, double *out, double val)  
{  
  int index = threadIdx.x;  
  out[index] = in[index] + val;  
}

(derived function){
...
double _r_d0 = _d_out[index0];
* _d_val += _r_d0; —> * _d_val[index0] = _r_d0;
}
```
###### Support of kernel’s characteristics: Handling of CUDA built-in objects
Another common characteristic of CUDA kernels is the use of built-in objects, e.g. `threadIdx`, as depicted above, to ensure that each thread computes its own share of the final result. These nodes should only be cloned when visited in the global initializations and be treated as integers when differentiated, or in other words their derivatives should be 0. In addition,  support for the shared memory macro must also be included in the project’s scope, by not discarding it when visiting a variable or array declaration.

---
### About me

Hi, I'm Christina, an Electrical and Computer Engineering major in Aristotle University of Thessaloniki, Greece. My participation in Google Summer of Code was fueled by a deep appreciation for open-source projects, stemming from my two-year experience with an open-source student team that particpates in ESA Education's Fly Your Satellite program. Despite my passion for physics, it did not lead me down that career path, but I'm trying to channel my enthusiasm into developing tools for the scientific community. Clad offers a great opportunity to do just that and contribute to research advancements.

