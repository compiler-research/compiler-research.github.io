---
title: "Final report for Port C and C++ Course to xeus-cpp"
layout: post
excerpt: "A summary for my project to implement an educational course, explaining C and C++ features in a notebook environment"
sitemap: false
author: Georgi Runtolev
permalink: blogs/xeus_cpp_G_Runtolev_blog_final/
thumbnail_image: /images/mg-pld-logo.png
date: 2026-06-02
tags: c++ xeus-cpp jupyter internship systems-programming
---

{% include dual-banner.html
left_logo="/images/mg-pld-logo.png"
right_logo="/images/cr-logo_old.png"
caption=""
height="20vh" %}

### **Project Overview**
The goal of this project was to modernize C and C++ education by porting a traditional curriculum into an interactive Jupyter Notebook environment using the **xeus-cpp** kernel. 
Unlike standard compilers that require a full write-build-run cycle, xeus-cpp uses a JIT interpreter to execute code cell by cell. 
This allows students to experiment with code incrementally while the program state, such as variables and functions, persists throughout the session.

### **Why This Project Was Important**
Traditional C++ learning often has a high barrier to entry due to complex compiler setups and the rigid nature of static builds. This project was vital because:
* Students can start coding immediately in a browser without configuring local toolchains.
* Provides instant feedback - errors are caught per cell, allowing students to fix bugs in real-time rather than waiting for a full program to compile.
* The stateful nature of notebooks makes it easier to demonstrate how pointers and memory allocation evolve during execution.

### **Results**
The project resulted in a comprehensive curriculum, spanning from C fundamentals to advanced C++20 features. Key deliverables included:
* **Interactive Notebooks:** 12 fully functional modules with theory and live code sandboxes.
* **Safe Coding Patterns:** A documented set of techniques, such as using `#ifndef` macro guards and namespace versioning to prevent redefinition errors when re-running cells.

### **What Worked Well and Key Challenges**
* **Successes:** The modular design of the notebooks proved highly effective. Breaking concepts into small, isolated cells made complex topics like OOP much more approachable.
* **Challenges:** The biggest hurdle was the fundamental difference in execution models. For instance, the traditional `int main()` function actually causes conflicts in a REPL environment. Additionally, managing the global state required strict discipline to avoid "pollution" where variables from previous cells unintentionally affected new ones.
