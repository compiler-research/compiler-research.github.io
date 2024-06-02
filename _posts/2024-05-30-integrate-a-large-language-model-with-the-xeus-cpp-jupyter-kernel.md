---
title: "Integrate a Large Language Model with the xeus-cpp Jupyter kernel"
layout: post
excerpt: "Integrate a Large Language Model with the xeus-cpp Jupyter kernel, part of Google Summer of Code 2024, aims to integrate a large langauge model into the xeus kernel for users to interactively generate and execute code."
sitemap: false
author: Tharun Anandh
permalink: blogs/gsoc24_tharun_anandh_introduction_blog/
date: 2024-05-30
tags: gsoc xeus xeus-cpp cpp llm
---

### Introduction

I am Tharun A, I graduated from the National Institute of Technology, Tiruchirapalli, India, in 2023, majoring in Computer Science and Engineering. I will be contributing to Xeus-cpp, developed by the wonderful developers at the Compiler Research Group from Princeton University and CERN.

**Mentors**: Anutosh Bhat, Johan Mabille, Aaron Jomy, David Lange, Vassil Vassilev

### What is Xeus-cpp?

Xeus-cpp, a Jupyter kernel for C++, is built upon the native implementation of the
Jupyter protocol, xeus. This setup empowers users to interactively write and
execute C++ code, providing immediate visibility into the results.With its REPL
(read-eval-print-loop) functionality, users can rapidly prototype and iterate
without the need to compile and run separate C++ programs.

### How will this project help?

With the ever growing popularity of large language models, this project aims to
integrate a large language model with the xeus-cpp Jupyter kernel. This
integration will enable users to interactively generate and execute code in C++
leveraging the assistance of the language model.

### Why GSoC?

I aspire to participate in GSoC because it offers an excellent opportunity to immerse myself in open source. Since college, I have consistently engaged in various activities, and this program seems like a fantastic chance to further expand my knowledge and enhance my software skills. I find compiler design intriguing, an area I didn't explore deeply during college. With the continual advancement of language models, this endeavor promises to enhance my understanding of compiler design and broaden my expertise in LLMs.

### Implementation

1. **Communication with Xeus-cpp**: Using Xplugin, an open-source plugin system developed by some of the Jupyter core team, allows for the creation of a loosely coupled and interchangeable project. This makes it easier to implement other LLMs or add various functionalities to Xeus-cpp in the future.

2. **Autocompletion**: Code completion is an essential feature in AI-assisted coding editors. The complete_request_impl function defined in Xeus will be helpful for this purpose. This function is called whenever any Jupyter frontend requests code completion following user action, such as pressing 'tab' on the keyboard. This triggers the Jupyter kernel to provide several completion options based on the context.

3. **Code Generation**:One way to implement code generation is by using magic commands. These are activated whenever the execute_request_impl method is called. When the Jupyter frontend requests the kernel to run code from a cell, the kernel first checks for valid code to execute, including any magic commands. Magic commands are recognized by their specific format, written as %%<magic_command.

4. **Communication with LLM**: This largely depends on choosing between open-source LLMs and closed-source LLMs. Closed-source LLMs, like OpenAI and Gemini, provide users with an API key for use with Xeus-cpp and may offer slightly better performance. In contrast, open-source LLMs offer greater privacy but come with their own backend development challenges.

4. **Testing**: Xeus-cpp includes comprehensive testing support for both the code and the kernel. This ensures that all possible scenarios are covered and helps verify that both the project and Xeus are functioning perfectly.

With this implementation, I aim to achieve the deliverables and address any new challenges that may arise.

### Conclusion

Completing this project, I aim to boost developers' productivity and satisfy my thirst for learning, particularly in these areas where I have less expertise. Additionally, I intend to continue contributing to this organization beyond this project and explore the vast world of open source.

### Related Links

- [Xeus-cpp Repository](https://github.com/compiler-research/xeus-cpp)
- [Project Description](https://hepsoftwarefoundation.org/gsoc/2024/proposal_XeusCpp-LLM.html)
- [GSoC Project Proposal](/assets/docs/TharunA_GSoC_Proposal_2024-Xeus-Cpp.pdf)
- [My GitHub Profile](https://github.com/tharun571)
