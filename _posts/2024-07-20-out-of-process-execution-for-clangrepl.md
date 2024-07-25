---
title: "Out Of Process execution for Clang-Repl"
layout: post
excerpt: "Out of Process Execution for Clang-Repl project, part of Google Summer of Code 2024, aims to enhance Clang-Repl by implementing out-of-process execution. This will address issues of high resource consumption and instability, making Clang-Repl more suitable for low-power devices and more stable for developers"
sitemap: false
author: Sahil Patidar
permalink: blogs/gsoc24_sahil_introduction_blog/
banner_image: /images/blog/gsoc-banner.png
date: 2024-07-18
tags: gsoc llvm clang-repl orc-jit llvm-jitlink-executor
---

### Introduction

I am Sahil Patidar, a student during the 2024 Google Summer of Code. I will be
working on the project "Out Of Process execution for Clang-Repl".

**Mentors**: Vassil Vassilev, Matheus Izvekov

### Overview of the Project

Clang is a powerful tool that helps convert different programming languages into machine code that computers can understand. It is part of the LLVM project and is used by many developers because it’s designed to be flexible and easy to use. One of the cool things you can do with Clang is use **Clang-Repl**, an interactive C++ interpreter. This means you can write and run C++ code on the spot, getting instant feedback. This is great for learning, testing, and quick experiments.

**Clang-Repl** uses a technology called Just-In-Time (JIT) compilation, which compiles and runs code in the same process. This makes it fast and efficient. However, there are some problems with this setup:

1. **Resource Limits**: The current design needs a lot of resources, which means it doesn't work well on devices with limited power, like an Arduino.
2. **Crash Issues**: If the code you’re testing crashes, it can take down the whole Clang-Repl program, causing inconvenience and instability.

This project aims to fix these problems by changing Clang-Repl to run code in a separate process.

#### Out Of Process execution

This project aims to make Clang-Repl run executor in a separate process. Doing this will provide several benefits:

- **Lightweight Execution**: Running Clang-Repl separately will use fewer resources, making it possible to run on devices with limited power.
- **Improved Stability**: If the user code crashes, only the separate process will crash. This keeps the main program running smoothly and makes the system more reliable.

### Approach

#### Utilizing Orc JITLink Executor for Out-of-Process Execution in `clang-repl`

To enhance `clang-repl` with out-of-process execution, we leveraged the Orc `llvm-jitlink-executor`. it allowed us to efficiently run initializers in a separate executor process and seamlessly relay results back to the controller process. Here's a detailed breakdown of how we accomplished this:

**`llvm-jitlink-executor` Executor**

To start, we used the `llvm-jitlink-executor` because of its robust features that facilitate communication between the controller process and the executor. This executor supports TCP connections through the `--listen` flag and pipe connections using file descriptors (`fd`). Additionally, its support for shared memory proved invaluable, enabling us to map memory in the executor from the controller using a mapper.

**Connecting with the Executor**

To manage the communication with the `llvm-jitlink-executor`, we needed an Executor Process Control to handle all communication, including sending, receiving data, and managing disconnections. Since `clang-repl` was using `SelfExecutorProcessControl` for in-process execution, we employed Orc `SimpleRemoteEPC`, which is designed for out-of-process execution. This component adeptly handled all communication tasks, from sending to receiving results. It utilized `CallWrapperAsync` and `FDTransport` for the data transport, ensuring efficient and reliable exchanges between the controller and executor processes.

**Introducing Flags in `clang-repl`**

To integrate `SimpleRemoteEPC` into `clang-repl`, we introduced new flags to enable out-of-process execution, similar to those used in `llvm-jitlink`. These flags facilitated different modes of communication:
1. **`--oop-executor`**: This flag enabled pipe-based communication, where the argument specified the executor path.
2. **`--oop-connect`**: This flag enabled TCP-based communication, where the argument specified the host and port.

By implementing these flags, we ensured flexible and robust communication options for out-of-process execution in `clang-repl`.

### Conclusion

This project will make Clang-Repl run in a separate process. This change will help Clang-Repl use fewer resources, making it suitable for devices with limited power. It will also make Clang-Repl more stable since any crashes in the user code won’t affect the main program. Overall, Clang-Repl will become more useful and reliable, and it will work on more types of devices.

### Related Links

- [LLVM Repository](https://github.com/llvm/llvm-project)
- [Project Description](https://discourse.llvm.org/t/clang-out-of-process-execution-for-clang-repl/68225)
- [My GitHub Profile](https://github.com/SahilPatidar)