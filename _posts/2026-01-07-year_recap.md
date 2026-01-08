---
title: "2025 Year-End Reflections: CompilerResearch Group (Personal Perspective)"
layout: post
excerpt: |
  A personal look at 2025: we moved from prototypes to infrastructure people can
  run on real code: shipping Clad; maturing CppInterOp; and growing a community.
  This recap focuses on the engineering, mentorship, and cross-domain impact
  that made that shift possible.
sitemap: true
author: Vassil Vassilev
permalink: blogs/cr25_recap/
banner_image: /images/blog/vv-2025-recap.webp
date: 2026-01-07
tags: [2025, recap, year-in-review, compiler-research, open-source, community]
---

If 2024 was the year we sketched the map, 2025 was the year we started paving
roads on it: not always smoothly, but in places where people actually needed to
walk. We deliberately shifted from "research prototypes" to "infrastructure
people can try on real code": releases you can install, tape designs that
survive long runs, device-side building blocks for gradients, and interactive
C++ that you can step through in a notebook. That shift was the story of the
year: technical grit plus mentorship, repeated many times over.

The year did not feel dramatic while we were living it. There was no single
breakthrough moment, no clean narrative arc. Instead, there were releases that
almost worked, benchmarks that failed for reasons we didn’t yet understand, and
long stretches where progress looked like deleting code rather than adding it.

And yet, by the end of the year, something had shifted. People were no longer
asking *“can this work?”*, they were asking *“how do I use this?”* That quiet
transition from possibility to expectation defined 2025 for
compiler-research.org.

---

## Differentiable Programming

Clad had been a compelling idea for years: automatic differentiation implemented
*by the compiler itself*, operating directly on C++ ASTs rather than via
operator overloading or purely runtime tapes. The more features we
added the more we saw the benefits of an compiler-based AD system being a first
class citizen in static languages.

Our integration efforts demonstrated significant speedups of various physics
workflows based on the RooFit system -- up to 10x faster likelihood evaluation
which sped up people's workflows without them changing a single line of
code[\[0\]][ref0]!

### From promising ideas to software that breaks loudly

In 2025 we finally had to pay the cost of our ambitious plan. Putting Clad into
the hands of users forced us to confront problems we had been politely ignoring:
tape memory pressure, allocation churn, subtle thread-safety interactions with
OpenMP, multi-platform packaging, and a hundred ways in which generated code can
be correct in theory and brittle in practice. The striking lesson of the year
was that *theory is cheap; engineering is expensive*.

So we did the expensive work. Aditi Milind Joshi rethought the tape. Together
with Parth Aurora they introduced layered (slab) allocation and small-buffer
optimizations so that tiny computations stay stack-local while larger workloads
spill into contiguous heap slabs -- lowering allocation overhead and improving
cache utilization for the backward pass[\[1\]][ref1]. Petro Zarytskyi reworked
scheduling so reverse passes do less redundant work and produce smaller, more
stable adjoint code[\[2\]][ref2]. Galin Bistrev worked on the adoption of
automatic differentiation in CMS Combine[\[11\]][ref11]. Those are boring
sentences on a page, however, they make the difference between a demo and a run
that works efficiently on a real dataset.


### GPU differentiation: turning challenges into progress

CPU reverse-mode felt like careful negotiation; GPU reverse-mode was an
opportunity to learn and improve.

The work of Christina Koutsou and Abdelrhman Elrawy enabled users to write
high-level device code (Thrust, device vectors) while still computing
gradients. This meant implementing custom pullbacks for many Thrust
primitives—reduce, transform, scan, inner_product—and validating them with heavy
benchmarks like RSBench and LULESH. Along the way, subtle behaviors emerged:
data races, memory aliasing, and tricky index assumptions[\[3\]][ref3].  Maksym
Andriichuk implemented a set of analyses that help reducing the conservative
atomic synchronization points making the CUDA generated code more
optimal[\[4\]][ref4].

Far from setbacks, these discoveries guided our roadmap. We added thread-safety
checks for injective index patterns, deterministic memory policies for device
allocations, and a verified catalog of Thrust pullbacks. The result? GPU
differentiation moved from a research goal to practical, reliable functionality.


### Cladtorch & compiler-driven ML: where compilers and ML talk seriously

Rohan Timmaraju led one of the year's more provocative efforts was to see
whether compiler-driven AD in C++ could be a practical path for training
medium-sized networks[\[5\]][ref5].

The early versions were elegant but slow. Abstractions (temporary objects, RAII,
high-level tensor wrappers) were doing what abstractions always do: hiding costs
that matter at tight loops. The experiment that changed things pivoted to a
simple truth: if the compiler can see everything and the data layout is optimal,
it can produce lower-overhead code than a heavy Python runtime.

Concretely, that meant moving from an object-oriented C++ tensor library to a
minimalist, arena-style engine: a single, contiguous pre-allocated buffer that
held parameters, activations, and gradients. That design removed most of the
allocation and context-switching overhead and gave the compiler a global
allocation layout to optimize. In CPU-bound tests the arena-based approach
reduced overhead and produced iteration speeds competitive with tuned Python
stacks on some workloads [\[4\]][ref4]. The result was not "we beat PyTorch
everywhere" but it was a concrete demonstration that compile-time AD has real
leverage when memory layout and kernel fusion are designed for it. Next in the
plan is porting that work from CPU to GPU.

