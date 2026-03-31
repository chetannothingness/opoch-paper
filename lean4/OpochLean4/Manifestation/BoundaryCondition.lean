import OpochLean4.Manifestation.PresentBoundary

/-
  Manifestation — Boundary Condition

  A real question is a finite local boundary condition:
    b_q ⊆ Δ_Q(C_t)

  Every admissible question/defect induces a boundary code.

  New axioms: 0
-/

namespace Manifestation

open Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- Boundary condition
-- ════════════════════════════════════════════════════════════════

/-- A boundary condition: a finite code specifying what needs to
    be resolved at the present boundary. -/
structure BoundaryCondition where
  /-- The local defect this boundary condition represents -/
  defect : LocalDefect
  /-- The boundary it sits on -/
  boundary : WritableBoundary
  /-- The defect is admissible -/
  admissible : IsAdmissibleDefect defect
  /-- The defect cost fits within boundary capacity -/
  fits : defect.totalCost ≤ boundary.capacity

/-- Every admissible defect induces a boundary condition
    when the boundary has enough capacity. -/
theorem question_defect_induces_boundary_condition
    (d : LocalDefect) (hadm : IsAdmissibleDefect d)
    (β : WritableBoundary) (hfits : d.totalCost ≤ β.capacity) :
    ∃ b : BoundaryCondition, b.defect = d :=
  ⟨⟨d, β, hadm, hfits⟩, rfl⟩

/-- The boundary condition is finite. -/
theorem boundary_condition_finite (b : BoundaryCondition) :
    b.defect.totalCost ≥ 1 :=
  b.defect.cost_pos

/-- The boundary condition is admissible. -/
theorem boundary_condition_admissible (b : BoundaryCondition) :
    IsAdmissibleDefect b.defect :=
  b.admissible

end Manifestation
