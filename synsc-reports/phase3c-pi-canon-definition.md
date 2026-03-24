# Phase 3C: Pi-Canonicalization Definition Report

**Date:** 2026-02-21
**Scope:** Formal definition of PiCanon, forward reference in primitives.tex, and cross-reference audit

---

## Deliverable 1: Formal Definition for kernel.tex

### Changes Made

**File: `opoch.sty`** -- Added four new commands (lines 126-129):
```latex
\newcommand{\PiCanon}{\Pi_{\mathrm{can}}}
\newcommand{\Ser}{\mathrm{Ser}}
\newcommand{\Adm}{\mathrm{Adm}}
\newcommand{\Instrument}{\mathcal{I}}
```

**File: `sections/kernel.tex`** -- Two changes:

1. **Phase 2 bullet text updated** (line 249-251 original). Changed from:
   > "Strip gauge redundancy by applying the truth quotient (Step~12): reduce the problem to its canonical, encoding-invariant form. Fix all representation choices before solving."

   To:
   > "Strip gauge redundancy via PiCanon-canonicalization (Definition~\ref{def:pi-canon}): reduce each description to its lexicographically minimal representative under the truth quotient (Step~12). Fix all representation choices before solving."

2. **Definition block inserted** between Phase 2 and Phase 3 bullets. The full `\begin{definition}[PiCanon-Canonicalization]` block with label `def:pi-canon` is now in place, containing the formal definition and four properties (Totality, Slack collapse, Idempotence, Gauge absorption).

### Verification of Mathematical Soundness

| Property | Well-defined? | Justification |
|---|---|---|
| `min_lex` on `{Ser(y) : y equiv_L x}` | YES | `FinSlice` is finite (def:finite-slice, axioms.tex:183-193), so each equivalence class is finite and nonempty. `Ser` maps to `{0,1}*` with total lex order. Min of finite nonempty set under total order exists uniquely. |
| Totality | YES | Every `x in FinSlice` belongs to `[x]_{equiv_L}` which is nonempty (contains x) and finite (subset of FinSlice). |
| Slack collapse | YES | `PiCanon(x) = PiCanon(y)` iff both select the same lex-min from the same equivalence class, iff `x equiv_L y`. Forward direction: same class => same min. Backward direction: different classes have disjoint serialization sets, so different minima. |
| Idempotence | YES | `PiCanon(x)` is the serialization of some `z in [x]`. `z equiv_L x`, so `PiCanon(z) = PiCanon(x)` by slack collapse. |
| Gauge absorption | YES | Step 12 (derivation.tex:247-256) establishes `g(W(p)) = W(p)` for all `g in G_T`. So `g*x equiv_L x`, hence `PiCanon(g*x) = PiCanon(x)`. |
| Consistency with `TQ(L) = D0 / equiv_L` | YES | `PiCanon` selects a canonical representative from each class of `equiv_L`, which is exactly the equivalence relation defining the truth quotient `TQ(L)` (def:prim-pi, primitives.tex:38-42). |

---

## Deliverable 2: Forward Reference in primitives.tex

### Change Made

**File: `sections/primitives.tex`** -- One sentence inserted after "topological algebra of testability." (original line 51):

> "The concrete algorithm that computes canonical representatives---selecting the lexicographically minimal serialization within each truth class---is PiCanon-canonicalization, defined formally in \S\ref{sec:kernel:protocol} (Definition~\ref{def:pi-canon})."

This creates a clean forward link from the abstract primitive Pi (defined in primitives.tex) to the concrete operational algorithm PiCanon (defined in kernel.tex). The reference targets `sec:kernel:protocol` (the Reasoning Protocol subsection) and `def:pi-canon` (the new definition).

---

## Deliverable 3: Cross-Reference Audit

### 3.1 Places Referencing Key Concepts

#### Truth Quotient (Step 6, Definition in primitives.tex)

