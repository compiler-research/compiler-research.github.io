---
title: "Exploring Automatic Differentiation with CHEF-FP for Floating-Point Error Analysis"
layout: post
excerpt: "In High-Performance Computing (HPC), where precision and performance are
critically important, the seemingly counter-intuitive concept of Approximate
Computing (AC) has gradually emerged as a promising tool to boost
computational throughput. There is a lot of interest in techniques that work
with reduced floating-point (FP) precision (also referred to as mixed
precision). Mixed Precision Tuning involves using higher precision when
necessary to maintain accuracy, while using lower precision at other times,
especially when performance can be improved."
sitemap: false
permalink: blogs/exploring-ad-with-chef-fp/
date: 2023-04-13
---


> Note: Following is a high-level blog post based on the research paper: [Fast
> And Automatic Floating Point Error Analysis With CHEF-FP]

In High-Performance Computing (HPC), where precision and performance are
critically important, the seemingly counter-intuitive concept of Approximate
Computing (AC) has gradually emerged as a promising tool to boost
computational throughput. There is a lot of interest in techniques that work
with reduced floating-point (FP) precision (also referred to as mixed
precision). Mixed Precision Tuning involves using higher precision when
necessary to maintain accuracy, while using lower precision at other times,
especially when performance can be improved.

As long as there are tools and techniques to identify regions of the code that
are amenable to approximations and their impact on the application output
quality, developers can employ selective approximations to trade-off accuracy
for performance.

### Introducing CHEF-FP

CHEF-FP is one such source-code transformation tool for analyzing
approximation errors in HPC applications. It focuses on using Automatic
Differentiation (AD) and its application in analyzing floating-point errors to
achieve sizable performance gains. This is accomplished by using Clad, an
efficient AD tool (built as a plugin to the Clang compiler), as a backend for
the presented framework.

CHEF-FP automates error estimation by injecting error calculation code into
the generated derivatives, enhancing analysis time and reducing memory usage.
The framework's ability to provide Floating-Point error analysis and generate
optimized code contributes to significant speed-ups in the analysis time.

### Modeling Floating-Point Errors

The error model describes a metric that can be used in the error estimation
analysis. This metric is applied to all assignment operations in the
considered function, and the results from its evaluation are accumulated into
the total floating point error of the left-hand side of the assignment. This
error model is sufficient for most smaller cases and can produce loose upper
bounds of the maximum permissible FP error in programs.

### Automatic Differentiation (AD) Basics

With increasingly better language support, AD is becoming a much more
attractive tool for researchers. AD takes as input any program code that has
meaningful differentiable properties and then it produces a new code that is
augmented with pushforward (forward mode AD) or pullback (reverse mode AD)
operators. 

The Reverse Mode AD in particular provides an efficient way to compute the
function’s gradient with relative time complexity,  which is independent of
the size of the input. Among AD techniques, the Source Transformation approach
has better performance, since it does as much as possible at compile time to
create the derivative only once. 

### AD-Based Floating-Point Error Estimation Using CHEF-FP

An important part of dealing with floating-point applications with high
precision requirements is identifying the sensitive (more error-prone) areas
to implement suitable mitigation strategies. This is where AD-based
sensitivity analysis can be very useful. It can find specific variables or
regions of code with a high contribution to the overall FP error in the
application. 

The CHEF-FP framework requires less manual integration work and comes packaged
with Clad, taking away the tedious task of setting up long tool chains. The
tool’s proximity to the compiler (and the fact that the floating-point error
annotations are built into the code’s derivatives) allows for powerful
compiler optimizations that provide significant improvements in the analysis
time. Another upside of using a source-level AD tool like Clad as the backend
is that it provides important source insights (variable names, IDs, source
location, etc.). Clad can also identify special constructs (such as loops,
lambdas, functions, if statements, etc.) and fine-tune the error code
generation accordingly. 

### Implementation

CHEF-FP's implementation involves registering an API in Clad for calculating
the floating-point errors in desired functions using the default error
estimation models. 

CHEF_FP not only serves as a proof-of-concept, but it also provides APIs for
building common expressions. For more complex expressions, custom calls to
external functions can be built as a valid [custom error model], as long as the
function has a compatible return type for the variable being assigned the
error. This means that users can define their error models as regular C++
functions, enabling the implementation of more computationally complex models.

### Conclusion

The research illustrates the power of CHEF-FP in automating Floating-Point
Error Analysis, guiding developers in optimizing various precision
configurations for enhanced performance. By utilizing AD techniques and
source-level insights, CHEF-FP presents a scalable and efficient solution for
error estimation in HPC applications, paving the way for better computational
efficiency. To explore this research, please view the [CHEF-FP examples repository].


[Fast And Automatic Floating Point Error Analysis With CHEF-FP]: https://arxiv.org/abs/2304.06441

[custom error model]: https://github.com/vgvassilev/clad/blob/v1.1/demos/ErrorEstimation/CustomModel/README.md

[CHEF-FP examples repository]: https://github.com/grimmmyshini/chef-fp-examples