---
title: "The Next Step in Language Interoperability using Cling and cppyy"
layout: post
excerpt: "Scientific software in constantly being challenged by enthusiasts trying to
test the boundaries of programming languages, in search of better performance
and simpler workflows. One such breakthrough was achieved using Cling, a C++
interpreter, that has presented new possibilities with an incremental
compilation infrastructure that is available at runtime."
sitemap: false
permalink: blogs/language_interoperability_with_cling_and_cppyy/
date: 2023-04-05
---

{% capture image_style %}
    max-width: 80%;
    display: block;
    margin: 0 auto;
{% endcapture %}

Scientific software in constantly being challenged by enthusiasts trying to
test the boundaries of programming languages, in search of better performance
and simpler workflows. One such breakthrough was achieved using Cling, a C++
interpreter, that has presented new possibilities with an incremental
compilation infrastructure that is available at runtime.

This means that Python can interact with C++ on an on-demand basis, and
bindings can be automatically constructed at runtime. This provides
unprecedented performance and does not require direct support from library
authors.

The Compiler Research team presented these findings in the paper: [Efficient
and Accurate Automatic Python Bindings with cppyy & Cling]. It presents the
enhancements in language interoperability using Cling with cppyy (an
automatic, run-time, Python-C++ bindings generator). Following is a high-level
summary of these findings.


### Background
C++ gained early adoption in scientific research fields due to its high
performance capabilities. But the interactive nature of Python and the gentler
learning curve led to higher adoption rates elsewhere, and as a result, it saw
exponential advancements in capabilities that were ideal for data science
research. A lot of research infrastructure is still rooted in C++ and benefits
from some of its unique features (e.g., access to accelerators in
heterogeneous computing environments), making it impossible, or at least
undesirable to abandon it for the exciting new features that the world of
Python has to offer. 

This is where the usefulness of language interoperability becomes evident.
However, this requires an advanced integration solution, especially for high
performance code that is executed in diverse environments. 

This is where Numba, a just-in-time (JIT) compiler for Python comes in. It is
capable of compiling Python code, while targeting either the CPU or the GPU,
and providing interfaces to use the JITed closures from low-level libraries.
Numba helps lower Python to machine code level and minimizes costly language
crossings. However, Numba has some limitations in this context that are
remediated with cppyy (an automatic runtime bindings generator).

The target of this research is to demonstrate a generic prototype that
automatically brings advanced C++ features (e.g., highly optimized numeric
libraries) to Numba-accelerated Python, with help from cppyy. This required
re-engineering of the cppyy back-end to directly use LLVM components. A new
CppInterOp library was also introduced to implement interoperability
primitives based on Cling and Clang-Repl (also an interactive interpreter, a
progression on Cling).

### Prototype Overview

To bring C++ to Numba, a reflection interface was developed on top of cppyy.
This enables Python programmers to develop and debug their code in Python and
only switching on the Numba JIT for selected performance-critical tasks.

Python is a dynamically typed language. It wraps and later unwraps objects
(referred to as boxing/unboxing). This is a costly operation that can be
eliminated with Numba, while using the new Reflection API. The Reflection API
uses a function called `__cpp_reflex__` that takes the reflection type and
format as parameters and returns the requested information (e.g., an object’s
C++ type).

Let's look at the  interaction between Numba, numba extention and cppyy.  

![numba extension](/images/blog/2023-04-05-numba-ext.png){: style="{{ image_style }}"}

Numba analyzes a Python code and when it encounters cppyy types, it queries
the cppyy’s pre-registered `numba_ext` module for the type information. If
`numba_ext` encounters a type that it hasn't seen before, it queries cppyy’s
new reflection API. This helps generate the necessary typing classes and
lowering methods. Each core language construct (namespaces, classes, free
functions, methods, data members, etc.) has its own implementation. This
process provides Numba with the information needed to convert the function
call to LLVM IR.

### Benchmarks

The following benchmarks were executed on a 3.1GHz Intel NUC Core i7-8809G CPU
with 32G RAM.

<br />

| Benchmark Case            &nbsp;| Cppyy JIT time (s) &nbsp;| Numba JIT time (s) &nbsp;| Hot run time (s) &nbsp;| Python run time (s) &nbsp;| Speedup &nbsp;|
|----------------------------|---------------------|---------------------|-------------------|----------------------|----------|
| Function w/o args         &nbsp;| 1.72e-03           &nbsp;| 3.33e-01           &nbsp;| 3.58e-06         &nbsp;| 1.73e-05            &nbsp;| 4.84×   |
| Overloaded functions      &nbsp;| 1.05e-03           &nbsp;| 1.35e-01           &nbsp;| 4.51e-06         &nbsp;| 3.47e-05            &nbsp;| 7.70×   |
| Templated free functions  &nbsp;| 8.92e-04           &nbsp;| 1.45e-01           &nbsp;| 3.48e-06         &nbsp;| 7.18e-05            &nbsp;| 20.66×  |
| Class data members        &nbsp;| 1.43e-06           &nbsp;| 1.33e-01           &nbsp;| 5.87e-06         &nbsp;| 1.82e-05            &nbsp;| 3.10×   |
| Class methods             &nbsp;| 2.16e-03           &nbsp;| 1.39e-01           &nbsp;| 6.06e-06         &nbsp;| 1.43e-05            &nbsp;| 2.36×   |

<br />

Where,
- Numba JIT time: The execution time of Numba JITed functions with cppyy objects against their Python counterparts (to obtain the time taken by Numba to JIT the function).
- cppyy JIT time: The time taken by cppyy to create the typing information and possibly to perform lookups and instantiate templates.
- Hot run time: The time taken to execute the function after it has been JITed.
- Python run time: The time taken to execute the equivalent Python function.
- Speedup: Compares the Hot run time to Python run time.

For more technical details, please view the paper: [Efficient and Accurate Automatic Python Bindings with cppyy & Cling]



[Efficient and Accurate Automatic Python Bindings with cppyy & Cling]: https://arxiv.org/abs/2304.02712