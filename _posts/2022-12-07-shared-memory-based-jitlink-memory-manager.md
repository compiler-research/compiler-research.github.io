---
title: "Shared Memory Based JITLink Memory Manager"
layout: post
excerpt: "LLVM JIT APIs include JITLink, a just-in-time linker that links 
together objects code units directly in memory and executes them. It uses the
JITLinkMemoryManager interface to allocate and manage memory for the generated
code. When the generated code is run in the same process as the linker, memory
is directly allocated using OS APIs. But for code that runs in a separate
executor process, an RPC scheme Executor Process Control (EPC) is used. The
controller process invokes RPCs in the target or executor process to allocate
memory and then when the code is generated, all the section contents are
transferred through finalize calls."
sitemap: false
author: Anubhab Ghosh
permalink: blogs/gsoc22_ghosh_experience_blog/
date: 2022-12-07
tags: gsoc llvm jitlink memory-manager
---

### Overview of the Project

LLVM JIT APIs include JITLink, a just-in-time linker that links together objects
code units directly in memory and executes them. It uses the
JITLinkMemoryManager interface to allocate and manage memory for the generated
code. When the generated code is run in the same process as the linker, memory
is directly allocated using OS APIs. But for code that runs in a separate
executor process, an RPC scheme Executor Process Control (EPC) is used. The
controller process invokes RPCs in the target or executor process to allocate
memory and then when the code is generated, all the section contents are
transferred through finalize calls.

#### Shared Memory

The main problem was that EPC runs on top of file descriptor streams like Unix
pipes or TCP sockets. As all the generated code and data bytes are transferred
over the EPC this has some overhead that could be avoided by using shared
memory. If the two processes share the same physical memory pages then we can
completely avoid extra memory copying.

#### Small code model

While we are at it, another goal was to introduce a simple slab-based memory
manager. It would allocate a large chunk of memory in the beginning from the
executor process and allocate smaller blocks from that entirely at the
controller side. It should significantly reduce RPCs for allocation and at the
same time also satisfy the condition for small code model which requires all
programs to be compiled into a 2 GiB range of address space.

Code compiled for small code model generally has better performance because the
compiler can often use 32 bit signed addresses relative to the program counter
that fit easily in many instructions. Here is an example:

```c
int value = 42;

int main() {
    return value + 1;
}
```

**Small code model**

```asm
0000000000001119 <main>:
    1119: 55                push rbp
    111a: 48 89 e5          mov  rbp,rsp
    111d: 8b 05 ed 2e 00 00 mov  eax,DWORD PTR [rip+0x2eed] # 4010 <value>
    1123: 5d                pop  rbp
    1124: c3                ret
```

**Large code model**

```asm
0000000000001119 <main>:
    1119: 55                    push   rbp
    111a: 48 89 e5              mov    rbp,rsp
    111d: 48 8d 05 f9 ff ff ff  lea    rax,[rip+0xfffffffffffffff9] # 111d <main+0x4>
    1124: 49 bb cb 2e 00 00 00  movabs r11,0x2ecb
    112b: 00 00 00
    112e: 4c 01 d8              add    rax,r11
    1131: 48 ba 28 00 00 00 00  movabs rdx,0x28
    1138: 00 00 00
    113b: 8b 04 10              mov    eax,DWORD PTR [rax+rdx*1]
    113e: 5d                    pop    rbp
    113f: c3                    ret
```

Small code model is the default for most compilations so this is actually
required to load ordinary precompiled code, e.g., from existing static archives.

### My Approach

#### Memory Mappers

I introduced a new `MemoryMapper` abstraction for interacting with OS APIs at
different situations. It has separate implementations based on whether the code
will be executed in the same or different process. The `InProcessMemoryMapper`
directly allocates memory in the same process. The finalize step is almost no-op
for this as the code is already in place and we just need to set the memory
protections.

For shared memory, we needed a new set of RPC functions that are implemented in
`SharedMemoryMapperService` using both  the POSIX and Win32 shared memory APIs.
At allocation it creates a new shared memory file and maps it into its address
space. The file name is returned to the caller. The `SharedMemoryMapper` calls
it and maps the returned file into its own address space at a possibly different
address. Once JITLink has written the code to those mapped addresses, they are
now already in place in the executor processes so finalization is just a matter
of sending the memory protections.

#### Slab-based allocator

Furthermore, I developed a slab-based memory allocator for JITLink, reserving a
large region of memory in the address space of the target process on the first
allocation. All subsequent allocations result in sub-regions of that to be
allocated which are performed entirely on the controller process without RPC
involvement. Furthermore as our all the allocation are from a contiguous memory
region, it also guarantees that JIT’d memory satisfies the layout constraints
required by the small code model.

#### Concurrency problems

After the implmentation, I tried JIT linking the CPython interpreter to
benchmark the implementation. We discovered that our overall CPU execution time
decreased by 45% but somewhat paradoxically clock time increased by 45%. In
other words, we are doing less CPU work but somehow it takes longer.

A quick profiling with [`trace-cmd`](https://www.trace-cmd.org/) showed the
problem. Somehow most of the time we are using only a single thread. It turned
out that without the slab allocator, allocations were asynchronus. When the
result of a allocation RPC was received by the controller process it would
create a new task to handle it that could run parallely. But now we directly
return a sub-region from the already reserved slab so the result is returned on
the same thread. Rest of the linking process depends on these allocations so
they are no longer parallel.

I changed the code to create a new task and run it asynchronusly to get some new
benchmarks. With that we found the actual performance improvement to be close to
4%. However we expect the benefit to be more significant once we start using
this to access memory at runtime.

For a more detailed description and all the patches, please consult my
[GSoC final report](https://compiler-research.org/assets/docs/Anubhab_Ghosh_GSoC2022_Report.pdf).

### Acknowledgements

I would like to share my gratitude for the LLVM community members and my mentors
Stefan Gränitz, Lang Hames, and Vassil Vassilev, who shared their suggestions
during the project development. I hope that this project will find its place in
many applications.

---

### Credits

**Developer:** Anubhab Ghosh (Computer Science and Engineering, Indian Institute
  of Information Technology, Kalyani, India)

**Mentors:** Stefan Gränitz (Freelance Compiler Developer, Berlin, Deutschland),
  Lang Hames (Apple), Vassil Vassilev (Princeton University/CERN)

**Funding:** [Google Summer of Code 2022](https://summerofcode.withgoogle.com/)

---

**Contact me!**

Email: <anubhabghosh.me@gmail.com>

Github Username: [argentite](https://github.com/argentite)

**Link to GSoC project proposal:** [Anubhab_Ghosh_Proposal_GSoC_2022](https://compiler-research.org/assets/docs/Anubhab_Ghosh_Proposal_2022.pdf)

**Link to GSoC project proposal:** [Anubhab_Ghosh_Final_Report_GSoC_2022](https://compiler-research.org/assets/docs/Anubhab_Ghosh_GSoC2022_Report.pdf)
