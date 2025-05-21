---
title: "Agent-Based Simulation of CAR-T Cell Therapy Using BioDynaMo"
layout: post
excerpt: "This GSoC 2025 project, Agent-Based Simulation of CAR-T Cell Therapy, aims to develop a BioDynaMo-based model to simulate CAR-T cell dynamics and interactions. The goal is to provide researchers with a tool to evaluate therapy efficacy and identify strategies to enhance treatment outcomes."
sitemap: true
author: Salvador de la Torre Gonzalez
permalink: blogs/gsoc25_salvador_introduction_blog/
banner_image: /images/blog/cart_plasma_gsoc.png
date: 2025-05-14
tags: gsoc BioDynaMo c++
---

### Introduction

I am Salvador de la Torre Gonzalez, a Mathematics and Computer Engineering student from the University of Seville, and a Google Summer of Code 2025 contributor who will be working on "Agent-Based Simulation of CAR-T Cell Therapy Using BioDynaMo project.

**Mentors**: Vassil Vassilev, Lukas Breitwieser

### Briefly about CAR-T Cell Therapy and BioDynaMo

Chimeric Antigen Receptor T-cell (**CAR-T**) therapy is a promising immunotherapy that reprograms a patient’s T-cells to recognize and eliminate cancer cells. While CAR-T has achieved remarkable success in blood cancers, its efficacy in solid tumors remains limited due to factors such as poor T-cell infiltration, immune suppression, and T-cell exhaustion.

This project will be built on **BioDynaMo**, an open-source, high-performance simulation engine for large-scale agent-based biological modeling. BioDynaMo provides an efficient framework for modeling cellular dynamics and complex microenvironments at scale, making it ideally suited for simulating CAR-T therapies under diverse tumor conditions.

The simulation will capture essential components of CAR-T behavior, including T-cell migration, tumor cell engagement, and the influence 
of microenvironmental factors like hypoxia, regulatory T-cells, and immunosuppressive cytokines. The goal is not only to provide the simulation, but also custom analysis scripts for visualizing and testing how therapy parameters influence treatment outcomes.

### Why I Chose This Project

This project represents an exciting opportunity to apply my dual academic background in mathematics and computer engineering to a highly impactful domain: cancer immunotherapy.

My interest in oncology and CAR-T treatments deepened significantly after attending a course on Mathematical Modeling and Data Analysis in Oncology, taught by researchers from the Mathematical Oncology Laboratory" ([MôLAB](https://molab.es/)) team at the University of Cádiz. During this course, I was introduced to the fundamentals of immunotherapy and CAR-T cell dynamics, and became fascinated by the potential of mathematical and computational tools to contribute to this area.

I believe that building a scalable, open-source simulation of CAR-T therapy can become a valuable resource for scientists and clinicians worldwide, helping them to better understand and optimize treatment strategies considering the complex landscape of solid tumors. 

### Implementation Details and Plans

This project will develop a scalable agent-based simulation of CAR-T therapy using BioDynaMo. The simulation will include:

- T-cell migration, proliferation, and tumor cell killing,
- Simulation of both solid tumors and hematological cancers,
- Modeling of tumor microenvironment components such as:
  - Hypoxia,
  - Regulatory T-cells,
  - Immunosuppressive cytokines,
- Development of custom scripts for:
  - Visualizing tumor progression/regression,
  - Quantifying CAR-T efficacy,
- Exploration of therapy strategies including:
  - CAR-T dosage and administration timing,
  - Performance benchmarking for different therapeutic scenarios.

A modular architecture will ensure that the simulation is extensible and reusable in future studies. Insights gained from these simulations will be summarized in a comprehensive report including replication of real data and comparison between treatment strategy results.

### Conclusion

By building a BioDynaMo-based model of CAR-T cell therapy, we aim to provide a flexible and high-performance tool for exploring treatment strategies in complex tumor environments. This is really valuable work for the community since it could help identify conditions that enhance CAR-T efficacy, contributing to improved design of immunotherapies.


### Related Links

- [Project Description](https://hepsoftwarefoundation.org/gsoc/2025/proposal_BioDynamo-CART.html)
- [BioDynaMo Repository](https://github.com/BioDynaMo/biodynamo)
- [My GitHub Profile](https://github.com/salva24)