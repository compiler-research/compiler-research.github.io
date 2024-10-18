---
title: "Integrate a Large Language Model with the xeus-cpp Jupyter kernel - Final Report"
layout: post
excerpt: "Integrate a Large Language Model with the xeus-cpp Jupyter kernel, part of Google Summer of Code 2024, aims to integrate a large langauge model into the xeus kernel for users to interactively generate and execute code."
sitemap: false
author: Tharun Anandh
permalink: blogs/gsoc24_tharun_anandh_final_blog/
date: 2024-10-17
tags: gsoc xeus xeus-cpp cpp llm
---

### Introduction

I am Tharun A, this summer I contributed to Xeus-cpp, started by the wonderful developers at the Compiler Research Group and Quantstack. My project was implementing large language models with the xeus kernel.

**Mentors**: Anutosh Bhat, Johan Mabille, Aaron Jomy, David Lange, Vassil Vassilev

---

### Project Overview

Xeus-cpp is a Jupyter kernel for C++ built on the native Jupyter protocol, enabling interactive coding with REPL functionality for quick prototyping without separate compilation. This project aims to integrate a large language model with the xeus-cpp kernel, allowing users to generate and execute C++ code interactively with AI-powered assistance.

---

### Implementation

![Codeflow](./images/blog/codeflow.png)

I created a magic function called XAssist that connects to a specific LLM based on the user's preference. It utilizes utility functions and the cURL library to connect with the LLM and retrieve the respective response. The user saves the API keys for OpenAI and Gemini, sets the URL for Ollama, saves a particular model, and then uses the LLM.

#### Coding Phase 1

1. **Establishing Test Coverage**
   - Focused on creating test coverage, which was instrumental in understanding the codebase.
   - Tracked every function to comprehend its purpose and behavior, enhancing familiarity with the project.

2. **Setting Up a Testing Framework**
   - Developed a testing framework to ensure that the Jupyter notebooks functioned as intended.
   - This allowed for early identification of issues and ensured smooth functionality.

3. **Understanding the Functionality of XMagics**
   - Gained insights into the functionality of `xmagics`, which was critical for my project.
   - This understanding laid the groundwork for further development and integration.

4. **Research on OpenLLM**
   - Conducted research on OpenLLM to evaluate its potential application in the project.
   - Determined that OpenLLM was not suitable, leading to the decision to build a custom framework.

5. **Building a Custom Framework for LLM Integration**
   - Developed a framework to connect with various LLMs using C++ and the **cURL library**.
   - Key functionalities included:
     - **Support for OpenAI and Gemini**: Integrated support for these specific LLMs, expanding the framework’s capabilities.
     - **API Key Management**: Saved API keys in text files to maintain security and accessibility.
     - **Customized JSON Calls**: Created tailored JSON requests for each model, ensuring proper integration.

#### Coding Phase 2

1. **Fixing Issues with the Initial PR**
   - Focused on addressing feedback from the initial pull request (PR) to improve code quality.
   - Made necessary adjustments to meet project standards and enhance functionality.

2. **Debugging Windows-Specific Issues**
   - Encountered challenges with importing the **cURL library** on Windows systems.
   - Investigated and resolved compatibility issues to ensure the framework worked across different platforms.

3. **Adding Context (Chat History) to LLM Calls**
   - Enhanced user experience by implementing the ability to include conversation context in LLM calls.
   - Allowed users to engage in seamless and continuous conversations with the LLM, improving interactivity.

4. **Providing Flexibility in Model Selection**
   - Introduced the option for users to select from multiple LLM models based on their preferences.
   - This flexibility empowered users to tailor their interactions with the LLMs to better meet their needs.

5. **Integrating Support for Ollama (Open Source Model)**
   - Added support for **Ollama**, enabling users to utilize their private models within the `xeus` kernel.
   - This feature expanded the project’s utility, allowing for greater customization and flexibility.

6. **Improving Documentation**
   - Updated and enhanced project documentation to make it more comprehensive and user-friendly.
   - Focused on providing clear instructions for setup, usage, and functionality, benefiting future contributors and users.

---

### Contributions

| PR | Description |
|----|-------------|
| [#47](https://github.com/compiler-research/xeus-cpp/pull/47), [#104](https://github.com/compiler-research/xeus-cpp/pull/104), [#107](https://github.com/compiler-research/xeus-cpp/pull/107), [#109](https://github.com/compiler-research/xeus-cpp/pull/109), [#112](https://github.com/compiler-research/xeus-cpp/pull/112), [#116](https://github.com/compiler-research/xeus-cpp/pull/116), [#124](https://github.com/compiler-research/xeus-cpp/pull/124), [#128](https://github.com/compiler-research/xeus-cpp/pull/128) | Increase test coverage |
| [#64](https://github.com/compiler-research/xeus-cpp/pull/64), [#93](https://github.com/compiler-research/xeus-cpp/pull/93) | Update tutorials, debug documentation |
| [#142](https://github.com/compiler-research/xeus-cpp/pull/142) | Testing framework for notebooks |
| [#151](https://github.com/compiler-research/xeus-cpp/pull/151) | XAssist Implementation - support for OpenAI and Gemini, Context aware, Documentation, Tests |
| [#156](https://github.com/compiler-research/xeus-cpp/pull/156) | XAssist Implementation - support for Ollama, Model freedom, Documentation, Tests  |
| [#160](https://github.com/compiler-research/xeus-cpp/pull/160) | XAssist Implementation - Update tests  |
| [#161](https://github.com/compiler-research/xeus-cpp/pull/161) | XAssist Implementation - Handle prompts with special cases  |

---

### Result

Here is an example that demonstrates how one can use XAssist.

![Gemini](./images/blog/gemini.png)

---

### Future Work

Potential enhancements to XAssist that could significantly increase its usefulness include enabling the LLM to output code directly into subsequent cells, allowing the entire notebook to be analyzed for potential errors, and refining the output format to improve readability and presentation. This has been opened as an issue at [#162](https://github.com/compiler-research/xeus-cpp/issues/162). 

---

### Conclusion

This project will help developers seamlessly integrate OpenAI, Gemini, and Ollama into their workflows, enabling smoother adoption of advanced language models and making development tasks easier and more efficient. By automating complex interactions and streamlining API usage, XAssist aims to reduce manual effort, improve productivity, and enhance the developer experience across various domains.

---

### Acknowledgements

From day one, the learning experience has been immensely rewarding. I would first like to express my gratitude to Vassil for his patience in addressing my doubts and guiding me through every stage of the process. I am also grateful to Johan for his valuable insights and code reviews, and to Anutosh for helping me understand the broader context. A special thanks to Matthew for always providing thoughtful feedback whenever I sought it. I would also like to acknowledge my peers and fellow contributors from the compiler research organization for their invaluable support and collaboration.

These past few months have been transformative for my professional growth, helping me refine my technical skills and enhance my problem-solving abilities. Looking ahead, I plan to continue contributing to xeus-cpp and other projects within the organization, deepen my engagement with open-source initiatives, and explore new areas where I can make meaningful contributions to the community.

---

### Related Links

- [Xeus-cpp Repository](https://github.com/compiler-research/xeus-cpp)
- [Project Description](https://hepsoftwarefoundation.org/gsoc/2024/proposal_XeusCpp-LLM.html)
- [GSoC Project Proposal](/assets/docs/TharunA_GSoC_Proposal_2024-Xeus-Cpp.pdf)
- [My GitHub Profile](https://github.com/tharun571)
