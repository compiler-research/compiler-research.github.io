---
title: "CARTopiaX and the Land of the In-Between"
layout: post
excerpt: |
  Cross-disciplinary research is not a stylistic choice but a structural necessity for tackling today's complex scientific systems. Join me in exploring why the most consequential problems live in the in-between -- and what it takes to work there.
sitemap: true
author: Luciana Luque
permalink: blogs/cartopiax-land-of-the-in-between/
banner_image: /images/blog/cartopiax-header.png
date: 2026-03-01
tags: [cross-disciplinary, mechanistic-modeling, CAR-T, agent-based-models, computational-biology]
---

After moving from loop quantum gravity to statistical mechanics and eventually into cancer research, I arrived at a conclusion that would once have surprised me: the most consequential scientific problems do not live inside disciplines. They live in the *in-between*.

Not because physics is incomplete. Not because biology is messy. Not because computation is insufficient. But because the systems we now try to understand -- and intervene in -- are too complex to respect the lines we draw between departments.

Cancer is one of those systems.

I work on immunotherapies, particularly CAR T-cell therapy [\[1\]][ref1]. CAR T cells are a patient's own immune T cells, genetically engineered to recognise and attack specific cancer-associated targets. In certain cancers they have produced extraordinary clinical responses -- eliminating advanced disease where other treatments failed, sometimes persisting long term and reducing relapse.

And yet the system is far from uniform. Some patients respond; others do not. Toxicities can be severe. Bone marrow behaves differently from peripheral blood. The cerebrospinal fluid is not equivalent to a solid tumour microenvironment. Activation, proliferation, exhaustion, cytokine diffusion, spatial constraints -- all interact.

We are not dealing with a single pathway. We are dealing with a coupled, stochastic, spatially structured system. And large portions of that system remain only partially characterised.

Biology is full of such unknowns. We often know components but not governing dynamics. We identify markers but lack formal equations. We describe behaviour without fully formalising the mechanism.

Looking at such a system from only one disciplinary angle is like walking through a landscape at ground level. You see detail -- texture, local interactions. Change the perspective -- step back, change the formalism -- and gradients, flows and constraints become visible. It is the same terrain, but different variables emerge.

For quantitatively trained scientists, this presents a choice. One can treat biological complexity as something to simplify away. Or one can treat it as a systems problem to formalise.

I clearly chose the second option.

## From Mechanistic Model to CARTopiaX

A couple of years ago I developed a mechanistic agent-based model (ABM) [\[2\]][ref2] to formalise CAR T-cell dynamics and test alternative dosing strategies under controlled *in silico* conditions. In this framework, individual cells are represented as discrete agents governed by explicit interaction rules. Activation, tumour killing, proliferation and exhaustion are encoded as probabilistic state transitions constrained by biologically informed parameters. Spatial positioning influences encounter rates. Time discretisation governs stability. Local interactions scale to system-level behaviour.

The model was designed not only to understand mechanisms but to explore hypotheses that are expensive, slow or ethically impractical to test experimentally. Multiple simulations can be run in parallel. Parameter spaces can be explored systematically. Dosing regimens can be perturbed in ways that would be difficult in vivo. In this sense, the model functions both as a lens and as a sandbox.

CARTopiaX [\[3\]][ref3] is the scalable implementation of that mathematical framework within the BioDynamo [\[4\]][ref4] simulation platform, developed in collaboration with the Compiler Research group. My contribution was the biological grounding and mechanistic structure of the ABM. Their expertise lay in high-performance architecture, modular design and computational scalability.

The model formalises biology.  
CARTopiaX turns that formalism into robust infrastructure.

## Why Formalisation Forces You to Cross Disciplines

To encode CAR T-cell behaviour mechanistically, one cannot remain descriptive.

Cytokines do not simply "spread." They diffuse. That diffusion must obey a formalism. Is Fickian diffusion sufficient at the spatial scale of interest? Does the microenvironment justify a continuum approximation? Should transport be implemented via discretised partial differential equations on a grid? What resolution balances biological fidelity with computational feasibility?

