---
layout: post
title: "A Battle Against Brute Forcing Information Asymmetry"
date: 2026-06-07
category: notebook
tags: docking consensus-docking machine-learning drug-discovery uncertainty
---

Drug discovery is often portrayed as a problem of scale.

Millions of molecules.
Thousands of targets.
Billions of possible interactions.

The intuitive response has always been the same: increase computation. Screen more compounds. Run more simulations. Build larger clusters. Search harder.

But over time I became convinced that scale is not the real enemy.

The enemy is information asymmetry.

When a docking engine evaluates a molecule, it does not observe reality. It observes a projection of reality through a particular scoring function, force field, search algorithm, and set of assumptions. Every engine sees a different world.

One engine sees shape complementarity.

Another sees electrostatics.

A third emphasizes hydrogen bonding.

Each produces rankings that appear authoritative, yet often disagree dramatically.

Traditionally, disagreement is treated as failure.

Consensus methods were developed to suppress disagreement, averaging predictions until a single answer emerges. Molecules that fail to satisfy the consensus are discarded. The assumption is simple: if experts disagree, confidence should decrease.

Yet this assumption contains a hidden flaw.

Disagreement is not always evidence of error.

Sometimes disagreement is evidence of missing information.

Imagine three explorers mapping a landscape from different mountains. If all three describe the same valley, confidence is justified. But if their maps differ dramatically, it does not necessarily mean one of them is wrong. It may mean that the terrain is more complex than any single viewpoint can capture.

In computational drug discovery, these regions of disagreement may contain some of the most interesting molecules in the entire search space.

Traditional screening pipelines eliminate them.

The philosophy behind PLE-DR emerged from a simple question:

What if disagreement itself is information?

Instead of interpreting inter-engine disagreement as noise, I began to view it as uncertainty. And uncertainty is valuable. It marks regions where our models possess the least knowledge and where potentially important compounds may be hiding.

The resulting framework was not designed to brute force the chemical universe more aggressively. It was designed to recover information that would otherwise be lost.

Compounds rejected by one layer could be reactivated if disagreement suggested unresolved uncertainty. Information was allowed to persist across layers through score memory rather than being destroyed by early elimination. The objective shifted from filtering molecules to preserving evidence.

In this sense, the project became less about docking and more about epistemology.

How should a system behave when multiple imperfect observers disagree?

Human beings face this problem constantly. Scientific progress itself is largely a process of navigating conflicting evidence. We rarely discover truth by silencing disagreement. More often, we discover truth by investigating it.

The same principle may apply to virtual screening.

The future of computational drug discovery may not belong solely to larger datasets, larger models, or larger compute budgets. It may belong to methods that better understand uncertainty and extract value from disagreement.

Because the challenge was never merely searching chemical space.

The challenge was learning how to see what our models could not.

At its heart, this work is a small battle against brute forcing information asymmetry.

A belief that when knowledge is incomplete, the answer is not always to compute harder.

Sometimes the answer is to listen more carefully to the places where our tools disagree.
