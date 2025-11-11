---
title: "Wrapping up GSoC 2025: Implement and improve an efficient, layered tape with prefetching capabilities"
layout: post
excerpt: "A summary of my GSoC 2025 project focusing on optimizing Clad's tape data structure by introducing slab-based memory, small buffer optimization, thread safety and multilayer storage."
sitemap: true
author: Aditi Milind Joshi
permalink: blogs/gsoc25_aditi_final_blog/
banner_image: /images/blog/gsoc-clad-banner.png
date: 2025-11-11
tags: gsoc clad clang c++
---

**Mentors:** Aaron Jomy, David Lange, Vassil Vassilev

## A Brief Introduction

### What is Automatic Differentiation?

Automatic Differentiation (AD) is a computational technique that enables efficient and precise evaluation of derivatives for functions expressed in code.

### What is Clad?

Clad is a Clang-based automatic differentiation tool that transforms C++ source code to compute derivatives efficiently.

### Tape in Clad

The tape is a stack-like data structure that stores intermediate values in reverse mode AD during the forward pass for use during the backward (gradient) pass.

This project focuses on improving the implementation and efficiency of the tape by removing unnecessary allocations, adding support for different features like thread-safety and offloading to disk and enhancing the related benchmarks.

### Understanding the Previous Implementation of the Tape and its Limitations

In Clad’s previous implementation, the tape was a monolithic memory buffer. It was a contiguous dynamic array and each time a new entry was pushed onto the tape and the underlying capacity was exceeded, the array grew by allocating a new larger block of memory of double the capacity, copying all existing entries to the new block and deallocating the old block.

```cpp
constexpr static std::size_t _init_capacity = 32;
CUDA_HOST_DEVICE void grow() {
  // If empty, use initial capacity.
  if (!_capacity)
    _capacity = _init_capacity;
  else
    // Double the capacity on each reallocation.
    _capacity *= 2;
  T* new_data = AllocateRawStorage(_capacity);

  // Move values from old storage to the new storage. Should call move
  MoveData(begin(), end(), new_data);
  // Destroy all values in the old storage.
  destroy(begin(), end());
  // delete the old data here to make sure we do not leak anything.
  ::operator delete(const_cast<void*>(
        static_cast<const volatile void*>(_data)));
  _data = new_data;
}
```

It dynamically resized its storage using a growth factor of 2x when capacity was exceeded. This led to expensive memory reallocation and copying overhead. While this approach was lightweight for small problems, it became inefficient and non-scalable for larger applications or parallel workloads. Frequent memory reallocations, lack of thread safety, and the absence of support for offloading made it a limiting factor in Clad’s usability in complex scenarios.

## Project Implementation

### 1. Slab-based Tape

Instead of reallocating memory, a slab-based memory allocation strategy is used. This involves allocating connected memory chunks (slabs) and linking them dynamically as the tape grows, reducing unnecessary reallocations. Each time an element is pushed onto the tape and the capacity is exceeded a new slab is allocated and linked to last slab, forming a linked list structure.

```cpp
struct Slab {
	alignas(T) char raw_data[SLAB_SIZE * sizeof(T)];
	Slab* prev;
	Slab* next;
	CUDA_HOST_DEVICE Slab() : prev(nullptr), next(nullptr) {}
	CUDA_HOST_DEVICE T* elements() {
#if __cplusplus >= 201703L
      return std::launder(reinterpret_cast<T*>(raw_data));
#else
      return reinterpret_cast<T*>(raw_data);
#endif
}
};
```

### 2. Small Buffer Optimization

Additionally, to further optimize performance for small-scale or short-lived tapes, a small buffer optimization (SBO) was introduced as part of the design. With SBO, elements are initially pushed onto a small statically allocated buffer. Only when this buffer overflows does the system transition to heap-allocated slabs.

```cpp
alignas(T) char m_static_buffer[SBO_SIZE * sizeof(T)];
```

### 3. Further Tape Improvements

There were further improvements made to the slab-based implementation of the tape during the course of the project which included adding a tail pointer which pointed to the last slab to reduce push pop operation runtime to O(n), using a capacity variable to reuse slabs and making the tape a doubly linked list to keep track of the tail pointer without traversing the entire tape after pop operations.

*Push Function:*
```cpp
template <typename... ArgsT>
CUDA_HOST_DEVICE void emplace_back(ArgsT&&... args) {
if (m_size < SBO_SIZE) {
  // Store in SBO buffer
  ::new (const_cast<void*>(static_cast<const volatile void*>(
      sbo_elements() + m_size))) T(std::forward<ArgsT>(args)...);
} else {
  const auto offset = (m_size - SBO_SIZE) % SLAB_SIZE;
  // Allocate new slab if required
  if (!offset) {
    if (m_size == m_capacity) {
      Slab* new_slab = new Slab();
      if (!m_head)
        m_head = new_slab;
      else {
        m_tail->next = new_slab;
        new_slab->prev = m_tail;
      }
      m_capacity += SLAB_SIZE;
    }
    if (m_size == SBO_SIZE)
      m_tail = m_head;
    else
      m_tail = m_tail->next;
  }

  // Construct element in-place
  ::new (const_cast<void*>(static_cast<const volatile void*>(
      m_tail->elements() + offset))) T(std::forward<ArgsT>(args)...);
}
m_size++;
}
```

