---
title: "Xeus Cpp: C++ and Python Integration in a Single Jupyter Environment"
layout: post
excerpt: "Xeus-CPP is a successor of xeus-clang-repl and xeus-cling. It is a Jupyter
kernel for C++, based on the native implementation of the Jupyter protocol
xeus. This enables users to write and execute C++ code interactively, seeing
the results immediately. Its REPL (read-eval-print-loop) nature allows rapid
prototyping and iterations without the overhead of compiling and running
separate C++ programs."
sitemap: false
permalink: blogs/xeus-cpp-jupyter-kernel/
date: 2024-01-31
---

{% capture image_style %}
    max-width: 90%;
    display: block;
    margin: 0 auto;
{% endcapture %}

Xeus-CPP is a successor of Xeus-Clang-Repl and Xeus-Cling. It is a Jupyter
kernel for C++, based on native implementation of the Jupyter protocol 'Xeus'.
This enables users to write and execute their C++ code interactively, where
they can see the results immediately. Its REPL (read-eval-print-loop)
mechanism allows for rapid prototyping and iterations without the overhead of
compiling and running separate C++ programs. 

Following are some interesting use cases for Xeus-CPP:

- Experiment with C++ and Python integration within the same Jupyter
  environment.

- Identify and resolve issues in small code snippets while isolating and
  testing specific pieces of your code.

- Practice C++ in an interactive yet controlled environment.

- Etc.

> Tip: Jupyter notebooks support magic commands (%%python) and inline code
> execution for various languages. You can use these features to run Python
> and C++ code in separate cells to accomplish interactive communication
> between them.

### C++-Python Integration Example

In this example, we are emphasizing the concept of Python-C++ integration,
where we use Python and C++ in the same session, sharing variables, scopes,
and features. 

![Integration Tutorial](/images/blog/2024-01-31-xeus-cpp-image-1.webp){: style="{{ image_style }}"}

Here, we have used variables (new_var1, new_var2, new_var3) in python which
have been initialised in C++. In the following context, we have tried the vice
versa as well of using the variables in Python (new_python_var) which have
been defined in C++.

For detailed instructions, please visit this [tutorial].

### Feature Roadmap

Our goal is to advance the project's feature support to the extent of what’s
supported in Xeus-Clang-Repl and Xeus-Cling. If you'd like to contribute to
Xeus-CPP's under-development features like Value Printing, advancing the WASM
infrastructure, etc., please visit the [Open Projects] page and the
[Contributing Guide].

### Related Links

For more information, please visit:

- **Github Repo**: [Xeus-CPP](https://github.com/compiler-research/xeus-cpp)

- **Documentation**: [ReadTheDocs](https://xeus-cpp.readthedocs.io/en/latest/InstallationAndUsage.html)



[Open Projects]: https://compiler-research.org/open_projects

[Contributing Guide]: https://github.com/compiler-research/xeus-cpp/blob/main/CONTRIBUTING.md

[tutorial]: https://xeus-cpp.readthedocs.io/en/latest/tutorials.html