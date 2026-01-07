---
title: "2024 Year-End Reflections: CompilerResearch Group (Personal Perspective)"
layout: post
excerpt: |
  A personal reflection on the Compiler Research Group's 2024 journey,
  highlighting advances in Clad and CppInterOp, deep integration with ROOT and
  CUDA, and the growth of a vibrant, global open-source community.
sitemap: true
author: Vassil Vassilev
permalink: blogs/cr24_recap/
banner_image: /images/blog/vv-2024-recap.webp
date: 2025-01-05
tags: [2024, recap, year-in-review, compiler-research, open-source, community]
---

As we close 2024, I'm filled with excitement about how far our Compiler Research
Group has come. Our core mission to build tools at the intersection of
compilers and data science drove a year of innovation. We saw our flagship
projects Clad and CppInterOp gain new power, and our work reach into major
systems like ROOT (for HEP data analysis) and CUDA (for GPU computing). For
example, Clad (a Clang plugin for C++ automatic differentiation[\[1\]][one]) now
handles more C++ features and even GPU kernels: as one Summer of Code
contributor put it, we worked to "allow Clad to ride the GPU tide by enabling
reverse-mode AD of CUDA kernels"[\[2\]][two]. Seeing that capability evolve was
amazing!

This year **Clad** grew in leaps: by December we had released Clad 1.8, which
added support for standard containers(`std::vector` and `std::array`), C++20
`constexpr`/`consteval`, and even differentiation of CUDA device kernels and
Kokkos library calls[\[3\]][three]. We were thrilled to watch Clad tackle GPU
code. Concretely, our team member Christina Koutsou described how Clad now
"supports differentiation of both host(CPU) and device (GPU) functions" and can
generate gradient kernels for CUDA code[\[2\]][two]. These advances mean
scientists can now compute gradients of GPU-accelerated code with Clad's AD, a
big stride toward high-performance automatic differentiation.

Likewise, our **CppInterOp** library which "provides a minimalist approach for
other languages to bridge C++ entities"[\[4\]][four] matured
significantly. CppInterOp is designed to let dynamic languages (likePython via
cppyy) talk to C++ efficiently. In 2024 we added a new C API and better
WebAssembly/Jupyter integration. Our v1.5.0 release (Dec 2024)introduced
JupyterLite demos and a new `CXScope` API for language
bindings[\[5\]][five]. Perhaps most importantly, we made progress on integrating
CppInterOp with CERN's ROOT framework. ROOT's C++ reflection system is
notoriously complex, and we've been developing an "Adoption of CppInterOp in
ROOT" to simplify it[\[6\]][six]. In short, we're paving the way for future
ROOT versions to use CppInterOp to speed up Python/C++ interop. This work has
already captured the attention of ROOT developers, showing our community impact
beyond compilers.

**Major systems integration** was a theme. Beyond CUDA and ROOT, our team
tackled ROOT's build system and other CMS/HEP tools. For example, Pavlo Svirin
spent the summer adding a _"superbuild"_ option to ROOT[\[7\]][seven], so users
can compile just the ROOT components they need – dramatically speeding up
builds. That work is still in the pipeline of the ROOT team to incorporate into
the project mainline. In another project, Isaac Morales improved _BioDynaMo_(a
simulation platform) by integrating Clang's new C++ modules, speeding up its
ROOT-based headers parsing. We also contributed to NumPy/CPPYY: Riya Bisht's
work showed that Python code using cppyy and Numba can compile CUDA code on the
fly, opening new doorways for GPU computing in Python.

Through all these technical wins, the human side of our work stood out. I was
happy to see that many contributors grew immensely this year. Garima Singh, who
joined us as an undergrad, published two papers on floating-point error and
RooFit gradients while helping enable Clad in ROOT[\[8\]][eight]. Today she's an
MSc student at ETH Zürich – a testament to the research experience. Jun Zhang, a
third-year student, pushed nearly 70 patches into the Clang/LLVM codebase,
bringing Cling (our interactive C++ REPL) features to upstream Clang. His work
makes C++ REPL programming more powerful even beyond HEP prototyping. And
Baidyanath Kundu, after building complex C++/Python interoperability
(interfacing cppyy, CPyCppyy, Numba), is now an ETH Zürich grad student. Their
stories demonstrated how open source mentorship can launch STEM careers.

Throughout 2024 we remained a close-knit community. We held weekly team calls,
GitHub discussions, and even Discord chats. In these discussions (and on our
blog!), we celebrated every merged pull request and debugging victory sometimes
after a good amount of sweat and tears. One highlight was seeing first-time
contributors present at conferences. Many collaborators across Princeton, CERN,
and beyond jumped in -- our NSF-supported team culture thrives on that
energy[\[9\]][nine]. I'm grateful for each person who joined: from seasoned
engineers to coding newcomers. Watching people learn, teach each other (often
across time zones),and make our code better was mesmerizing.

We kept meticulous records of our work on our website and blog. Our project
proposals for 2024 clearly laid out efforts like GPU kernel support in Clad and
CppInterOp adoption in ROOT. Our progress is documented in releases and blogs
(e.g. Clad 1.8 and CppInterOp 1.5 features,summaries of student projects, and
the success stories of our team members). These sources inform the highlights
above. Our great year was built one commit, one idea, and one person at a time.

Looking ahead, I'm optimistic for 2025.We've laid solid groundwork: Clad's new
features and CppInterOp's momentum put us in a great position. We'll continue
partnering with ROOT and CUDA communities, and we're already exploring how Clad
can speed up machine learning training (e.g. compiler-driven gradients for tensor
libraries). Personally, I'm excited to mentor a new cohort in Google Summer of
Code, where I know we'll empower even more students like Garima, Jun, and
Baidyanath. Our story in 2024 is one of growth both in code and community. We
built bridges between languages, between CPU and GPU, and between learners and
experts. That journey reflects our aspiration _to make science computing faster,
smarter, and more collaborative_.

[one]: "https://compiler-research.org/clad/#:~:text=Clad enables automatic differentiation ,mode AD"
[two]: "https://compiler-research.org/blogs/gsoc24_christina_koutsou_project_final_blog/"
[three]: "https://github.com/vgvassilev/clad/releases/tag/v1.8"
[four]: "https://github.com/compiler-research/CppInterOp"
[five]: "https://github.com/compiler-research/CppInterOp/releases/tag/v1.5.0"
[six]: "https://hepsoftwarefoundation.org/gsoc/2024/proposal_CppInterOp-AdoptionInROOT.html"
[seven]: "https://compiler-research.org/blogs/gsoc24_pavlo_svirin_final_blog/"
[eight]: "https://compiler-research.org/stories/"
[nine]: "https://compiler-research.org/stories/#:~:text=Garima attributes her success in,National Institute for Subatomic Physics"
