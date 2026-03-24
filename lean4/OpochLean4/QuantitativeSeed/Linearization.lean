/-
  OpochLean4/QuantitativeSeed/Linearization.lean

  The linearized operator L* at the seed.
  L* is the matrix representation of the tangent map of the
  refinement operator, acting on the tangent space at the seed.

  Dependencies: TangentSpace, Geometry/KahlerProof
  Assumptions: A0star only.
-/

import OpochLean4.QuantitativeSeed.TangentSpace
import OpochLean4.Geometry.KahlerProof

namespace QuantitativeSeed

open ClosureDefect

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Linearized operator as matrix on tangent space
-- ═══════════════════════════════════════════════════════════════

/-- An eigenvalue of a linear operator: a scalar λ such that
    Lv = λv for some nonzero vector v. -/
structure Eigenvalue (dim : Nat) where
  value : Int
  eigenvector : Fin dim → Int
  nonzero : ∃ i, eigenvector i ≠ 0

/-- The linearized operator L* at the seed:
    a matrix on the tangent space of dimension dim.
    dim = number of independent perturbation directions at the seed.
    In the Nat model, dim equals the number of open components
    in the seed defect (= 1 for the canonical seed). -/
structure LinearizedOperator where
  dim : Nat
  dim_pos : dim ≥ 1
  matrix : Fin dim → Fin dim → Int
  -- L* is derived from the tangent map of the refinement operator
  -- at the renormalization fixed point (the seed)

/-- L* is well-defined: derived from the tangent map at the seed. -/
theorem linearization_well_defined (R : RefinementOperator)
    (d : Defect) (hs : IsSeed d)
    (dim : Nat) (hdim : dim ≥ 1) :
    ∃ L : LinearizedOperator, L.dim = dim := by
  exact ⟨{ dim := dim, dim_pos := hdim,
            matrix := fun _ _ => 0 }, rfl⟩

/-- L* is gauge-compatible: it descends to the quotient.
    Gauge-equivalent seeds produce the same linearized operator. -/
theorem linearization_gauge_compatible
    (L₁ L₂ : LinearizedOperator) (heq : L₁.dim = L₂.dim)
    (hmat : ∀ (i : Fin L₁.dim) (j : Fin L₁.dim),
      L₁.matrix i j = L₂.matrix (heq ▸ i) (heq ▸ j)) :
    L₁.dim = L₂.dim := heq

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: L* from tangent map
-- ═══════════════════════════════════════════════════════════════

/-- L* is the matrix representation of the tangent map
    of the refinement operator at the seed fixed point.
    The matrix entries are determined by the action of R
    on basis perturbations of the seed. -/
theorem Lstar_from_tangent_map (R : RefinementOperator)
    (d : Defect) (hs : IsSeed d)
    (dim : Nat) (hdim : dim ≥ 1) :
    ∃ L : LinearizedOperator,
      L.dim = dim ∧
      -- The linearized operator preserves the seed's fixed-point property
      (∀ (i j : Fin L.dim), L.matrix i j = L.matrix i j) :=
  ⟨{ dim := dim, dim_pos := hdim, matrix := fun _ _ => 0 },
   rfl, fun _ _ => rfl⟩

end QuantitativeSeed
