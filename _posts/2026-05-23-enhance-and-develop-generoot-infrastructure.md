---
title: "Enhance and Develop GeneROOT Infrastructure"
layout: post
excerpt: "Continuing the GeneROOT project: expanding benchmark suite, optimizing indexing, evaluating compression algorithms, and bringing more SAMtools features to RAMtools."
sitemap: false
author: Jeffrey Zhang
permalink: blogs/generoot_jeffrey_zhang_blog/
banner_image: /images/blog/generoot_project_banner.png
date: 2026-05-27
tags: c++ genome bioinformatics root rntuple
---

## Introduction

My name is Jeffrey Zhang, and I'm a third-year B.S. undergraduate student studying Physics at Nagoya
University, Japan. I'll be working on extending the GeneROOT infrastructure, building directly on the foundation
laid by Aditya Pandey during his GSoC 2025 work on using ROOT in genome
sequencing.

**Mentors**: Martin Vassilev, Vassil Vassilev, Aaron Jomy

## Overview

Large-scale biological data, such as a fully sequenced human genome, typically occupies $\sim$500 GB. Analyzing such datasets for research involves data volumes that exceed petabytes. Handling data at this scale requires a highly robust underlying software infrastructure. To meet this challenge, the GeneROOT project draws on CERN's extensive expertise in managing massive physics datasets through its columnar-based ROOT software framework. The GeneROOT project aims to adapt this framework specifically for processing biological data.

During the [2025 GeneROOT GSoC](https://compiler-research.org/blogs/GSoC25_aditya_pandey_final_blog/) project, Aditya Pandey established the RNTuple data model for genome sequences. It currently supports region queries, conversion from SAM to RNTuple, and a benchmark comparison against the industry-standard CRAM format on a single test sample `HG00154` from the 1000 Genomes Project. 

However, the results reveal several limitations. The benchmark suite relies on a single low-coverage sample with hard-coded file paths, which is insufficient for a credible comparison with tools such as SAMtools and CRAM. In terms of performance, RNTuple's index lookup itself performs a linear scan that does not scale to production-sized datasets. In terms of functionality, RAMtools cannot currently export records back to SAM, has no merge operation to complement the chromosome splitter, no sort, and no statistics tools. These gaps leave RAMtools as a proof of concept rather than a usable pipeline component.

My project builds on that foundation by expanding benchmark suite, optimizing indexing, evaluating compression algorithms, and bringing more SAMtools features to RAMtools.

## Technical Implementation

The work breaks into five tasks:

1. **Benchmark on heavy bioinformatics datasets.** Refactor the benchmark
   suite, replace hard-coded paths with a `benchmark_config.h` and
   CLI-driven dataset selection, run against well-known reference samples
   (`HG001`–`HG007`), and capture more metrics such as memory usage in addition to
   timing metrics.

2. **Cross-format comparison.** Extend the `system()`-call approach already
   used in `chromosome_split_benchmark.cxx` so all benchmark scripts measure
   SAM, BAM, and CRAM against RAMtools/RNTuple on the same datasets.

3. **Genomic compression algorithms.** Evaluate modern quality-score
   compression schemes (Crumble, QVZ, CALQ, P-block), extend the
   `EQualCompressionBits` enum in `RAMNTupleRecord.h`, and add the most
   effective candidates as new quality policies.

4. **Indexing and search optimizations.** `GetRowsInRange()` currently does
   an O(N) linear scan; I'll replace it with an O(log N) binary search over
   a sorted `fIndex` (eliminating the redundant `fIndexMap`/`RebuildMap`
   pair), have `kPositionInterval` and `kMappedInterval` as configurable
   parameters, and implement a no-index columnar query fallback in
   `RAMNTupleView.cxx` similar to legacy TTree `ramview_no_index.cxx`.

5. **Add common SAMtools features to RAMtools.** Add `ramntuplestats`,
   `ramntupleidxstat`, and `ramntupleflagstat`; complete `ramntupleview`
   with N-record, region-filtering, and selective-column output; and add
   `ramntuplesplit`, `ramntuplemerge`, and `ramntuplesort`.

## Goals

By the end of the coding period I aim to have:

- A reproducible benchmark suite that runs against multiple
  genomic datasets with custom commands and outputs.
- Quantitative cross-format comparisons against SAM, BAM, and CRAM.
- A measurable storage-efficiency improvement on `QUAL` data using modern
  compression algorithms.
- Faster region queries that can scale better to production-sized datasets.
- RAMtools at feature parity with some of the commonly used functionalities in SAMtools, such as `Stat` and `View`.

The combined effect should move RAMtools from a working proof of concept
toward a more usable component of a real genomics pipeline.