That experience taught us how to think about co-design: compiler optimizations
plus memory layout plus tight kernels. The lesson will inform both our ML
experiments and how we approach HPC workloads going forward.

---


## Compiler as a service: the tooling that makes C++ alive

A quiet but consequential part of 2025 enhancing interactive C++. Clang-Repl
continued to evolve in a stable and predictable manner.

### Xeus

Anutosh Bhat pushed browser-side experiments in xeus-cpp using a Wasm
incremental executor approach (compile small units to standalone Wasm modules
and link at runtime) so that C++ REPL sessions can run without a
server[\[5\]][ref5].That made classroom demos and quick experiments far more
accessible.

At the same time, Abhinav Kumar implemented LLDB/DAP integration for the
notebook/Jupyter flow so people can set breakpoints, step through generated
code, and inspect variables. The change is subtle: once users can *debug*
generated code, they stop treating it as magic and start contributing
fixes[\[6\]][ref6].


### CppInterOp

CppInterOp matured to a point where it became a backbone of C++ interoperability
in the newly developed jank-lang[\[7\]][ref7]. The jank-lang author Jeaye
Wilkerson collaborated with our team and donated to sponsor some of our
developments.

Aaron Jomy led the integration of the library in the ROOT framework while Vipul
Cariappa led its integration within the cppyy ecosystem.

Sahil Patidar quietly and persistently shaped the supporting LLVM and Clang
infrastructure and committed downstream code to the LLVM mainline.

Matthew Barton kept our infrastructure sane and reduced the CI noise to minimum
this year which greatly helped our overall development.

---


## Cross-disciplinary work: where system engineering matters

In 2025, we deliberately expanded our cross-domain engagement. Our goal was to
understand where our technologies could have impact beyond their original
context and to invest in making them usable in those settings. One of the most
rewarding outcomes was seeing our tools not just support, but improve if not
reshape, domain-specific workflows.

- **Genomics (RAMTools):** Aditya Pandey adapted RNTuple-style columnar storage
    concepts from high-energy physics to genomic alignment queries. The result
    was measurable speedups for several analytic workloads and, in some cases,
    reduced storage overhead. What began as a student project now highlights
    practical data-engineering synergies between HEP and genomics[\[8\]][ref8].

- **Cancer simulation (CARTopiaX):** Salvador de la Torre Gonzalez developed an
    agent-based CAR-T simulator on top of BioDynaMo, using our tooling to
    accelerate simulations and improve experimental reproducibility. While
    modest in scope, this work represents a concrete step toward tissue-aware
    digital twins for preclinical research[\[9\]][ref9].

- **Disaster response (NEO-FLOOD):** Rohan Timmaraju applied compiler and
    systems thinking contributed to a NASA-recognized project that demonstrates
    low-power, on-satellite inference pipelines using neuromorphic processors
    for rapid flood mapping, showing how our work can touch mission-critical
    applications when integrated properly[\[10\]][ref10].

None of these efforts were accidental. They emerged from sustained collaboration
between domain scientists and systems engineers—and from a shared confidence in
the tools we build.

---

## Broader impact

In 2025, we continued to do what we do best: establish collaborations, surface
domain pain points, and educate users. This year, however, the emphasis shifted
toward persistence and deeper synergy across those collaborations.

### The people — mentor, ship, repeat

One of the clearest signals that we are doing something right is watching people
grow into the work. In 2025 we saw contributors arrive cautiously fixing a small
bug, asking careful questions, and leave the year owning real subsystems. For
many of them, this was not just another open-source contribution. It became
something concrete they could point to: a body of work that shaped interviews,
graduate school applications, and their own sense of what they were capable of
building.

That kind of growth does not happen by accident. It only happens when mentorship
is present, patient, and deeply technical.

Jonas Rembser's steady guidance, both mathematical and practical, was
essential in helping us confront the hardest performance questions in the
RooFit-driven Clad use cases. When things became subtle or ambiguous, Jonas
helped anchor discussions in first principles without losing sight of real
constraints.

Harshitha Menon brought a calm, scientific clarity to our benchmarking and
workflow analysis. Her ability to methodically dissect performance behavior and
suggest meaningful optimizations helped turn noisy measurements into actionable
improvements.

Luciana Melina Luque's deep understanding of agent-based modeling and CAR-T cell
therapy shaped the CARTopiaX work in ways we could not have faked. Her domain
expertise ensured that the simulations we built were not just faster, but
scientifically grounded.

Martin Vassilev played a key role in shaping RAMTools, helping bridge ideas from
high-energy physics data handling into a genomics context that demanded both
rigor and pragmatism.

Vipul Cariappa and Anutosh Bhat brought consistency and hard-won knowledge of
low-level tooling to the xeus-cpp debugging infrastructure. Their work quietly
but decisively raised the bar for what interactive C++ debugging can feel like
in practice.

