---
layout: post
title: "A Battle Against Brute Forcing Information Asymmetry"
date: 2026-06-07
category: notebook
tags: docking consensus-docking machine-learning drug-discovery uncertainty
---

Drug discovery is often portrayed as a problem of scale:

- **Millions** of molecules.
- **Thousands** of targets.
- **Billions** of possible interactions.

The intuitive response has always been the same: increase computation. Screen more compounds. Run more simulations. Build larger clusters. Search harder.

This logic is seductive because it has sometimes worked. High-throughput virtual screening pipelines, enabled by cheap cloud compute and increasingly fast docking engines, have expanded the chemical space accessible to early-stage discovery. Projects that once required months of manual enumeration can now be seeded with hundreds of millions of compounds in days.

But over time I became convinced that scale is not the real enemy.

> **The enemy is information asymmetry.**

And scaling computation does not necessarily reduce information asymmetry. Sometimes it merely amplifies it.

---

## What Docking Actually Does

To understand the problem, it helps to be precise about what a docking engine actually computes.

Molecular docking attempts to predict the preferred binding pose and affinity of a small molecule within a protein binding site. The process involves two coupled problems: a **search problem** (sampling the conformational and translational space of the ligand) and a **scoring problem** (ranking those sampled poses according to an estimated binding free energy).

Both problems are hard. Protein binding sites are non-rigid. Solvation effects are difficult to model. Entropic contributions to binding are notoriously difficult to estimate without extensive simulation. The approximations made by any particular docking engine are therefore numerous, often implicit, and rarely identical across programs.

When a docking engine evaluates a molecule, it does not observe reality. It observes a **projection** of reality through a particular scoring function, force field, search algorithm, and set of assumptions. Every engine sees a different world:

- **AutoDock Vina** weights hydrophobic contacts, hydrogen bond geometry, and rotational entropy using an empirical scoring function trained on experimental binding data.
- **Glide** (Schrödinger) emphasizes shape complementarity and electrostatics, incorporating a grid-based energy representation and additional GlideScore terms.
- **GOLD** applies a genetic algorithm search with a fitness function emphasizing hydrogen bond and van der Waals contributions.
- **PLANTS** uses ant colony optimisation with a CHEMPLP scoring function that rewards metal-ligand coordination and lipophilic complementarity.

Each produces rankings that appear authoritative. Each is grounded in genuine physics and validated against real data. Yet in practice, when the same library of compounds is screened against the same target by these four programs, the top-ranked compounds often share surprisingly little overlap.

This is not a software bug. It is a fundamental consequence of the projection problem.

---

## Disagreement as a Source of Knowledge

Traditionally, disagreement is treated as failure.

Consensus docking methods were developed to suppress this disagreement, averaging or rank-aggregating predictions until a single ordered list emerges. The logic is statistical: if multiple independent estimators point to the same answer, confidence should increase. Molecules that fail to satisfy the consensus are discarded. The assumption is simple: if experts disagree, reduce confidence.

Yet this assumption contains a hidden flaw.

> **Disagreement is not always evidence of error.**
>
> Sometimes disagreement is evidence of missing information.

Consider the distinction carefully. When two people observing the same event give contradictory accounts, one common interpretation is that one of them is wrong. But another interpretation — often more interesting — is that they observed different aspects of the same event, neither of which is sufficient alone to characterise the full picture.

Imagine three explorers mapping a landscape from three different mountains. If all three describe the same valley, confidence is justified. But if their maps differ dramatically, it does not necessarily mean one of them is wrong. It may mean that the terrain is more complex than any single viewpoint can capture.

In computational drug discovery, this landscape is the binding free energy surface of the target. Each docking engine is an explorer standing on a different mountain, using different instruments. Disagreement between their maps does not indicate that the terrain is absent — it indicates that it has not yet been fully resolved.

