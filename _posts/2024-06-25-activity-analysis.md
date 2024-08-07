---
title: "Optimizing automatic differentiation using activity analysis"
layout: post
excerpt: "IRIS-HEP project aimed to optimize automatic differentiation using activity analysis"
sitemap: false
author: Maksym Andriichuk
permalink: blogs/iris_maksym_andriichuk_introduction_blog/
banner_image:
date: 2024-06-25
tags: iris-hep clang llvm clad
---

### Introduction

My name is Maksym Andriichuk, I am currently studying Mathematics at the the University of Wuerzburg, Germany. I am a IRIS-HEP fellow contributing to Clad, a source transformation based automatic differentiation tool introduced by the Compiler Research group. My goal is to implement activity analysis which would improve the performance of the generated code.

**Mentors**: David Lange, Vassil Vassilev, Petro Zarytskyi

### Briefly about Clad and Activity Analysis

Clad is a Clang plugin designed to provide automatic differentiation (AD) for C++ mathematical functions. It generates code for computing derivatives modifying abstract syntax tree using LLVM compiler features. AD breaks down the function into elementary operations and applies chain rule to compute derivatives of intermediate variables. Clad supports forward- and reverse-mode differentiation that are effectively used to integrate all kinds of functions.

Activity analysis is an optimization which discards all statements which are irrelevant for the generated code. That is, if the statements do not depend on the input/output variables of a routine in a differentiable way, they are ignored. The advantage is that this improves the performance of the generated code and reduces the phase space of features needed to be supported to enable differentiable STL, for example.

In its implementation activity analysis would be similar to an already implemented To-Be-Recorded analysis. TBR analysis is a part of an adjoint mode of AD. It finds variables whose present value is used in a derivative instruction and reduces the number of statements by not creating temporary variables for dependent variables that are being overwritten and not being used.

### Implementation Details

We will operate on two sets of variables: “Varied” set contains all variables that depend on some independent input and “Useful” contains all variables that influence some other dependent output.
In order to do this we will create a new class to keep information about the “Varied” and “Useful” variables sets using the AST visitor technology in clang. We will analyze statements for “Varied” variables the way it is implemented in the VarData class from TBRAnalyzer, since both TBR and “Varied” variables are determined after a forward-sweep. We will derive the “Useful” set of variables in a reverse-sweep, its implementation would also be relevant for the future AA extensions.

We will also use diff-dependency analysis to preliminary compute a set of all dependent variables before a certain statement. Using the transitivity of a “dependency in a differentiable way” we derive to certain relations between defined sets which at the end help to determine if certain statements are not important to add to the body of a generated derivative code.

### Conclusion

Activity analysis is an important step in the development of Clad. When activity analyses is default, which is my ultimate goal, it would be possible to further optimize TBR analysis. There are many analyses to be implemented in Clad and I am exited to be a part of it.

### Related Links

- [Clad Repository](https://github.com/vgvassilev/clad)
- [IRIS-HEP Project Proposal](https://compiler-research.org/assets/docs/Maksym_Andriichuk_Proposal_2024.pdf)
- [My GitHub Profile](https://github.com/ovdiiuv)
