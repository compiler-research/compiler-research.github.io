---
title: "Port C and C++ courses to xeus-cpp for interactive learning"
layout: post
excerpt: "Exploring how traditional C and C++ programming courses can be adapted into interactive Jupyter notebooks using the xeus-cpp kernel"
sitemap: false
author: Georgi Runtolev
permalink: blogs/xeuscpp_Georgi_Runtolev_blog/
thumbnail_image: /images/mg-pld-logo.png
date: 2026-03-01
tags: xeus-cpp jupyter c++ xeus internship systems-programming
custom_css: jupyter
---

{% include dual-banner.html
left_logo="/images/mg-pld-logo.png"
right_logo="/images/cr-logo_old.png"
caption=""
height="20vh" %}

## Introduction

My name is Georgi Runtolev, and I am a student at High School of Mathematics “Akad. Kiril Popov” in Plovdiv. I have been passionate about programming for the past six years, with experience in C++ and C#. I am looking forward to further developing my skills and gaining practical experience through my internship at Compiler Research.

**Mentor**: Vassil Vassilev


## Project Overview

The `xeus-cpp` kernel provides a Jupyter interface for interactive C++ programming. Unlike traditional compilation workflows, `xeus-cpp` executes code cell by cell while preserving the program state across executions. 
This allows students and developers to experiment, visualize, and debug C++ code incrementally, but introduces behaviors that are different from standard compilation, such as state persistence, redefinition conflicts, and execution order sensitivity.
The goal of this project is to port existing C and C++ course materials to `xeus-cpp` notebooks, making them interactive and suitable for hands-on learning. 
The project emphasizes understanding `xeus-cpp`’s execution model, documenting differences from standard compilation, and producing teaching materials that help users explore C and C++ concepts in a notebook environment.


## Project Goals

Understand `xeus-cpp`’s state management, including how variables, functions, and classes persist across cells.


Port C and C++ tutorial materials to `xeus-cpp` notebooks, covering topics such as:


  - Fundamentals of C programming


  - Modern C++ (C++11–C++20) features


  - Memory management (pointers, arrays, dynamic allocation)


  - Object-oriented programming and STL usage


Document the differences between notebook-based execution and traditional compilation workflows.


Create interactive notebooks that serve as teaching tools.


Test, debug, and provide guidelines for safe coding practices within xeus-cpp.


Produce a final report summarizing lessons learned, best practices, and recommended notebook structures for teaching.

