---
title: "Student Success Stories"
layout: gridlay
excerpt: "Student Success Stories"
sitemap: false
permalink: /stories/
---

This page is dedicated to showcasing the notable achievements of our students
and contributors. Under the guidance of mentors from the Compiler Research
Group, these talented individuals have achieved remarkable success in
open-source software development and research advancement.

<div class="col-sm-12 clearfix">
  <img src="{{ site.url }}{{ site.baseurl }}/images/team/Garima_Singh.jpg" class="img-responsive" width="15%" style="float: left" />
## Garima Singh

  Garima was a software engineering student at Manipal Institute of Technology
  in Manipal, Karnataka, India when she started her first project with the
  compiler research organization. She has since made several contributions to
  compiler research, delivering 2 papers and presenting at four major
  conferences as oral presentations. She is currently (as of this writing) an
  MSc student at ETH Zurich.

  Github Profile: [grimmmyshini](https://github.com/grimmmyshini)
  <br />
</div>

### Error Estimation Framework

Garima's interest in error estimation led to her exploration of floating point
 error estimation in High Performance Computing (HPC) applications. This also
led to her research on its applications in High Energy Physics (HEP). She
explored how these floating point estimation tools can be applied to different
 software, to not just estimate errors, but to also perform different
numerical analyses on the programs. These tools can be used, for example, for
sensitivity analysis, and to improve your program's precision to get higher
performance.

For more details, please see the [Error Estimation Framework] document.

### Automatic Differentiation with C++ and Clad

Garima explored the internal workings of the Clang compiler and applications
of its Clad[^1] plugin, specifically for Automatic Differentiation. She
issued several patches and bug fixes to these projects.

### Enabling Clad at scale in HEP through RooFit

During her research, Garima came across the challenges faced by users when
performing large-scale data analysis. She saw the potential of current
state-of-the-art techniques to make analysis faster and more efficient. She
also discovered that even small improvements to the workflow had significant
impact on performance, when working at such a large scale. This work was
particularly rewarding for Garima since she was able to delve deep into the
theoretical properties of AD during this research.


### How leading companies can utilize this technology

For the error estimation work, companies can use this technology to not only
determine any numerical instabilities in their code, but also to perform
approximate computing techniques to make their software more efficient.

Clad has a lot of practical applications, especially in companies or
organizations with scientific software. Garima's work has demonstrated how
Clad can be used with sufficiently complex codebases such as ROOT.

Opensource/ scientific software may benefit more from this work, as compared
to the mainstream technology companies, since it is geared more towards
exploratory science than consumer products.


### Why new programmers would want to learn about these features

Error estimation work is an exciting, new research area and can also be used
on smaller-scale projects. The customizable nature of the tool allows
researchers to create new analyses and share them with others in the form of
papers or other scientific contributions.

On the RooFit-AD side, as RooFit grows and more classes change and evolve, the
 underlying AD framework also needs to evolve. It is safe to assume that users
 of RooFit would be interested in following up on this work to keep using AD
with their statistical models.

### Soft skills and community outreach

The Compiler Research team attributes the community-wide acceptance of
Automatic Differentiation to Garima's work in demonstrating its usefulness in
large codebases such as that of the ROOT Framework[^2], specifically in its
RooFit[^3] classes.

Working with a large open source community and getting people onboard to
implement a major shift from Numerical Differentiation (ND) to Automatic
Differentiation (AD) was a great achievement in itself.

Garima values the overall exposure to the diverse community that these
projects have provided her, including opportunities to present her work
infront of large technical audiences, and publishing formal papers in
reputable publications. Published work:

- [Fast And Automatic Floating Point Error Analysis]
- [Automatic Differentiation of Binned Likelihoods With Roofit and Clad]

### Credits

Garima attributes her success in these projects to several collaborators from
[Lawrence Livermore National Laboratory], [Princeton Department of Physics],
[CERN] (European Council for Nuclear Research), and [Nikhef] (National
Institute for Subatomic Physics).

---

<div class="col-sm-12 clearfix">
  <img src="{{ site.url }}{{ site.baseurl }}/images/team/Jun_Zhang.png" class="img-responsive" width="15%" style="float: left" />
## Jun Zhang

Jun is a 3rd year software engineering student at Anhui Normal University,
WuHu, China. He was originally introduced to the Compiler Research team
through Google Summer of Code. Since then, working on the Clang/LLVM
infrastructure, he has contributed ~70 patches.

Github Profile: [junaire](https://github.com/junaire)
<br />
</div>

### Handle Execution Results in Clang-REPL

Jun's major contributions are summed up in the following RFC:

- [Handle Execution Results in clang-repl](https://discourse.llvm.org/t/rfc-handle-execution-results-in-clang-repl/68493)

It builds on top of previous initiative to bring Cling-REPL functionality in
the upstream Clang repo for more generalized applications.

Background: Cling is an interpretive technology that is based on Clang.
Cling-REPL provides REPL (read–eval–print loop) functionality for interactive
programming. Moving parts of Cling-REPL to upstream Clang repository in the
Clang-REPL component helps push the advancements achieved in Cling-REPL to a
wider audience.

Following are the relevant patches:

- [Add a new annotation token: annot_repl_input_end](https://reviews.llvm.org/D148997)

- [Introduce Value to capture expression results](https://reviews.llvm.org/D141215)

- [Implement Value pretty printing](https://reviews.llvm.org/D146809)

A brief explanation of these changes can be found in the Clang-REPL document:

- [Clang-REPL](https://clang.llvm.org/docs/ClangRepl.html)

### Technical debt alleviation

Besides making useful contributions to help the High Energy Physics (HEP)
field, he was also able to land critical patches to the upstream LLVM
repositories, that will reduce the technical debt and help Compiler Research
Org adapt the upcoming LLVM versions more seamlessly. Some examples can be
seen [here](https://reviews.llvm.org/D131241)
and [here](https://reviews.llvm.org/D130831).

### How leading companies can utilize this technology

Cling are most commonly used by engineers at CERN for High Energy Physics (HEP)
computations. The goal of Clang-REPL is to generalize Cling and broaden the user
base  for different research and data science areas, especially when **fast
prototyping** is a major requirement.

These features have opened up a new paradigm of interactive possibilities in
C++ programming and as it gains traction, more users are expected to adopt this
approach to achieve better performance.

### Why new programmers would want to learn about these features

REPL is a beginner-friendly approach to programming. Runtime value capture and
pretty printing features are essential parts of REPL interactivity. Programmers
 who use Clang-REPL command line are very likely to use these features to help
them to code and debug.

Runtime value capture **connects the Compiled Code & Interpreted Code**, which
makes it easier for Clang-REPL enable C++ interoperability with other
user-friendly languages like Python.

> Clang-REPL is a general-purpose adaptation of Cling (which is more
HEP-centric). Anyone who wants to learn about interactive features of
Clang-REPL will also benefit from learning about how Cling works and how it
evolved over time.

### Soft skills and community outreach

One of the areas of interest for Jun was: How to demonstrate my work to
others?

Besides accomplishing the technical aspects of each project, a major
personal achievement for Jun was pitching these ideas to the broader LLVM
community (e.g., in LLVM Developers Meeting, Request for Comment (RFC) forum
discussions, exhaustive code reviews, etc.) and demonstrating to them that
these ideas would add value to their overall codebase.

Effectively communicating technical direction to a diverse audience from
different cultures, while speaking in English as a second language was also
a valuable experience.

Intellectual discourse with, and acceptance from, the veterans of Clang project
 provided Jun with valuable insights into the inner workings of
open source collaboration.

Finally, Jun's proactive approach in engaging reviewers and mentors was a great
asset in pushing through these major changes in a large, remote, and
decentralized open source project such as LLVM, where it is hard for a new
comer to establish themselves as an expert (as opposed to brick-and-mortar
companies, where it is easy to identify star performers).

### Credits

Jun attributes his success in these projects to several collaborators
from [Princeton Department of Physics], and [CERN] (European Council for
Nuclear Research).

---

<div class="col-sm-12 clearfix">
  <img src="{{ site.url }}{{ site.baseurl }}/images/team/Baidyanath.png" class="img-responsive" width="15%" style="float: left" />
## Baidyanath Kundu

Baidyanath was a software engineering student at Manipal Institute of
Technology in Manipal, Karnataka, India when he started his first project with
 the compiler research organization. He is currently an MSc Computer Science
student (as of this writing) at ETH, Zurich.

Github Profile: [sudo-panda](https://github.com/sudo-panda)

<br />
</div>

### C++/Python on-demand interoperability (InterOp, cppyy, CPyCppyy, cppyy-backend):

This project required deep understanding of the two major programming
languages used in statistical analysis. It helped bridge the gap between
Python's usability and C++'s performance. Baidyanath also enjoyed working with
 complex codebases, since the general programming wisdom directs most
programmers towards code simplification, whereas with projects like these,
code complexity is an inherent requirement.

### interoperability between Cppyy and Numba

Using the principles established during Python/C++ interoperability
development, this was the next step in adding a third programming language to
the mix. This meant more rules and restrictions since all three languages
needed to agree on the specific operations.

### Applications of Error Estimation Framework

Baidyanath's work in Error Estimation Framework development was mainly focused
 on High Energy Physics (HEP) applications, but it also demonstrated its
possible applications in other High Performance Computing (HPC) fields as
well.

### Clad Array and Hessian support

This was Baidyanath's first exposure to compiler research. He found the
restrictive nature of designing new software features both, challenging and
rewarding. Specifically, template metaprogramming was a great are of interest
for him.


### How leading companies can utilize this technology

During his IPDPS exposure, Baidyanath was please to interact with researchers
who can use it for Climate Modeling. This is important because such models
require a high level of accuracy. Another major use case is for Mixed
Precision Analysis when using MLIR [^4].

### Why new programmers would want to learn about these features

Interoperability is not only targeted towards scientific analysis, but also
new programmers that need an interactive way of learning complex programming
concepts. Languages like Python have a lower barrier to entry, and
interoperability with more complex languages like C++ enables students to
explore these languages in a simplified and fast-paced manner.

### Soft skills and community outreach

An important skill that Baidyanath was able to attain during these projects
was the ability to convey his work to other technical people, who aren't
necessarily from the same field. Participating in several conferences and
presenting in front of large technical audiences helped him develop the tools
to help motivate people to experiment with a new project/research for their
specific applications.

### Credits

Baidyanath attributes his success in these projects to several collaborators
from [Princeton Department of Physics], and [CERN] (European Council for
Nuclear Research).



[^1]: Clad is a source transformation Automatic Differentiation (AD) library
for C++, implemented as a plugin for the Clang compiler.

[^2]: ROOT is a C++ based data analysis framework that provides tools for data
 storage, analysis, and visualization.

[^3]: RooFit is a statistical data analysis tool, widely used in scientific
research, especially in the high-energy physics (HEP) field. It is an
extension of the ROOT framework. RooFit provides a set of tools/classes to
define and evaluate probability density functions (PDFs), perform maximum
likelihood fits, perform statistical tests, etc.

[^4]: MLIR is a unifying software framework for compiler development. MLIR can
 make optimal use of a variety of computing platforms such as GPUs, DPUs,
TPUs, FPGAs, AI ASICS, and quantum computing systems (QPUs). MLIR is a
sub-project of the LLVM Compiler Infrastructure project.

[Error Estimation Framework]: https://compiler-research.org/tutorials/fp_error_estimation_clad_tutorial/

[Lawrence Livermore National Laboratory]: https://www.llnl.gov/about

[CERN]: https://home.web.cern.ch/about

[Princeton Department of Physics]: https://phy.princeton.edu/

[Nikhef]: https://www.nikhef.nl/en/

[Fast And Automatic Floating Point Error Analysis]: https://arxiv.org/pdf/2304.06441.pdf

[Automatic Differentiation of Binned Likelihoods With Roofit and Clad]: https://arxiv.org/abs/2304.02650
