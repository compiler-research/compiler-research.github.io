---
title: "The Next Step in Language Interoperability using compiler-as-a-service and cppyy"
layout: post
excerpt: "Scientific software is constantly being challenged by enthusiasts trying to
test the boundaries of programming languages, in search of better performance
and simpler workflows. Interactive C++ interpreters such as Cling and ClangRepl
presented new possibilities with an incremental compilation infrastructure that
 is available at runtime."
sitemap: false
permalink: blogs/language_interoperability_with_cling_and_cppyy/
date: 2023-04-05
---

{% capture image_style %}
    max-width: 80%;
    display: block;
    margin: 0 auto;
{% endcapture %}

### Introduction

Scientific software development continually seeks to balance the high
performance of languages like C++ with the user-friendly nature of Python.
This article summarizes the advancements in language interoperability
presented in the paper [Efficient and Accurate Automatic Python Bindings with
cppyy & Cling]. 

This research focuses on enhancing language interoperability with cppyy,
enabling uniform cross-language execution environments. It illustrates the use
of advanced C++ in Numba-accelerated Python through cppyy. This required
re-engineering parts of cppyy to use upstream LLVM components. cppyy was
further empowered with a C++ reflection library, InterOp, which offers
interoperability primitives based on Cling and Clang-Repl (C++ Interpreters).

### Key Components


#### 1. Cling: Interactive C++ Interpreter

Cling, an interactive C++ interpreter based on Clang/LLVM, provides the
foundation for cppyy's ability to interact with C++ code dynamically and
efficiently.

#### 2. cppyy: An automatic Runtime Bindings Generator

cppyy is a tool that automatically generates Python bindings for C++ code at
runtime. It allows Python to interact with C++ on an on-demand basis.

#### 3. Numba: a just-in-time (JIT) compiler for Python

Numba is capable of compiling Python code while targeting either the CPU or
the GPU, and providing interfaces to use the JITed closures from low-level
libraries.

![numba extension](/images/blog/cppyy-numba-1.png){: style="{{ image_style }}"}

Numba helps lower Python to machine code level and minimizes costly
language crossings. In order to provide the missing links for this research,
Numba was also integrated with the cppyy project to connect to the Python
runtime.


#### 4. cppyy Integration with Numba

The research demonstrates how cppyy can be integrated with Numba, a
just-in-time (JIT) compiler for Python. This integration aims to eliminate the
overhead of crossing the language barrier, particularly in loop-heavy code.

#### 5. CppInterOp: A New Interoperability Library

A new library, CppInterOp, was introduced to implement interoperability
primitives based on Cling and Clang-REPL. This library enhances the reflection
capabilities necessary for efficient language interoperability.


### Prototype Overview

The primary motivation behind the addition of Numba support in cppyy is the
elimination of the overhead that arises from crossing the language barrier,
which can multiply into large slowdowns when using loops with cppyy objects.
Since Numba compiles Python code into machine code, it only crosses the
language barrier once, and the loops thus run faster.

![numba extension](/images/blog/cppyy-numba-2.png){: style="{{ image_style }}"}

Python is a dynamically typed language. It wraps and later unwraps objects
(referred to as boxing/unboxing). These costly operations are eliminated with
Numba, which unboxes the inputs of a function and converts it to machine code.
This improves the performance of heavily looped code that perform certain
operations. At the end, the output is boxed so that Python can use it. For
this to work, Numba needs to infer the types of not only the input and output
but the intermediate variables as well.

#### Numba Extension for cppyy

A custom module was developed on top of cppyy using Numba's low-level
extension API. This enables Python programmers to selectively enable Numba
acceleration for performance-critical tasks involving C++ code (by importing
`cppyy.numba_ext`).

![numba extension](/images/blog/cppyy-numba-3.png){: style="{{ image_style }}"}

The extension aids Numba's three phases, which are: Typing, Lowering(to LLVM
IR), and Boxing/Unboxing; which process all (or most) C++ proxies held by the
Python interpreter in the form of cppyy objects.

#### Enhanced Reflection API

This research included creation of an improved reflection API
(`__cpp_reflex__`) within cppyy. The Reflection API provides detailed
information about cppyy objects (within the scope of the Numba-accelerated
function). This allows inheritance of Numba's type handling classes and
populating them with more information required to box/unbox and lower the code
to LLVM IR.

