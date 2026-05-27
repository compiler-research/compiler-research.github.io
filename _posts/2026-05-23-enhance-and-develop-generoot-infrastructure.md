---
title: "Enhance and Develop GeneROOT Infrastructure"
layout: post
excerpt: "Continuing the GeneROOT effort: expanding benchmarks to heavy bioinformatics datasets, optimizing RNTuple indexing, evaluating modern genomic compression algorithms, and bringing RAMtools to feature parity with SAMtools."
sitemap: false
author: Jeffrey Zhang
permalink: blogs/generoot_jeffrey_zhang_blog/
banner_image: /images/blog/generoot_project_banner.png
date: 2026-05-23
tags: c++ genomics bioinformatics root rntuple cern hpc samtools
---

## Introduction

My name is Jeffrey Zhang, and I'm a third-year Physics undergraduate at Nagoya
University, Japan. I've been programming since elementary school — through
video games, hackathons, competitive C++ programming (USACO Gold, 75th in
2023), and a software engineering internship at Rakuten. I'll be working on
extending the GeneROOT infrastructure, building directly on the foundation
laid by Aditya Pandey during his GSoC 2025 work on using ROOT in genome
sequencing.

**Mentors**: Martin Vassilev, Vassil Vassilev, Aaron Jomy

## Overview

Large-scale biological data is enormous — a fully sequenced human genome
occupies roughly 500 GB, and research-scale analyses easily push into
petabytes. The GeneROOT project tackles this by adapting ROOT, CERN's
columnar physics-data framework, to genomic workloads.

Aditya's 2025 GSoC project established an RNTuple data model for genome
sequences, implemented a SAM-to-RNTuple converter, and produced a
single-sample benchmark against CRAM on `HG00154` from the 1000 Genomes
Project. That work is a solid foundation, but it also exposed several gaps:
the benchmark suite relies on hard-coded paths against one low-coverage
sample, region queries in RNTuple perform a linear scan that won't scale to
production-sized datasets, and RAMtools still lacks core functionality
(export to SAM, merge, sort, statistics) — leaving it closer to a proof of
concept than a usable pipeline component.

My project builds on that foundation by expanding the benchmark suite,
optimizing core performance, and introducing new functionality to bring
RAMtools toward feature parity with SAMtools.

## Technical Implementation

The work breaks into five tasks:

1. **Benchmark on heavy bioinformatics datasets.** Refactor the benchmark
   suite, replace hard-coded paths with a `benchmark_config.h` and
   CLI-driven dataset selection, run against well-known reference samples
   (`HG001`–`HG007`), and capture memory usage alongside the existing
   timing metrics.

2. **Cross-format comparison.** Extend the `system()`-call approach already
   used in `chromosome_split_benchmark.cxx` so all benchmark scripts measure
   SAM, BAM, and CRAM against RAMtools/RNTuple on the same datasets.

3. **Genomic compression algorithms.** Evaluate modern quality-score
   compression schemes (Crumble, QVZ, CALQ, P-block), extend the
   `EQualCompressionBits` enum in `RAMNTupleRecord.h`, and add the most
   effective candidates as new quality policies. A new
   `qual_compression_benchmark.cxx` will measure file-size gains against
   CRAM's lossy and lossless modes.

4. **Indexing and search optimizations.** `GetRowsInRange()` currently does
   an O(N) linear scan; I'll replace it with an O(log N) binary search over
   a sorted `fIndex` (eliminating the redundant `fIndexMap`/`RebuildMap`
   pair), expose `kPositionInterval` and `kMappedInterval` as configurable
   parameters, and implement a no-index columnar scan fallback in
   `RAMNTupleView.cxx` that mirrors the legacy TTree behavior.

5. **RAMtools feature parity with SAMtools.** Add `ramntuplestats`,
   `ramntupleidxstat`, and `ramntupleflagstat`; complete `ramntupleview`
   with N-record, region-filtering, and selective-column output; and add
   `ramntuplesplit`, `ramntuplemerge`, and `ramntuplesort` (the last using
   an external merge-sort to handle data that won't fit in memory).

## Goals

By the end of the coding period I aim to have:

- A reproducible benchmark suite that runs against multiple realistic
  genomic datasets with a single command and outputs JSON/CSV.
- Quantitative cross-format comparisons against SAM, BAM, and CRAM.
- A measurable storage-efficiency improvement on `QUAL` data using modern
  compression algorithms.
- Region queries that scale to production-sized datasets via logarithmic
  index lookup.
- RAMtools at feature parity with the commonly used SAMtools subcommands,
  documented with `.md` and `.ipynb` examples under a new `doc/` folder.

The combined effect should move RAMtools from a working proof of concept
toward a usable component of a real genomics pipeline.