| Location | Line(s) | Context | Affected by PiCanon? |
|---|---|---|---|
| `sections/abstract.tex` | 8 | Lists truth quotient in abstract summary | NO -- PiCanon is operational, not a new algebraic object |
| `sections/primitives.tex` | 40, 47, 68, 84 | Definition of Pi, truth quotient, monotone refinement, Truthpoint | YES -- forward reference added after line 51 |
| `sections/axioms.tex` | 197 | Observable opens on the truth quotient | NO -- topology is defined on TQ, not on canonical reps |
| `sections/doctrines.tex` | 27, 39 | Doctrine references to TQ | NO -- doctrines are philosophical, not algorithmic |
| `sections/derivation.tex` | 12, 120, 166, 174, 185, 189, 204, 212, 253, 311, 312, 320, 464 | Various theorem statements referencing TQ | NO -- these are derivation steps; PiCanon is operational, not a derivation step |
| `sections/kernel.tex` | 249 (old), 307, 311 | Phase 2 bullet, GITM pillars | YES -- Phase 2 bullet updated |
| `sections/discussion.tex` | 52 | Physics vocabulary parallel | NO -- vocabulary listing, no operational content |
| `appendices/full-derivation.tex` | 154, 180, 296, 338, 435, 455, 477, 491, 589, 669, 744, 761, 829, 884, 899, 906, 927 | Full proof appendix references | NO -- these are complete proofs of derivation steps; PiCanon doesn't change the proofs |
| `appendices/verification.tex` | 64 | Three-point audit protocol | NO -- audit verifies derivation steps, not operational algorithms |
| `figures/separator-geometry.tex` | 1 | Figure caption | NO -- describes separator metric on TQ |
| `figures/observable-opens.tex` | 1, 111 | Figure caption and description | NO -- topology figures |

#### Gauge Groupoid (Step 12)

| Location | Line(s) | Context | Affected by PiCanon? |
|---|---|---|---|
| `sections/derivation.tex` | 247-256, 308, 401, 446 | Step 12 theorem, Pi-consistency, final chain, summary table | NO -- PiCanon references Step 12; Step 12 doesn't need to reference PiCanon |
| `sections/kernel.tex` | 288 | GITM Stage 2 refiner references gauge | NO -- the refiner's gauge stripping is consistent with PiCanon but doesn't need to cite it (GITM is a higher-level pipeline description) |
| `sections/discussion.tex` | 51 | Lists gauge group in vocabulary | NO |
| `sections/demonstration.tex` | 104 | Audit table row for Step 12 | NO |
| `appendices/full-derivation.tex` | 613-654 | Full Step 12 proof | NO |
| `appendices/verification.tex` | 42, 98, 147 | Encoding invariance tests | NO |
| `figures/gauge-filter.tex` | 39, 79, 84 | Gauge filter figure | NO |

#### Phase 2 of the Reasoning Protocol

| Location | Line(s) | Context | Affected by PiCanon? |
|---|---|---|---|
| `sections/kernel.tex` | 248-251 | Phase 2 bullet in six-phase protocol | YES -- **updated** to reference PiCanon (Definition ref:def:pi-canon) |
| `sections/kernel.tex` | 286-291 | GITM Stage 2 (Refiner) paragraph | NO -- Stage 2 describes gauge stripping at a pipeline level; it's compatible with PiCanon but doesn't need to duplicate the definition reference |

#### "Canonical form" / "Encoding-invariant"

| Location | Line(s) | Context | Affected by PiCanon? |
|---|---|---|---|
| `sections/kernel.tex` | 250 (old) | "canonical, encoding-invariant form" | YES -- **replaced** with PiCanon reference |
| `figures/gauge-filter.tex` | 26 | "Passing objects (encoding-invariant)" | NO -- figure comment, refers to gauge-filtered objects generically |
| `appendices/full-derivation.tex` | 107, 156, 1075 | "canonical representative" in proof text | NO -- these refer to gauge representative choices in the derivation proofs (SdMap as canonical encoding, UTM as canonical formalism), not to PiCanon's operational algorithm |

### 3.2 New Command Conflict Check