#### cppyy Backend Re-Engineering 

The cppyy backend was re-engineered to directly use LLVM components. This
modification aims to improve performance and sustainability, leveraging the
advanced capabilities of the LLVM infrastructure.

#### Interaction between Cppyy, Numba and the Numba extension

Numba analyzes Python code and when it encounters cppyy types, it queries
cppyy’s pre-registered `numba_ext` module for the type information. 

![numba extension](/images/blog/cppyy-numba-4.png){: style="{{ image_style }}"}

If `numba_ext` encounters a type that it hasn't seen before, it queries
cppyy’s new reflection API. This helps generate the necessary type handling
classes and lowering methods. 

Each core language construct (namespaces, classes, free functions, methods,
data members, etc.) has its own implementation. This process provides Numba
with the information needed to convert the function call to LLVM IR.

### Results

The following benchmark tests the running time of Numba-JITed functions with
cppyy objects against their Python counterparts to obtain: 

- the time taken by Numba to JIT the function (Numba JIT time), 
- the time taken by cppyy to create the typing info and possibly perform
lookups and instantiate templates (cppyy JIT time), 
- the time taken to run the function after it has been JITed (Hot run time),
and 
- the time taken to run the equivalent Python function. 

> Note: The results are obtained on a 3.1GHz Intel NUC Core i7-8809G CPU with
> 32G RAM.
 
#### Benchmark 

The following fixture for ‘Templated free functions’ case was used to evaluate
the speedup obtained by Numba JITing of cppyy objects. The other cases uses a
similar setup.

**C++ code in cppyy**

Using a C++ templated function, as declared in cppyy:

```c++
cppyy.cppdef(r"""
template<class T>
T add42(T t) {
    return T(t+42);
}
""")
```

**Python/C++ binding with cppyy**

Using a Python kernel to run this C++ function:

```c++
def go_slow(a):
    trace = 0.0
    for i in range(a.shape[0]):
        trace +=
          cppyy.gbl.add42(a[i, i]) +
          cppyy.gbl.add42(int(a[i, i]))
    return a + trace
```

**Numba-acceleration of cppyy**

Using the same kernel but adding the Numba JIT decorator to accelerate it:

```c++
@numba.jit(nopython=True)
def go_fast(a):
    trace = 0.0
    for i in range(a.shape[0]):
        trace +=
          cppyy.gbl.add42(a[i, i]) +
          cppyy.gbl.add42(int(a[i, i]))
    return a + trace
```

For each benchmark case in the following table, a Numpy array of size 100 ×
100 was passed to the function. The times indicated in the table are averages
of 3000 runs. The Numba JITed functions achieve a minimum speedup of **2.3
times** in the case of methods and a maximum speedup of nearly **21 times** in
the case of templated free functions.

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
- Numba JIT time: The execution time of Numba JITed functions with cppyy
  objects against their Python counterparts (to obtain the time taken by Numba
  to JIT the function).
- cppyy JIT time: The time taken by cppyy to create the typing information and
  possibly to perform lookups and instantiate templates.
- Hot run time: The time taken to execute the function after it has been JITed.
- Python run time: The time taken to execute the equivalent Python function.
- Speedup: Compares the Hot run time to Python run time.

For more technical details, please view the paper: [Efficient and Accurate Automatic Python Bindings with cppyy & Cling]

### Summary

The advancements presented in this research, particularly the changes to
cppyy and its integration with Cling and Numba, represent a significant step
forward in creating more seamless and efficient multilingual programming
environments. 

This opens up several possibilities for developers. For example, they can
develop and debug their code in Python, while using C++ libraries, and
switching on the Numba JIT for selected performance-critical closures. 

The results are promising, with a 2 to 20 times speedup when using Numba to
accelerate cppyy through our extension. Further gains were demonstrated using
the Clang-Repl component of LLVM and the newly developed library CppInterOp.
Preliminary results show 1.4 to 144 times faster handling of templated code in
cppyy, which will indirectly improve the Numba-accelerated Python as well.

[Efficient and Accurate Automatic Python Bindings with cppyy & Cling]: https://arxiv.org/abs/2304.02712