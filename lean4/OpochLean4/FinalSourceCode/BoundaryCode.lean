import OpochLean4.FinalSourceCode.ConsciousBoundary

/-
  FinalSourceCode — Boundary Code

  b_q = finite boundary code.
  Every question/defect is a boundary code.
  Reuses BoundaryCode from IndistinguishabilityEnergy.

  New axioms: 0
-/

namespace FinalSourceCode

open IndistinguishabilityEnergy Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- Boundary code properties
-- ════════════════════════════════════════════════════════════════

/-- Boundary code exists for any admissible defect fitting the boundary. -/
theorem boundary_code_exists (pb : PresentBoundary)
    (d : LocalDefect) (hadm : IsAdmissibleDefect d)
    (hfits : d.totalCost ≤ pb.boundaryCapacity) :
    ∃ b : BoundaryCode, b.code = d ∧ b.boundary = pb :=
  question_as_boundary_code_exact pb d hadm hfits

/-- The boundary code is finite: cost fits within capacity. -/
theorem boundary_code_finite (b : BoundaryCode) :
    b.code.totalCost ≤ b.boundary.boundaryCapacity :=
  IndistinguishabilityEnergy.boundary_code_finite b

/-- The boundary code is a local selector: it selects from the local defect. -/
theorem boundary_code_is_local_selector (b : BoundaryCode) :
    b.code.unresolved.length ≥ 1 :=
  boundary_code_sub_local_defect b

end FinalSourceCode
