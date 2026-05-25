---
title: "Enhance Clang Diagnostics: Making the Compiler Work Harder for You"
layout: post
excerpt: |
  A CppAlliance Fellowship 2026 project to close diagnostic gaps in Clang: C2y standard
  papers, silent semantic changes, clang-tidy upstreaming, and missing warnings that other
  compilers already catch.
sitemap: true
author: Aditya Medhane
permalink: blogs/cppalliance26_aditya_medhane_intro_blog/
thumbnail_image: /images/cppalliance-logo.svg
date: 2026-05-23
tags: [cppalliance, clang, diagnostics, c2y, sema, llvm, compiler-engineering]
---

{% include dual-banner.html
left_logo="/images/cppalliance-logo.svg"
right_logo="/images/cr-logo_old.png"
caption=""
height="20vh" %}

### Introduction

Hello everyone! I'm Aditya Medhane, a Computer Science undergrad at IIIT Gwalior, India. I'm working with the Compiler Research group as part of the **CppAlliance Fellowship 2026** on the project "Enhance Clang Diagnostics."

Compilers have always fascinated me. Not just what they produce, but how they work inside. There's something genuinely interesting about a piece of software that understands other software. The more I dig into it, the more there is to learn, and I think that's what I love most about working in this space. Contributing to a compiler like Clang means working on a tool that millions of developers depend on every day, and even a small improvement in the diagnostics can save someone hours of debugging.

**Mentors**: Vassil Vassilev, Aaron Jomy

---

### Why Diagnostics?

Compilers communicate with us. When something goes wrong in our code, they tell us what happened and where through errors, warnings, notes, and remarks. But there are a surprising number of cases where Clang just stays silent, and that silence causes real bugs that are hard to track down.

Think about this: you write a generic lambda that compares a string to some pointer. It works fine when your vector holds `std::string` objects. Swap the vector to hold `const char*` and that same lambda silently switches from comparing string contents to comparing raw memory addresses. Same code, same lambda, completely different behavior. No warning. No error. Nothing.

These silent failures are exactly what this project aims to fix.

---

### Overview

The project targets five categories of diagnostic gaps:

1. **C2y standard papers** that Clang either hasn't implemented or only partially implemented
2. **Silent semantic changes** where valid code silently does something unintended
3. **Clang-tidy checks** worth pulling into Clang proper so everyone benefits without opt-in
4. **Diagnostic rewording and fix-it hints** where the current message is confusing or missing a suggestion
5. **Missing warnings** for patterns other compilers already catch

Each category has concrete, well-scoped tasks tied to open GitHub issues or gaps in Clang's C status page, so the work is measurable from the start.

Each of these categories deserves a detailed post of its own, and that's exactly the plan. As patches land, I'll write deeper dives into the specific problems, the implementation decisions, and what the review process looked like. Stay tuned for those.

---

### What the Work Looks Like

#### C2y Standards Patches

C2y is the upcoming C standard, and Clang's C status page tracks which proposals are implemented. Two papers are marked incomplete. [N3418](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n3418.pdf) makes creating unicode character names through token pasting a constraint violation, where Clang is currently silent while GCC already diagnoses it. [N3244](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n3244.pdf) has two remaining items around `extern inline` functions and alignment specifier mismatches on redeclarations where Clang's behavior is either missing or incorrect. Fixing these closes two papers and makes Clang more conformant.

#### Silent Semantic Change Detection

This is the flagship deliverable. You can see the problem live on [Godbolt](https://godbolt.org/z/E9Me1djP6). A generic lambda comparing two values behaves correctly when the container holds `std::string`, and silently does the wrong thing when the container holds `const char*`. The comparison flips from a proper string comparison to a raw pointer address comparison, and no compiler in the world warns about it today. The goal is to make Clang the first one that does.

#### Clang-Tidy Upstreaming

Clang-tidy has useful checks that most people never see because they have to opt in. Two of those checks are good candidates to live in Clang proper, where they'd run for everyone. One catches macros that expand to multiple statements used as a bare `if` body, where only the first statement is actually conditional. The other catches raw memory functions like `memset` or `realloc` being called on non-trivial C++ types, which silently bypasses constructors and destructors.

#### Diagnostic Rewording and Missing Warnings

Several open issues are clean and self-contained. One of the most user-facing is a fix-it hint for implicit function declarations. When you call `printf` without including `<stdio.h>`, Clang already knows which header you need. It just doesn't tell you. Another category is patterns that GCC already warns about, like self-initialization (`int x = x;`), where Clang has been silent for over a decade.

---

### Goals

By the end of the fellowship, the aim is to have:

- N3418 and N3244 resolved in Clang's C status page
- A new warning for silent `const char*` pointer comparisons
- Two clang-tidy checks upstreamed into Clang proper
- Several open diagnostic issues closed with rewording or fix-it hints
- Missing warnings added for patterns that other compilers already catch

Every patch will come with regression tests, negative tests to prevent false positives, and compile-time measurements for anything that runs during a normal build.

---

### Related Links

- [Project Listing](https://compiler-research.org/open_projects#enhance-clang-diagnostics)
- [Clang C Status (`c_status.html`)](https://github.com/llvm/llvm-project/blob/main/clang/www/c_status.html)
- [N3418](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n3418.pdf)
- [N3244](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n3244.pdf)
- [My GitHub Profile](https://github.com/flash1729)
