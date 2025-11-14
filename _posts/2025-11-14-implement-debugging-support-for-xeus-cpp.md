---
title: "Implementing Debugging Support for xeus-cpp"
layout: post
excerpt: "A GSoC 2025 project aiming at integration of debugger into the xeus-cpp kernel for Jupyter using LLDB and its Debug Adapter Protocol (lldb-dap)."
sitemap: true
author: Abhinav Kumar
permalink: blogs/gsoc25_abhinav_kumar_final_blog/
banner_image: /images/blog/gsoc-banner.png
date: 2025-11-14
tags: gsoc c++ debugger dap clang jupyter clang clang-repl
---

## Introduction
Hello! I’m Abhinav Kumar, and this summer I had the exciting opportunity to participate in Google Summer of Code (GSoC) 2025. My project revolved around implementing debugging support for xeus-cpp kernel. 

## Project Overview
`xeus-cpp` is a C++ Jupyter kernel that enables interactive C++ execution within JupyterLab.  
My project focused on integrating a full-fledged **debugger** into the `xeus-cpp` kernel, enabling users to perform interactive debugging directly from JupyterLab.

The debugger integration is powered by **LLDB-DAP** - the Debug Adapter Protocol implementation for the LLDB debugger. However, directly attaching LLDB-DAP to the kernel process causes the kernel to pause and terminate.  
To address this, the project leverages **out-of-process JIT execution**, inspired by [Clang-Repl’s Out-of-Process Execution model](https://compiler-research.org/blogs/gsoc24_sahil_wrapup_blog/).

With this design, users can now seamlessly:
- Set and hit breakpoints  
- Inspect variables  
- Step through code (step in, step out, continue)  
- Debug C++ programs interactively  

all within **JupyterLab**, using the `xeus-cpp` kernel.

## Overview of the Work Done

### JupyterLab
#### **Pull Request**: [Fix threadId being passed to the debugger #17667](https://github.com/jupyterlab/jupyterlab/pull/17667)
Identified and fixed a bug in JupyterLab’s frontend debugger implementation.  
Previously, the [`DebuggerService::_currentThread`](https://github.com/jupyterlab/jupyterlab/blob/72410ce1ac956d4da1769b428de369e84e0b6c17/packages/debugger/src/service.ts#L754) method returned a hardcoded value of `1`.  
This was corrected to dynamically return the first available `threadId`, ensuring accurate thread handling during debugging sessions.

#### **Issue**: [Bug: Multiple configurationDone Requests Sent by JupyterLab #17673](https://github.com/jupyterlab/jupyterlab/issues/17673)
Discovered that JupyterLab was sending a `configurationDone` request after every `setBreakpoints` call.  
According to the Debug Adapter Protocol (DAP) specification, this request should only be sent **once**, after all initial configuration is complete.  
This issue was reported and documented for further upstream resolution.

---

### CppInterOp
#### **Pull Request**: [Documentation for debugging CppInterOp using LLDB #621](https://github.com/compiler-research/CppInterOp/pull/621)
Added comprehensive documentation describing how to debug **CppInterOp** using **LLDB**, making it easier for developers to inspect and troubleshoot CppInterOp internals.

#### **Pull Request**: [Out-Of-Process Interpreter for CppInterOp #717](https://github.com/compiler-research/CppInterOp/pull/717)
Implemented an **Out-of-Process Interpreter** for CppInterOp.  
This enhancement utilizes LLVM’s `llvm-jitlink-executor` and the **ORC Runtime** to delegate JIT execution to a separate process.  
Users can enable this functionality simply by passing the `--use-oop-jit` flag as a `ClangArg` when constructing the interpreter.

---

### LLVM Project
#### **Pull Request**: [[clang-repl] Adds custom lambda in launchExecutor and PID retrieval](https://github.com/llvm/llvm-project/pull/152562) *(Merged but later reverted by [#153180](https://github.com/llvm/llvm-project/pull/153180))*
Introduced:
1. A **custom lambda function** in `launchExecutor`.  
2. Support for **retrieving the PID** of the launched out-of-process (OOP) JIT executor.  

However, due to issues with the testing infrastructure, the PR was reverted.

#### **Subsequent Pull Requests**
- [[clang-repl] Sink RemoteJITUtils into Interpreter class (NFC) #155140](https://github.com/llvm/llvm-project/pull/155140)  
- [[clang-repl] Add support for running custom code in Remote JIT executor #157358](https://github.com/llvm/llvm-project/pull/157358)  
- [[clang-repl] Disable out of process JIT tests on non-unix platforms #159404](https://github.com/llvm/llvm-project/pull/159404)  

These follow-up PRs addressed the functionality of the reverted change by:
1. **Refactoring `RemoteJITUtils`**, creating the `JitBuilder` inside the `Interpreter` class.  
2. **Adding support for custom lambdas** in `launchExecutor`.  
3. **Enabling PID retrieval** for the launched OOP JIT executor.  
4. **Improving test reliability** by disabling OOP JIT tests on non-Unix platforms.

---

### **xeus-cpp**
> The changes in *xeus-cpp* are currently awaiting review and merge.  

#### **Pull Request:** [Debugger for xeus-cpp with testing framework #401](https://github.com/compiler-research/xeus-cpp/pull/401)

This pull request introduces comprehensive debugger support for the *xeus-cpp* kernel.  

**Key contributions include:**
1. A new kernel variant with an out-of-process interpreter and integrated debugger support.  
2. Integration of LLDB-DAP within the *xeus* environment.  
3. A dedicated testing framework to validate and ensure the reliability of debugger functionality.  

## Demo
### Docker Image
The provided Docker image is based on **Ubuntu 22.04 (x86_64)**. You can run it on any x86_64 host machine.  
When launched, it automatically starts a **JupyterLab** instance configured with the **xcpp17-debugger** kernel, allowing you to experiment with the debugger directly.

#### **Commands to Run**
```bash
docker pull kr2003/xcpp-debugger
```
```bash
docker run -it --privileged -p 8888:8888 kr2003/xcpp-debugger
```

Once the container starts, open `localhost:8888` in your browser to access JupyterLab and try out the debugger.

### Video Demo
[Video demo of xeus-cpp debugger](https://drive.google.com/file/d/1pQZk4OESNQe43LOa4IzZLS1-XfUvXE8e/view?usp=sharing)

## Future Works
1. **Merge the xeus-cpp debugger support:** Finalize and merge the pending PR by breaking it into 2–3 incremental PRs for better review and integration.  
2. **Explore LLDB in WebAssembly:** Investigate the feasibility of running LLDB in WASM and adding debugger (DAP) support in JupyterLite.  
3. **Enhance LLDB-DAP for advanced C++ debugging:** Extend DAP functionality to include advanced C++ debugging features such as watchpoints and data breakpoints.  
4. **Optimize the out-of-process interpreter:** Improve performance by leveraging shared memory for communication between processes.  
5. **Expand architecture support:** Extend the out-of-process interpreter to additional architectures beyond Linux x86_64 and macOS Darwin.  

I look forward to continuing contributions beyond GSoC, particularly towards implementing new features and improvements in **clang-repl** and **CppInterOp**.

## Conclusion
Participating in Google Summer of Code 2025 has been an incredibly enriching experience.  
Throughout the program, I gained a deeper understanding of how interactive execution, debugging, and JIT compilation work together within the LLVM and Jupyter ecosystems.  

This project not only strengthened my skills in **systems programming**, **compiler internals**, and **debugger integration**, but also gave me the opportunity to collaborate with an inspiring community of developers and mentors at **CERN-HSF**.  

I’m grateful to my mentors — **Anutosh Bhat**, **Vipul Cariappa**, and **Vassil Vassilev** — for their constant support, insightful reviews, and guidance throughout the project.  

While the foundation for debugger support in `xeus-cpp` has been successfully implemented, there remains exciting future work to further refine and expand its capabilities.  
I look forward to continuing my contributions to **xeus-cpp**, **CppInterOp**, and **clang-repl**, and to further advancing open-source compiler and debugging infrastructure.  

