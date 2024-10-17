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

### Project Overview

Xeus-cpp is a Jupyter kernel for C++ built on the native Jupyter protocol, enabling interactive coding with REPL functionality for quick prototyping without separate compilation. This project aims to integrate a large language model with the xeus-cpp kernel, allowing users to generate and execute C++ code interactively with AI-powered assistance.

### Implementation

![Codeflow](./images/blog/codeflow.png)

I created a magic function called XAssist that connects to a specific LLM based on the user's preference. It utilizes utility functions and the cURL library to connect with the LLM and retrieve the respective response. The user saves the API keys for OpenAI and Gemini, sets the URL for Ollama, saves a particular model, and then uses the LLM.

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

### Result

Here is an example that demonstrates how one can use XAssist.

![Gemini](./images/blog/gemini.png)

### Related Links

- [Xeus-cpp Repository](https://github.com/compiler-research/xeus-cpp)
- [Project Description](https://hepsoftwarefoundation.org/gsoc/2024/proposal_XeusCpp-LLM.html)
- [GSoC Project Proposal](/assets/docs/TharunA_GSoC_Proposal_2024-Xeus-Cpp.pdf)
- [My GitHub Profile](https://github.com/tharun571)
