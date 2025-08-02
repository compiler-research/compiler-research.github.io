---
title: "Improve automatic differentiation of object-oriented paradigms using Clad"
layout: post
excerpt: "A GSoC 2025 contributor project aiming to enhance Clad's ability to differentiate through OOP and STL constructs by supporting functions with side-effects."
sitemap: false
author: Petro Zarytskyi
permalink: blogs/2025_petro_zarytskyi_introduction_blog/
banner_image: /images/blog/gsoc-banner.png
date: 2025-07-31
tags: gsoc c++ llvm clang root automatic-differentiation
---

### Introduction
Hi! I'm Petro Zarytskyi, and I’m a Ukrainian Mathematics student at the University of Würzburg, Germany. I’ve been programming in C++ for the past 4 years, and I’m especially interested in compiler research and static analysis. I'm very excited for the project!

### Project description
The project addresses a limitation in Clad, a Clang plugin for C++ automatic differentiation, which currently cannot fully support non-trivially copyable types, restricting its use in Object-Oriented Programming. I'm going to enhance Clad's reverse mode differentiation by modifying its forward sweep functions to store intermediate values effectively and improving the To-Be-Recorded analysis to handle nested function calls and pointer operations. 

### Project goals
The main goals of this project are:

- Support functions with side-effects.

- Support non-copyable types like smart pointers.

- Enhance TBR analysis.

- Optimize memory usage.

### Implementation strategy
- Work on a new system of memory management for `reverse_forw` functions to support functions with side-effects. Improve the `reverse_forw` infrastructure to make it more reliable.

- Improve TBR analysis and make it suitable for OOP. In particular, add support for pointers.

- Work on relevant OOP-related issues to further enhance OOP support.

- Show that the implemented changes enable more support for STL types.

## Conclusion 

The support for functions with side-effects is currently a major blocker for modern Object-Oriented Programming as it limits the usage of many member functions and operators. Having this system successfully implemented will not only add support for storing non-copyable types but will also make storing copyable structures more efficient because only specific parts of them will need to be stored.

### Related Links

- [My GitHub profile]https://github.com/PetroZarytskyi