These **regions of inter-engine disagreement** may contain some of the most pharmacologically interesting molecules in the entire screening library. Yet traditional consensus pipelines systematically eliminate them, treating unresolved uncertainty as negative signal rather than as an invitation to investigate further.

---

## The Cost of Early Elimination

The practical consequence of this is worth dwelling on.

In a typical high-throughput virtual screening campaign, an initial library of millions of compounds passes through a succession of computational filters. Each filter discards compounds that fail to meet its criterion, progressively narrowing the list toward a manageable set for experimental validation. This funnel model is operationally sensible — experimental resources are finite, and filters are cheap.

The problem is that most filters, including consensus docking filters, are applied **irreversibly**. A compound eliminated in round one cannot be reconsidered in round two, regardless of what round two might reveal about it.

This irreversibility is not a design choice. It is typically an unexamined default — a consequence of treating each filtering stage as a classification problem with a binary output: keep or discard.

What if the output were instead: **keep, discard, or revisit**?

This third category is not common in virtual screening literature, but it corresponds to something real. There are molecules that a single docking engine dislikes for reasons that may be artefactual — ligands whose flexibility confuses the search algorithm, scaffolds whose polarity profile is penalised by one scoring function but rewarded by another, compounds near the boundary of the force field parameterisation space.

These are precisely the molecules where inter-engine disagreement would be expected to be highest. And they are the molecules that irreversible filtering pipelines are most likely to eliminate.

---

## The Philosophy of PLE-DR

The philosophy behind PLE-DR (Potential-Landscape Ensemble Disagreement Ranking) emerged from a simple question:

> _What if disagreement itself is information?_

Instead of interpreting inter-engine disagreement as noise to be suppressed, I began to view it as a signal worth preserving — a marker of **epistemic uncertainty** rather than of molecular inadequacy.

The conceptual shift is significant. Noise suppression is a lossy operation. It destroys information by averaging it away. Uncertainty quantification is a conservative operation. It attempts to retain information by tagging it with its confidence level and deferring the discard decision to a later stage when more evidence might be available.

In practice, this meant redesigning the scoring pipeline around several principles:

**1. Score memory across layers.** Rather than allowing each filtering stage to begin with a clean slate, the system accumulates a persistent record of each compound's scoring history across all docking engines. A compound that scores poorly in Glide but exceptionally in PLANTS does not receive the average of these two scores. It receives a flag indicating unresolved disagreement, and this flag is propagated forward.

**2. Disagreement as a reactivation signal.** Compounds that had been tentatively deprioritised by one layer could be reactivated if their cross-engine disagreement score exceeded a defined threshold. The logic is conservative: do not discard until the disagreement has been explained.

**3. Uncertainty-weighted ranking.** Final compound selection was performed not by raw score rank but by a compound ranking function that explicitly incorporated both predicted affinity and estimated uncertainty. High-uncertainty, moderate-affinity compounds were intentionally preserved alongside high-confidence, high-affinity compounds.

The resulting framework was not designed to brute force the chemical universe more aggressively. It was designed to recover information that would otherwise be lost.

---

## Fungal Hsp90 as a Test Case

The methodology was developed and validated in the context of antifungal drug discovery, specifically targeting **fungal Hsp90** — heat shock protein 90 as expressed in pathogenic fungi including _Candida albicans_ and _Aspergillus fumigatus_.

Hsp90 is a molecular chaperone that stabilises a wide range of client proteins involved in signal transduction, cell cycle regulation, and stress response. In fungi, it is essential for virulence and for the acquisition and maintenance of drug resistance. Inhibition of fungal Hsp90 has been demonstrated to resensitise resistant strains to existing antifungal agents, making it a particularly attractive target in the context of a global antifungal resistance crisis.

The fungal Hsp90 ATP-binding pocket shares structural similarity with human Hsp90 but contains sufficient sequence divergence — most notably around residues lining the adenine-binding sub-pocket — to make selective inhibition theoretically achievable.

