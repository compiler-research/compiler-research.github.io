---
title: "Creating teaching materials for C++ and CUDA with xeus-cpp"
layout: post
excerpt: "Exploring how xeus-cpp behaves, porting tutorials for C++ and CUDA and Contribute small and safe improvements"
sitemap: false
author: Hristiyan Shterev
permalink: blogs/xeus_cpp_Hristiyan_Shterev_blog/
date: 2026-03-01
tags: xeus-cpp cuda jupyter c++ xeus internship high-school systems-programming
custom_css: jupyter
---

{% include dual-banner.html
left_logo="/images/mg-pld-logo.png"
right_logo="/images/cr-logo_old.png"
caption=""
height="20vh" %}

## Introduction

I am Hristiyan Shterev and I`m a high-school student with a strong interest in C++ and systems programming. Through my internship at Compiler Research, I aim to expand my understanding of interactive execution environments and contribute teaching materials with xeus-cpp.

**Mentor**: Vassil Vassilev


## Overview of the Project

`xeus-cpp` project provides a Jupyter kernel that enables interactive **C++** programming in Jupyter notebooks. It allows **C++** code to be compiled and executed cell by cell while preserving state across executions, which makes it useful for experimentation and learning, but also introduces behavior that is not always obvious.

This project starts with contained, simpler tasks that assume prior **C++** experience, rather than beginner-level programming. The initial phase focuses on writing structured **C++** programs in `xeus-cpp` notebooks and observing how they behave when split across multiple cells. These examples are used to explore and explain key aspects of the kernel, such as execution order, state persistence, recompilation, and error handling.

As the project progresses, the focus shifts toward more advanced usage patterns, including modifying existing code, reusing definitions across cells, and understanding how changes affect previously executed code. The goal is to build a clear mental model of how `xeus-cpp` works from a user’s perspective.

With this foundation, the project then moves to a high-level exploration of the `xeus-cpp` codebase to understand its overall structure and execution flow. Based on this understanding, the final stage focuses on small, practical contributions such as improving documentation, adding example notebooks, or clarifying existing behavior.



## Project Goals

The main goal of this project is to understand how `xeus-cpp` and CUDA work and how to use them together to contribute by creating teaching materials with the Jupiter notebook.

More specific goals include:

* Understanding `xeus-cpp` and its state management and differences from normal **C++** compilations

* Learn how the notebook remembers variables and functions from one cell to the next

* Porting different courses to xeus-cpp. For example:
   - C/C++: Tutorial: [Learning resources C/C++](https://researchcomputing.princeton.edu/education/external-online-resources/cplusplus?utm_source=chatgpt.com)
   - OpenMP Tutorial: [An Introduction to Parallel Programming with OpenMP](https://indico.cern.ch/event/1568686/contributions/6608233/attachments/3107963/5508628/OpenMP_CPU.pdf)
   - CUDA Tutorial: [CUDA by example](https://edoras.sdsu.edu/~mthomas/docs/cuda/cuda_by_example.book.pdf?utm_source=chatgpt.com)   


* Trigger and document most possible linking and runtime errors

* Explore the source code of xeus-cpp and learn about how it works. Contribute small and safe improvements

## Example

{::nomarkdown}

<div tabindex="-1" id="notebook" class="border-box-sizing">
  <div class="container" id="notebook-container">
    <div class="cell border-box-sizing text_cell rendered">
      <div class="prompt input_prompt"></div>
      <div class="inner_cell">
        <div class="text_cell_render border-box-sizing rendered_html">
          <h1 id="CPU - std::sort vs GPU - Merge sort speed test">CPU - std::sort vs GPU - Merge sort speed test<a class="anchor-link" href="#CPU - std::sort vs GPU - Merge sort speed test">&#182;</a></h1>
          <p>
            The example below shows a C++ benchmark comparing the performance of sorting a large array on a CPU versus a GPU. It provides a clear visual of how parallel processing can drastically outperform traditional sequential execution for data-heavy tasks.
          </p>

          <p>
            In the first cell we create the unsorted data that is going to be sorted by the CPU and GPU. We have loaded a compiled CUDA .so file beforehand.
          </p>
        </div>
      </div>
    </div>

<div class="cell border-box-sizing code_cell rendered">
      <div class="input">
        <div class="prompt input_prompt">In&nbsp;[1]:</div>
        <div class="inner_cell">
          <div class="input_area">
            <div class=" highlight hl-c++">
              <pre>
<span class="kt">unsigned int</span> <span class="n">N_bench = <span class="mi">1048576</span>;</span>
<span class="n">std<span class="o">::</span>vector<</span><span class="kt">unsigned int</span><span class="n">> data_cpu(N_bench);</span>
<span class="n">std<span class="o">::</span>vector<</span><span class="kt">unsigned int</span><span class="n">> data_gpu(N_bench);</span>

<span class="k">for</span> <span class="p">(</span><span class=
"kt">unsigned int</span> <span class="n">i</span> <span class="o">=</span> <span class=
"mi">0</span><span class="n">;</span> <span class="n">i</span> <span class=
"o">&lt;</span> <span class="n">N_bench;</span></span> <span class="n">i</span><span class="o">++</span><span class=
"n">)</span> <span class="p">{</span>
    <span class="kt">unsigned int </span><span class="n">val = N_bench - i;</span>
    <span class="n">data_cpu[i] <span class="o">=</span> val;</span>
    <span class="n">data_gpu[i] <span class="o">=</span> val;</span>
<span class="p">}</span>
</pre>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="cell border-box-sizing text_cell rendered">
      <div class="prompt input_prompt"></div>
      <div class="inner_cell">
        <div class="text_cell_render border-box-sizing rendered_html">
        <h1 id="CPU and GPU sorting">CPU and GPU sorting<a class="anchor-link" href="#CPU and GPU sorting">&#182;</a></h1>
          <p>
            Next we use std::sort and merge_sort_gpu_full function form the loaded CUDA code and measure the time the CPU and GPU sorts the data. 
          </p>
        </div>
      </div>
    </div>
  <div class="cell border-box-sizing code_cell rendered">
      <div class="input">
        <div class="prompt input_prompt">In&nbsp;[2]:</div>
        <div class="inner_cell">
          <div class="input_area">
            <div class=" highlight hl-c++">
              <pre>
<span class="k">auto</span> <span class="n">start_cpu = std<span class="o">::</span>chrono<span class="o">::</span>high_resolution_clock<span class="o">::</span>now();</span>
<span class="n">std<span class="o">::</span>sort(data_cpu.begin(), data_cpu.end());</span>
<span class="k">auto</span> <span class="n">end_cpu = std<span class="o">::</span>chrono<span class="o">::</span>high_resolution_clock<span class="o">::</span>now();</span>

<span class="n">std<span class="o">::</span>chrono<span class="o">::</span>duration&lt;double, std<span class="o">::</span>milli&gt; cpu_ms <span class="o">=</span> end_cpu - start_cpu;</span>

<span class="k">auto</span> <span class="n">start_gpu = std::chrono::high_resolution_clock::now();</span>
<span class="n">merge_sort_gpu_full(data_gpu.data(), N_bench);</span>
<span class="k">auto</span> <span class="n">end_gpu = std::chrono::high_resolution_clock::now();</span>

<span class="n">std<span class="o">::</span>chrono<span class="o">::</span>duration&lt;double, std<span class="o">::</span>milli&gt; gpu_ms <span class="o">=</span> end_gpu - start_gpu;</span>
</pre>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="cell border-box-sizing text_cell rendered">
      <div class="prompt input_prompt"></div>
      <div class="inner_cell">
        <div class="text_cell_render border-box-sizing rendered_html">
        <h1 id="">Printing the times and comparing them<a class="anchor-link" href="#Printing the times and comparing them">&#182;</a></h1>
          <p>
            Finally we print both times and compare them to see how much faster parallel processing is.
          </p>
        </div>
      </div>
    </div>
            <div class="cell border-box-sizing code_cell rendered">
      <div class="input">
        <div class="prompt input_prompt">In&nbsp;[3]:</div>
        <div class="inner_cell">
          <div class="input_area">
            <div class=" highlight hl-c++">
              <pre>
<span class="n"><span class="kt">double</span> speedup = cpu_ms.count() / gpu_ms.count();</span>

<span class="n">std<span class="o">::</span>cout << <span class="s">"CPU (std::sort) took: "</span> << std<span class="o">::</span>fixed << std<span class="o">::</span>setprecision(<span class="mi">4</span>) << cpu_ms.count() << <span class="s">" ms"</span> << std<span class="o">::</span>endl;</span>
<span class="n">std<span class="o">::</span>cout << <span class="s">"GPU (Merge Sort) took: "</span> << gpu_ms.count() << <span class="s">" ms"</span> << std<span class="o">::</span>endl;</span>

<span class="n">std<span class="o">::</span>cout << std<span class="o">::</span>endl;</span>

<span class="n">std<span class="o">::</span>cout << <span class="s">"GPU Speedup: "</span> << speedup << <span class="s">" times faster than CPU"</span> << std<span class="o">::</span>endl;</span>
</pre>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="output_wrapper">
        <div class="output">
          <div class="output_area">
            <div class="prompt output_prompt">Out[3]:</div>
            <div class="output_text output_subarea output_execute_result">
              <pre>
CPU (std<span class="o">::</span>sort) took: 145.3539 ms
GPU (Merge Sort) took: 9.6199 ms

GPU Speedup: 15.1097 times faster than CPU
</pre>
            </div>
          </div>
        </div>
      </div>
    </div>
    </div>
      
<br /> <br /> <br />

{:/}

## Related links

- [Xeus-cpp repository](https://github.com/compiler-research/xeus-cpp)
- [My github account](https://github.com/HrisShterev)
- [Project proposal](/assets/docs/Hristiyan_Shterev_project_proposal.pdf)
