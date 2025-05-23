---
title: "Supporting STL Concurrency Primitives in CLAD"
layout: post
excerpt: "Support for STL concurrency features in CLAD is a useful feature for applications utilizing cpu threads. Many applications of autodifferentiation benefit from parallel or concurrent processing, and support for some STL concurrency primitives such as threads and basic synchronization primitives may considerably simplify the user's design."
sitemap: false
author: Petro Mozil
permalink: blogs/gsoc25_/
banner_image: /images/blog/gsoc-banner.png
date: 2025-05-18
tags: gsoc llvm clang auto-differentiation
---

## About me

I am Petro Mozil, a student participating in the Google Summer of Code program in 2025.
I will work on adding support of STL concurrency primitives to CLAD.

## Problem description

`Clad` is a plugin for automatic differentiation for the `clang` compiler.
Automatic differentiation is a term for multiple techniques of deriving a mathematical function analytically. Some of the ways of doing this include simply calculating the derivative numerically or by deriving a function by a set of rules, symbolically.

`Clad` provides an interface that returns an object that contained the derivative of a given function. There might be problems with some functions, if they are to be derived. For example, one would not derive `printf`,  and neither would they derive `std::tread` - those are exceptions, and should be handled differently from mathematical  functions.

The main goals of this project are to implement support for automatically derive functions that contain `std::thread` so that the user wouldn't have to separate the multi-processing logic from the mathematical functions - such a feature would be a great time-saver for production of multi-processing code.

## Objectives

The objectives for this project include adding support for multiple objects in STL, such as `std::thread`, `std::atomic`, `std::mutex`.

The first, and, likely, most important part of the project is to add support for `std::thread` - this will include deriving not the `std::thread` constructor, but deriving the function supplied for the thread.

Support for mutexes is a bit more straightforward - though `clad` creates a second object to represent the derived value, it shouldn't do so for a mutex. It is a matter of having a custom derivative for `std::mutex`.

Atomics will likely involve more effort - they would require custom derivatives for `compare_exchange` functions as well as their methods.

If time allows, I would also like to add support for `std::condition_variable`, `std::lock_guard`, `std::unique_lock` and `std::jthread`, and most of those would also only involve a custom derivative.


## Conclusion

A a result of this project, support for the concurrency primitives is expected. Clad should seamlessly derive functions with concurrency primitives in them.
Though this project does not focus on features immediately required from `clad`, it should result in making easier the lives of those, who use clad for high-perf computing.

## Related links

- [LLVM Repository](https://github.com/llvm/llvm-project)
- [CLAD repository](https://github.com/vgvassilev/clad)
- [Project description](https://hepsoftwarefoundation.org/gsoc/2025/proposal_Clad-STLConcurrency.html)
- [My github](https://github.com/pmozil)