Answering those questions required learning not only immunology, but transport physics and stochastic processes. Choosing the diffusion equation is not decorative mathematics; it constrains emergent behaviour. An inappropriate abstraction alters gradients, signalling thresholds and ultimately predicted outcomes.

Similarly, activation and exhaustion are not labels; they are stochastic transitions. At each time step, state-transition probabilities govern behaviour. Those probabilities must be calibrated against experimental measurements. Sensitivity analysis must reveal which parameters materially alter system dynamics.

In my own trajectory, this necessity pushed me beyond computation into biological training -- not to change identity, but to understand the provenance of the data constraining the equations. Calibration and validation are not technical afterthoughts; they are epistemic commitments.

Biology defines what interactions matter.  
Physics constrains how they propagate.  
Mathematics formalises their dynamics.  
Computation implements them at scale.

## Implementation Is Not Secondary

Many academic models are designed to answer a question, generate a figure and remain difficult to extend. If a model is to become infrastructure rather than illustration, its computational architecture matters.

My original ABM was built with object-oriented C++ because performance, modularity and reproducibility are structural requirements, not engineering luxuries. Agent-based systems grow rapidly in complexity. They may involve thousands or millions of interacting entities. Without modular design, small changes cascade unpredictably. Without careful separation of concerns, validation becomes fragile. Without reproducibility, trust erodes.

The Compiler Research group brought deep expertise in scalable systems and performance optimisation. They implemented the mechanistic framework within BioDynamo, improving scalability and computational robustness while preserving biological fidelity.

## Crystal Boxes in a Machine Learning Era

Because we are living in a machine learning renaissance, it is important to clarify what this approach is -- and what it is not.

Machine learning models excel at pattern detection and prediction across large, high-dimensional datasets. In imaging and genomics, they have transformed what is possible. They are often described as black boxes: powerful but internally opaque.

Agent-based models operate differently.

They are crystal boxes. Every rule is explicit. Every assumption is encoded. When unexpected behaviour emerges, it can be traced back to the mechanisms that generated it.

This distinction is not about superiority. It is about purpose. Machine learning is exceptional at identifying correlations and making predictions within observed data regimes. Mechanistic models are designed to interrogate dynamics under perturbation -- to ask how system behaviour changes when assumptions shift.

A hammer and a screwdriver are both indispensable. Confusing one for the other weakens the work.

CARTopiaX deliberately implements a mechanistic crystal box because refining immunotherapies often requires understanding not only what happens, but why.

## Beyond Proximity

Cross-disciplinary research is often described optimistically. It conjures images of mathematicians, biologists, engineers, and clinicians gathered around a table, exchanging ideas. But proximity does not guarantee integration.

Imagine trying to solve a global crisis with a room full of monolingual experts from different countries. Each person is brilliant. Each perspective is valuable. Without shared language, progress stalls.

Scientific collaboration faces the same structural constraint.

In the Nature exchange between Kenneth Kosik [\[5\]][ref5] and Sarah Bohndiek [\[6\]][ref6], the biologist and physicist each articulate what "understanding" means in their own fields. For a biologist, understanding gene transcription may involve identifying transcription factors and binding sites. For a physicist, understanding may involve probability distributions and force quantification. Those are not competing definitions. They are orthogonal planes.

Chris Ponting emphasises that interdisciplinary work requires trust and acknowledgement of differing expertise [\[7\]][ref7]. Sean Eddy argues that many breakthroughs emerge when individuals step outside disciplinary identity entirely [\[8\]][ref8]. In my own experience, learning to build mechanistic models required recognising when "I don't understand" meant I lacked biological context, and when it meant I lacked mathematical formalism. It also required resisting the temptation to fit models to whatever data happened to be available. Instead, it often meant asking: what data would make this model defensible?

Translation operates in both directions. Quantitative scientists should learn biological language. Biologists should become comfortable with abstraction, equations and uncertainty. Neither side can remain monolingual if the goal is mechanistic understanding. However, in practice, we cannot expect every biologist to learn stochastic modelling, nor every engineer to master immunology. Cross-disciplinary scientists therefore act as translators between monolingual specialists. But they are not merely translators. They are integrators. They connect formalisms, expose hidden assumptions and ask structural questions that neither discipline would independently frame. They are often the missing piece -- not because they know everything, but because they know enough to move between frameworks.

