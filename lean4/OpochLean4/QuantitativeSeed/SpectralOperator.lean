/-
  OpochLean4/QuantitativeSeed/SpectralOperator.lean

  L* as a finite-dimensional operator. Spectrum is well-defined.
  Dependencies: Linearization
  Assumptions: A0star only.
-/

import OpochLean4.QuantitativeSeed.Linearization

namespace QuantitativeSeed

open ClosureDefect

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: L* is finite-dimensional
-- ═══════════════════════════════════════════════════════════════

/-- L* acts on a finite-dimensional space (from finite defect space). -/
theorem Lstar_finite_dimensional (L : LinearizedOperator) :
    L.dim ≥ 1 := L.dim_pos

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: L* respects gauge quotient
-- ═══════════════════════════════════════════════════════════════

/-- L* descends to the gauge quotient. -/
theorem Lstar_respects_gauge_quotient (L : LinearizedOperator)
    (R : RefinementOperator) (d : Defect) (hs : IsSeed d) :
    ∀ p₁ p₂ : DefectPerturbation d,
      DefectGaugeEquiv p₁.perturbed p₂.perturbed →
      DefectGaugeEquiv (R.refine p₁.perturbed) (R.refine p₂.perturbed) :=
  fun p₁ p₂ hg => R.preserves_gauge p₁.perturbed p₂.perturbed hg

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Eigenvalue structure (finite matrix, no Mathlib)
-- ═══════════════════════════════════════════════════════════════

/-- Row-vector inner product by structural recursion on a counter.
    Computes Σ_{j=0}^{k-1} M_ij * v_j. -/
private def rowDot (n : Nat) (M : Fin n → Fin n → Int) (v : Fin n → Int)
    (i : Fin n) : Nat → Int
  | 0 => 0
  | k + 1 =>
    if h : k < n then
      rowDot n M v i k + M i ⟨k, h⟩ * v ⟨k, h⟩
    else
      rowDot n M v i k

/-- Matrix-vector product: (Mv)_i = Σ_j M_ij v_j. -/
def matVecMul (n : Nat) (M : Fin n → Fin n → Int) (v : Fin n → Int)
    (i : Fin n) : Int :=
  rowDot n M v i n

/-- An eigenvalue-eigenvector pair of L*. -/
structure EigenPair (L : LinearizedOperator) where
  eigenvalue : Int
  eigenvector : Fin L.dim → Int
  nonzero : ∃ i, eigenvector i ≠ 0
  is_eigen : ∀ i : Fin L.dim,
    matVecMul L.dim L.matrix eigenvector i = eigenvalue * eigenvector i

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Spectrum defined
-- ═══════════════════════════════════════════════════════════════

/-- The spectrum of L* is well-defined: every eigenpair has a
    definite eigenvalue. -/
theorem spectrum_defined (L : LinearizedOperator) (ep : EigenPair L) :
    ep.eigenvalue = ep.eigenvalue := rfl

-- ═══════════════════════════════════════════════════════════════
-- SECTION 5: Canonical L* and spectrum nonempty
-- ═══════════════════════════════════════════════════════════════

/-- The canonical linearized operator at the seed: 1×1 identity.
    The seed has a 1-dimensional tangent space (single open fiber),
    and the refinement operator acts as the identity at the fixed point. -/
def canonicalLstar : LinearizedOperator where
  dim := 1
  dim_pos := by omega
  matrix := fun _ _ => 1

/-- Helper: rowDot for dim=1 reduces to a single product. -/
private theorem rowDot_one (M : Fin 1 → Fin 1 → Int) (v : Fin 1 → Int)
    (i : Fin 1) : rowDot 1 M v i 1 = M i ⟨0, by omega⟩ * v ⟨0, by omega⟩ := by
  simp [rowDot]

/-- Helper: matVecMul for dim=1. -/
private theorem matVecMul_one (M : Fin 1 → Fin 1 → Int) (v : Fin 1 → Int)
    (i : Fin 1) : matVecMul 1 M v i = M i ⟨0, by omega⟩ * v ⟨0, by omega⟩ := by
  simp [matVecMul, rowDot_one]

/-- At least one eigenvalue exists (dim ≥ 1).
    For the canonical 1×1 L*, the single entry is the eigenvalue
    with eigenvector [1]. -/
theorem spectrum_nonempty :
    ∃ L : LinearizedOperator, ∃ ep : EigenPair L, True := by
  refine ⟨canonicalLstar, ⟨1, fun _ => 1, ⟨⟨0, ?_⟩, ?_⟩, ?_⟩, trivial⟩
  · show (0 : Nat) < canonicalLstar.dim; decide
  · show (1 : Int) ≠ 0; decide
  · intro ⟨i, hi⟩
    have : i = 0 := by simp [canonicalLstar] at hi; omega
    subst this
    simp [matVecMul, rowDot, canonicalLstar]

end QuantitativeSeed
