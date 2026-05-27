---
title: "CARTopiaX: Extending a Next-Generation Platform for Computational Cancer Biology"
layout: post
excerpt: "Extending CARTopiaX within BioDynaMo to reproduce new biologically relevant CAR T-cell phenomena using real wet-lab experimental data."
sitemap: true
author: Salvador de la Torre Gonzalez
permalink: /blogs/gsoc26_salvador_introduction_blog/
banner_image: /images/blog/cartopiax_plasma_gsoc.png
date: 2026-05-27
tags: gsoc BioDynaMo c++
---

### Introduction

My name is Salvador de la Torre Gonzalez, and I am a Mathematics and Computer Engineering student at the University of Seville and a Google Summer of Code 2026 contributor working on the project **“CARTopiaX: Extending a Next-Generation Platform for Computational Cancer Biology”**.

During GSoC 2025, I was part of the Compiler Research team, where I initiated the CARTopiaX framework. This year, the project focuses on extending the platform to reproduce additional biologically relevant phenomena in CAR T-cell therapy research.

**Mentors**: Luciana Melina Luque, Vassil Vassilev, Lukas Breitwieser

### Briefly about CAR-T Cell Therapy and CARTopiaX

Chimeric Antigen Receptor T-cell (**CAR-T**) therapy is an immunotherapy approach where a patient’s T-cells are engineered to recognize and destroy cancer cells. Although highly successful in blood cancers, CAR-T therapy still faces major challenges in solid tumors due to limited infiltration, immunosuppressive microenvironments, and T-cell exhaustion.