This movement is not only technical; it is psychological. Stepping into a new field can mean knowing less than a master's student in that domain. It tests confidence. It requires comfort with temporary incompetence. It forces humility without surrendering authority [\[9\]][ref9].

But it also reveals which skills are transferable: abstraction, structured reasoning, the ability to formalise intuition.

The in-between demands both fluency and resilience.

## Curiosity and Reframing

What made the collaboration behind CARTopiaX effective was not only technical strength. The Compiler Research group does not simply gather engineering talent; they cultivate curiosity.

They did not only ask what to implement. They asked why the question existed -- what biological assumption motivated a rule, what constraint justified a parameter, what failure mode might invalidate a prediction.

They brought computational robustness.  
I brought the mechanistic and biological framework.

The result was not a pipeline from biology to code. It was an iterative loop.

There is a persistent assumption that innovation comes from asking practitioners what they need and incrementally improving workflows. But as is often (perhaps apocryphally) attributed to Henry Ford: if he had asked people what they wanted, they would have said faster horses.

Mechanistic modelling does not simply accelerate existing experiments. It reframes the question.

What dynamics are invisible in static assays?  
What system-level behaviour emerges from local rules?  
What happens under perturbations we cannot easily test in the lab?

Because biology contains unknown processes, new perspectives are not optional additions. They are instruments for revealing structure where none has yet been formalised.

## Why the *In-Between* Matters

For systems like CAR T-cell therapy -- multiscale, stochastic, spatially structured -- cross-disciplinary integration is not stylistic preference. It is a structural necessity.

Mechanistic modelling without biological grounding becomes abstraction detached from consequence.  
Biology without formalisation struggles to interrogate dynamics.  
Computation without architecture collapses under scale.

But something else is also true.

The scientific questions that will define the next generation of therapies will not wait for our institutional categories to stabilise. They will demand formalisation, simulation, calibration and iteration across scales.

If we insist on staying inside disciplinary comfort zones, we risk mischaracterising the system itself.

The *in-between* is not an intellectual compromise. It is where abstraction meets consequence. It is where unknown processes become structured hypotheses. It is where simulation informs experiment and experiment refines simulation.

If you are looking for questions worthy of your training, do not look for a department.

Look for the *in-between*.

### References

[1] Zugasti, Ines, et al. "CAR-T cell therapy for cancer: current challenges and future directions." Signal transduction and targeted therapy 10.1 (2025): 210.

[2] Luque, Luciana Melina, et al. "In silico study of heterogeneous tumour-derived organoid response to CAR T-cell therapy." Scientific reports 14.1 (2024): 12307.

[3] Compiler Research. "GSoC 2025: CARTopiaX wrap-up blog."

[4] BioDynamo Github

[5] Kosik, Ken. "Thirteen tips for engaging with physicists, as told by a biologist." Nature 577.7789 (2020): 281-284.

[6] Bohndiek, Sarah. "Twelve tips for engaging with biologists, as told by a physicist." Nature 577.7789 (2020): 283-285.

[7] Ponting, Chris P. "Genetics Needs Non-geneticists." Trends in Genetics 36.9 (2020): 629-630.

[8] Eddy, Sean R. ""Antedisciplinary" science." PLoS computational biology 1.1 (2005): e6.

[9] Luque, Luciana M. The expert illusion building confidence across disciplines.

[ref1]: https://doi.org/10.1038/s41392-025-02269-w
[ref2]: https://doi.org/10.1038/s41598-024-63125-5
[ref3]: https://compiler-research.org/blogs/gsoc25_salvador_wrapup_blog/
[ref4]: https://github.com/BioDynaMo/biodynamo
[ref5]: https://doi.org/10.1038/d41586-019-03960-z
[ref6]: https://doi.org/10.1038/d41586-019-03961-y
[ref7]: https://doi.org/10.1016/j.tig.2020.06.015
[ref8]: https://doi.org/10.1371/journal.pcbi.0010006
[ref9]: https://www.lmluque.com/blog/the-expert-illusion-building-confidence-across-disciplines