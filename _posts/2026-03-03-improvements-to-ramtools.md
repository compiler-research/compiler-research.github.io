---
title: "General improvements to ramtools"
layout: post
excerpt: "Exploring possibilities for increased speed and efficiency"
sitemap: false
author: Georgi Haralanov
permalink: blogs/ramtools_Georgi_Haralanov_blog/
thumbnail_image: /images/mg-pld-logo.png
date: 2026-03-03
tags: c++ genomics bioinformatics root rntuple cern hpc
---

{% include dual-banner.html
left_logo="/images/mg-pld-logo.png"
right_logo="/images/cr-logo_old.png"
caption=""
height="20vh" %}

## Introduction
My name is Georgi Haralanov and the aim of this project is to explore ways
of increasing the speed of the query tools found in the Ramtools project.
The current implementation has shown great results, far outpacing other tools
when using large data sets.

**Mentor**: Vassil Vassilev

## Overview

Assessing the current state of the project with tools like samply it is clear
that the project is very optimized when querying per item in the needed file.
The sheer amount of individual data components which need to be analyzed leads
to the large amount of wait time when processing wide search regions. One way
to mitigate this slowdown is to divide the work between more than one processes.
This way you can achieve parallel workflow and increase the speed. This is
already implemented by the project by splitting the file into multiple fragments
each containing one chromosome. This allows for parallel work when viewing more than
one chromosome but if that is not necessary than you are forced into a sequential
analysis. This project aims to increase the overall speed of such an analysis by
adding multithreading to the query tools.

## Technical implementation
There are two possible ways to go about doing the work in the project:
1. To use the built-in ROOT Implicit Multithreading (IMT); using this would
allow for quicker deployment of the feature with near zero drawbacks. It has
some features which might lead to underutilization on some hardware platforms
and might not even activate in certain circumstances which leads us to method
number 2: personal implementation.
2. Implementing the multithreading from scratch would mean longer time before the
feature is ready and exposes the project to some risk of gaining new undefined
behavior by way of bugs and logic errors during creation. On the flip side
this method allows for direct control of the number of threads used during 
runtime and greater certainty of the actual work being done by the program.

## Goals
I aim to decrease query times and increase perceived performance of the
tools found in the ramtools project by implementing and testing both methods of
multithreading in the coming months. Roughly the steps I will try to follow during
the making of the project looks something like this:
1. Benchmark current times
2. Implement functionality by one of the two methods
3. Benchmark the implementation and compare to previous benchmarks
4. Implement functionality using the other method
5. Benchmark the new implementation
6. Compile, analyze and publish findings




