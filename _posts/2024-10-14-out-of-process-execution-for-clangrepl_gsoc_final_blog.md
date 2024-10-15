---
title: "Wrapping Up GSoC 2024: Out-Of-Process Execution for Clang-REPL"
layout: post
excerpt: "Out of Process Execution for Clang-Repl project, part of Google Summer of Code 2024, aims to enhance Clang-Repl by implementing out-of-process execution. This will address issues of high resource consumption and instability, making Clang-Repl more suitable for low-power devices and more stable for developers"
sitemap: false
author: Sahil Patidar
permalink: blogs/gsoc24_sahil_wrapup_blog/
banner_image: /images/blog/gsoc-banner.png
date: 2024-10-14
tags: gsoc llvm clang-repl orc-jit llvm-jitlink-executor
---

### **Introduction**

Hello! I'm Sahil Patidar, and this summer I had the exciting opportunity to
participate in Google Summer of Code (GSoC) 2024. My project revolved around
enhancing Clang-Repl by introducing Out-Of-Process Execution.

Mentors: Vassil Vassilev and Matheus Izvekov

### **Project Overview**

**Clang** is a popular compiler front-end in the **LLVM** project, capable of handling languages like C++. One of its cool tools, **Clang-Repl**, is an interactive C++ interpreter using **Just-In-Time (JIT)** compilation. It lets you write, compile, and run C++ code interactively, making it super handy for learning, quick prototyping, and debugging.

However, Clang-Repl did have a few drawbacks:

1. **High Resource Usage**: Running both Clang-Repl and JIT in the same process used up a lot of system resources.
2. **Instability**: If the user's code crashed, the entire Clang-Repl session would shut down, leading to interruptions.

### **Out-Of-Process Execution**

The solution to these challenges was **Out-Of-Process Execution**—executing user code
in a separate process. This offers two major advantages:

- **Efficient Resource Management**: By isolating code execution, Clang-Repl reduces
  its system resource footprint, crucial for devices with limited memory or processing
  power.
- **Enhanced Stability**: Crashes in user code no longer affect the main Clang-Repl
  session, improving reliability and user experience.

This improvement makes Clang-Repl more reliable, especially on low-power or embedded
systems, and suitable for broader use cases.

---

## **Summary of accomplished tasks**

### **Note: Some of the PRs are still under review, but they are expected to be merged soon.**

#### **Add Out-Of-Process Execution Support for Clang-Repl** [#110418](https://github.com/llvm/llvm-project/pull/110418)

To implement out-of-process execution, I leveraged **ORC JIT’s remote execution capabilities** with `llvm-jitlink-executor`. Key features included:

- **New Command Flags**:
  - `--oop-executor`: Launches the JIT executor in a separate process.
  - `--oop-executor-connect`: Connects Clang-Repl to the external process for out-of-process execution.

These flags enable Clang-Repl to use `llvm-jitlink-executor` for isolated code execution.

---

### **Key ORC JIT Enhancements**

To support Clang-Repl’s out-of-process execution, I contributed several improvements to **ORC JIT**:

#### **Incremental Initializer Execution for Mach-O and ELF** [#97441](https://github.com/llvm/llvm-project/pull/97441), [#110406](https://github.com/llvm/llvm-project/pull/110406)

The `dlupdate` function was added to the ORC runtime to allow for the incremental execution of new initializers in the REPL environment. Unlike the traditional `dlopen` function, which deals with everything from handling initializers to code mapping and library reference counts, `dlupdate` is all about running just the new initializers. This focused approach makes things way more efficient, especially during interactive sessions in `clang-repl`.

#### **Push-Request Model for ELF Initializers** [#102846](https://github.com/llvm/llvm-project/pull/102846)

I introduced a push-request model to handle ELF initializers in the runtime state for each JITDylib, similar to how Mach-O and COFF handle initializers.
Previously, ELF had to request initializers every time `dlopen` was called, but
lacked the ability to `register`, `deregister`, or `retain` these initializers.
This led to issues when re-running `dlopen` because, once `rt_getInitializers`
was invoked, the initializers were erased, making subsequent executions impossible.

