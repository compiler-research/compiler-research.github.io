---
title: "CLAD Jupyter Tutorial"
layout: textlay
excerpt: "CLAD Jupyter Tutorial"
sitemap: false
permalink: /tutorials/clad_jupyter/
---

**Clad & Jupyter Notebook Tutorial**

*Tutorial level: Intro*

[xeus-cling](https://github.com/jupyter-xeus/xeus-cling) provides a Jupyter
kernel for C++ with the help of the C++ interpreter cling and the native
implementation of the Jupyter protocol xeus.

Within the xeus-cling framework, Clad can enable [automatic differentiation (AD)]
(https://en.wikipedia.org/wiki/Automatic_differentiation) such that users can
automatically generate C++ code for their computation of derivatives of their
functions.

**Rosenbrock Function**

In mathematical optimization, the Rosenbrock function is a non-convex function
used as a performance test problem for optimization problems. The function is
defined as:

<div align=center style="max-width:1095px; margin:0 auto;">
  <img src="/images/tutorials/clad_jupyter/clad_jupyter1.png" style="max-width:90%;"><br/>
 <p align="center">
  </p>
</div>

In order to compute the function’s derivatives, we can employ both Clad’s
Forward Mode or Reverse Mode as detailed below:

**Forward Mode AD**

For a function `f` of several inputs and single (scalar) output, forward mode AD
can be used to compute (or, in case of Clad, create a function) computing a
directional derivative of `f` with respect to a _single_ specified input
variable. Moreover, the generated derivative function has the same signature as
the original function `f`, however its return value is the value of the
derivative.

<div align=center style="max-width:1095px; margin:0 auto;">
  <img src="/images/tutorials/clad_jupyter/clad_jupyter2.png" style="max-width:90%;"><br/>
 <p align="center">
  </p>
</div>

**Reverse Mode AD**

Reverse-mode AD enables the gradient computation within a single pass of the
computation graph of `f` using _at most_ a constant factor (around 4) more
arithmetical operations compared to the original function. While its constant
factor and memory overhead is higher than that of the forward-mode, it is
independent of the number of inputs.

Moreover, the generated function has `void` return type and same input arguments.
The function has an additional argument of type `T*`, where `T` is the return
type of `f`. This is the "result" argument which has to point to the beginning
of the vector where the gradient will be stored.

<div align=center style="max-width:1095px; margin:0 auto;">
  <img src="/images/tutorials/clad_jupyter/clad_jupyter3.png" style="max-width:90%;"><br/>
 <p align="center">
  </p>
</div>

**Performance Comparison**

The derivative function created by the forward-mode AD is guaranteed to have
_at most_ a constant factor (around 2-3) more arithmetical operations compared
to the original function. Whilst for the reverse-mode AD for a function having N
inputs and consisting of T arithmetical operations, computing its gradient takes
a single execution of the reverse-mode AD and around 4*T operations. In
comparison, it would take N executions of the forward-mode, this requiring up to
N*3*T operations.

<div align=center style="max-width:1095px; margin:0 auto;">
  <img src="/images/tutorials/clad_jupyter/clad_jupyter4.png" style="max-width:90%;"><br/>
 <p align="center">
  </p>
</div>

**Clad Produced Code**

We can now call rosenbrockX / rosenbrockY /  rosenbrock_dX_dY .dump() to obtain
a print out of the Clad’s generated code. As an illustration, the reverse-mode
produced code is:

<div align=center style="max-width:1095px; margin:0 auto;">
  <img src="/images/tutorials/clad_jupyter/clad_jupyter5.png" style="max-width:90%;"><br/>
 <p align="center">
  </p>
</div>