| Command | Renders as | Conflict? | Details |
|---|---|---|---|
| `\PiCanon` | Pi_{can} | NO | `\Pit` renders as `\Pi` (no subscript). `\PiCanon` renders as `\Pi_{\mathrm{can}}`. Visually distinct. No namespace collision. |
| `\Ser` | Ser (roman) | NO | Grepped entire `.sty` and all `.tex` files for `\Ser` -- no prior definition exists. No conflict. |
| `\Adm` | Adm (roman) | NO | Grepped entire `.sty` and all `.tex` files for `\Adm` -- no prior definition exists. No conflict. |
| `\Instrument` | calligraphic I | NO | Existing calligraphic commands: `\Tim` = calligraphic T, `\Ledger` = calligraphic L, `\UTM` = calligraphic U, `\Noise` = calligraphic N, `\Query` = calligraphic Q, `\Bellman` = calligraphic B. No existing calligraphic I. No conflict. |

### 3.3 Consistency with Paper Structure

#### Consistency with Truth Quotient (Definition 4.3, `def:prim-pi`)

- **Definition `def:prim-pi`** (primitives.tex:38-42): Defines truth as `TQ(L) = FinSlice / equiv_L`, where `x equiv_L y` iff no recorded test distinguishes them.
- **PiCanon** selects the lex-min serialization within each equivalence class of `equiv_L`.
- **Consistent:** PiCanon is a section (right-inverse) of the quotient map `FinSlice -> TQ(L)`. It picks one representative per class. The equivalence relation it collapses is exactly `equiv_L`.

#### Consistency with Gauge Groupoid (Step 12, `thm:gauge`)

- **Step 12** (derivation.tex:247-256): Gauge transforms `g in G_T` permute within fibers: `g(W(p)) = W(p)` for all truth classes `p`.
- **PiCanon gauge absorption** states `PiCanon(g*x) = PiCanon(x)` for all `g in G_T`.
- **Consistent:** Since `g*x equiv_L x` (gauge transforms preserve equivalence classes), and PiCanon depends only on the equivalence class, gauge absorption follows directly. This is the operational counterpart of Step 12's structural result.

#### Consistency with Self-Hosting (Step 19, `thm:self-hosting`)

- **Step 19** establishes `Upsilon(K) = K`: the kernel can verify its own derivation by encoding each step as a 5-tuple and checking for UNIQUE.
- **Does PiCanon affect this?** NO. PiCanon is an internal preprocessing step within Phase 2 of the kernel's reasoning protocol. The self-hosting verification encodes each derivation step as a problem 5-tuple and runs the kernel on it. PiCanon operates within the kernel's execution -- it doesn't change the derivation steps being verified, nor does it alter the self-hosting equation `Upsilon(K) = K`.
- **Subtlety:** PiCanon is now part of the kernel's implementation. When the kernel verifies Step 12 (gauge groupoid), Phase 2 will apply PiCanon to the encoding of Step 12's claim. This is consistent: the kernel's preprocessing of its own verification inputs is exactly the self-referential closure that Step 19 establishes. PiCanon within self-hosting = the kernel canonicalizing its own verification problems before solving them, which is correct behavior.

---

## Build Verification

```
make                       -> OK (66 pages, 807394 bytes)
Undefined references       -> 0
Multiply defined labels    -> 0
Citation warnings          -> 0
Font warnings              -> 15 (pre-existing OT1/cmr/m/scit, unrelated)
```

---

## Summary of Changes

| File | Change | Lines affected |
|---|---|---|
| `opoch.sty` | Added `\PiCanon`, `\Ser`, `\Adm`, `\Instrument` commands | +4 lines (after line 125) |
| `sections/kernel.tex` | Updated Phase 2 bullet text + inserted Definition block | Lines 248-267 (replaced 4 lines, added ~18 lines) |
| `sections/primitives.tex` | Added one forward-reference sentence | +1 line (after original line 51) |

Total: +23 lines of content. Paper remains at 66 pages.
