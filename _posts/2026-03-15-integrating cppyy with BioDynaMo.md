---
title: "Integrating cppyy with BioDynaMo"
layout: post
excerpt: "Exploring integration of cppyy, an automatic Python-C++ bindings generator, with BioDynaMo."
sitemap: false
author: Anton Dekov
permalink: blogs/cppyy_BioDynaMo_Anton_Dekov_blog/
thumbnail_image: /images/mg-pld-logo.png
date: 2026-03-15
tags: BioDynaMo cppyy bioinformatics c++
---

{% include dual-banner.html
left_logo="/images/mg-pld-logo.png"
right_logo="/images/cr-logo_old.png"
caption=""
height="20vh" %}

## Introduction
The project aims to integrate cppyy, an automatic Python-C++ bindings generator, with BioDynaMo. This will enable a hybrid modeling environment where users can call existing C++ agents from Python and also create new agents in Python that inherit directly from C++ base classes. This combines the performance of C++ with the accessibility, flexibility and libraries of Python 
**Mentor**: Vassil Vassilev

## Overview
While BioDynaMo's performance-critical core is written in C++, many researchers, students, and data scientists prefer Python for prototyping, analysis, and education.
This project integrates cppyy, an automatic run-time Python-C++ bindings generator, with BioDynaMo to enable hybrid agent development. Unlike static binding tools , cppyy requires no manual binding code, generates bindings on-the-fly, and crucially supports cross-inheritance—allowing Python classes to inherit from C++ base classes.
The main goal of the project is to demonstrate that BioDynaMo can have simulation agents in Python that seamlessly inherit from and extend existing C++ agent implementations, combining C++ performance with Python flexibility.

## Goals
The goal is to explore the possibility of cppyy integration with BioDynaMo by creating a Python class that inherits from a C++ BioDynaMo agent class, overrides virtual methods, and integrates with the simulation's agent management system, resolving the main technical challenges around cross-language polymorphism and type handling. Below are the steps along the way.
1. Demonstrate a pre-existing, compiled C++ BioDynaMo agent that can be loaded and its methods can be called from a Python script. 
2. Create a new agent class written entirely in Python that inherits from a C++ BioDynaMo agent.
3. Test the newly made class in a BioDynaMo simulation. 
4. Polish and document everything.


## Related links

- [Cppyy repository](https://github.com/wlav/cppyy)
- [BioDynaMo repository](https://github.com/BioDynaMo/biodynamo)
- [Project proposal](/assets/docs/Anton_Dekov_project_proposal.pdf)

