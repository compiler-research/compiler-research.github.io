---
title: "Compiler Research Research Areas"
layout: gridlay
excerpt: "Automatic differentiation (AD) is a powerful technique for evaluating the
derivatives of mathematical functions in C++, offering significant advantages
over traditional differentiation methods."
sitemap: true
permalink: /automatic_differentiation
---

## Automatic differentiation

Automatic differentiation (AD) is a technique for evaluating the derivatives
of mathematical functions in C++, offering a number of advantages over
traditional differentiation methods. By leveraging the principles of Automatic
Differentiation, programmers can efficiently calculate partial derivatives of
functions, opening up a range of applications in scientific computing and
machine learning.

### Understanding Differentiation in Computing

Differentiation in calculus is the process of finding the rate of change of
one quantity with respect to another. There are several principles and
formulas for differentiation, such as Sum Rule, Product Rule, Quotient Rule,
Constant Rule, and Chain Rule. For Automatic Differentiation, the Chain Rule
of differential calculus is of special interest.

Within the context of computing, there are various methods for
differentiation:

- **Manual Differentiation**: This consists of manually applying the rules of
  differentiation to a given function. While straightforward, it can be
  tedious and error-prone, especially for complex functions.

- **Numerical Differentiation**: This method approximates the derivatives
  using finite differences. It is relatively simple to implement, but can
  suffer from numerical instability and inaccuracy in its results.

- **Symbolic Differentiation**: This approach uses symbolic manipulation to
compute derivatives analytically. It provides accurate results but can lead to
lengthy expressions for large computations. It is limited to closed-form
expressions; that is, it cannot process the control flow.

- **Automatic Differentiation (AD)**: Automatic Differentiation is a highly
  efficient technique that computes derivatives of mathematical functions by
  applying differentiation rules to every arithmetic operation in the code.
  Automatic Differentiation can be used in two modes: 

    - Forward Mode: calculates derivatives with respect to a single variable, and 
    
    - Reverse Mode: calculates gradients with respect to all inputs
    simultaneously.

### Automatic Differentiation in C++

Automated Differentiation implementations are based on Operator Overloading or
Source Code Transformation. C++ allows operator overloading, making it
possible to implement Automatic Differentiation. The derivative of a function
can be evaluated at the same time as the function itself. Automatic
Differentiation exploits the fact that every computer calculation consists of
elementary mathematical operations and functions, and by applying the chain
rule recurrently, partial derivatives of arbitrary order can be computed
accurately. Following are some of its highlights:

- Automatic Differentiation can calculate derivatives without any additional
  precision loss. 

- It is not confined to closed-form expressions. 

- It can take derivatives of algorithms involving conditionals, loops, and
  recursion. 

- It works without generating inefficiently long expressions. 

### Automatic Differentiation Implementation with Clad - a Clang Plugin

Implementing Automatic Differentiation from the ground up can be challenging.
However, several C++ libraries and tools are available to simplify the
process. The Compiler Research Group has been working on [Clad], a C++ library
that enables Automatic Differentiation using the LLVM compiler infrastructure.
It is implemented as a plugin for the Clang compiler. 

[Clad] operates on Clang AST (Abstract Syntax Tree) and is capable of
performing C++ Source Code Transformation. When Clad is given the C++ source
code of a mathematical function, it can automatically generate C++ code for
the computing derivatives of that function. Clad has comprehensive coverage of
the latest C++ features and a well-rounded fallback and recovery system in
place.

**Clad's Key Features**:

- Support for both, Forward Mode and Reverse Mode Automatic Differentiation.

- Support for differentiation of the built-in C input arrays, built-in C/C++
  scalar types, functions with an arbitrary number of inputs, and functions
  that only return a single value.

- Support for loops and conditionals.

- Support for generation of single derivatives, gradients, Hessians, and
  Jacobians.

- Integration with CUDA for GPU programming.

- Integration with Cling and ROOT for high-energy physics data analysis.

### Basics of using Clad

Clad provides five API functions:

- `clad::differentiate` to use Forward Mode Automatic Differentiation.
- `clad::gradient` to use Reverse Mode Automatic Differentiation.
- `clad::hessian` to construct a Hessian matrix using a combination of Forward
  Mode and Reverse Mode Automatic Differentiation.
- `clad::jacobian` to construct a Jacobian matrix using Reverse Mode Automatic
  Differentiation.
- `clad::estimate-error` to calculate the Floating-Point Error of the
  requested program using Reverse Mode Automatic Differentiation.

These API functions label an existing function for differentiation and return
a functor object that contains the generated derivative, which can be called
by using the `.execute` method.

[Benchmarks] show that Clad is numerically faster than the conventional
Numerical Differentiation methods, providing Hessians that are 450x (~dim/25
times faster). [General benchmarks] demonstrate a 3378x improvement in speed
with Clad (compared to Numerical Differentiation) based on central
differences. 

For more information on Clad, please view:

- [Clad - Github Repository](https://github.com/vgvassilev/clad)

- [Clad - ReadTheDocs](https://clad.readthedocs.io/en/latest/)

- [Clad - Video Demo](https://www.youtube.com/watch?v=SDKLsMs5i8s)

- [Clad - PDF Demo](https://indico.cern.ch/event/808843/contributions/3368929/attachments/1817666/2971512/clad_demo.pdf)

- [Clad - Automatic Differentiation for C++ Using Clang - Slides](https://indico.cern.ch/event/1005849/contributions/4227031/attachments/2221814/3762784/Clad%20--%20Automatic%20Differentiation%20in%20C%2B%2B%20and%20Clang%20.pdf)

- [Automatic Differentiation in C++ - Slides](https://compiler-research.org/assets/presentations/CladInROOT_15_02_2020.pdf)



[Clad]: https://compiler-research.org/clad/

[Benchmarks]: https://compiler-research.org/assets/presentations/CladInROOT_15_02_2020.pdf

[General benchmarks]: https://indico.cern.ch/event/1005849/contributions/4227031/attachments/2221814/3762784/Clad%20--%20Automatic%20Differentiation%20in%20C%2B%2B%20and%20Clang%20.pdf



