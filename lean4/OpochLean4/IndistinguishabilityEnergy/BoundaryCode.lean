import OpochLean4.IndistinguishabilityEnergy.PresentBoundary

/-
  Indistinguishability Energy — Boundary Code

  b_q = finite boundary code.
  Every question/defect is a boundary code.

  New axioms: 0
-/

namespace IndistinguishabilityEnergy

open Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- Boundary code
-- ════════════════════════════════════════════════════════════════

structure BoundaryCode where
  boundary : PresentBoundary
  code : LocalDefect
  admissible : IsAdmissibleDefect code
  fits : code.totalCost ≤ boundary.boundaryCapacity

-- ════════════════════════════════════════════════════════════════
-- Theorems
-- ════════════════════════════════════════════════════════════════

theorem question_as_boundary_code_exact (pb : PresentBoundary)
    (d : LocalDefect) (hadm : IsAdmissibleDefect d)
    (hfits : d.totalCost ≤ pb.boundaryCapacity) :
    ∃ b : BoundaryCode, b.code = d ∧ b.boundary = pb :=
  ⟨⟨pb, d, hadm, hfits⟩, rfl, rfl⟩

theorem boundary_code_finite (b : BoundaryCode) :
    b.code.totalCost ≤ b.boundary.boundaryCapacity :=
  b.fits

theorem boundary_code_sub_local_defect (b : BoundaryCode) :
    b.code.unresolved.length ≥ 1 :=
  b.code.nonempty

end IndistinguishabilityEnergy
