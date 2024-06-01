---
title: "Superbuilds for ROOT"
layout: post
excerpt: "A GSoC 2024 project with goal to split ROOT into separate components and thus speed up its compilation"
sitemap: false
author: Pavlo Svirin
permalink: blogs/gsoc24_pavlo_svirin_introduction_blog/
date: 2024-05-31
tags: gsoc root cmake 
---

### Introduction

I am Pavlo Svirin, a software engineer at the Bogolyubov Institute of
Theoretical Physics in Kyiv, Ukraine. During the Google Summer of Code 2024 I
will be working on superbuilds for ROOT.

**Mentors**: Vassil Vassilev, Danilo Piparo


### Briefly about ROOT

ROOT is a framework for data processing, born at CERN, at the heart of the
research on high-energy, molecular and laser physics, as well as in  astronomy.
Every day, thousands of physicists use ROOT applications to analyze their data
or to perform simulations. 

ROOT has plenty of built-in components which allow to do:
- Histogramming and graphing to view and analyze distributions and functions,
- curve fitting (regression analysis) and minimization of functionals,
- statistics tools used for data analysis,
- matrix algebra,
- four-vector computations, as used in high energy physics,
- standard mathematical functions,
- multivariate data analysis, e.g. using neural networks,
- image manipulation, used, for instance, to analyze astronomical pictures,
- access to distributed data (in the context of the Grid),
- distributed computing, to parallelize data analyses,
- persistence and serialization of objects, which can cope with changes in class
  definitions of persistent data,
- access to databases,
- 3D visualizations (geometry),
- creating files in various graphics formats, like PDF, PostScript, PNG, SVG,
  LaTeX, etc.
- interfacing Python code in both directions,
- interfacing Monte Carlo event generators.


Because of such a variety of  features, ROOT is a very large software which
takes a very long time to compile. Currently ROOT compiles all of the components
available within the source code distribution.


### Implementation Details and Plans

The goal of the project is to speed up the compilation process by letting users
specify which components of the ROOT will be needed. This can be done by
converting ROOT’s CMake configuration into a set of “CMake External Projects”
(superbuilds).  Superbuilds can remove all of this cruft from the project’s
source repository, and enable you to more directly use the upstream project’s
build system as an independently built software component. It is basically a
simple package manager that you make consistently work across your target build
platforms, and if your target platforms have a common package manager you might
consider using that instead. 

Also, during the configuration process it could be possible to identify if ROOT
is already installed in the destination folder, the components which are already
installed and offer an option to skip their compilation and use these already
installed components for current compilation.


### Conclusion

The goal of this project is not to change the build system of ROOT, but to
optimize it and offer users an option to select only  the parts of the ROOT to
be built. Partial  builds for ROOT can allow the creation of “edition” builds if
necessary. There is also an option to create an Ncurses menu-based configuration
application (TUI, text user interface) which will simplify the configuration
process and will let users not to remember names of ROOT subprojects, thus
making build process easier.


### Related Links

- [ROOT website](https://root.cern)
- [CMake Superbuilds and Git Submodules](https://www.kitware.com/cmake-superbuilds-git-submodules/)
- [CMake external projects documentation](https://cmake.org/cmake/help/latest/module/ExternalProject.html)
- [My GitHub Profile](https://github.com/pavlo-svirin)


