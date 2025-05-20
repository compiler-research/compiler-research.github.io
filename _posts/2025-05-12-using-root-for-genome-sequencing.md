---
title: "Using ROOT for genome sequencing"
layout: post
excerpt: "A GSoC 2025 project aiming to advance genomic data management by implementing ROOT's next-generation RNTuple format for sequence alignment storage."
sitemap: false
author: Aditya Pandey
permalink: blogs/gsoc25_aditya_pandey_introduction_blog/
banner_image: /images/blog/genome_project_banner.png
date: 2025-05-13
tags: gsoc root genome bioinformatics 
---

### Introduction

I am Aditya Pandey currently a Bachelor of Technology student with experience in C++, Python, 
and algorithm optimization. During Google Summer of Code 2025, I'll be working on the project
"Using ROOT in the field of genome sequencing" with CERN-HSF.

**Mentors**:Martin Vassilev, Jonas Rembser, Fons Rademakers, Vassil Vassilev


### The Challenge of Genomic Data

Genomic sequencing data volumes are growing exponentially, creating performance bottlenecks in 
traditional storage formats. A single human genome sequencing project can generate files ranging
from 10-30GB, and large-scale initiatives involve thousands of samples. This data tsunami requires
more efficient storage and query solutions than traditional formats like BAM and CRAM can provide.
Previous work with the GeneROOT project (a CERN initiative to use ROOT for genomics) has shown 
promising results with the TTree format, demonstrating approximately 4x performance improvements.
 My project aims to build on this foundation by implementing the next-generation RNTuple format, 
which promises even greater efficiency.

### Why RNTuple for Genomics?
RNTuple is ROOT's successor to TTree columnar data storage, offering several advantages for genomic data:

Improved Memory Efficiency: RNTuple's design allows uncompressed data to be directly mapped to memory without further copies due to the clear separation between offset/index data and payload data. This matches the in-memory layout on modern architectures and reduces RAM requirements when processing large genomic datasets.
Type Safety: RNTuple provides compile-time type-safe interfaces through the use of templates, reducing common programming errors in genomic data processing. This is particularly valuable when handling complex nested data types common in genomic sequence information.
Enhanced Storage Efficiency: Recent benchmarks show RNTuple achieving 20-35% storage space savings compared to TTree, which already outperforms traditional genomic formats. This translates to significant storage cost reductions for large-scale genomic datasets.
Optimized Performance: RNTuple demonstrates multiple times faster read throughput than TTree, along with better write performance and multicore scalability. It can fully harness the performance of modern NVMe drives and object stores.
Columnar Access Pattern: The columnar structure is ideal for genomic region queries that often only access chromosome and position information, avoiding unnecessary data loading. This is particularly important for genomic data, where analysts frequently need to examine specific regions rather than entire sequences.


### Project Description
My project extends GeneROOT by implementing ROOT's next-generation RNTuple format for genomic data storage and analysis through two main stages:

#### Stage 1: Reproduction and Baseline Establishment

Reproduce and validate previous GeneROOT benchmarks showing 4x performance gains with TTree
Establish reliable baseline metrics for comparison
Identify and address performance bottlenecks in the current implementation
Optimize the existing code before transitioning to RNTuple
Analyze and compare compression strategies from Samtools/HTSlib and ROOT

#### Stage 2: RNTuple Implementation

Implement a genomic data model using RNTuple's templated field system
Develop efficient converters between standard genomic formats (BAM/CRAM) and RNTuple
Create advanced file splitting strategies (by chromosome, region, or read group)
Implement high-performance query tools leveraging RNTuple's columnar structure

### Compression Strategy Analysis

A key component of this project involves analyzing the compression techniques used by Samtools/HTSlib and comparing them with ROOT's compression capabilities:

#### BGZF (Blocked GZIP Format) in BAM Files

- I'll study the 64KB block architecture that enables random access while maintaining gzip compatibility
- Test the nine compression levels (1-9) to determine optimal settings for genomic data
- Analyze the multi-threading implementation for parallel compression/decompression

#### CRAM Advanced Codecs

- Investigate rANS (Asymmetric Numeral Systems) implementations
- Examine CRAM transforms including interleaving, RLE, bit-packing, and striped encoding
- Analyze integration techniques for external codecs like bzip2 and LZMA

#### Implementation Strategy

The findings from this analysis will inform the implementation of:

- Codec library integration with HTSlib's compression libraries where possible
- ROOT-native implementations of key algorithms where direct integration isn't possible
- Reference-based compression similar to CRAM
- Adaptive selection of optimal compression methods based on data characteristics



### Project Architecture
<embed src="/images/blog/genome_sequencing.pdf" type="application/pdf" style="display: block; margin-left: auto; margin-right: auto;" width="100%" height="600px" />

### Implementation Progress
I have already made significant progress optimizing the existing GeneROOT codebase. My initial work on ramview.C has shown impressive performance gains through:

Replacing linear search with a two-phase approach combining exponential and binary search
Implementing dynamic batch processing to reduce I/O operations
Adding selective branch management to focus resources on necessary data
Implementing resource optimization that scales based on file size

### Expected Benefits
This project will deliver tools for handling rapidly growing genomic datasets with significantly improved performance:

Faster genomic region queries through RNTuple's columnar structure
Better memory efficiency when processing large genomic files
Enhanced type safety through RNTuple's templated interfaces
Optimized storage through specialized compression and splitting strategies
A potential new standard for high-performance genomic data analysis.