This selectivity window is narrow, however. Many existing Hsp90 inhibitor scaffolds (geldanamycin derivatives, resorcinol-based compounds, purine analogues) bind both fungal and human Hsp90 with comparable affinities, creating a therapeutic window too small for clinical use. Identifying compounds that exploit the structural differences between fungal and human Hsp90 requires docking to both structures and carefully interpreting the differential signal.

This is exactly the regime where information asymmetry is most dangerous. A compound that appears equally potent against both targets in Glide might appear selectively active in GOLD, but be deprioritised by a consensus filter. PLE-DR was designed to surface these cases rather than suppress them.

---

## Epistemology in Virtual Screening

In retrospect, the project became less about docking and more about epistemology.

> _How should a rational system behave when multiple imperfect observers disagree?_

This is one of the oldest problems in philosophy of science, and it does not have a fully satisfying answer. Bayesian inference offers a partial framework: treat disagreement as evidence that updates a prior probability distribution, rather than as a verdict requiring a binary outcome. This is elegant in theory, and there are attempts to apply Bayesian scoring functions in docking — but the prior distributions required are rarely available in practice, and calibration of docking score uncertainties remains an open problem.

The approach taken in PLE-DR was more pragmatic: use the empirical distribution of cross-engine scores as a proxy for uncertainty, without claiming that this proxy is theoretically grounded in any strict Bayesian sense. The claim is weaker and more defensible: _when docking engines disagree substantially, we have less evidence than when they agree, and this should affect how aggressively we discard._

Human beings face this problem constantly and have developed institutional mechanisms to manage it. Scientific peer review exists partly to surface disagreement before it becomes invisible. Clinical trials are designed to measure disagreement between treatment and control arms. Courts of law maintain the presumption of innocence — a formal acknowledgment that absence of agreement is not equivalent to evidence of guilt.

Scientific progress itself is largely a process of navigating conflicting evidence. The history of science is full of cases where premature consensus suppressed a correct minority view: continental drift, prion diseases, H. pylori and peptic ulcer disease. In each case, the epistemic crime was not having the wrong theory but having too much confidence in it.

The same risk applies to virtual screening. The future of computational drug discovery may not belong solely to larger datasets, larger models, or larger compute budgets. It may belong to methods that are more honest about what they do not know — and that are designed to preserve, rather than destroy, the signal contained in that uncertainty.

---

## What This Is Not

It is worth being clear about the limits of this work.

PLE-DR is not a validated experimental workflow. The compounds it would prioritise have not been synthesised and tested. The cross-engine disagreement scores it generates have not been shown, in a controlled experiment, to correlate with experimental hit rates better than conventional consensus ranking. These validations remain to be done.

It is also not a general theory of uncertainty in drug discovery. The specific approach — using inter-engine score variance as an uncertainty proxy — is one of many possible operationalisations, and not obviously the best one. Alternatives based on ensemble molecular dynamics, machine learning confidence calibration, or Bayesian graph neural networks may ultimately prove more principled.

What it is, I think, is a **conceptual reorientation**: a shift from asking _which molecules does my model prefer?_ to asking _in which regions of chemical space is my model's knowledge least reliable, and what should I do about that?_

This reorientation does not require PLE-DR specifically. It requires only the recognition that computational screens are not oracles, and that the shape of their uncertainty is information.

---

## A Small Battle

At its heart, this work is a small battle against brute forcing information asymmetry.

Not a decisive battle. Not a solved problem. A single engagement in a much longer campaign that computational drug discovery will have to wage if it wants to be more than a very fast way of being very confidently wrong.

The belief driving it is simple: when knowledge is incomplete, the answer is not always to compute harder. Sometimes the answer is to compute more carefully. Sometimes it is to acknowledge what you cannot yet know, and to build systems that preserve that acknowledgment rather than discard it.

Because the challenge was never merely searching chemical space. The challenge was learning how to see what our models could not.

And sometimes the answer is to listen more carefully to the places where our tools disagree.

That is where the interesting chemistry is hiding.
