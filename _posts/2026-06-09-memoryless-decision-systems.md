---
layout: post
title: "Memoryless and Memory-Enabled Decision Systems"
date: 2026-06-09
category: notebook
tags: decision-systems memory virtual-screening evolution machine-learning
---

The score-memory idea in PLE-DR kept bothering me after I wrote it down. Not because it
felt wrong, but because it felt small — like a local trick for docking pipelines when it
might be an instance of something much larger. So I want to try defining that larger thing
as bluntly as I can and see what falls out.

<div class="text-center mt-4 mb-4">
  <img src="{{ '/assets/img/memory-matters.png' | relative_url }}" class="img-fluid rounded" style="max-width: 100%; height: auto;" alt="Memory Matters overview illustration">
</div>

Start with the simplest possible distinction.

## Two Kinds of System

A **memoryless** decision system makes each decision solely from current information, and
then forgets.

```text
Input
↓
Decision
↓
Forget
```

Examples are everywhere once you look: a single docking-score cutoff, a knockout
tournament, a stateless API, a one-time jury verdict, a reflex. The appeal is real — these
systems are fast, cheap, and scalable. They have exactly one serious weakness, and it is
fatal in the wrong setting:

> **In a memoryless system, early mistakes are permanent.**

A **memory-enabled** system lets past evidence survive and influence what comes next.

```text
Input
↓
Decision
↓
Store evidence
↓
Future decisions influenced
```

The immune system does this. So does a credit history, the scientific literature, human
expertise — and the score-memory protocol from the last note. These systems are robust to
noise, can learn from mistakes, and can recover opportunities they nearly missed. They pay
for it with complexity, and with a darker liability: **they can preserve bad information as
faithfully as good information.**

That trade is the whole subject. The interesting question is not _which kind is better_ —
it is _how much is the memory worth, and when._

## The Quantity I Actually Care About

Define memory value as

> **$V_m$ — how much better a system performs when historical information is retained, holding
> everything else fixed.**

I want to resist the temptation to leave this as a slogan. It is the same mistake consensus
docking makes with disagreement: gesturing at a thing instead of measuring it. So before
generalising to evolution and civilisations, I forced myself to compute $V_m$ in the one
domain I can actually control — virtual screening.

## A Small Experiment

The setup is deliberately synthetic, so the mechanism is visible rather than buried in real
chemistry. Six thousand compounds, each with a hidden _true_ binding quality. Four docking
engines each observe that quality through their own noise — the projection problem from the
last note, made into a knob. The genuinely best ~120 compounds are the "true hits" we would
like to keep.

Two pipelines compete:

- **Memoryless cascade** — the classic funnel. Each stage ranks the survivors by one engine
  and irreversibly discards the bottom fraction. A hit that one early engine happens to
  mis-score is gone, regardless of what later engines would have said.
- **Memory-enabled** — retain every compound's full score history, discard nothing outright,
  and rank by an uncertainty-aware aggregate:
  $\mathrm{mean}(\mathrm{scores}) + \lambda \cdot \mathrm{std}(\mathrm{scores})$. The
  $+\mathrm{std}$ term is the revisit rule from PLE-DR — a compound the engines _disagree_
  about is given the benefit of the doubt rather than thrown away.

<div class="text-center mt-4 mb-4">
  <img src="{{ '/assets/img/memory-schematic.png' | relative_url }}" class="img-fluid rounded" style="max-width: 80%; min-width: 300px; height: auto;" alt="Two decision-system architectures">
</div>

Then I measure recall: of the true hits, how many does each pipeline keep in a final
shortlist of size $L$?

<div class="text-center mt-4 mb-4">
  <img src="{{ '/assets/img/memory-recall.png' | relative_url }}" class="img-fluid rounded" style="max-width: 80%; min-width: 300px; height: auto;" alt="Recall versus shortlist size">
</div>

The shape is the entire argument. The memoryless cascade climbs, then **plateaus near 0.57
and stops** — widening the shortlist past ~200 buys nothing, because the hits it discarded in
round one cannot be recalled by any later round. "Early mistakes are permanent" is not a
metaphor here; it is the flat line. The memory-enabled pipeline keeps climbing to 0.92,
because nothing was ever truly thrown away. At a shortlist of 300 the gap is **$V_m \approx 0.28$** —
the memory pipeline recovers roughly half again as many real hits for the same experimental
budget.

That is a satisfying result, but on its own it is a sales pitch. The honest question is when
memory _stops_ being worth it.

## When Memory Stops Paying

