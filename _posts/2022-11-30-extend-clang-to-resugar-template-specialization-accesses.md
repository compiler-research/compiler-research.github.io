---
title: "Extend Clang to Resugar Template Specialization Accesses"
layout: post
excerpt: "Clang is an LLVM native C/C++/Objective-C compiler, which aims to
 deliver amazingly fast compiles, extremely useful error and warning messages
  and to provide a platform for building great source level tools. The Clang
   Static Analyzer and clang-tidy are tools that automatically find bugs in 
   your code, and are great examples of the sort of tools that can be built 
   using the Clang frontend as a library to parse C/C++ code. When 
   instantiating a template, the template arguments are canonicalized 
   before being substituted into the template pattern. Clang does not 
   preserve type sugar when subsequently accessing members of the instantiation. 
   This leads to many infamous pathological errors which have haunted C++ 
   developers for decades."
sitemap: false
author: Matheus Izvekov
permalink: blogs/gsoc22_izvekov_experience_blog/
date: 2022-11-30
---

### Overview of the Project

Clang is an "LLVM native" C/C++/Objective-C compiler, which aims to deliver
amazingly fast compiles, extremely useful error and warning messages and to
provide a platform for building great source level tools. The Clang Static
Analyzer and clang-tidy are tools that automatically find bugs in your code, and
are great examples of the sort of tools that can be built using the Clang
frontend as a library to parse C/C++ code. When instantiating a template, the
template arguments are canonicalized before being substituted into the template
pattern. Clang does not preserve type sugar when subsequently accessing members
of the instantiation. This leads to many infamous pathological errors which have
haunted C++ developers for decades. For example:

```cpp
#include <string>
#include <vector>

using namespace std;
  size_t test (vector<string> &strings) {
  return strings.begin().length();
}
// clang: error: no member named 'length' in '__gnu_cxx::__normal_iterator<std::basic_string<char> *, std::vector<std::basic_string<char>>>'; did you mean to use '->' instead of '.'?
```

Clang has the
[clang::preferred_name](https://clang.llvm.org/docs/AttributeReference.html#preferred-name)
attribute to improve the situation but with limited success.

### My approach

To further enhance Clang’s expressive error diagnostics system, I implemented an
eager approach to syntactic resugaring in Clang. The novel approach does not
require introduction of new nodes to the Abstract Syntax Tree (AST).  During the
early stage of development I focused on getting the overall design for the
needed transform, testing, and validating effects against member-type access to
class template specializations.  The initial transform was already implemented
in the Clang AST for representing type substitution, and needed to keep track of
the templated context. This approach resulted in limitations of the AST,
therefore I developed a transform that directly look up an argument from the
naming context, without the need of tracking the template context. This
approach, although more efficient, required some intrusive modifications on the
way substitutions are represented in the AST.


### Contributions

The main contributions to this project are listed here.

[Project repository](https://github.com/mizvekov/llvm-project/tree/resugar)

Pull Requests:

1. [D112374 - Implement ElaboratedType sugaring for types written bare](https://reviews.llvm.org/D112374)
2. [D131802 - Fix missing initialization of original number of expansions](https://reviews.llvm.org/D131802)
3. [D128113 - Fix AST representation of expanded template arguments](https://reviews.llvm.org/D128113)
4. [D111283 - Template / auto deduction deduces common sugar](https://reviews.llvm.org/D111283)
5. [D111509 - Use getCommonSugar in an assortment of places](https://reviews.llvm.org/D111509)
6. [D130308 - Extend getCommonSugaredType to merge sugar nodes](https://reviews.llvm.org/D130308)
7. [D131858 - Track the templated entity in type substitution](https://reviews.llvm.org/D131858)
8. [D127695 - Implement Template Specialization Resugaring](https://reviews.llvm.org/D127695)


### Contributions

1. Syntactic resugar of Non Type Template Parameters (NTTPs) is still under
development. When checking template arguments, we perform substitutions on NTTPs
that reference another template parameter. In this case, the instantiation is
not owned by any specialization declaration. These substitutions can be
performed using non-canonical arguments, but they require a higher degree of
competence compared to using non-canonical arguments in the MLTAL. The same
applies to alias templates and concepts.

2. Real world C++ components, especially Standard Template Libraries (STL), are
often complex to the point that the sugar preservation process leads to
optimization of the code only if it is able to perform across a big chain of
different scenarios, with failure in any of them affecting the whole
system. This issue often prevents successful resugaring in C++. Improving the
type rules for syntactic sugar in STL will reduce the generation of errors in
terms of desugared code, improving the relationship between the user's source
program and the program evaluation.


### Acknowledgements

I thank my mentors Richard Smith and Vassil Vasilev for their excellent
support, their welcoming behavior motivated me and gave me the opportunity to
increase my confidence as a developer in the LLVM open community!

---

### Credits

**Developer:** Matheus Izvekov

**Mentors:** Richard Smith (Google), Vassil Vassilev (Princeton University/CERN)

**Funding:** [Google Summer of Code 2022](https://summerofcode.withgoogle.com/)

---

**Contact me!**

Email: mizvekov@gmail.com

Github Username: [mizvekov](https://github.com/mizvekov)

**Link GSoC project proposal:** [Matheus_Izvekov_Proposal_2022](https://compiler-research.org/assets/docs/Matheus_Izvekov_Proposal_2022.pdf)
