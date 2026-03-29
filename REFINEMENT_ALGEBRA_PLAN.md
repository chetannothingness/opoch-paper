# Refinement Algebra — The Real Source Code

## What Must Be Built

6 files + 2 audit files. The complete weighted algebra of refinement events.

```
Foundations/Manifestability/
  SequentialComposition.lean    — how refinements compose in time
  ParallelComposition.lean      — how independent refinements compose in space
  CoarseGraining.lean           — how distinctions are forgotten
  LatentEnergy.lean             — hidden distinction-energy U_lat
  LatentEnergyConservation.lean — the conservation law
  BinaryNormalForm.lean         — the actual binary source code

Audit/
  PreRefinementManifest.lean    — freeze baseline
  PreRefinementAxiomCensus.lean — freeze axiom count
```

## Execution Plan — 8 Steps, Strict Order

### Step 0: Freeze Baseline

Create `Audit/PreRefinementManifest.lean` and `PreRefinementAxiomCensus.lean`.
Record: current file count (188), sorry count (0), axiom count (1),
build status (green), flagship theorem hashes.

**Gate 0:** Build green. Baseline committed. No mutations yet.

---

### Step 1: SequentialComposition.lean

**Imports:** RefinementEvent, RefinementKernel

**What to define:**
- `SequentialRefinement`: two refinement events e₁ : W → {Wᵢ} and e₂ : Wⱼ → {Uₖ}
  where Wⱼ is a target of e₁
- `compose : RefinementEvent → RefinementEvent → RefinementEvent`
  The composed event goes from W to ({Wᵢ} \ {Wⱼ}) ∪ {Uₖ}
- `compose_action`: action of composed event

**What to prove:**
- `sequential_composition_well_defined`:
  The composition is a valid refinement event
  (targets are still residual classes, multiplicity conserved)
- `sequential_action_additivity`:
  A(e₂ ∘ e₁) = A(e₁) + A(e₂)
  Because: the ledger is append-only, costs accumulate
- `sequential_entropy_additivity`:
  ΔS(e₂ ∘ e₁) = ΔS(e₁) + ΔS(e₂)
  Entropy changes are additive in ordered time
- `sequential_composition_associative`:
  (e₃ ∘ e₂) ∘ e₁ = e₃ ∘ (e₂ ∘ e₁)
  Because ledger append is associative

