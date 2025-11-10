---
title: "Congratulations to Rohan Timmaraju & the NEO-FLOOD Team"
layout: post
excerpt: >
  Congratulations to Rohan Timmaraju and the NEO-FLOOD team for their success in
  NASA's Beyond the Algorithm Challenge. This win highlights the strength of
  cross‑disciplinary thinking, where foundational research technologies enable
  solutions to high‑stakes problems.
sitemap: false
author: Vassil Vassilev
permalink: blogs/rohan-timmaraju-neo-flood-nasa/
banner_image: /images/blog/nasa-beyond-algo.png
date: 2025-10-08
tags: [
  nasa,
  neo-flood,
  compiler-research,
  neuromorphic-computing,
  satellite-ai,
  earth-observation,
  flood-prediction,
  research-award,
  space-technology
]
---

## Congratulations to Rohan Timmaraju & the NEO-FLOOD Team

We’re thrilled to congratulate Rohan Timmaraju and his collaborators on their
outstanding achievement in the Beyond the Algorithm Challenge with the NEO‑FLOOD
project. This win highlights the strength of cross‑disciplinary thinking, where
foundational research technologies enable solutions to high‑stakes problems.

The NASA Earth Science Technology Office seeks solutions to complex Earth
Science problems using transformative or unconventional computing technologies
such as quantum computing, quantum machine learning, neuromorphic computing, or
in-memory computing. The NEO-FLOOD team developed a novel, brain-inspired
algorithm to detect floods in real-time on power-constrained neuromorphic
hardware suitable for deployment in space.

## Problem Space

Floods cause *$100B+* in annual damages globally, yet critical response decisions
are often delayed by 6–72 hours due to ground-based satellite processing
bottlenecks. This “intelligence gap” makes high-quality Earth observation data
operationally useless during the crucial “Golden Hour” — when rapid intervention
can save lives. The NEO-FLOOD (Neuromorphic Earth Observation for Flood-mapping)
approach directly addresses this challenge:
  - **The problem:** Traditional satellites act as passive data collectors, sending
    raw data to Earth for processing, creating dangerous delays.
  - **The innovation:** A spiking neural network, Spike2Former-Flood, optimized
    for real-time optical and SAR data directly on-satellite.
  - **The hardware:** Space-validated neuromorphic processors (BrainChip Akida,
    Intel Loihi 2) running at only 2–5W.
  - **The impact:** Closes the intelligence gap from hours to minutes,
    transforming satellites into autonomous decision-support systems. This
    order-of-magnitude latency improvement could enable immediate flood response
    coordination for emergency agencies, insurers, and humanitarian organizations.

## A Compiler Researcher’s Role

Rohan’s expertise in compilers and systems research provided key foundations for
NEO-FLOOD’s success. Reconciling a novel AI paradigm and real-time systems
required compiler-level thinking to:

  - Optimize for the edge: optimize the model for performance and energy
    efficiency on heavily constrained space hardware.
  - Ensure Robustness: enable streamlined, reliable pipelines for sensor fusion
    and onboard processing.
  - Map to Novel Hardware: develop strategies for mapping a complex neural
    network onto heterogeneous neuromorphic hardware.

This achievement demonstrates that advances in compilers and systems research
can directly influence solutions to pressing global problems, and bridge the gap
between research infrastructure and mission-critical practice.
<img src="/images/blog/rohan_interview.png" alt="Rohan Timmaraju interview photo"
     style="float: left; margin: 0 1em 1em 0; width: 35%; border-radius: 8px;">
Rohan's achievement with NEO-FLOOD is a testament to how foundational compiler
and systems research can directly impact global resilience challenges.
We couldn’t be prouder to see him bridging disciplines — from compiler
technologies to neuromorphic AI in orbit. "Early on, we spent a lot of time
trying to fit our flood analysis models onto the neuromorphic hardware. But the
real breakthrough came when we stepped back and re-examined the core problem,"
shares Rohan. "We realized the critical bottleneck wasn’t computational power,
it was latency. The goal isn’t just to process data faster; it’s to eliminate
the round-trip to Earth entirely. That insight shifted our focus from simply
optimizing an algorithm to redesigning the entire decision-making workflow
around the hardware's native strengths: low power and real-time processing
directly in orbit."

[Project gallery (NEO‑FLOOD)](https://www.nasa-beyond-challenge.org/project-gallery/neo-flood)


[Rohan (Compiler Research profile)](https://compiler-research.org/team/RohanTimmaraju)
