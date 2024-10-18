---
title: "Wrapping up GSoC'24: Improving performance of BioDynaMo using ROOT C++ Modules"
layout: post
excerpt: "This project, part of Google Summer of Code 2024, aims to reduce the header parsing in BioDynaMo using the ROOT C++ Modules"
sitemap: false
author: Isaac Morales Santana
permalink: blogs/gsoc24_isaac_morales_wrapup_blog/
banner_image: /images/blog/gsoc-banner.png
date: 2024-10-17
tags: gsoc root cmake c++ 
---

### Introduction

I am Isaac Morales, a Computer Engineering student at the University of Granada, Spain.
This summer I had the opportunity to participate in Google Summer of Code 2024. My project
revolved around enhancing BioDynaMo's performance using the ROOT C++ Modules.

**Mentors**: Vassil Vassilev, Lukas Breitwieser.


### Project overview

BioDynaMo is an agent-based simulation platform designed to facilitate complex simulations,
particularly in fields like cancer research, epidemiology, and social sciences. It leverages
ROOT—a framework widely used in high-energy physics—for statistical analysis, random number 
generation, C++ Jupyter notebooks, and I/O operations. However, enhancing BioDynaMo’s performance
remains a key challenge. This is where this Google Summer of Code 2024 (GSoC ‘24) project comes
into play, focusing on optimizing the platform through ROOT C++ Modules.

### The Challenge: Performance Bottlenecks in BioDynaMo
BioDynaMo’s reflection system, which utilizes Cling (an interactive C++ interpreter from ROOT),
experiences significant runtime performance and memory usage issues. The repeated parsing of library
descriptors by Cling introduces inefficiencies that slow down the startup phase and consume excessive
memory. These bottlenecks are especially evident in simulations with a low number of time steps, as
a substantial portion of the time is spent on parsing rather than on actual computations.

### The Solution: Integrating ROOT C++ Modules.
The primary goal of the GSoC project was to integrate ROOT’s C++ Modules into BioDynaMo to minimize
these performance issues. C++ Modules offer an efficient on-disk representation of C++ code,
reducing the need for repeated parsing of invariant code. By implementing these modules,
the project aimed to optimize runtime memory usage and improve overall performance

## Key steps undertaken include:
1. **Reworking CMake Rules:** The project incorporated ROOT and another packages
efficiently using FetchContent, modifying CMake rules accordingly (e.g., PR [#365](https://github.com/BioDynaMo/biodynamo/pull/365)
and [#387](https://github.com/BioDynaMo/biodynamo/pull/387))
2. **Replacing genreflex with rootcling:** This switch was crucial to enable C++ Modules and
streamline the generation of reflection information (PR [#379](https://github.com/BioDynaMo/biodynamo/pull/379))
3. **Automatic Modules Map Generation:** Using relative paths, the CMake system was modified to
automate module map creation, ensuring smooth integration with BioDynaMo's libraries.

### Promising Results
The results have been promising, showcasing significant performance gains. Benchmarking revealed 
improvements ranging from 18% reduction in peak memory usage with the default modules.idx to 25% with the
updated one.
![Plot of the peak memory usage in various demos](/images/blog/bdm-peak-memory.png)


Moreover, the startup phase saw an impressive 80% reduction in time, thanks to the optimized
handling of header parsing. That highlights the efficiency of C++ Modules in minimizing
Cling’s parsing overhead
![Plot of the startup time in various demos](/images/blog/bdm-startup-time.png)

As expected, the simulation time did not show an appreciable improvement. However, in the
unit tests, the time was 33% lower. I believe this is because unit tests involve a lot of parsing and Cling calls.

### Future Steps and Challenges Ahead
Despite these advances, several challenges remain. For instance, memory leaks have been observed when using the new
`ROOT_GENERATE_DICTIONARY`, even with C++ Modules disabled. Additionally, the build system for individual demos has
caused compatibility issues with the main build system. Resolving these issues and finalizing the integration of C++
Modules will be essential for ensuring long-term stability and reliability.

Looking ahead, further optimizations are planned, including potential module-based optimizations for BioDynaMo’s
core components. Collaboration with the BioDynaMo team continues, with upcoming meetings scheduled
to align efforts and resolve outstanding issues.

### Conclusion
The integration of C++ Modules has proven effective in reducing memory usage and startup time, although some hurdles remain.
Continued collaboration and testing will be crucial to fully realize the performance potential of BioDynaMo,
enabling more efficient simulations for researchers in computational biology.

### Related Links

- [ROOT website](https://root.cern)
- [BioDynaMo website](https://www.biodynamo.org/)
- [My GitHub Profile](https://github.com/imorlxs)


