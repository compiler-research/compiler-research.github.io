---
title: "Wrapping Up GSoC 2025: Advanced symbol resolution for Clang-Repl"
layout: post
excerpt: "Advanced symbol resolution and re-optimization for Clang-Repl is a Google Summer of Code 2025 project. It aims to improve Clang-Repl and ORC JIT by adding support for automatically loading dynamic libraries when symbols are missing. This removes the need for users to load libraries manually and makes things work more smoothly."
sitemap: false
author: Sahil Patidar
permalink: blogs/gsoc25_sahil_wrapup_blog/
banner_image: /images/blog/gsoc_clang_repl.jpeg
date: 2026-01-15
tags: gsoc LLVM clang-repl ORC-JIT auto-loading
---

## Introduction

Hello! I’m Sahil Patidar, and this summer I had the opportunity to participate in Google Summer of Code (GSoC) 2025 with the LLVM Organization.
My project focused on enhancing ORC-JIT and `Clang-Repl` by introducing a new feature for advanced symbol resolution, aimed at improving runtime symbol handling and flexibility.

**Mentors**: Vassil Vassilev, Aaron Jomy

## Overview of the Project

[Clang-Repl](https://clang.llvm.org/docs/ClangRepl.html) is an interactive C++ interpreter built on top of LLVM’s ORC JIT, enabling incremental compilation and execution.
However, when user code references symbols from external libraries, those libraries must currently be loaded manually. This happens because ORC JIT does not automatically resolve symbols from libraries that haven’t been loaded yet.

To overcome this limitation, my project introduces an automatic library resolver for unresolved symbols in ORC JIT, improving Clang-Repl’s runtime by making external symbol handling seamless and user-friendly.

## Project Goals

The main goal of my project was to design and implement a new Library-Resolution API for ORC-JIT.
This API acts as a smart symbol resolver — when ORC-JIT encounters an unresolved symbol, it can call this API to find where the symbol exists and which library provides it.

The next step is to integrate this API into ORC-JIT, so that `Clang-Repl` can automatically use it to handle missing symbols without requiring manual library loading.

## Library-Resolution

During my GSoC project, one of the major components I worked on was Library-Resolution — an API we re-designed and re-implemented based on Cling’s original library-resolver.

In simple terms, Library-Resolution acts as a smart library resolver.
It doesn’t actually load libraries — instead, it finds where the missing symbols (unresolved references) can be found and provides their correct library paths.

This makes it a powerful helper when dealing with unresolved symbols during execution.


### How It Works

When system (Orc-JIT or any) encounters an unresolved symbol, system can call the resolver to find symbols that not found.
It scans through user-provided library paths, checks potential matches, and identifies the libraries that contain the missing symbols — all without directly loading them.

At the heart of this system is the `LibraryResolver`, which runs the resolution process by:

1. Scanning available libraries.
2. Filtering symbols efficiently using Bloom filters.
3. Matching unresolved symbols through a `SymbolQuery` tracker.

The result: symbols are mapped to their correct library paths, and system can continue execution seamlessly.


### Core Components Overview

Here’s a quick breakdown of the key components that make Library-Resolution work:

#### 1. LibraryResolver

The main coordinator that controls the entire flow — from scanning libraries to managing symbol lookups.
It ensures that unresolved symbols are systematically matched to libraries.

#### 2. LibraryScanner

Handles the actual scanning of directories and library paths.
It detects valid shared libraries and registers them with the `LibraryManager`.

* **LibraryScanHelper** - Keeps track of directories that need to be scanned.
* **LibrarySearchPath** - Represents a directory and its type (User/System) along with its current scan state.
* **PathResolver** - Normalizes and resolves file paths efficiently.
* **LibraryPathCache** - Stores already-resolved paths and symbolic links to prevent repeated filesystem checks.

#### 3. LibraryManager

Maintains metadata about all discovered libraries.
Each library is represented by a `LibraryInfo` object containing:

* Library path
* Load status (loaded or not)
* A **Bloom filter** for fast symbol existence checks

Here’s a more **blog-friendly, clear, and polished** version of your section, with smoother flow and simpler language while keeping the technical meaning intact.

## Symbol Resolution Flow

So how does symbol resolution actually work? Let’s walk through the process step by step.

1. **Start with unresolved symbols**
   The process begins with a list of unresolved symbols. These are passed to `LibraryResolver::searchSymbolsInLibraries`, where a `SymbolQuery` object is created to track the resolution state.

2. **Scan available libraries**
   The resolver scans both user-defined and system library paths to discover new or previously unregistered libraries that may contain the missing symbols.

3. **Filter symbols**
   As each library is inspected, we filter symbols that are guaranteed to exist. If a library doesn’t already have a Bloom filter, one is created. This filter allows for much faster symbol lookups in future scans.

4. **Match symbols to libraries**
   Each unresolved symbol is checked against the Bloom filters. When a potential match is found, it is verified, and the symbol is linked to the corresponding library path.

5. **Repeat until done**
   This cycle continues until all symbols are resolved or there are no remaining libraries that could provide valid matches.

6. **Complete and return results**
   Once the process finishes, the final resolution results are returned through a completion callback.

## Summary of accomplished tasks

### ExecutorResolver:
[143654](https://github.com/llvm/llvm-project/pull/143654)
suggested by Lang Hames. We introduced a `DylibSymbolResolver` that helps resolve symbols for each loaded dylib.

Previously, we returned a DylibHandle to the controller. Now, we wrap the native handle inside `DylibSymbolResolver` and return a `ResolverHandle` instead. This makes the code cleaner and separates the symbol resolution logic from raw handle management.

with this changes this will help us to integrate LibraryResolver API using some future through new `AutoDylibResolver`.

### Library-Resolver API:
[#165360](https://github.com/llvm/llvm-project/pull/165360)

This is the main API we redesigned based on cling auto library-resolver. this api provide way to user to add search-path and ask for symbols to search and provide resolved library for each symbols.

The goal is to make library discovery and symbol resolution more straightforward, while keeping the design flexible for future improvements.

## What the Library Resolution API Can Do

With these updates, the **Library Resolution API** is now fully operational. It can find missing symbols at runtime and figure out which shared libraries they belong to — without loading those libraries into memory.

The API searches through both system and user-defined paths, looks for unresolved symbols, and pinpoints the exact libraries where those symbols are defined.

Because of this, the API is especially useful for dynamic runtime systems like **ORC-JIT** and **Clang-Repl**, where symbols often need to be resolved on the fly without slowing things down or breaking execution.

Below is a simple example showing how to set up the API and start the resolution process:

{% raw %}
```cpp
llvm::orc::LibraryResolver::Setup S =
    llvm::orc::LibraryResolver::Setup::create({});

// Define a callback that decides whether a library should be scanned
S.ShouldScanCall = [&](llvm::StringRef lib) -> bool { return true; };

// Create the driver that coordinates the resolution
Controller = llvm::orc::LibraryResolutionDriver::create(S);

// Add user and system library paths to be scanned
for (const auto &SP : SearchPaths)
  Controller->addScanPath(SP, llvm::orc::PathType::User);

// Prepare the symbols to be resolved
SmallVector<StringRef> Sym;
Sym.push_back(MangledName);

// Configure resolution policy
llvm::orc::SearchConfig Config;
Config.Policy = {
  {{llvm::orc::LibraryManager::LibState::Queried,  llvm::orc::PathType::User},
   {llvm::orc::LibraryManager::LibState::Unloaded, llvm::orc::PathType::User},
   {llvm::orc::LibraryManager::LibState::Queried,  llvm::orc::PathType::System},
   {llvm::orc::LibraryManager::LibState::Unloaded, llvm::orc::PathType::System}}};

Config.Options.FilterFlags =
    llvm::orc::SymbolEnumeratorOptions::IgnoreUndefined;

// Run the symbol resolution
Controller->resolveSymbols(
    Sym,
    [&](llvm::orc::LibraryResolver::SymbolQuery &Q) {
      if (auto S = Q.getResolvedLib(MangledName))
        Res = *S;
    },
    Config);
```
{% endraw %}

### Other PRs
[166510](https://github.com/llvm/llvm-project/pull/166510)
[166147](https://github.com/llvm/llvm-project/pull/166147)
[169161](https://github.com/llvm/llvm-project/pull/169161)

## Future Work

The next step will be to continue development on the ORC-JIT side, aligned with the ongoing evolution of the Executor layer.
Once the new Executor design stabilizes, we’ll revisit the Library-Resolution API and make any necessary adjustments for compatibility and cleaner integration.
This work will be done under the guidance of Lang Hames, ensuring it fits well within the evolving ORC architecture.

The next phase of this project focuses on integrating the Library-Resolution API into ORC-JIT.
Specifically, we plan to:

* **Introduce the AutoDylibResolver** — based on the groundwork implemented in the *ExecutorResolver* pull request.
  This component will allow ORC-JIT to automatically invoke the Library-Resolution API whenever it encounters an unresolved symbol.

* **Enable automatic library loading** in ORC-JIT.
  Once integrated, ORC-JIT (and tools like `Clang-Repl`) will be able to automatically locate and load the required libraries during runtime — removing the need for users to manually load them.

This next step will complete the feature chain — from symbol detection to automatic library resolution and loading — making `Clang-Repl` more user-friendly.

## Conclusion

With this project, we now have a working Library-Resolver API implemented in ORC-JIT. This is an important step toward making library handling more automatic and reliable at runtime.
The next phase of work will focus on integrating this API more deeply into ORC-JIT. This will allow automatic library loading, which will directly benefit tools like `Clang-Repl` and other projects that rely on ORC-JIT as their execution engine.
This project has been a great learning experience, and I’m excited about the improvements it can bring to the LLVM ecosystem.
Thank you for following along on my GSoC 2025 journey!

## Acknowledgements

I would like to thank Google Summer of Code (GSoC) and LLVM for the opportunity to work on this project. Special thanks to my mentor Vassil Vassilev for his guidance and support, and to Lang Hames for his helpful insights on ORC-JIT and Clang-Repl.


## Related Links

- [LLVM Repository](https://github.com/llvm/llvm-project)
- [Project Description](https://discourse.llvm.org/t/gsoc2025-advanced-symbol-resolution-and-reoptimization-for-clang-repl/84624/3)
- [My GitHub Profile](https://github.com/SahilPatidar)