I made the engines' errors correlated by a factor $\rho$ — at $\rho = 0$ they fail
independently, at $\rho = 1$ they all make the same mistakes (a shared systematic bias, the
"preserve bad information" failure made concrete) — and recomputed $V_m$.

<div class="text-center mt-4 mb-4">
  <img src="{{ '/assets/img/memory-vm.png' | relative_url }}" class="img-fluid rounded" style="max-width: 80%; min-width: 300px; height: auto;" alt="Memory value versus error correlation">
</div>

$V_m$ falls steadily, from about 0.27 with independent observers to about 0.12 when they share
a bias — it loses more than half its value. This is the same thesis as the disagreement note,
now stated as a quantity: **memory is worth most precisely when your observers fail
independently**, because then their private errors average away and only the signal
accumulates. When they err together, there is nothing for the accumulation to cancel.

But notice what $V_m$ does _not_ do: it does not reach zero. Even with fully shared bias,
retaining information beats forgetting it. That surprised me, and the reason is worth stating
because it corrects my own first draft of this idea. Memory's value has two components, not
one:

1. **Noise-averaging** — repeated independent observations cancel their private errors. This
   part _does_ vanish as observers become correlated.
2. **Reversibility** — never discarding means an early misjudgement is never final. This part
   has nothing to do with independence, and it persists even under shared bias.

I had assumed memory could be made _harmful_ simply by feeding it bad information. The
experiment says otherwise: a shared artifact corrupts the cascade too — it was exposed to the
same bad engines — so memory's _relative_ advantage survives. To make forgetting actually
preferable you need an asymmetry: a contaminated channel that the memory system trusts but
the cascade structurally avoids. That regime exists, but it has to be engineered; it is not
the default. The plain statement "memory can preserve bad information" is true, but it does
not by itself imply "memory is worse." That is a sharper claim than I started with, and I
trust it more for having had to find it.

## The Same Pattern, Larger

With $V_m$ defined as _information from past states that influences future decisions_, the
broad cases stop being loose analogies and start looking like the same mechanism at different
scales — though each deserves its own caution.

**Evolution** is the cleanest. Natural selection is not memoryless: genes _are_ memory, a
compressed record of which past environments rewarded which configurations. Strip out
inheritance and you get selection with a Forget step — variation that never compounds.
Selection without memory barely climbs, for the same reason the cascade's recall plateaus.

**Science** is civilisation's literature acting as durable storage. If every paper vanished
on publication, each generation would re-derive from scratch; the compounding that makes
science cumulative is exactly the Store-evidence arrow.

**Institutions** — constitutions, precedent, case law — are collective memory, which is one
honest way to read the difference between a system with accumulated precedent and a pure
direct democracy deciding each question fresh. (Here the second component bites: institutions
also preserve bad precedent faithfully, which is the cost side of $V_m$ made political.)

**Machine learning** sharpens it. A feed-forward network is largely memoryless at inference;
an RNN carries a hidden state forward; a transformer's attention is, read plainly, a memory-
retrieval mechanism over the context. The trajectory of the field has been, in part, a
steady purchase of larger and more flexible $V_m$.

I want to be careful not to over-claim the unification. These systems differ in what counts
as "evidence," in how faithfully it is stored, and in whether the bad-information cost
dominates. The pattern is a lens, not a theorem.

## The Distinction Underneath

Still, the lens suggests a reframing I keep coming back to. Maybe the sharp line is not

```text
intelligent  vs  unintelligent
```

but

```text
memory-enabled  vs  memoryless
```

— because much of what we call intelligence appears exactly when a system can accumulate
information across time and let it bear on the next decision. Two civilisations, one that
forgets each generation and must rediscover fire, agriculture, mathematics, and one that
preserves; the second's advantage is not raw cleverness. It is $V_m$.

Which brings the whole thing back to where it started. A docking cascade is just one
memoryless system among many, and most screening pipelines are memoryless by unexamined
default. The case for building them otherwise is not that memory is always good — the second
figure is precisely a map of when it is not. The case is narrower and, I think, more
defensible: **when your observers are imperfect and disagree independently, the information
you would otherwise discard is worth more than the simplicity you would gain by discarding
it.** That is a measurable claim. $V_m$ is the measurement.

That is where I'd start digging.

---

## What This Is Not

This is a toy. The compounds are synthetic, the engines are Gaussian noise rather than real
scoring functions, and the recall numbers are properties of the simulation, not of any actual
screen. The experiment demonstrates a _mechanism_ — why retaining evidence recovers hits that
irreversible filtering loses, and how that value scales with observer independence — but it
does not establish the size of $V_m$ for any real campaign. Measuring $V_m$ on a genuine library,
with real engines and experimental confirmation, is the obvious and harder next step.
