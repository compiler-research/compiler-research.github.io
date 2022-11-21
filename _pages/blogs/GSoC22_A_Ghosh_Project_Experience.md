---
title: "GSoC 2022 Experience of Anubhab Ghosh"
layout: gridlay
excerpt: "GSoC 2022 Experience of Anubhab Ghosh"
sitemap: false
permalink: blogs/gsoc22_ghosh_experience_blog/
---

# Shared Memory Based JITLink Memory Manager

**Developer:** Anubhab Ghosh (Computer Science and Engineering, Indian Institute
  of Information Technology, Kalyani, India)

**Mentors:** Stefan Gränitz (Freelance Compiler Developer, Berlin, Deutschland),
  Lang Hames (Apple), Vassil Vassilev (Princeton University/CERN)

**Funding:** [Google Summer of Code 2022](https://summerofcode.withgoogle.com/)

---

**Contact me!**

Email: anubhabghosh.me@gmail.com

Github Username: [argentite](https://github.com/argentite)

**Link to my GSoC project proposal:** [Anubhab_Ghosh_Proposal_GSoC_2022](https://compiler-research.org/assets/docs/Anubhab_Ghosh_Proposal_2022.pdf)

**Link to my GSoC project proposal:** [Anubhab_Ghosh_Final_Report_GSoC_2022](https://compiler-research.org/assets/docs/Anubhab_Ghosh_GSoC2022_Report.pdf)

---


## Overview of the Project

LLVM JITLink uses the JITLinkMemoryManager interface to allocate and manage
memory for the generated code. When the generated code is run in the same
process as the linker, memory is directly allocated using OS APIs. For code that
is run in a separate executor process, an RPC scheme ExecutorProcessControl
(EPC) is used to control it over streams like Unix pipes or TCP sockets. In this
case, all the generated code and data bytes are transferred over the EPC.

## My Approach

1. I introduced a new JITLinkMemoryManager based on a MemoryMapper abstraction
that is capable of allocating JIT’d code (and data) using shared memory. It may
provide faster transport (and access) for code and data when running JIT’d code
in a separate process on the same machine.
2. Furthermore, I developed a slab-based memory allocator for JITLink, reserving
a large region of memory in the address space of the target process on the first
allocation. All subsequent allocations result in sub-regions of that to be
allocated which are performed entirely on the linker side without RPC
overhead. Finalizations and deallocations are also batched to minimize RPC
involvement. Allocation from a contiguous memory region also guarantees that
JIT’d memory satisfies the layout constraints required by the small code model
which is default for most compiled code. The new allocator thus enables ORC to
load ordinary precompiled code, e.g., from existing static archives.  The shared
memory implementation and its performance improvements for most use cases of
JITLink. I demonstrated the benefits of a separate executor process on top of
the same underlying physical memory. Results will contribute to the improvement
of larger projects, such as Clang-Repl and Cling.


For a more detailed description of my results, and list of pull requests, please
consult my [GSoC final report](https://compiler-research.org/assets/docs/Anubhab_Ghosh_GSoC2022_Report.pdf).


## Acknowledgements

I would like to share my gratitude for the LLVM community members and my mentors
Stefan Gränitz, Lang Hames, and Vassil Vassilev, who shared their suggestions
during the project development. I hope that this project will find its place in
many applications.
