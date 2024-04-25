---
title: "Compiler Research Research Areas"
layout: gridlay
excerpt: "Automatic Differentiation (AD) is a general and powerful technique
of computing partial derivatives (or the complete gradient) of a function inputted as a
computer program."
sitemap: true
permalink: /automatic_differentiation
---

## Automatic differentiation

Automatic Differentiation (AD) is a general and powerful technique
of computing partial derivatives (or the complete gradient) of a function inputted as a
computer program.

Automatic Differentiation takes advantage of the fact that any computation can
be represented as a composition of simple operations / functions - this is
generally represented in a graphical format and referred to as the [compuation
graph](https://colah.github.io/posts/2015-08-Backprop/). AD works by repeated
application of chain rule over this graph.

### Understanding Differentiation in Computing

Efficient computation of gradients is a crucial requirement in the fields of
scientific computing and machine learning, where approaches like
[Gradient Descent](https://en.wikipedia.org/wiki/Gradient_descent)
are used to iteratively converge over the optimum parameters of a mathematical
model.

Within the context of computing, there are various methods for
differentiation:

- **Manual Differentiation**: This consists of manually applying the rules of
  differentiation to a given function. While straightforward, it can be
  tedious and error-prone, especially for complex functions.

- **Numerical Differentiation**: This method approximates the derivatives
  using finite differences. It is relatively simple to implement, but can
  suffer from numerical instability and inaccuracy in its results. It doesn't
  scale well with the number of inputs of the function.

- **Symbolic Differentiation**: This approach uses symbolic manipulation to
compute derivatives analytically. It provides accurate results but can lead to
lengthy expressions for large computations. It requires the computer program to
be representable in a closed form mathematical expression, and thus doesn't work
well with control flow scenarios (if conditions and loops) in the program.

- **Automatic Differentiation (AD)**: Automatic Differentiation is a general and
  efficient technique that works by repeated application of chain rule over the
  computation graph of the program. Given its composable nature, it can easily scale
  for computing gradients over a very large number of inputs.
  
### Forward and Reverse mode AD
Automatic Differentiation works by applying chain rule and merging the derivatives
at each node of the computation graph. The direction of this graph traversal and
derivative accumulation results in two modes of operation:

  - Forward Mode: starts at an input to the graph and moves towards all the output nodes. 
  For every node, it sums all the paths feeding in. By adding them up, we get the total
  way in which the node is affected by the input. Hence, it calculates derivatives of output(s)
  with respect to a single input variable.
  
  - Reverse Mode: starts at the output node of graph and moves backward towards all
  the input nodes. For every node, it merges all paths which originated at that node.
  It tracks how every node affects one output. Hence, it calculates derivative of a single
  output with respect to all inputs simultaneously - the gradient.

### Automatic Differentiation in C++

Automated Differentiation implementations are based on [two major techniques]:
Operator Overloading and Source Code Transformation. Compiler Research Group's
focus has been on exploring the [Source Code Transformation] technique, which
involves  constructing the computation graph and producing a derivative at
compile time. 

[The source code transformation approach] enables optimization by retaining
all the complex knowledge of the original source code. The compute graph is
constructed during compilation and then transformed to generate the derivative 
code. It typically uses a custom parser to build code representation and produce
the transformed code. It is difficult to implement (especially in C++), but it is
very efficient, since many computations and optimizations are done ahead of time.

### Advantages of using Automatic Differentiation

- Automatic Differentiation can calculate derivatives without any [additional
  precision loss]. 

- It is not confined to closed-form expressions. 

- It can take derivatives of algorithms involving conditionals, loops, and
  recursion. 

- It can be easily scaled for functions with very large number of inputs.

### Automatic Differentiation Implementation with Clad - a Clang Plugin

Implementing Automatic Differentiation from the ground up can be challenging.
However, several C++ libraries and tools are available to simplify the
process. The Compiler Research Group has been working on [Clad], a C++ library
that enables Automatic Differentiation using the LLVM compiler infrastructure.
It is implemented as a plugin for the Clang compiler. 

[Clad] operates on Clang AST (Abstract Syntax Tree) and is capable of
performing C++ Source Code Transformation. When Clad is given the C++ source
code of a mathematical function, it can algorithmically generate C++ code for
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

### Clad Benchmarks (while using Automatic Differentiation)

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

[additional precision loss]: https://compiler-research.org/assets/presentations/CladInROOT_15_02_2020.pdf

[Source Code Transformation]: https://compiler-research.org/assets/presentations/V_Vassilev-SNL_Accelerating_Large_Workflows_Clad.pdf

[two major techniques]: https://compiler-research.org/assets/presentations/G_Singh-MODE3_Fast_Likelyhood_Calculations_RooFit.pdf

[The source code transformation approach]: https://compiler-research.org/assets/presentations/I_Ifrim-EuroAD21_GPU_AD.pdf