---
title: "Season of Docs program 2023"
layout: gridlay
excerpt: "Season of Docs program 2023"
sitemap: false
permalink: /season_of_docs_2023
---

# Our 2023 Season of Docs project

We seek to advance the documentation in the area of interactive analysis, both in the context of C++ and support for C++/Python interoperability.  Our intent is to build the sort of documentation that enables user engagement while being easy to update as our codes continue to evolve and improve.

Our background is in enabling particle physics researchers to do cutting-edge data analysis. To make this happen, researchers have developed several unique software technologies in the area of data analysis. We developed an interactive, interpretative C++ interpreter (aka REPL) as part of the ROOT data analysis project, including “Cling”, which is a REPL based on LLVM. [Cling](https://rawgit.com/root-project/cling/master/www/index.html) is a core component of ROOT and has been in production since 2014. Cling is also a standalone tool, which has a growing community outside of our field. It is recognized for enabling interactivity, dynamic interoperability and rapid prototyping capabilities for C++ developers. For example, if you are typing C++ in a Jupyter notebook you are using the (xeus-cling)[https://xeus-cling.readthedocs.io/en/latest/] Jupyter kernel. 

We are in the midst of an important project to address one of the major challenges to ensure Cling’s sustainability and to foster that growing community: moving most parts of Cling into LLVM. Since LLVM version 13 we have released a version of Cling called Clang-Repl within LLVM itself. We subsequently focused on the language interoperability capabilities of Cling. One user facing application of our libInterOp, together with Clang-Repl, is Xeus-Clang-Repl, which is a replacement for xeus-cling using these new codes. As we advance the implementation and generalize its usage we aim for improving the overall documentation experience in the area of interactive programming in various environments.

## Scope
This project will audit and extend the existing documentation for the Clang-Repl (interactive C++), Xeus-Clang-Repl (notebook-based C++ and Python platform) and libInterOp (bridging automatically C++ and Python). We aim to Identify gaps in the information or presentation from the point-of-view of new, science-oriented users.

The anticipated scope of the work is:
  * Improve user and developer documentation about xeus-clang-repl
  * Write several tutorials demonstrating the current capabilities of clang-repl.
  * Prepare a blog post (or posts) about clang-repl and xeus-clang-repl.
  * Improve user and developer documentation about InterOp library API and usage.
  * Develop a set of blog posts on how to use the InterOp library API and usage.
  * Develop a set of blog posts on how to use the InterOp library together with higher-level tool kits such as [Cppyy](https://github.com/wlav/cppyy). 

Work that is out-of-scope for this project:
  * Candidates are not expected to have detailed physics or interactive compilation knowledge. Technical writers will focus on
  explaining the technical systems, working closely with our research teams to ensure the end results have the appropriate
  mix of  scientific reasoning and technical detail. 
  * Candidates are not required to have past experience with a particular set of documentation tools.

## Contact us

