---
layout: page
title: Prot2Prop
description: Structure-aware fine-tuning of protein language models for joint prediction of multiple developability properties from protein structure inputs.
importance: 4
category: Research
github: https://github.com/NeurosnapInc/Prot2Prop
---

Prot2Prop trains a shared adapter with lightweight task-specific residual adapters and heads on top of a structure-aware protein language model, jointly predicting developability properties such as thermal stability, aggregation propensity, solubility, and oligomerization state. It targets a gap in the current ecosystem, where most tools handle these properties with separate, older, task-specific models rather than a unified, modern, structure-aware one.
