# Refinement Algebra — Final Plan

## The Target

```
theorem refinement_algebra_theorem :
  All local becoming factors through a state-enriched weighted braided
  monoidal refinement multicategory of residual classes.
```

15 files in `Foundations/RefinementAlgebra/`. Concrete finite structures first.

---

## The 15 Files — Strict Order

### File 1: ResidualClass.lean
Import from existing Manifestability. Re-export with multiplicity, entropy.
No new content — bridge file.

### File 2: RefinementEvent.lean
Extended event with ALL fields:
- source W, targets [W₁,...,Wᵣ], channel α
- action A(e), entropy drop ΔS(e), value gain ΔV(e)
- ledger update ΔL(e), channel/back-reaction update ΔC(e)
- witness, admissibility

### File 3: RefinementKernel.lean
The full rule:
(W, α, {Wᵢ}) → (A, ΔS, ΔV, ΔL, ΔC, {Wᵢ})
Prove: chi_is_infimum (χ is only the support function)

### File 4: SequentialComposition.lean
TREE GRAFTING, not pairwise:
e₂ ∘ⱼ e₁ : W → (W₁,...,U₁,...,Uₘ,...,Wᵣ)
where e₂ replaces child j of e₁.
Prove:
- sequential_composition_well_defined
- sequential_action_additivity: A(e₂ ∘ⱼ e₁) = A(e₁) + A(e₂)
- history_entropy_telescopes: total ΔS = Σ local ΔS

### File 5: Independence.lean
Formal independence W ⊥ Z:
- disjoint witness support (no witness nonconstant on both)
- disjoint resource support
Prove:
- independence_symmetric
- independence_stable_under_refinement

### File 6: ParallelComposition.lean
Tensor e₁ ⊗ e₂ ONLY for independent sectors.
Prove:
- parallel_composition_well_defined
- parallel_commutative (for independent)
- parallel_associative (for independent)
- parallel_sequential_interchange

### File 7: WorkSpan.lean
TWO action projections:
- A_work(e₁ ⊗ e₂) = A(e₁) + A(e₂) — total burden
- A_span(e₁ ⊗ e₂) = max(A(e₁), A(e₂)) — synchronized threshold
Prove:
- parallel_work_additivity
- parallel_span_max
- chi_is_span_projection (χ = projection onto span side)

### File 8: CoarseGrainingAdjunction.lean
Partition-order adjunction:
Ref(P) ≼ Q ↔ P ≼ Cg(Q)
Prove:
- coarse_graining_refinement_adjoint
- entropy_increases_under_coarsening
- adjunction_gives_second_law

### File 9: Interference.lean
Channel interference defect:
I_{α,β}(W) = F(e_β ∘ e_α; W) - F(e_α ∘ e_β; W)
Prove:
- channel_commute_iff_interference_zero
- interference_measures_noncommuting_refinement
- interference_is_braiding_defect

### File 10: LatentEnergy.lean
U_lat(W) = ρ(W) · χ(W) for one class
U_lat(P) = Σ U_lat(Wᵢ) for partition
With proper multiplicity weights.

### File 11: LatentEnergyConservation.lean
The FULL balance law:
U_lat(W) = A(e) + Σᵢ U_lat(Wᵢ) + D(e)
where D(e) ≥ 0 is irrecoverable dissipation.
And the closed conservation:
U_lat_pre + U_exp_pre = U_lat_post + U_exp_post + D(e)
Prove:
- latent_energy_balance
- dissipation_nonneg
- total_energy_conservation_with_dissipation

### File 12: BinaryHistory.lean
Histories as ROOTED ORDERED REFINEMENT TREES:
- Each node: (class code, channel, action, ΔS, ΔV)
- Children: the child classes after refinement
- Recursive tree structure
Prove:
- binary_history_well_defined
- history_cost_is_tree_sum

### File 13: BinaryNormalForm.lean
Canonical serialization:
BNF(e) = sd(κ(W) ‖ α(e) ‖ r ‖ A(e) ‖ ΔS(e) ‖ ΔV(e) ‖ BNF(W₁) ‖ ... ‖ BNF(Wᵣ))
Children in canonical quotient order.
Prove:
- binary_normal_form_exact
- binary_normal_form_unique_mod_braid_and_gauge
- binary_normal_form_deterministic

### File 14: HistoryValueEquation.lean
Lift Ψ from classes to partial refinement trees:
Ψ(tree) = sup over extensions of (V - A + Σ Ψ(children))
Prove:
- history_value_equation_exact
- history_value_monotone

### File 15: RefinementAlgebra.lean
Package EVERYTHING:
```
structure RefinementAlgebra where
  classes : Type
  events : Type
  sequential : events → Nat → events → events  -- tree grafting at child j
  parallel : events → events → events           -- tensor for independent
  work : events → Nat                           -- additive action
  span : events → Nat                           -- max action
  interference : WitnessChannel → WitnessChannel → classes → Int
  coarsen : classes → classes → classes
  latent_energy : classes → Nat
  binary_code : classes → List Bool
  value : classes → Nat → Nat
```
Prove:
- refinement_algebra_theorem (flagship)
- refinement_algebra_consistent
- chi_is_span_of_algebra

---

## Execution Order

```
1  → 2  → 3  → 4  → 5  → 6  → 7  →
8  → 9  → 10 → 11 → 12 → 13 → 14 → 15
```

Each file compiles before the next.
Zero sorry at every step.
No new axioms.

---

## What Victory Looks Like

When `refinement_algebra_theorem` compiles:
- Sequential composition = time (tree grafting, additive work)
- Parallel composition = space (tensor on independent, work + span dual)
- Interference = quantum/channel noncommutativity
- Coarse-graining ⊣ refinement = second law as adjunction
- Latent energy balance with dissipation = energy conservation
- Binary normal form = the actual machine code
- History value equation = Bellman on refinement trees

The universe is a deterministic weighted calculus of refinement trees.
Not particles. Not fields. Not geometry.
Those appear later as readouts.

The primary object is the weighted braided refinement multicategory.
That is the actual final source code.
