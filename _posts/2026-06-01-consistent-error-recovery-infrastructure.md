---
title: "Improving Clang Error Recovery for Interactive Workflows: Early Findings"
layout: post
excerpt: |
  As part of the CppAlliance Fellowship 2026, this project explores improvements to Clang’s error recovery infrastructure for interactive environments such as Clang-Repl, with the goal of providing more reliable recovery and better compiler state consistency after failed inputs.
sitemap: true
author: Sahil Patidar
permalink: blogs/cppalliance26_sahil_patidar_intro_blog/
thumbnail_image: /images/cppalliance-logo.svg
date: 2026-06-01
tags: [cppalliance, clang, error-recovery, clang-repl, interactive-compilation]
---

{% include dual-banner.html
left_logo="/images/cppalliance-logo.svg"
right_logo="/images/cr-logo_old.png"
caption=""
height="20vh" %}

## Introduction

I am Sahil Patidar. As part of the **CppAlliance Fellowship 2026**, I am working on the **Consistent Error Recovery Infrastructure** project.

In this project, I have been exploring how Clang handles errors in interactive environments such as Clang-Repl. During this work, We came across several issues related to rollback, error recovery, and compiler state management. This post shares some of those findings and the challenges involved in improving error recovery for interactive compilation.

Mentors: Vassil Vassilev, Aaron Jomy

---

## Project Description
This project aims to improve Clang’s error recovery infrastructure for interactive systems such as Clang-Repl and other tools built on top of Clang’s frontend.

Clang is primarily designed for traditional batch compilation, where a translation unit is compiled once from start to finish. Interactive systems work differently: they accept multiple inputs over time, and a failed input should not affect future inputs. Users expect the compiler to remain stable and continue working correctly after an error.

While Clang already provides robust error recovery for normal compilation, some recovery paths do not work well in incremental compilation scenarios. Failed inputs can sometimes leave semantic state behind and influence future analysis, which can affect the reliability of interactive workflows.

The goal of this project is to improve and extend Clang’s error recovery infrastructure so that interactive tools can recover from failed inputs more reliably, avoid polluting compiler state, and remain stable after errors, while preserving Clang’s existing behavior and compiler invariants.

---

## Why This Project Matters

Building an interactive C++ environment is much more challenging than traditional compilation. In a normal compiler workflow, the entire program is compiled once from start to finish. In a REPL (Read-Eval-Print Loop), however, code is entered incrementally, modified frequently, and sometimes rolled back using commands such as %undo.

For users, the expectation is simple: a failed input should not affect future inputs. The compiler should recover cleanly and remain in a consistent state. In practice, achieving this is difficult because the compiler must carefully manage parser state, semantic analysis, and AST structures across multiple independent inputs.

While exploring Clang-Repl, we encountered several issues related to semantic state recovery, and handling of invalid declarations. These examples highlight some of the challenges that motivated this project.

⸻

### Case Study 1: Undo Does Not Fully Remove Template Specializations

One issue appears when undoing template specializations.

Example
```cpp
Clang-Repl> template <class T> struct S2 {};
Clang-Repl> template <> struct S2<int> {};
Clang-Repl> template <> struct S2<int> { int val = 32; };
// error: redefinition of 'S2<int>'
Clang-Repl> %undo
Clang-Repl> template <> struct S2<int> { int val = 32; };
// still gives redefinition error
```
What Happens?

The cleanup logic in `IncrementalParser::CleanUpPTU` removes declarations from lookup structures such as DeclContext and IdResolver. However, it does not fully remove all template-related information.

Some important template state is still left behind:

* The specialization remains stored in `ClassTemplateDecl::Specializations`.
* Its canonical declaration still remains in the AST.

Later, when a new specialization with the same definition is written, Sema checks the existing specializations using `findSpecialization`.

Since the old specialization is still present in the template’s specialization list, Sema finds it and treats the new declaration as a duplicate. As a result, it reports a redefinition error.

Why It Matters

This behavior causes several problems in interactive workflows:

* `%undo` does not fully restore the previous state.
* Old declarations continue to affect future inputs.
* Valid code may fail unexpectedly.

⸻

### Case Study 2: Parser Recovery on Incomplete Functions

Another issue appears when the user enters incomplete code.

Example
```cpp
Clang-Repl> void foo() {
```
What Happens?

Instead of waiting for additional input, the parser repeatedly reports errors such as:
```cpp
error: expected expression
```
Eventually the session ends with:
```cpp
fatal error: too many errors emitted
```
The REPL fails to recover from the incomplete input.

Comparison with Cling

Cling handles this situation differently. When a function body is incomplete, it waits for more input instead of immediately producing a stream of parser errors.

Why the Parser Repeats the Same Error?

When the parser encounters `{`, it enters the function body and begins parsing statements using the following loop:
```cpp
while (... Tok.isNot(tok::r_brace) && Tok.isNot(tok::eof)) {
  ...
  R = ParseStatementOrDeclaration(...);
}
```
After encountering `{`, the parser enters the function body and repeatedly calls `ParseStatementOrDeclaration()` until it finds a closing `}` or reaches the end of the file.

With incomplete input, no valid statements can be parsed and no closing `}` is found. Parsing fails, but no tokens are consumed, so the parser remains at the same position.

As a result, the loop keeps running, repeatedly calling `ParseStatementOrDeclaration()` on the same token and emitting the same error message.

The root cause is that the loop does not check whether parsing made any progress. When parsing fails without consuming tokens, there is no condition to break out of the loop.

Why It Matters

This leads to:

* Repeated and noisy error messages.
* Poor interactive user experience.
* Reduced stability for subsequent inputs.

⸻

### Case Study 3: Invalid Template Definitions Affect Future Inputs

A third issue occurs when a template specialization contains a compilation error.

Example
```cpp
Clang-Repl> template <class T> struct S2 {};
Clang-Repl> template <> struct S2<int> { int val =; };
// error: expected expression
Clang-Repl> template <> struct S2<int> { int val = 32; };
// error: redefinition of 'S2<int>'
```
What Happens?

Although the first specialization is invalid, Clang still records it internally as an existing specialization. When the user later provides a correct definition, it is rejected as a redefinition.

In other words, a failed declaration continues to influence future inputs even though compilation never succeeded.

Comparison with Cling

In normal interactive mode, Cling rolls back the invalid specialization and discards it. As a result, the later valid definition is accepted.

Additional Challenge: Combined Inputs

A related issue appears when multiple statements are processed as a single input transaction. In this scenario, even Cling/ROOT exhibits similar behavior.

```cpp
root [0] template <class T> struct S2 {};
root [1] template <> struct S2<int> { int v = ; }; \
root (cont ed, cancel with .@) [1]template <> struct S2<int> { int v = 32; };
ROOT_prompt_1:1:38: error: expected expression
template <> struct S2<int> { int v = ; }; \
                                     ^
ROOT_prompt_1:2:20: error: redefinition of 'S2<int>'
template <> struct S2<int> { int v = 32; };
                   ^~~~~~~
ROOT_prompt_1:1:20: note: previous definition is here
template <> struct S2<int> { int v = ; }; \
```

In this case, both specializations are compiled as part of the same transaction. Since rollback occurs only after compilation of the entire input completes, the invalid specialization remains visible while processing the second definition, resulting in a redefinition error.

Why It Matters

This behavior makes interactive development more difficult because:

* Invalid code affects later inputs.
* Users cannot easily correct mistakes incrementally.
* REPL behavior changes depending on how inputs are grouped.
* Recovery from template-related errors becomes unintuitive.

---

## What We Learned During Investigation

While investigating these issues, I found that the observed behavior is actually consistent with Clang’s current design, even though it is not ideal for an interactive environment such as Clang-Repl.

Consider the following example:
```cpp
template <class T> struct S1 {};
template <>
struct S1<int> {
  int val =;
};
template <>
struct S1<int> {
  int val = 32;
};
```
This produces:
```cpp
error: redefinition of 'S1<int>'
```
At first, this looked like an error recovery problem. However, after tracing the implementation, it became clear that Clang is behaving as expected according to its normal compilation model.

The specialization declaration is created successfully and added to Clang’s semantic state before the initializer error is diagnosed. Later, when the second specialization is encountered, Clang naturally treats it as a redefinition.

While following the code path, I also noticed that the specialization begins to be treated as a definition through `Specialization->startDefinition()` before the entire class body has been processed. If parsing fails later, some definition-related state may already have been recorded and can influence future declarations.

This led to an important realization: the problem is not simply that an invalid declaration exists. The bigger issue is that a failed incremental submission can continue to participate in future semantic analysis.

For normal compilation, this behavior is reasonable because Clang is designed around a semantic state that continuously grows throughout compilation. In a REPL, however, users usually expect a failed input not to affect future attempts.

Another important constraint is that any solution must preserve Clang’s existing behavior. The redefinition diagnostic above is correct according to Clang’s current rules and should continue to behave the same way during normal compilation.

**Looking at Possible Directions**

During the investigation, I also looked at Cling’s declaration unloading mechanism. Cling handles similar problems by updating lookup structures and semantic state after failures. While this works well for Cling, it relies on modifying data structures that Clang generally expects to remain stable, making the same approach difficult to apply directly.

One possible direction is to control whether declarations from failed submissions participate in lookup, redeclaration checks, and other semantic operations, instead of removing them completely. This could allow interactive environments to treat failed inputs differently without modifying the AST itself.

However, lookup is only part of the problem. By the time an error is diagnosed, information may already have been recorded in redeclaration chains, specialization sets, or definition state. Because of this, filtering declarations from lookup alone may not be enough.

Filtering vs Rollback

“Removing” a declaration does not mean removing it from memory. Clang mostly uses bump allocation, so AST nodes typically remain allocated for the lifetime of the compilation. In practice, removal usually means preventing a declaration from participating in semantic operations such as lookup and redeclaration checks.

At this stage, it is still unclear whether rollback, filtering, delayed registration, or some combination of these approaches is the right solution.

What became clear during this investigation is that the larger challenge is deciding how failed incremental submissions should interact with Clang’s semantic state while preserving the behavior and invariants that Clang already relies on.

This leads to the central question for the project:

When should declarations from a failed interactive submission become visible to future semantic analysis, and how can that be controlled without breaking Clang’s existing behavior?

---

## Where This Leads

What started as a simple redefinition error turned out to be a much deeper question about how Clang manages semantic state.

The investigation showed that the behavior is not really a bug in Clang’s normal compilation model. Instead, it exposes a mismatch between the expectations of interactive environments and the assumptions built into a traditional compiler.

The next step is to understand where that gap should be addressed. Whether the answer involves rollback, filtering, delayed registration, or something else entirely is still an open question, but the investigation has already provided a clearer picture of the problem space.

---

## Related Links

- [LLVM Repository](https://github.com/llvm/llvm-project)
- [Project Description](https://compiler-research.org/open_projects#consistent-error-recovery-infrastructure)
- [My GitHub Profile](https://github.com/SahilPatidar)

---