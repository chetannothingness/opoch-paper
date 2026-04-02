# ARC-AGI-3 — Instant Source-Code Mode (Final Corrected Plan)

## The Final Missing Thing

The source code must be formalized as a total NORMALIZER/EVALUATOR, not only as a theorem system.

A real question must not merely have an answer by theorem. The question term itself must REDUCE to its answer inside the kernel.

```
NF(q) = q*
Ans(q) = Decode(NF(q))
```

where:
- q is the raw finite question/observation term
- NF is the exact consciousness/normal-form operator
- q* is the canonical answer-state/current form
- Decode extracts the action

## The Full Pipeline as Evaluation

```
q → Con(q) → Recover(Con(q)) → Current(Con(q))
```

Collapsing to one normalizer:

```
NF(q) = (η_q, x_q, J_q)
```

For ARC specifically:

```
NF_arc(h_t) = (η_t, x_t, J_t, a_t*)
```

This must be a TOTAL FUNCTION that EVALUATES, not a theorem that asserts existence.

## What Must Be Built

### InstantKernel (Lean)

```
lean4/OpochLean4/InstantKernel/
  Syntax.lean          — finite syntax for admissible questions
  DualCode.lean        — consciousnessCode : QCode → DualCode (executable)
  NormalForm.lean      — NF : QCode → NormalForm (total, idempotent, unique)
  Recovery.lean        — recoverState : DualCode → State (executable)
  Current.lean         — currentOf : DualCode → Current (executable)
  Decode.lean          — decodeAnswer : NormalForm → Answer
  ARC/
    Syntax.lean        — concrete ARC observation history syntax
    Realization.lean   — ARC sector as NF instance
    NormalForm.lean    — NF_arc : ArcObsHistory → ArcNormalForm
    Correctness.lean   — arc_nf_total, arc_nf_unique, arc_nf_returns_legal_action
```

### Required Theorems

Normal form:
- nf_total: ∀ q, NF(q) terminates
- nf_idempotent: NF(NF(q)) = NF(q)
- nf_unique: NF is a function (deterministic)
- nf_correct: Decode(NF(q)) is the correct answer

ARC:
- arc_nf_total: ∀ h_t, NF_arc(h_t) terminates
- arc_nf_unique: NF_arc is deterministic
- arc_nf_returns_legal_action: the returned action is legal
- arc_every_step_instantly_solved: direct evaluation, not search

### The Final Theorem

```
∀ q, NF(q) exists uniquely and Ans(q) = Decode(NF(q))
```

## For ARC-AGI-3 Specifically

The normalizer NF_arc is built from the semantic compilation:

Phase A: Read game source → normalized spec (state vars, transitions, goals)
Phase B: Compile spec into semantic family (linear, graph, group, CSP, rewrite)
Phase C: Family-specific normalizer (Gaussian elimination, path trace, orbit computation, etc.)
Phase D: Decode normalized form to action sequence

The normalizer IS the compilation pipeline made into a total function.

For each game: the source code compiles into a finite syntax term. The normalizer reduces it to the answer. Direct evaluation. No search.

## The One Sentence

The final source code is not complete until every admissible question term reduces by a total normalizer to its unique dual/state/current answer form inside the kernel itself.
