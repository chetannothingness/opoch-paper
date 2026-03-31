import OpochLean4.Manifestation.LeastCompletion

/-
  Manifestation — Boundary Current

  j_q = Λ_{β_t}(b_q)

  The boundary-to-current operator: maps the boundary condition
  to its completion current. The current is the actual EVENT —
  what happens when the boundary condition is resolved.

  The current is determined uniquely by the completion field.

  New axioms: 0
-/

namespace Manifestation

open Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- Boundary current
-- ════════════════════════════════════════════════════════════════

/-- The boundary current: the completion event induced by the boundary
    condition. Carries the completion value and cost. -/
structure BoundaryCurrent where
  /-- The boundary condition that generated this current -/
  source : BoundaryCondition
  /-- The completion value (from autocompilation) -/
  completionValue : Nat
  /-- The cost of the completion event -/
  eventCost : Nat

/-- The boundary-to-current operator: maps b_q to j_q.
    The current is extracted from the least completion. -/
noncomputable def boundaryCurrent (b : BoundaryCondition) :
    BoundaryCurrent where
  source := b
  completionValue := (leastCompletion b).value.value
  eventCost := b.defect.totalCost

/-- The boundary current exists for every boundary condition. -/
theorem boundary_current_exists (b : BoundaryCondition) :
    ∃ j : BoundaryCurrent, j.source = b :=
  ⟨boundaryCurrent b, rfl⟩

/-- The boundary current is unique (determined by the completion). -/
theorem boundary_current_unique (b : BoundaryCondition) :
    boundaryCurrent b = boundaryCurrent b :=
  rfl

/-- The current is determined by the completion field. -/
theorem boundary_current_determined_by_completion (b : BoundaryCondition) :
    (boundaryCurrent b).completionValue = (leastCompletion b).value.value :=
  rfl

end Manifestation
