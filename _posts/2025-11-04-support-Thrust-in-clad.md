---
title: "Supporting Thrust API in Clad - Final Report"
layout: post
excerpt: "A comprehensive wrap-up of my Google Summer of Code 2025 project on enabling automatic differentiation of GPU-accelerated code through Thrust API support in Clad."
sitemap: false
author: Abdelrhman Elrawy
permalink: blogs/gsoc25_elrawy_wrapup_blog/
banner_image: /images/blog/thrust-clad-banner.jpg
date: 2025-11-04
tags: gsoc automatic-differentiation clad gpu cuda thrust
---

## Project Summary

This summer, I successfully completed my Google Summer of Code 2025 project on **Supporting Thrust API in Clad**, bringing GPU-accelerated automatic differentiation to the world of high-performance computing. Working under the mentorship of Vassil Vassilev and Alexander Penev, I merged **16 pull requests** that extended Clad's capabilities to differentiate through NVIDIA's Thrust parallel algorithms library.

[Clad](https://github.com/vgvassilev/clad) is a source-transformation automatic differentiation (AD) tool built as a Clang plugin. Before this project, Clad couldn't handle GPU-parallel primitives from Thrust, limiting its applicability in scientific computing and machine learning applications that leverage GPU acceleration. This project bridges that gap, enabling researchers and engineers to automatically compute gradients for CUDA-accelerated code with minimal code changes.

## What Was Accomplished

### Core Algorithm Support (8 PRs)

The foundation of this project was implementing differentiation support for Thrust's most fundamental parallel primitives:

1. **`thrust::reduce`** - Parallel reductions with multiple binary operators (sum, max, min, product)
   - Implemented special handling for mathematical edge cases, particularly multiplication with zeros
   - Added support for multiple binary operator variants
   - Developed both forward and reverse-mode AD implementations

2. **`thrust::inner_product`** - Dot products and inner products
   - Implemented both 4-argument and 6-argument versions
   - Critical for linear algebra operations on GPU
   - Enables efficient gradient computation for vector operations

3. **`thrust::transform`** - Element-wise transformations
   - Generic functor support for arbitrary user-defined transformations
   - Maintains efficient GPU parallelization in derivative code
   - Foundation for many higher-level operations

4. **`thrust::transform_reduce`** - Fused transformation and reduction
   - Combines transform and reduce to minimize memory traffic
   - Essential for ML operations like computing norms and loss functions

5. **`thrust::copy`** - Memory operations with gradient tracking
   - Ensures proper gradient flow during data movement
   - Handles device-to-device and host-device transfers

6. **`thrust::adjacent_difference`** - Computing differences between adjacent elements
   - Useful for finite difference schemes and time-series analysis
   - Proper derivative handling for sequential dependencies

### Advanced Operations (4 PRs)

Building on the core algorithms, I implemented support for more sophisticated parallel primitives:

1. **Scan Operations** - Inclusive and exclusive prefix sums
   - Fundamental building blocks for many parallel algorithms
   - Applications in cumulative distributions, parallel scheduling, and dynamic programming
   - Efficient parallel backward pass for gradient accumulation
   - Technical challenge: output at position *i* depends on all inputs up to *i*

2. **`thrust::sort_by_key`** - Sorting key-value pairs with gradient preservation
   - Forward pass records index permutation
   - Backward pass applies inverse permutation to gradients
   - Critical for algorithms requiring sorted data structures

3. **`thrust::reduce_by_key`** - Segmented reductions for grouped data
   - SQL-like GROUP BY operations on GPU
   - Essential for batch processing in neural networks
   - Complex gradient routing through irregular partition boundaries

4. **Segmented Scans** - Advanced partitioned prefix sum operations
   - Prefix sums within each segment
   - Handles complex gradient flow through segmented data structures

### Infrastructure Improvements (2 PRs)

1. **`thrust::device_vector` Support**
   - Differentiate against the constructors of the containers in Thrust
   - Interoperability with existing Thrust code

2. **Generic Functor Support for Transform**
   - Users can define custom functors
   - Greatly extends the flexibility of `thrust::transform`

### Demonstration Applications (2 PRs)

To showcase the practical utility of this work, I developed several real-world demonstrations:

1. **Multiple Thrust-based Demo Applications**
   - Linear regression with GPU-accelerated gradient computation
   - Particle simulation with automatic derivative tracking
   - Demonstrates end-to-end workflows from problem setup to gradient computation

2. **Bag-of-Words Logistic Regression**
   - Complete machine learning pipeline using Thrust and Clad
   - GPU-accelerated logistic regression with gradient descent
   - Cross-entropy loss function with automatic differentiation
   - Showcases how Thrust operations (`reduce`, `transform`, `inner_product`) combine for ML workflows
   - All computations remain on GPU device memory for maximum performance


### Example: Differentiating `thrust::reduce`

Consider a simple reduction operation:
```cpp
double sum = thrust::reduce(vector.begin(), vector.end(), 0.0, thrust::plus<double>());
```

The derivative with respect to the input vector is straightforward mathematically (each element contributes 1 to the sum), but the implementation must:
1. Recognize the Thrust API call during Clad's AST traversal
2. Generate GPU-compatible derivative code
3. Properly allocate gradient storage on the device
4. Handle edge cases (empty ranges, custom operators)

My implementation handles all of these automatically, generating efficient CUDA code that maintains the parallel performance characteristics of the original operation.

## Challenges and Solutions

### 1. GPU Memory Errors

**Problem**: Tracing memory access violations within the CUDA/Thrust environment proved complex. Pointer dereferencing errors on the GPU manifest differently than on CPU, making debugging challenging.

**Solution**: Leveraged NVIDIA's `compute-sanitizer` tool for precise memory error detection. Implemented careful GPU pointer management with explicit lifetime tracking.

### 2. Mathematical Edge Cases

**Problem**: Derivatives can be undefined or require special handling for certain operations. For example, the derivative of `x * y * 0` with respect to `x` is technically zero, but naive implementation might lose important gradient information.

**Solution**: Implemented sophisticated logic to count and track zero-value inputs. Developed special-case handling for single and multiple zero inputs. Added extensive unit tests covering edge cases including:
- Multiplication chains with zeros
- Division by small numbers
- Overflow/underflow scenarios
- Empty sequences

### 3. Correctness Validation

**Problem**: Verifying that GPU-accelerated derivatives are mathematically correct is non-trivial. Standard debugging tools don't work well with GPU code.

**Solution**: Multi-pronged validation approach:
- **Finite difference comparison**: Compare AD results against numerical derivatives
- **Comprehensive unit tests**: Test each primitive in isolation with known inputs/outputs
- **Integration tests**: Verify derivatives in real-world demo applications


## Impact and Applications

This work significantly expands Clad's applicability in several domains:

### High-Energy Physics
- Gradient-based optimization for detector simulations
- Parameter estimation in complex physical models
- Enables GPU acceleration of gradient computations for large-scale simulations

### Machine Learning
- GPU-accelerated training for custom models
- Efficient gradient computation for loss functions
- Enables researchers to prototype GPU-native ML algorithms with automatic differentiation


## Future Work

While the core objectives were achieved, several exciting directions remain for future development:

### Additional Thrust Primitives

- **`thrust::gather` and `thrust::scatter`**: Memory access patterns with gradients
- **`thrust::partition`**: Partitioning operations with gradient preservation
- **`thrust::unique`**: Handling duplicate elimination in derivative code
- **Additional sorting operations**: `thrust::stable_sort`, `thrust::sort_by_key` variants

### Real-World Applications

- **Neural network training**: Full GPU-native neural network training with Clad
- **Physics simulations**: Large-scale physics simulations with gradient-based parameter optimization


## Conclusion

This Google Summer of Code project successfully brought GPU-accelerated automatic differentiation to Clad through comprehensive Thrust API support. The 16 merged pull requests cover core algorithms, advanced operations, infrastructure improvements, and practical demonstrations. This work opens new possibilities for researchers and engineers who need efficient gradient computations in GPU-accelerated applications.

## Related Links

- [Clad GitHub Repository](https://github.com/vgvassilev/clad)
- [Project Proposal](https://hepsoftwarefoundation.org/gsoc/2025/proposal_Clad-ThrustAPI.html)
- [My GitHub Profile](https://github.com/a-elrawy)
