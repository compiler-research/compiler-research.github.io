---
layout: gridlay
title: "Accelerating and Scaling Python for HPC"
excerpt: "Landing page for the SC26 tutorial 'Accelerating and Scaling Python
          for HPC' -- abstract, logistics, and tutorial materials."
sitemap: false
permalink: /tutorials/sc26/
redirect_from:
  - /sc26/
date: 2026-11-16
---

{::nomarkdown}

{% include tutorial-hero-style.html %}

<div class="hero-box">
  <span class="status-badge">★ SC26 TUTORIAL · MON, NOV 16 · ROOM W185A</span>
  <h1 style="color: #004481; font-weight: 800; margin-top: 0; font-size: 2.2em;">
    Accelerating and Scaling<br>Python for HPC
  </h1>
  <p class="lead" style="margin-bottom: 0;">Monday, November 16, 2026 · 8:30am&ndash;5:00pm CST
  · Room W185a, McCormick Place, Chicago, IL ·
  <a href="https://sc26.conference-program.com/presentation/?id=tut150&sess=sess183">SC26 program entry</a></p>
</div>

{:/}

Python is powering breakthrough exascale scientific discoveries -- come learn
how to program the world's largest supercomputers with it! In this
interactive tutorial you'll learn how to write, debug, profile, and optimize
high-performance, multi-node GPU applications in Python. You'll learn and
master: CuPy for drop-in GPU acceleration of NumPy workflows, Numba for
writing custom kernels that match the performance of C++ and Fortran, mpi4py
for scaling across thousands of nodes, DragonHPC for workflow acceleration
with cuPhoton for astronomical image processing, and CppJIT for on-demand
Python/C++ interoperability and automatic binding generation, including
compiler-based automatic differentiation of C++ with Clad. Everything is
hands-on: short, interactive lectures by expert instructors are paired with
guided Jupyter notebooks that introduce each concept and have you apply it
immediately in bite-sized exercises, among them a mini-app applying several
programming models (JAX, cuda.compute, Numba CUDA) to simulated cosmic-web
data and a CARTopiaX CAR T-cell therapy example. We'll use a web-based
environment that requires no installs or setup -- just a laptop and a
browser. Whether you're a domain scientist seeking faster turnaround or a
software engineer evaluating portable acceleration strategies, you'll leave
with a roadmap, skills, and code for bringing scalable Python practices back
to your own HPC facility.

In this tutorial we will cover:

- NumPy fundamentals and the `ndarray` memory model.
- Accelerating array workflows on the GPU with CuPy, including memory spaces and asynchrony.
- Distributed computing with mpi4py for multi-node parallelism.
- Programming models in Python for GPU applications: array expressions, fusion, library iterators, kernel authoring, and interoperability with CUDA C++ kernels.
- Reading an application's profile with Nsight Systems and Nsight Compute.
- Case studies of horizontal Python and C++ integration in domain sciences such as cancer research and high energy physics.
- DragonHPC fundamentals enabling `multiprocessing` to scale across HPC multi-node resources.
- cuPhoton astronomical image processing workflows orchestrated using DragonHPC.

Attendees are expected to have general knowledge of HPC and Python
programming. Some familiarity with NumPy and C/C++ is helpful but not
required.

## Logistics

- **When**: Monday, November 16, 2026, 8:30am--5:00pm CST
- **Where**: Room W185a, McCormick Place, Chicago, IL
- **Official page**: [SC26 program entry](https://sc26.conference-program.com/presentation/?id=tut150&sess=sess183)
- **What to bring**: just a laptop and a browser -- the hands-on sessions run
  in a web-based environment with no installs and no setup.

## Materials

- **Complete Talk Materials**: [PDF](/assets/tutorials/sc26/sc26__all_slides.pdf)
  (intro, basics, fundamentals, cosmic-web mini-app, domain science integration,
  DragonHPC and cuPhoton)
- **Handouts - Basics**: [PDF](/assets/tutorials/sc26/sc26__basics_handout.pdf)
- **Domain Science Integration**: [JupyterLite notebooks](https://compiler-research.org/live-cpp-tutorials/)
  (live-cpp-tutorials, run in the browser)
- **Notebooks and container**: [pyHPC/sc2026-tutorial](https://github.com/pyHPC/sc2026-tutorial)
  on GitHub, with the outline in `notebooks/syllabi/`.

This page is the permanent home for the tutorial materials -- bookmark it,
or keep the QR code from the handouts.

<i>If you are interested in our work you can join our
[compiler-research-announce google groups forum](https://groups.google.com/g/compiler-research-announce)
or follow us on [LinkedIn](https://www.linkedin.com/groups/9579649/).</i>
