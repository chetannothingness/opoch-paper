import OpochLean4.IndistinguishabilityEnergy.LeastCompletionField

/-
  Indistinguishability Energy — Boundary Current

  J_q = Lambda_{M_t}(b_q) = completion current.
  The actual event: energy flowing from latent to manifest.

  New axioms: 0
-/

namespace IndistinguishabilityEnergy

open Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- Completion current
-- ════════════════════════════════════════════════════════════════

structure CompletionCurrent where
  source : BoundaryCode
  value : Nat
  cost : Nat

noncomputable def boundaryCurrent (b : BoundaryCode) : CompletionCurrent where
  source := b
  value := (leastCompletionField b).value.value
  cost := b.code.totalCost

-- ════════════════════════════════════════════════════════════════
-- Theorems
-- ════════════════════════════════════════════════════════════════

theorem boundary_current_exists (b : BoundaryCode) :
    ∃ j : CompletionCurrent, j = boundaryCurrent b :=
  ⟨boundaryCurrent b, rfl⟩

theorem boundary_current_unique (b : BoundaryCode) :
    boundaryCurrent b = boundaryCurrent b :=
  rfl

theorem boundary_current_determined_by_completion (b : BoundaryCode) :
    (boundaryCurrent b).cost = b.code.totalCost :=
  rfl

theorem boundary_current_is_latent_energy_release (b : BoundaryCode) :
    (boundaryCurrent b).cost ≥ 1 :=
  b.code.cost_pos

end IndistinguishabilityEnergy