**Proof strategy:**
- Action additivity: by definition — action of composed = sum of actions
  (define it this way, prove it's the only consistent choice)
- Associativity: from associativity of list append on the ledger
- Well-definedness: targets of composition = (targets of e₁ minus Wⱼ) union (targets of e₂)

**Gate 1:** Compiles. Zero sorry.

---

### Step 2: ParallelComposition.lean

**Imports:** RefinementEvent, SequentialComposition

**What to define:**
- `IndependentClasses`: two classes W, Z are independent if
  they share no distinctions (disjoint carriers)
- `ParallelRefinement`: two events e₁ on W and e₂ on Z
  where W and Z are independent
- `tensor : RefinementEvent → RefinementEvent → RefinementEvent`
  The parallel event refines both W and Z simultaneously

**What to prove:**
- `parallel_composition_well_defined`:
  If W and Z are independent, e₁ ⊗ e₂ is a valid event
- `parallel_action_additive`:
  A(e₁ ⊗ e₂) = A(e₁) + A(e₂)
  WHY ADDITIVE: independent refinements use disjoint resources.
  The total resource cost is the sum because the resources don't interfere.
  (This is the SAME reason χ_MAPF decomposes over independent resources.)
- `parallel_composition_commutative`:
  e₁ ⊗ e₂ = e₂ ⊗ e₁ (order doesn't matter for independent events)
- `parallel_composition_associative`:
  (e₁ ⊗ e₂) ⊗ e₃ = e₁ ⊗ (e₂ ⊗ e₃)
- `parallel_sequential_interchange`:
  Under independence, (e₁ ⊗ e₂) ∘ (f₁ ⊗ f₂) = (e₁ ∘ f₁) ⊗ (e₂ ∘ f₂)
  This is the interchange law of a monoidal category.

**The deep question: additive vs max-type.**
For INDEPENDENT resources (disjoint carriers): ADDITIVE.
  Total cost = sum of individual costs.
  This is forced because disjoint resources don't compete.
For SHARED resources (same carrier): MAX-TYPE.
  Cost = max(cost₁, cost₂) because the bottleneck limits both.
  But shared resources means the events are NOT independent.

So: parallel composition of INDEPENDENT events has additive cost.
Events with shared resources must be composed sequentially, not in parallel.
This resolves the question completely.

**Proof strategy:**
- Additivity: by definition on independent events + proof of independence
- Commutativity: from independence (no ordering)
- Interchange: from independence (no interaction between the two pairs)

**Gate 2:** Compiles. Zero sorry. Parallel action law resolved.

---

### Step 3: CoarseGraining.lean

**Imports:** RefinementEvent, ResidualClass

**What to define:**
- `CoarseGraining`: merging two classes W₁, W₂ into W = W₁ ∪ W₂
  This is the REVERSE of refinement
- `merge : ResidualClass → ResidualClass → ResidualClass`
  The merged class has multiplicity = sum of multiplicities
- `coarsen : RefinementEvent → CoarseGraining → RefinementEvent`
  Coarsening after refinement: refine then forget

**What to prove:**
- `coarsening_increases_entropy`:
  S(W₁ ∪ W₂) ≥ max(S(W₁), S(W₂))
  Merging classes never decreases entropy
- `refine_then_coarsen_ge_identity`:
  If you refine W into {Wᵢ} then merge them back, the cost is ≥ 0
  You can't get free distinctions by refining and then forgetting
- `coarsen_then_refine_le_identity`:
  If you coarsen then try to refine back to the original partition,
  it costs at least as much as the original refinement
  This IS the second law of thermodynamics as an algebraic inequality
- `coarsening_refinement_galois`:
  refine and coarsen form a Galois connection on the lattice of partitions
  refine ∘ coarsen ≥ id, coarsen ∘ refine ≤ id

**Proof strategy:**
- Entropy increase: from multiplicity addition (|W₁ ∪ W₂| = |W₁| + |W₂|)
- Galois connection: from the lattice structure of partitions
  (refinement = going down, coarsening = going up)
- Second law: from the Galois connection + entropy monotonicity

**Gate 3:** Compiles. Zero sorry. Second law as algebraic theorem.

---

### Step 4: LatentEnergy.lean

**Imports:** RefinementThreshold, ResidualClass

**What to define:**
- `LatentEnergy`: the total hidden distinction-energy in a partition P
  U_lat(P) = Σ_{W ∈ P} ρ(W) · χ(W)
  where ρ(W) is the multiplicity/weight of class W
- For the finite version: ρ(W) = W.multiplicity, χ(W) = threshold.chi
  U_lat = Σ multiplicity × chi over all classes in the partition

**What to prove:**
- `latent_energy_nonneg`:
  U_lat ≥ 0 (all terms are non-negative)
- `latent_energy_well_defined`:
  U_lat depends only on the partition, not on the labeling
- `latent_energy_zero_iff_fully_resolved`:
  U_lat = 0 iff every class is a singleton (nothing left to refine)
- `latent_energy_decreases_on_refinement`:
  If W is refined to {Wᵢ}, the new latent energy is ≤ old latent energy
  Because: the split resolves some distinction, reducing unresolved energy

**Proof strategy:**
- Non-negativity: from chi_nonneg and multiplicity ≥ 1
- Zero iff resolved: from chi = 0 for singletons (no nonconstant witnesses)
- Decrease on refinement: from the definition of chi as infimum

**Gate 4:** Compiles. Zero sorry.

---

### Step 5: LatentEnergyConservation.lean

**Imports:** LatentEnergy, RefinementEvent, SequentialComposition

**What to define:**
- `ExplicitEnergy`: the total energy that has been ledgered
  U_explicit(t) = Σ actions spent so far
- `TotalEnergy`: latent + explicit
  U_total = U_lat + U_explicit

**What to prove:**
- `latent_energy_conservation`:
  U_lat(t+1) - U_lat(t) = -(action spent at step t)
  When you refine (spend action A), latent energy decreases by
  at least A (you resolved a distinction worth at least A)
- `total_energy_monotone`:
  U_total(t+1) ≤ U_total(t)
  Total energy never increases (distinction-energy is conserved or dissipated)
- `explicit_energy_monotone`:
  U_explicit only increases (ledger is append-only)

**The conservation law:**
  U_lat(t) + U_explicit(t) ≥ U_lat(t+1) + U_explicit(t+1)
  is NOT exact equality but an inequality — because some energy
  may be dissipated (lost to gauge). Exact equality holds when
  ALL refinement action converts perfectly to resolved distinction.

**Proof strategy:**
- From the definitions: U_explicit increases by A(e) at each step
- U_lat decreases by at least A(e) because chi was the infimum
- Therefore U_total is non-increasing

**Gate 5:** Compiles. Zero sorry. Energy conservation as algebraic inequality.

---

### Step 6: BinaryNormalForm.lean

**Imports:** RefinementEvent, SequentialComposition, ResidualClass

**What to define:**
- `BinaryCode`: κ(W) — a canonical binary encoding of a residual class
  κ : ResidualClass → List Bool
- `BinaryUpdate`: the deterministic transition function on binary codes
  F(κ(W), α) = (κ(W₁), ..., κ(Wᵣ), A, ΔS, ΔV)
- `RefinementHistory`: a sequence of binary codes and channel labels
  representing the complete history of refinement

**What to prove:**
- `binary_code_well_defined`:
  Gauge-equivalent classes get the same code
- `binary_code_injective`:
  Different (non-equivalent) classes get different codes
- `binary_update_deterministic`:
  Same code + same channel → same output (no nondeterminism)
- `binary_normal_form_exact`:
  Every refinement history has a unique canonical normal form
  (sequences that differ only by reordering of independent events
  are identified — the interchange law makes this well-defined)
- `binary_normal_form_complete`:
  Every valid binary code sequence corresponds to a valid refinement history

**Proof strategy:**
- Code well-definedness: from gauge invariance of residual classes
- Injectivity: from the quotient being complete (no two distinct classes
  are mapped to the same code)
- Determinism: from the deterministic nature of refinement
  (A0* forces unique outcomes for given state + channel)
- Normal form: from the interchange law (parallel events commute)
  and sequential associativity

**Gate 6:** Compiles. Zero sorry. The actual binary source code.

---

### Step 7: Verify Everything

- `lake build` — GREEN
- `grep sorry` — 0
- `grep axiom` — 1 (A0star)
- All new theorems compile
- All existing theorems still compile (no regressions)
- Total files: 188 + 8 = 196

**Gate 7:** Everything green. The source code is complete.

---

### Step 8: Commit and Push

Single commit message:
"Refinement Algebra: the complete source code of reality.
 6 new files completing the weighted composition law.
 Sequential + parallel composition, coarse-graining adjunction,
 latent energy + conservation, binary normal form.
 Zero sorry. One axiom. 196 files."

---

## The Flagship Theorems

```
sequential_action_additivity      — A(e₂ ∘ e₁) = A(e₁) + A(e₂)
parallel_action_additive          — A(e₁ ⊗ e₂) = A(e₁) + A(e₂) for independent
parallel_sequential_interchange   — (e₁⊗e₂)∘(f₁⊗f₂) = (e₁∘f₁)⊗(e₂∘f₂)
coarsening_refinement_galois      — refine and coarsen form Galois connection
latent_energy_conservation        — U_lat + U_explicit is non-increasing
binary_update_deterministic       — same code + same channel → same output
binary_normal_form_exact          — every history has unique canonical form
```

## What This Achieves

When these compile:
- Sequential composition = how time works algebraically
- Parallel composition = how space works algebraically
- Coarse-graining = why entropy increases (second law as theorem)
- Latent energy = what dark energy IS (unresolved distinction-energy)
- Conservation = why energy is conserved (algebraic inequality)
- Binary normal form = the actual machine code of reality

Not a theory OF the universe. The universe's own computation, in Lean.