*Pop Function:*
```cpp
CUDA_HOST_DEVICE void pop_back() {
	assert(m_size);
	m_size--;
	if (m_size < SBO_SIZE)
	  destroy_element(sbo_elements() + m_size);
	else {
	  std::size_t offset = (m_size - SBO_SIZE) % SLAB_SIZE;
	  destroy_element(m_tail->elements() + offset);
	  if (offset == 0) {
	    if (m_tail != m_head)
	      m_tail = m_tail->prev;
	  }
	}
}
```

### 3. Enhancements in Benchmarks

- Benchmark Script:
Added a benchmark script which takes two revisions (baseline and current) and computes and compares the benchmarks of both.

- Configurable Benchmarks:
Added configurable tape memory benchmarks which take different slab and SBO sizes to test and find the optimal size.

```cpp
template <std::size_t SBO_SIZE, std::size_t SLAB_SIZE>
static void BM_TapeMemory_Templated(benchmark::State& state) {
  int block = state.range(0);
  AddBMCounterRAII MemCounters(*mm.get(), state);
  for (auto _ : state) {
    clad::tape<double, SBO_SIZE, SLAB_SIZE> t;
    func<double, SBO_SIZE, SLAB_SIZE>(t, 1, block * 2 + 1);
  }
}

#define REGISTER_TAPE_BENCHMARK(sbo, slab)                                     \
  BENCHMARK_TEMPLATE(BM_TapeMemory_Templated, sbo, slab)                       \
      ->RangeMultiplier(2)                                                     \
      ->Range(0, 4096)                                                         \
      ->Name("BM_TapeMemory/SBO_" #sbo "_SLAB_" #slab)

REGISTER_TAPE_BENCHMARK(64, 1024);
REGISTER_TAPE_BENCHMARK(32, 512);
```
- Fixes in Benchmarks:
	- Removed ```Iterations(1)``` to get better estimate of the benchmarks.
	- Fixed memory manager counters.
	- Added ```DoNotOptimize()``` to prevent compiler from optimizing out the pop function.

### 4. Tape Thread-Safety

Added thread-safe tape access functions with mutex locking mechanism to allow for concurrent access. Since the locking mechanism has significant overhead, the tape access functions were overloaded and separate thread-safe functions have been introduced which can be used as the default tape access functions by setting the ```is_multithread``` template parameter to ```true``` during tape initialization.

```cpp
/// Thread safe tape access functions with mutex locking mechanism
#ifndef __CUDACC__
  /// Add value to the end of the tape, return the same value.
  template <typename T, std::size_t SBO_SIZE = 64, std::size_t SLAB_SIZE = 1024,
            typename... ArgsT>
  T push(tape<T, SBO_SIZE, SLAB_SIZE, /*is_multithreaded=*/true>& to,
         ArgsT&&... val) {
    std::lock_guard<std::mutex> lock(to.mutex());
    to.emplace_back(std::forward<ArgsT>(val)...);
    return to.back();
  }

  /// A specialization for C arrays
  template <typename T, typename U, size_t N, std::size_t SBO_SIZE = 64,
            std::size_t SLAB_SIZE = 1024>
  void push(tape<T[N], SBO_SIZE, SLAB_SIZE, /*is_multithreaded=*/true>& to,
            const U& val) {
    std::lock_guard<std::mutex> lock(to.mutex());
    to.emplace_back();
    std::copy(std::begin(val), std::end(val), std::begin(to.back()));
  }

  /// Remove the last value from the tape, return it.
  template <typename T, std::size_t SBO_SIZE = 64, std::size_t SLAB_SIZE = 1024>
  T pop(tape<T, SBO_SIZE, SLAB_SIZE, /*is_multithreaded=*/true>& to) {
    std::lock_guard<std::mutex> lock(to.mutex());
    T val = std::move(to.back());
    to.pop_back();
    return val;
  }

  /// A specialization for C arrays
  template <typename T, std::size_t N, std::size_t SBO_SIZE = 64,
            std::size_t SLAB_SIZE = 1024>
  void pop(tape<T[N], SBO_SIZE, SLAB_SIZE, /*is_multithreaded=*/true>& to) {
    std::lock_guard<std::mutex> lock(to.mutex());
    to.pop_back();
  }

  /// Access return the last value in the tape.
  template <typename T, std::size_t SBO_SIZE = 64, std::size_t SLAB_SIZE = 1024>
  T& back(tape<T, SBO_SIZE, SLAB_SIZE, /*is_multithreaded=*/true>& of) {
    std::lock_guard<std::mutex> lock(of.mutex());
    return of.back();
  }
#endif
```

### 5. Multilayer Storage (Ongoing)

To scale AD beyond memory limits, an offloading mechanism to offload slabs to disk and load slabs from disk to memory is being introduced. Instead of keeping all the slabs in memory, only the last N slabs are kept in memory at a time and the rest are offloaded to the disk. One slab space is kept for random access where slabs are loaded if element to be loaded is not in memory.

## Results and Benchmarks

The current tape implementation was tested against the old tape, ```std::vector```, ```std::stack``` and tapenade.
The following were the results obtained:

![Benchmarks](/images/blog/gsoc25_tape_benchmarks.png)

## Future Work

- Supporting CPU-GPU memory transfers for future heterogeneous computing use cases.
- Introducing checkpointing for optimal memory-computation trade-offs.

---

## Related Links

- [Clad Repository](https://github.com/vgvassilev/clad)
- [Project Description](https://hepsoftwarefoundation.org/gsoc/2025/proposal_Clad-ImproveTape.html)
- [GSoC Project Proposal](/assets/docs/Aditi_Milind_Joshi_Proposal_2025.pdf)
- [My GitHub Profile](https://github.com/aditimjoshi)