Parth Arora's deep command of data structures and algorithms made a tangible
difference in the tape infrastructure. His contributions helped us simplify,
tighten, and reason about some of the most performance-critical paths in the
system.

Looking back, it is clear that the year's technical progress is inseparable from
these human investments. Code shipped because people were supported. Systems
matured because knowledge was shared. And the next generation of contributors
emerged not by being shielded from complexity, but by being trusted with it.

That cycle is the mechanism by which this work continues to exist.


### Community and leadership

In 2025, our engagement with the broader community became more intentional. We
did not just report progress: we used workshops and meetings as places to test
ideas in public, invite criticism, and ground our research in real use cases.

We shared work across several established venues. CARTopiaX and
CppInterOp-powered cppyy were presented at the ROOT Users Workshop, where
discussions with ROOT developers and users directly shaped follow-up
work. CARTopiaX was also presented at the Foundations of Oncological Digital
Twins workshop in Cambridge, where clinical and modeling perspectives helped us
sharpen both the technical assumptions and the scientific framing. Our progress
on automatic differentiation and CUDA was presented at MODE 2025, alongside
updates on RooFit autodiff work that were also discussed at CMS CAT
meetings. These venues were particularly valuable because they exposed our
compiler-centric ideas to domain experts who are quick to ask the hard,
practical questions.

Beyond participating, we also stepped into a convening role. This year we
organized the first edition of CompilerResearchCon, a small, focused conference
designed to bring together contributors, users, and curious newcomers.
[CompilerResearchCon](/crcon2025/) became a focal point for the project. Its
success confirmed something we suspected that our community benefits most from
formats that are compact, technical, and conversation-driven.

We were also honored to organize the
[EuroAD](https://indico.cern.ch/e/EuroAD-2025) workshop, which brought together
researchers working on automatic differentiation from compiler, ML, and
scientific computing perspectives. There, we presented our work on
differentiating object-oriented C++ code and shared experiences on teaching
differentiable programming to students. More importantly, EuroAD created space
for aligning expectations between theory and practice — exactly the kind of
alignment our work depends on.

---

## Looking ahead: where the work continues

If 2025 taught us anything, it is that infrastructure is never "done". It either
hardens under real use, or it quietly erodes.

There are three areas where we know that the work must continue in 2026.

First, GPU reverse-mode at scale. The Thrust primitives and end-to-end demos we
built this year are real progress, but they are still building blocks rather
than a turnkey solution. Arbitrary kernels, complex memory access patterns, and
predictable performance remain open problems. Benchmarks like RSBench and LULESH
are no longer aspirational demos for us; they are acceptance tests, and they
will continue to be the standard we measure ourselves against.

Second, packaging and cross-platform reliability. macOS and Windows failures,
fragile upstream test matrices, and dependency churn still consume an outsized
amount of maintainer time. None of this work is glamorous, but all of it
determines whether someone can actually try our tools without giving up. A
focused investment here would likely unlock more adoption than any single new
feature.

Third, shared JIT and interoperability hardening. The idea of a shared JIT model
between CppInterOp, Numba, and notebook environments continues to show real
promise for interactive performance and usability. But symbol resolution, thread
safety, and long-running session stability need careful, disciplined engineering
-- and far more integration testing -- before that promise becomes something
users can rely on.

These are not research risks. They are engineering commitments.


## Epilogue: why this matters — beyond code

We did not spend 2025 chasing visibility or novelty. We spent it making things
that bend workflows. We turned student curiosity into real engineering
capacity. And we ended the year with something that feels different from before:
weight.

Once a compiler primitive becomes reliable enough to use, it reshapes design
choices in other projects. It becomes a lever that domain scientists pull
without thinking about compilers at all. And, quietly, it creates career paths:
for students who learn to debug generated code; for contributors who become
maintainers; and for researchers who discover that infrastructure work can carry
scientific weight.

The tools we maintain now matter in other people's pipelines. They surface real
problems. They attract collaborators. They are no longer purely speculative.

If you read this and want to help you can submit bug report, contribute a test,
or look at the list of [open projects](/open_projects) -- that kind of
contribution is exactly how fragile, useful tools turn into durable
infrastructure.

[ref0]: https://root.cern/blog/roofit-ad/
[ref1]: /blogs/gsoc25_aditi_final_blog/
[ref2]: /blogs/2025_petro_zarytskyi_introduction_blog/
[ref3]: /presentations/#MODE2025CUDA
[ref4]: /blogs/gsoc25_andriichuk_final_blog/
[ref5]: /blogs/gsoc25_rohan_final_blog/
[ref5]: https://blog.jupyter.org/c-in-jupyter-interpreting-c-in-the-web-c9d93542f20b
[ref6]: /blogs/gsoc25_abhinav_kumar_final_blog/
[ref7]: https://jank-lang.org/blog/2025-06-06-next-phase-of-interop/
[ref8]: /blogs/gsoc25_aditya_pandey_final_blog/
[ref9]: /blogs/gsoc25_salvador_wrapup_blog/
[ref10]: /blogs/rohan-timmaraju-neo-flood-nasa/
[ref11]: /blogs/2025_galin_bistrev_results_blog/
