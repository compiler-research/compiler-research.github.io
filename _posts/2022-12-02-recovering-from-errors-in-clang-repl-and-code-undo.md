---
title: "Recovering from Errors in Clang-Repl and Code Undo"
layout: post
excerpt: "Incremental C++ enables exploratory programming by considering the 
translation unit to be an ever-growing entity. This allows implementation of 
interpreter-like tools such as Cling and Clang-Repl, which consume C++ code 
piece by piece and use the JIT infrastructure to run each piecewise.  One of 
the challenges of Incremental C++ is the reliable recovery from errors which 
allows the session to continue after faulty user code. Supporting reliable 
error recovery requires splitting the translation unit into a sequence of 
Partial Translation Units (PTUs). Each declaration is associated with a 
unique PTU that owns it. Owning PTU isn’t always the “active” (most recent) 
PTU and it isn’t always the PTU that the declaration comes from. Even a new 
declaration that isn’t a declaration or or specialization of anything 
belongs to the active PTU. However, in case of a template specialization, 
it can be pulled into a more recent PTU by its template arguments."
sitemap: false
author: 
- Jun Zhang
- Purva Chaudhari
permalink: blogs/gsoc22_zhang_chaudhari_experience_blog/
date: 2022-12-02
tags: gsoc clang llvm
---

### Overview of the Project

Incremental C++ enables exploratory programming by considering the translation
unit to be an ever-growing entity. This allows implementation of
interpreter-like tools such as Cling and Clang-Repl, which consume C++ code
piece by piece and use the JIT infrastructure to run each piecewise.  One of the
challenges of Incremental C++ is the reliable recovery from errors which allows
the session to continue after faulty user code.

Supporting reliable error recovery requires splitting the translation unit into
a sequence of Partial Translation Units (PTUs). Each declaration is associated
with a unique PTU that owns it. Owning PTU isn’t always the “active” (most
recent) PTU and it isn’t always the PTU that the declaration “comes from". Even
a new declaration that isn’t a declaration or or specialization of anything
belongs to the active PTU. However, in case of a template specialization, it can
be pulled into a more recent PTU by its template arguments. Additionally,
processing a PTU might extend an earlier PTU.  Rolling back the later PTU does
not throw that extension away. Most declarations/definitions will only refer to
entities from the same or earlier PTUs.  Clang-Repl recovers from errors by
disconnecting the most recent PTU and updating the primary PTU lookup tables.

The work on error recovery in clang repl is directed in making the Clang-Repl
tool more robust to encountered errors. For example :

```cpp
clang-repl> template<class T> T f() { return T(); }
clang-repl> auto ptu2 = f<float>(); err;
In file included from <<< inputs >>>:1:
input_line_1:1:25: error: C++ requires a type specifier for all declarations
auto ptu2 = f<float>(); err;
                        ^
clang-repl: /home/purva/llvm-project/clang/include/clang/Sema/Sema.h:9406: clang::Sema::GlobalEagerInstantiationScope::~GlobalEagerInstantiationScope(): Assertion `S.PendingInstantiations.empty() && "PendingInstantiations should be empty before it is discarded."' failed.
Aborted
 (core dumped)
```

and

```cpp
clang-repl> template<class T> T f() { return T(); }
clang-repl> auto ptu2 = f<float>(); err;
In file included from <<< inputs >>>:1:
input_line_1:1:25: error: C++ requires a type specifier for all declarations
auto ptu2 = f<float>(); err;
                        ^
clang-repl: /home/purva/llvm-project/clang/include/clang/Sema/Sema.h:9406: clang::Sema::GlobalEagerInstantiationScope::~GlobalEagerInstantiationScope(): Assertion `S.PendingInstantiations.empty() && "PendingInstantiations should be empty before it is discarded."' failed.
Aborted
 (core dumped)
clang-repl> int x = 42;
clang-repl> %undo
clang-repl> float x = 24 // not an error
```

### Contributions

The main contributions to this project are listed here.

Pull Requests:

1. [D123674 - Clang-Repl Error Recovery Bug Fix](https://reviews.llvm.org/D123674)
2. [D125946 - Handles failing driver tests of Clang](https://reviews.llvm.org/D125946)
3. [D125944 - Template instantiation error recovery](https://reviews.llvm.org/D125944)
4. [D126682 - Implement code undo](https://reviews.llvm.org/D126682)
5. [D127991 - Remove memory leak of ASTContext/TargetMachine](https://reviews.llvm.org/D127991)
6. [D126781 - Keep track info of lazy-emitted symbols in ModuleBuilder](https://reviews.llvm.org/D126781)
7. [D128782 - Keep track of decls that were deferred and have been emitted](https://reviews.llvm.org/D128782)
8. [D130420 - Consider MangleCtx when move lazy emission States](https://reviews.llvm.org/D130420)
9. [D130422 - Fix incorrect return code](https://reviews.llvm.org/D130422)
10. [D131241 - Extend HeaderSearch::LookupFile to control OpenFile behavior](https://reviews.llvm.org/D131241)
11. [D130831 - Track DeferredDecls that have been emitted](https://reviews.llvm.org/D130831)
12. [Code gen passing](https://gist.github.com/Purva-Chaudhari/1555b887618cec569b638e96056d9679)

### Results

1. We implemented the initial code undo for Clang-Repl, the patch we submitted
extends the functionality used to recover from errors and adds functionality to
recover the low-level execution infrastructure. Now you can do below in
clang-repl:

```cpp
clang-repl> int x = 42;
clang-repl> %undo
clang-repl> float x = 24; // not an error
```

2. We fixed a bunch of bugs in Clang-Repl, by upstreamed ready-made patches in
cling: Fix inline function in Clang-Repl. Take the example below:

```cpp
inline int foo() { return 42; }
int r3 = foo(); // This fails before my fix.
```

More context: [cd64a427](https://github.com/llvm/llvm-project/commit/cd64a427efa0baaf1bb7ae624d4301908afc07f7)
3. Partially fix incorrect return code in Clang-Repl. Take the example below:

```cpp
clang-repl> BOOM!
clang-repl> int x = 42;
// This previously passed in the LLVM lit tests incorrectly
```

4. Partially fix weak attribute usage in Clang-Repl. Take the example below:

```cpp
int __attribute__((weak)) bar() { return 42; }
auto r4 = printf("bar() = %d\n", bar()); // This fails before my patch. Note this is not supported in Windows yet.
```

5. We fixed some issues in lambda usage in Clang-Repl.

### Conclusion

During this summer, I not only improved my technical skills but also enhanced my ability to work with others and
appreciate the charm of open source. I would like to thank all the people who helped me, especially my mentor Vassil,
who is not only an experienced programmer but also a respected life teacher. I'm also pretty happy working with my
partner Purva, who made a great effort when preparing our LLVM Dev lightning talk this year.

In the future, I'll continue my journey into the world of open source, and bring the code and love to all!

---

### Credits

**Developers:** Jun Zhang (Software Engineering, Anhui Normal University, WuHu,
  China) and Purva Chaudhari (California State University Northridge, Northridge
  CA, USA)

**Mentor:** Vassil Vassilev (Princeton University/CERN)

---

**Contact us!**

Jun: jun@junz.org

GitHub username: [junaire](https://github.com/junaire)

Purva: [Webpage](https://purva-chaudhari.github.io/My-Portfolio/)

GitHub username: [Purva-Chaudhari](https://github.com/Purva-Chaudhari)
