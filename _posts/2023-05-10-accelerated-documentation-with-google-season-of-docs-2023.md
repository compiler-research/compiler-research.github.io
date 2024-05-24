---
title: "Driving Collaboration in Documentation: Google Season of Docs 2023"
layout: post
excerpt: "A review of the documentation efforts in 2023, powered by Google's 
Season of Docs initiative. An audit of the existing documentation was done to 
identify gaps and potential areas of improvement. Our main areas of focus were: 
Automatic Differentiation applications (using Clad, e.g. in RooFit and 
Floating-Point Error Estimation), and Python-C++ Interoperability (Clang-Repl 
(LLVM), CppInterOp, cppyy, Numba, etc.)."
sitemap: false
author: QuillPusher
permalink: blogs/gsod23_quillpusher_experience_blog/
date: 2023-05-10
tags: gsod documentation llvm root clang-repl cppyy
---

### How we got started

An audit of the existing documentation was done to identify gaps and potential
areas of improvement. Our main areas of focus were (these evolved over time,
based on documentation audit):

- Automatic Differentiation applications (using Clad, e.g. in RooFit and
  Floating-Point Error Estimation), and

- Python-C++ Interoperability (Clang-Repl (LLVM), CppInterOp, cppyy, Numba,
  etc.).

We also wanted to capture the [Student Success Stories], including milestones
achieved by student developers under the banner of Compiler Research
Organization’s guidance and mentorship programs.

### What we accomplished

Following are the major documentation areas that we worked on.

- [AD Support in RooFit] (ROOT)
- [Execution Results Handling] ([PR65650]) in Clang-REPL (LLVM)
- [Floating Point Error Estimation] (Clad)
- [CppInterOp for Python and C++ Interoperability] (Compiler Research
  Organization)
- [cppyy Enhancements] (Compiler Research Organization)
- [Numba Enhancements] (cppyy)

These were concluded based on expected timeline. A detailed report with
relevant PRs can be found in the [GSoD 2023 Case Study].

### Our overall experience

We would consider the project successful, on account of the major documentation
contributions in upstream LLVM, ROOT, and other repositories, where our
developers had previously contributed code.

Going into this project, we had a vision of what we wanted to achieve, but over
several brainstorming sessions, we identified several areas that we thought
needed improvement. Due to the limited time frame that we were working with, we
prioritised the tasks based on what was urgent and what was important.

### GSoD contributor’s experience

“I came into this project without much experience with compiler-related
technologies. I had technical writing experience, but in a different domain.
So, I had to shift gears and come in with a student’s mentality, while bringing
along the discipline of a seasoned writer.

My mentors (David Lange and Vassil Vassilev) were kind and patient as I learned
the ropes and started landing upstream documentation for large communities such
as ROOT, LLVM, etc. Despite having years of experience before this, it was a
major confidence boost for me since I wasn’t functioning in a sterilised
corporate environment anymore and was finally part of the open source community
at large.

My takeaway from this project is that the open source community is not as
walled-off as it seems to an outsider. There are people who are willing to help
you, as long as they see the value in your work and that you’re willing to make
an effort. This project has set me off on a trajectory of self-improvement and
learning, helping me identify how large, distributed communities work and what
skills I need to acquire to advance in my career.” – [@QuillPusher] (Saqib)

[Student Success Stories]: https://compiler-research.org/stories/

[GSoD 2023 Case Study]: https://github.com/compiler-research/compiler-research.github.io/blob/master/assets/docs/gsod_casestudy_2023.pdf

[@QuillPusher]: https://github.com/QuillPusher

[AD Support in RooFit]: https://github.com/root-project/root/pull/14018

[Execution Results Handling]: https://reviews.llvm.org/D156858

[PR65650]: https://github.com/llvm/llvm-project/pull/65650

[Floating Point Error Estimation]: https://github.com/vgvassilev/clad/pull/648

[CppInterOp for Python and C++ Interoperability]: https://github.com/compiler-research/CppInterOp/pull/85

[cppyy Enhancements]: https://github.com/compiler-research/CppInterOp/pull/160

[Numba Enhancements]: https://github.com/wlav/cppyy/pull/199
