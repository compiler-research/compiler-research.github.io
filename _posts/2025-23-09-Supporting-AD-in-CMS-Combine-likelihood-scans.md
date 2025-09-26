title: "Results from CERN Summer School 2025: Supporting Automatic 
Differentiation in CMS Combine profile likelihood scans"
layout: post
excerpt: "A CERN Summer Student 2025 project aiming at the support of 
automatic differentiation (AD) for likelihood scans in the CMS Combine 
tool to accelerate statistical inference by leveraging RooFit's AD 
support and LLVM-based gradient generation."
sitemap: false
author: Galin Bistrev
permalink: blogs/2025_galin_bistrev_results_blog/
banner_image: /images/blog/banner-cern.jpg
date: 2025-09-25
tags: cern cms root combine c++ RooFit automatic-differentiation	
---

### **Introduction**
Greetings! I’m Galin Bistrev, a fourth-year student specializing in
 Nuclear and Particle Physics at the University of Sofia "St. Kliment Ohridski."  
As part of the CERN Summer Student Programme 2025, I was working on a 
project that aimed to provide support for Automatic Differentiation 
(AD) into the CMS Combine tool profile likelihood scans.

Mentors: Jonas Rembser, Vassil Vasilev, David Lange

### **Description of the Project**

This project aims to enhance support for Automatic Differentiation (AD) 
in likelihood scans within the CMS Combine framework, the primary 
statistical analysis tool of the CMS experiment at CERN. Combine is 
built on top of RooFit, which has recently introduced AD to improve 
minimization techniques. By providing computationally efficient 
gradients through AD, RooFit achieves substantial performance 
improvements. In RooFit, Clad converts internal likelihood 
representations into standalone C++ code, from which gradient 
routines for AD are generated. This strategy not only speeds up the 
fitting process but also increases the portability and shareability 
of likelihood models, making them usable even by those without 
detailed knowledge of RooFit or Combine internals.

### **Brief overview of the CMS Combine engine**
Combine is a statistical analysis framework that compares models of 
expected observations with real data. It is widely used for tasks such 
as searching for new particles or processes, setting limits on 
potential new physics, and measuring physical quantities like cross-sections. 
Although developed with High Energy Physics (HEP) 
applications in mind, Combine contains no intrinsic physics assumptions, 
making it fully general and independent of any specific analysis. 
This flexibility allows it to be applied across a broad range of 
statistical problems.

Roughly, Combine performs three main functions:

- Builds a statistical model of expected observations.
- Runs statistical tests comparing the model with observed data.
- Provides tools for validating, inspecting, and understanding both the 
model and the results of the statistical tests.

### **Project goals**

In order for AD to be supported in Combine likelihood scans, a number of goals needed to be achieved:

- Refactoring some of Combine's logic into RooFit, so that Combine can 
reuse the AD-enabled minimization algorithm already present there. 
- Integrate gradient computation into likelihood scans, ensuring that 
derivatives are correctly propagated for efficient and accurate minimization.  
- Validate correctness and performance, confirming that the AD-based 
scans produce results consistent with traditional methods while 
offering improved performance.

## **Overview of Completed Work**
Over the course of the project, several major tasks were completed to achieve the stated objectives:

- Imported the `RooMultiPdf` class in RooFit from Combine, enabling 
switching between multiple PDFs, applying statistical penalties, 
and supporting code generation for AD.
 
- The implementation of the new class was made to be supported by 
`codegen` in RooFit by adding a new function in `MathFunc.h` and 
extending `CodegenImpl.cxx` to generate code for models making use of it.
  
- Imported three pieces of code from Combine that handle the 
minimization procedures within the framework in RooFit's `RooMinimizer.cxx`. 
The first is a class imported by Jonas Rembser 
called `FreezeDisconnectedParametersRAII`, which automatically 
freezes and unfreezes parameters disconnected from the likelihood graph. 
The second is the function `generateOrthogonalCombinations`, which 
generates a list of index combinations by initializing a base 
configuration with all indices set to zero and then varying one category at a time. 
The third and final piece of code is a function called `reorderCombinations`, 
which takes the set of indices produced by `generateOrthogonalCombinations` 
and adjusts each combination by adding the corresponding base values 
modulo the maximum allowed index, effectively shifting the combinations 
relative to the current best indices.

- Using the above-stated functions, the discrete profiling algorithm, 
which is the main minimization algorithm in Combine, was imported 
into `RooMinimizer.cxx`.
- A [tutorial](https://root.cern/doc/master/rf619__discrete__profiling_8py.html) 
was created along with a [benchmark](https://github.com/vgvassilev/clad/issues/1521), 
made by Jonas Rembser, demonstrating discrete profiling with RooMultiPdf objects 
and evaluating the performance of AD in the likelihood scans.  

## **Results**
With those objectives accomplished, RooFit now provides AD support for 
discrete profiling. However, the developed benchmark indicates that AD 
does not currently improve efficiency, as the gradient code generated by 
Clad introduces overhead. Further optimization in Clad is needed to achieve 
the potential performance gains for RooFit likelihood scans. More information 
regarding the issue can be found at [#1521](https://github.com/vgvassilev/clad/issues/1521).

## **Conclusions**
Thanks to this project, RooFit now enables AD support for discrete profiling in Combine, 
which, after addressing the current overhead in Clad, would allow for 
significantly faster and more efficient likelihood scans while maintaining 
accurate optimization of both discrete and continuous parameters. 

## **Future work**
- Further benchmarking is required to quantify the potential performance 
gains from automatic differentiation.
- Additional optimization of Clad is needed to eliminate unnecessary 
overhead in gradient generation.
- The discrete profiling logic implemented in RooMinimizer should be 
tested across different models to evaluate the minimizer’s behavior and 
robustness.
- Extend doxygen documentation of RooMinimizer to describe treatment of discrete 
parameters.
- Test if the implementation of discrete profiling works also inside CMS Combine , 
replacing their implementation in `CascadeMinimizer.cxx`. 

## **Acknowledgements**
I would like to express my sincere gratitude to the CERN Summer School 
for the opportunity to participate in such an inspiring project. 
I extend special thanks to Jonas Rembser, Vassil Vassilev, and David Lange for 
their invaluable guidance and for providing continuous learning opportunities throughout this journey. 
I am also grateful to the ROOT team for welcoming me and supporting me throughout my stay at CERN. 

## **Related Links**
- [CMS Combine GitHub page](https://cms-analysis.github.io/HiggsAnalysis-CombinedLimit/latest/)  
- [ROOT official repository](https://github.com/root-project/root)  
- [My GitHub profile](https://github.com/GalinBistrev2)
- [Presentation](/assets/presentations/CaaS_Weekly_25_09_2025_Galin_Bistrev_AD_in_CMS_Combine.pdf)



