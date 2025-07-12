---
title: "Implementing AD in CMS Combine"
layout: post
excerpt: "A  CERN Summer Student 2025 project aiming at the integration of 
automatic differentiation (AD) into the CMS Combine tool to accelerate statistical
inference by leveraging RooFit's AD support and LLVM-based gradient generation."
sitemap: false
author: Galin Bistrev
permalink: blogs/2025_galin_bistrev_introduction_blog/
banner_image: /images/blog/banner-cern.jpg
date: 2025-07-05
tags: cern cms root combine c++ rooFit automatic-differentiation 
---

### Introduction
Greetings! I’m Galin Bistrev, a fourth-year student specializing in Nuclear and 
Particle Physics at the University of Sofia "St. Kliment Ohridski".
As part of the CERN Summer Student Programme 2025, I’m working on a project to 
integrate automatic differentiation (AD) 
into the CMS Combine tool.

### Project description

This project focuses on implementing automatic differentiation (AD) into the CMS 
Combine tool, which the primary statistical analysis framework used by the CMS experiment
at CERN. Combine is built on top of RooFit, which recently introduced AD 
technology  to support  minimization methods.
By generating computationally efficient gradients through AD, RooFit enables significant
performance gains. RooFit’s implementation of AD works by converting internal 
likelihood representations into standalone C++ code, from which gradient code is 
produced. This approach not only accelerates fitting but also improves 
the portability and shareability of likelihood models, making them accessible
even to users without deep knowledge of RooFit or Combine internals.

### Brief description of the CMS Combine engine
Combine is a statistical analysis tool designed to compare a model of expected 
observations with real data. It’s commonly used for tasks such as discovering 
new particles or processes, setting limits on potential new physics, and measuring
physical quantities like cross sections.While Combine was developed with High 
Energy Physics (HEP) applications in mind, it contains no built-in physics 
knowledge,thus it remains completely general and independent of the interpretation
of any specific analysis. This flexibility allows it to be used across a wide range 
of statistical problems

### Project goals
The main goals of this project are:

- Support external users in working with Combine-generated models without needing
to dive into RooFit or Combine internals.

- Optimize performance in high-complexity workflows within the Combine framework.


### Implementation strategy 

- Refactor Combine to use standard RooFit primitives where possible, and add AD support to custom components.

- Integrate RooFit's AD- generated gradients into Combines's likelihood  
evaluation and minimization workflows to improve performance and enable external 
gradient use.


- Developing benchmarks to quantitatively demonstrate the performance improvements AD brings to Combine overflows.

## Conclusion 

By integrating automatic differentiation into the CMS Combine tool, we aim to make
statistical inference not only faster but also more accessible to the broader 
community. I’m excited to contribute to this effort during my time at CERN and 
look forward to sharing progress, insights, and benchmarks as the project evolves.

### Related Links
- [CMS Combine GitHub page]https://cms-analysis.github.io/HiggsAnalysis-CombinedLimit/latest/
- [ROOT official repository]https://github.com/root-project/root
- [My GitHub profile]https://github.com/GalinBistrev2 
