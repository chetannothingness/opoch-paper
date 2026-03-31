import OpochLean4.FinalSourceCode.CompletionField

/-
  FinalSourceCode — Completion Current

  J_q = boundaryCurrent b = energy flowing from latent to manifest.
  Reuses boundaryCurrent from IndistinguishabilityEnergy.

  New axioms: 0
-/

namespace FinalSourceCode

open IndistinguishabilityEnergy Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- Completion current
-- ════════════════════════════════════════════════════════════════

/-- The completion current exists for every boundary code. -/
theorem completion_current_exists (b : BoundaryCode) :
    ∃ j : CompletionCurrent, j = boundaryCurrent b :=
  boundary_current_exists b

/-- The completion current is unique (deterministic). -/
theorem completion_current_unique (b : BoundaryCode) :
    boundaryCurrent b = boundaryCurrent b :=
  boundary_current_unique b

/-- The completion current is determined by boundary and self-model. -/
theorem completion_current_determined_by_boundary_and_self_model (b : BoundaryCode) :
    (boundaryCurrent b).cost = b.code.totalCost :=
  boundary_current_determined_by_completion b

end FinalSourceCode
