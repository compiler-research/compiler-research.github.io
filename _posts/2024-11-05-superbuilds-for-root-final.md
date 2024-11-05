---
title: "Superbuilds for ROOT: Updates"
layout: post
excerpt: "A GSoC 2024 project aimed to introduce superbuilds into ROOT"
sitemap: false
author: Pavlo Svirin
permalink: blogs/gsoc24_pavlo_svirin_final_blog/
banner_image: /images/blog/gsoc-banner.png
date: 2024-11-05
tags: gsoc root cmake
---

### About Me

I am Pavlo Svirin, a software engineer at the Bogolyubov Institute of Theoretical Physics in Kyiv, Ukraine. During the Google Summer of Code 2024 I had been working  on superbuilds for ROOT.

### Project Description

ROOT is a framework for data processing, born at CERN, at the heart of the research on high-energy, molecular and laser physics, as well as in astronomy. Every day, thousands of physicists use ROOT applications to analyze their data or to perform simulations.
ROOT has plenty of built-in components, and because of such a variety of features, ROOT is a very large software which takes a very long time to compile. Currently ROOT compiles all of the components available within the source code distribution.

The goal of the project is to speed up the compilation process by letting users specify which components of the ROOT will be needed. This can be done by converting ROOT’s CMake configuration into a set of “CMake External Projects” (superbuilds). Superbuilds can remove all of this cruft from the project’s source repository, and enable you to more directly use the upstream project’s build system as an independently built software component. It is basically a simple package manager that you make consistently work across your target build platforms, and if your target platforms have a common package manager you might consider using that instead.

Also, during the configuration process it could be possible to identify if ROOT is already installed in the destination folder, the components which are already installed and offer an option to skip their compilation and use these already installed components for current compilation.

My mentors for the project were Vassil Vassilev and Danilo Piparo.


### Technologies

* `C++`
* `CMake`
* `Makefile`
* `Bash`

### Preparation & The Community Bonding Period

During the Community Bonding period I was studying the ROOT's codebase, which contains around 5.5 million lines of code in C, C++, Python and other programming languages.
I was also studying approaches to solve this problem which were suggested by people in the past years and the needs and ticket on GitHub, which are relevant.
My mentors provided very good help regarding these points. 

### Deliverables

The primary goal of the project was to provide an option of partial builds for ROOT.

Initial weeks were dedicated to studying the codebase and discovering of dependencies among ROOT's components, since ROOT is a very large and complex product.
We've identified a minimum viable set of components using which ROOT can be built and run.
We've inroduced modifications to the build script which allowed to decrease the level of coupling among the components. This made an option to build ROOT in edition-like mode: an "universal" one which provides the same result as the build scripts did before my changes and "essentials" which includes only the basic modules.
The option to build ROOT components without building the whole ROOT and linking against already built and installed components was also implemented.
Lots of attention was paid to compatibillity with the original version of build scripts: if no extra parameters are needed to build the "universal" ROOT, thus, no changes needed for the customers or current tests in the CI/CD system.

### Consequences

The changes I've made within the context of this project allow to speed up the compilation of ROOT which can be done by selection of the necessary projects or reusing already compiled componens.
During this project we've also identified some issues which will be fixed in the future.


### Personal Experience

During the work on this project I had a great chance to dive deep into the internals of the one of the most important frameworks used in High-energy physics.
I got familiar with the internals of ROOT, its build system, as well as the need of the people who use and develop this software.
I will use this knowledge for related works in the future.
Also, I greatly improved my knowledge of CMake.

### Related Links

- [ROOT website](https://root.cern)
- [CMake Superbuilds and Git Submodules](https://www.kitware.com/cmake-superbuilds-git-submodules/)
- [CMake external projects documentation](https://cmake.org/cmake/help/latest/module/ExternalProject.html)
- [My GitHub Profile](https://github.com/pavlo-svirin)
- [My development branch for superbuilds](https://github.com/pavlo-svirin/root/tree/superbuilds)