To address this, I introduced the following functions:

- **`__orc_rt_elfnix_register_init_sections`**: Registers the ELF initializer's for the JITDylib.

- **`__orc_rt_elfnix_register_jitdylib`**: Registers the JITDylib with the ELF runtime state.

With this push-request model, we can better track and manage initializers for each `JITDylib` state. By leveraging Mach-O’s `RecordSectionsTracker`, we only run newly registered initializers, making the system more efficient and reliable when working with ELF targets in `clang-repl`.

This update is key to enabling out-of-process execution in `clang-repl` on the ELF platform.

---

### **Additional Improvements**

#### **Auto-loading Dynamic Libraries in ORC JIT** [#109913](https://github.com/llvm/llvm-project/pull/109913) (On-going)

I added an auto-loading dynamic library feature to ORC JIT to speed up symbol resolution for both loaded and unloaded libraries. A key improvement is the global bloom filter, which helps skip symbols that probably aren’t there, reducing unnecessary searches and making things faster. With this update, if the JIT can't find a symbol in the loaded libraries, it will automatically search other libraries for the definition.

So, here’s how it works: when the JIT tries to resolve a symbol, it first checks the currently loaded libraries. If it finds the symbol there, it simply grabs its address using dlsym and stores it in the results. If the symbol isn’t found among the loaded libraries, the search expands to unloaded ones.

As we scan through each library, its symbol table gets added to the global bloom filter. If we go through all the possible auto-linkable libraries and still can’t find the symbol, the bloom filter gets returned as part of the result. Plus, we keep track of any symbols that the bloom filter marks as 'may-contain' but don’t actually resolve in any library, adding those to an excluded set.

#### **Refactor `dlupdate`** [#110491](https://github.com/llvm/llvm-project/pull/110491)

This change refactors the `dlupdate` function by removing the `mode` argument simplifying the function's interface.

---

### **Benchmarks: In-Process vs Out-of-Process Execution**

- [Prime Finder](https://gist.github.com/SahilPatidar/4870bf9968b1b0cb3dabcff7281e6135)
- [Fibonacci Sequence](https://gist.github.com/SahilPatidar/2191963e59feb7dfa1314509340f95a1)
- [Matrix Multiplication](https://gist.github.com/SahilPatidar/1df9e219d0f8348bd126f1e01658b3fa)
- [Sorting Algorithms](https://gist.github.com/SahilPatidar/c814634b2f863fc167b8d16b573f88ec)

---

### **Result**

With these changes, `clang-repl` now supports out-of-process execution. We can run it using the following command:

```bash
clang-repl --oop-executor=path/to/llvm-jitlink-executor --orc-runtime=path/to/liborc_rt.a
```

### **Conclusion**

Thanks to this project, **Clang-Repl** now supports **out-of-process execution** for
both `ELF` and `Mach-O`, vastly improving its resource efficiency and stability. These
changes make Clang-Repl more robust, especially on low-resource devices.

Looking ahead, I plan to focus on automating library loading and further enhancing
ORC-JIT to optimize Clang-Repl's out-of-process execution.

Thank you for being a part of my **GSoC 2024** journey!

### **Acknowledgements**

I would like to extend my deepest gratitude to Google Summer of Code (GSoC)
for the incredible opportunity to work on this project. A special thanks to
my mentors, Vassil Vassilev and Matheus Izvekov, for their invaluable guidance
and support throughout this journey. I am also immensely grateful to Lang Hames
for their expert insights on ORC-JIT enhancements for `clang-repl`. This experience
has been a pivotal moment in my development, and I am excited to continue
contributing to the open-source community.

---

### **Related Links**

- [LLVM Repository](https://github.com/llvm/llvm-project)
- [Project Description](https://discourse.llvm.org/t/clang-out-of-process-execution-for-clang-repl/68225)
- [My GitHub Profile](https://github.com/SahilPatidar)

---
