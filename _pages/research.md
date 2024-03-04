---
title: "Compiler Research Research Areas"
layout: gridlay
excerpt: "Research"
sitemap: false
permalink: /research/
---

Following are the areas of research that Compiler Research Group is focused on:

### Automatic Differentiation

Automatic Differentiation (AD) is a useful technique in scientific research
fields like machine learning and computational physics. AD enables the
automatic computation of derivatives of functions with high precision and
efficiency. A notable implementation of AD is the [Clad plugin for the Clang]
compiler. This integration not only simplifies the process of differentiation
but also enhances the performance and accuracy of numerical computations in
scientific applications.

In scientific research, where intricate mathematical models are prevalent, the
utilization of AD through tools like the Clad brings a new level of
sophistication and speed to derivative calculations. By leveraging AD within
C++ compilers, researchers can focus more on the scientific aspects of their
work rather than getting bogged down in manual differentiation tasks. This
automation not only accelerates the development process but also ensures that
computations are error-free and consistent.

### Compiler-As-A-Service

[Compiler as a Service (CaaS)] is an evolving technology that redefines the
traditional approach to compilers by providing a service-oriented
architecture. Instead of treating the compiler as a black box, the CaaS
approach helps open up the functionality to make it available as APIs. This
gives developers unprecedented control and insights into the compilation
process, while being able to use lightweight APIs for simpler workflows and
diagnostics, helping create sophisticated applications more efficiently.

Practical applications of CaaS include deeper and interactive program analysis
and conversion from one programming language to another (e.g., C++ <->
Python).


### Incremental C++

Despite its high performance capabilities, C++ not the first programming
language that comes to mind for rapidly developing robust applications, mainly
due to the long edit-compile-run cycles.

Ongoing research in projects such as [Cling], [Clang-REPL], etc. aims to
provide practically usable interactive capabilities to the C++ programming
language. The goal is to enable dynamic interoperability, rapid prototyping,
and exploratory programming, which are essential for data science and other
scientific applications.

Following are some practical applications of a "[C++ Interpreter]," so to speak:

- In Data Science: Interactive probing of data and interfaces, making complex
  libraries and data more accessible to users. [^1]

- In CUDA: The Cling CUDA extension brings the workflows of interactive C++ to
  GPUs without losing performance and compatibility to existing software. [^1]

- In Exploratory Programming: rapid reproduction of results, which is crucial
  during the exploratory phase of a project. [^2]

- In Jupyter Notebooks: Interactive C++ can be integrated with Jupyter
  Notebooks, providing a swift prototyping and learning experience for C++ users. [^2]

### Language Interoperability

[Language interoperability] helps programmers get the best of both worlds, with
the ability to work with a high-performance language (e.g., C++), and at the
same time, take advantage of a more interactive one (e.g., Python), while
helping them identify each other's entities (like variables and classes) for
seamless integration.

This interoperability can be achieved by libraries like [CppInterOp], which
expose APIs from compilers like Clang/LLVM in a backward-compatible manner. By
enabling interactive C++ usage through the Compiler-As-A-Service, CppInterOp
simplifies complex tasks such as "language interoperability on the fly".

The practical implications of language interoperability include the growing
need for systems in data science to be able to interoperate with C++
codebases. By providing automatic creation of bindings on demand, tools
like CppInterOp enable Python to interoperate with C++ code dynamically,
instantiate templates, and execute them efficiently. This dynamic approach not
only improves performance but also simplifies code development and debugging
processes, offering a more efficient alternative to static binding methods.

---
Footnotes:

[^1]: [Interactive C++ for Data Science](https://blog.llvm.org/posts/2020-12-21-interactive-cpp-for-data-science/)

[^2]: [Interactive Workflows for C++ with Jupyter](https://blog.jupyter.org/interactive-workflows-for-c-with-jupyter-fe9b54227d92)


[CppInterOp]: https://github.com/compiler-research/CppInterOp/blob/main/README.md

[Clad plugin for the Clang]: https://compiler-research.org/clad/

[Language interoperability]: https://compiler-research.org/libinterop/

[Cling]: https://rawgit.com/root-project/cling/master/www/index.html

[Clang-REPL]: https://clang.llvm.org/docs/ClangRepl.html

[Compiler as a Service (CaaS)]: https://compiler-research.org/caas/

[C++ Interpreter]: https://compiler-research.org/interactive_cpp