[CARTopiaX](https://github.com/compiler-research/CARTopiaX) is an advanced agent-based model designed to study CAR T-cell therapy in solid tumors. Built on [BioDynaMo](https://github.com/BioDynaMo/biodynamo), a high-performance open-source platform for large-scale and modular biological simulations, CARTopiaX enables detailed exploration of complex biological interactions, hypothesis testing and data-driven discovery within tumor microenvironments.

The framework implements the mathematical model proposed in the *Nature Scientific Reports* paper *“In silico study of heterogeneous tumour-derived organoid response to CAR T-cell therapy”* and successfully reproduces its experimental trends *in silico*.

The goal of this GSoC project is to expand CARTopiaX so it can replicate new *in vitro* experimental observations and biological mechanisms, strengthening its role as a flexible framework for computational cancer biology research.

### Implementation Details and Plans

The project will focus on extending CARTopiaX with additional biological mechanisms identified through a literature review of recent CAR T-cell studies.

#### Possible extension directions

<u>1. Agents</u>

- **Additional immune populations (PBMCs, macrophages, MDSCs):** Incorporating alternative immune populations, such as PBMCs (comprising T cells and dendritic cells), macrophages that engulf debris and pathogens, and MDSCs which act as immunosuppressive cells to inhibit T-cell activity.
- **Stromal cells (fibroblasts and CAFs) acting as physical barriers:** Including stromal cells like fibroblasts and CAFs (Cancer-Associated Fibroblasts), which contribute to extracellular matrix production and physical immune cell exclusion.
- **Tumor heterogeneity, cancer types, and antigen loss/re-expression:** Modeling tumor heterogeneity and variability, which includes differences in antigen expression and the ability of tumor cells to temporarily lose and later regain target antigens to enable immune evasion.

<u>2. Microenvironment</u>

- **Cytokine signaling and immunosuppressive factors:** Examining cytokine signaling and immunosuppressive factors, which are signaling proteins that regulate immune activity and can suppress immune responses (e.g., TGF-β, IL-10) to promote tumor evasion.
- **Hypoxia and nutrient deprivation effects:** Accounting for hypoxia, which consists of low oxygen regions within tumors caused by limited diffusion and high cellular consumption, along with the associated effects of nutrient deprivation.
- **Vascularization and nutrient diffusion:** Simulating vascularization and nutrient diffusion through blood vessels that supply oxygen and nutrients while directly influencing spatial gradients within the tumor microenvironment.
- **ECM viscosity and hydrogel-based barriers:** Evaluating ECM viscosity and hydrogel-based barriers, where the density and stiffness of the structural extracellular matrix network hinder immune cell movement.
- **ECM degradation and heat-induced microenvironment modulation:** Assessing ECM degradation and heat-induced microenvironment modulation as processes that experimentally modify the extracellular matrix to increase permeability and improve immune cell infiltration.

<u>3. Rules & Dynamics</u>

- **Immune suppression and exhaustion mechanisms:** Integrating immune suppression and exhaustion mechanisms, which are processes where immune cells gradually lose their activity due to prolonged stimulation or inhibitory signals.
- **Antigen-dependent recognition and immune evasion:** Analyzing antigen-dependent recognition and immune evasion, whereby CAR T-cells recognize tumor cells based on specific antigens while tumors actively evade this by downregulating or losing antigen expression.
- **Chemotaxis and infiltration dynamics:** Modeling chemotaxis and infiltration dynamics to capture the directed movement of immune cells toward specific chemical gradients such as cytokines.
- **Macrophage phagocytosis:** Incorporating macrophage phagocytosis as the active process by which macrophages engulf and remove dead or damaged cells.
- **ECM permeability evolution:** Tracking ECM permeability evolution to understand how continuous changes in tissue structure affect how easily cells can move through the extracellular matrix.
- **Hypoxia-induced necrosis and cell-state transitions:** Simulating hypoxia-induced necrosis and cell-state transitions, which involve cell death caused by oxygen deprivation and the subsequent transitions between different cellular states under stress conditions.

---

The project is organized into four main phases:

<u>Phase 1: Literature Review & Data Acquisition</u>

- Select a high-impact experimental study from the literature that provides relevant biological and computational insights for model extension.  
- Obtain usable wet-lab datasets associated with the selected study, ensuring they are suitable for computational analysis.  
- Extract quantitative metrics from experimental data to enable model calibration and evaluation.  

<u>Phase 2: Model Expansion</u>

- Add new biological agents, microenvironment components and required to represent the selected CAR T-cell phenomenon.  
- Implement biologically grounded rules and interactions that govern cell behavior and system new dynamics.  
- Adapt and extend the existing CARTopiaX model structure to accurately reproduce the chosen biological setting.  

<u>Phase 3: Model Calibration & Optimization</u>

- Define fitness functions using error metrics (e.g., MSE/RMSE) for model fitting, measuring the discrepancy between simulated outputs and experimental observations.  
- Implement and apply efficient optimization methods for high computational cost scenarios, such as Bayesian optimization and evolutionary algorithms, to explore the parameter space effectively.  
- Reduce computational cost via early stopping, simplified simulations, and staged calibration strategies that progressively refine parameter estimates.  
- Perform parameter estimation to identify the set of model parameters that best reproduce the experimental data.   

<u>Phase 4: Validation & Delivery</u>

- Validate the model using multiple stochastic simulations to ensure robustness and consistency of results.  
- Perform sensitivity analysis and robustness checks to understand parameter influence and model stability.  
- Summarize findings in a structured scientific report oriented towards a future research publication.  

---

### Conclusion

This project aims to demonstrate how CARTopiaX can evolve into a flexible and extensible framework capable of reproducing increasingly complex biological phenomena in CAR T-cell therapy research.

By combining real experimental data with large-scale agent-based simulations, the project seeks to support hypothesis-driven exploration in computational oncology while strengthening the connection between *in vitro* experimentation and predictive *in silico* modeling.

As both the original author of CARTopiaX and a student working at the intersection of mathematics, computer engineering and computational biology, I am excited to continue expanding the project during GSoC 2026.


### Related Links

- [CARTopiaX](https://github.com/compiler-research/CARTopiaX)
- [Project Description](https://hepsoftwarefoundation.org/gsoc/2026/proposal_BioDynamo_CartopiaX.html)
- Luque, L.M., Carlevaro, C.M., Rodriguez-Lomba, E. et al. *In silico study of heterogeneous tumour-derived organoid response to CAR T-cell therapy.* Sci Rep 14, 12307 (2024). [DOI](https://doi.org/10.1038/s41598-024-63125-5)
- Breitwieser, L., Hesam, A., de Montigny, J. et al. *BioDynaMo: a modular platform for high-performance agent-based simulation.* Bioinformatics 38(2), 453–460 (2022). [DOI](https://doi.org/10.1093/bioinformatics/btab649)
- Breitwieser, L., Hesam, A., Rademakers, F., Gómez Luna, J., and Mutlu, O. *High-Performance and Scalable Agent-Based Simulation with BioDynaMo.* In Proceedings of the 28th ACM SIGPLAN Annual Symposium on Principles and Practice of Parallel Programming (PPoPP '23), 174–188 (2023). [DOI](https://doi.org/10.1145/3572848.3577480)
- [BioDynaMo Repository](https://github.com/BioDynaMo/biodynamo)
- [My GitHub Profile](https://github.com/salva24)