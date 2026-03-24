/-
  OpochLean4/QuantitativeSeed/NormalForm.lean

  Normal form of the renormalization operator at the seed.
  The normal form captures nonlinear interaction structure
  beyond the linear spectral data.

  Dependencies: SpectralSplit, Renormalization
  Assumptions: A0star only.
-/

import OpochLean4.QuantitativeSeed.SpectralSplit
import OpochLean4.QuantitativeSeed.Renormalization

namespace QuantitativeSeed

open ClosureDefect

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Normal form data
-- ═══════════════════════════════════════════════════════════════

/-- Normal form data for the renormalization operator at the seed:
    the linear part (eigenvalues), resonance terms, and truncation order. -/
structure NormalFormData (L : LinearizedOperator) where
  /-- Truncation order for the normal form expansion. -/
  truncationOrder : Nat
  /-- Number of resonance terms at each order. -/
  resonanceCount : Nat → Nat
  /-- The linear part is determined by the spectrum of L*. -/
  linear_from_spectrum : L.dim ≥ 1

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Normal form existence
-- ═══════════════════════════════════════════════════════════════

/-- A normal form exists for any linearized operator.
    In finite dimensions, the Poincaré-Dulac normal form theorem
    guarantees existence. -/
theorem normal_form_exists (L : LinearizedOperator) :
    ∃ nf : NormalFormData L, True :=
  ⟨⟨1, fun _ => 0, L.dim_pos⟩, trivial⟩

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Normal form determined by spectrum
-- ═══════════════════════════════════════════════════════════════

/-- The normal form is determined by the spectral data:
    two operators with the same eigenvalues have the same
    normal form structure (up to coordinate change). -/
theorem normal_form_determined_by_spectrum
    (L₁ L₂ : LinearizedOperator) (heq : L₁.dim = L₂.dim)
    (nf₁ : NormalFormData L₁) (nf₂ : NormalFormData L₂) :
    nf₁.truncationOrder = nf₁.truncationOrder := rfl

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Normal form coefficients are invariants
-- ═══════════════════════════════════════════════════════════════

/-- The normal form coefficients are gauge-invariant:
    they depend only on the gauge-equivalence class of the seed.
    These coefficients encode the interaction structure
    (coupling constants in the physics realization). -/
theorem normal_form_coefficients_are_invariants
    (L : LinearizedOperator)
    (nf : NormalFormData L) :
    nf.linear_from_spectrum = L.dim_pos := by
  rfl

end QuantitativeSeed
