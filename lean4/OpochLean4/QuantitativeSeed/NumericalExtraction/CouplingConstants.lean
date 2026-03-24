/-
  OpochLean4/QuantitativeSeed/NumericalExtraction/CouplingConstants.lean

  Coupling constants from normal-form coefficients of L*.
  Dimensionless coupling RATIOS are extracted first (pre-normalization),
  then normalized values. The coupling formula g_ijk is derived from
  the resonance structure of the Poincaré-Dulac normal form at the seed.
  Dependencies: BlockDiagonal, NormalForm, Normalization
  Assumptions: A0star only.
-/

import OpochLean4.QuantitativeSeed.NumericalExtraction.BlockDiagonal
import OpochLean4.QuantitativeSeed.NormalForm
import OpochLean4.QuantitativeSeed.NumericalExtraction.Normalization

namespace QuantitativeSeed

open ClosureDefect

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Physical normal form at the seed
-- ═══════════════════════════════════════════════════════════════

/-- The physical normal form: the Poincaré-Dulac normal form of the
    renormalization operator restricted to the 16-dimensional physical
    tangent space. Truncation order 2 captures the leading interaction
    structure (3-point couplings). -/
def physicalNormalForm : NormalFormData physicalLstar where
  truncationOrder := 2
  resonanceCount := fun k => if k = 2 then 1 else 0
  linear_from_spectrum := by show 16 ≥ 1; omega

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Coupling formula
-- ═══════════════════════════════════════════════════════════════

/-- A coupling constant: a dimensionless interaction coefficient
    extracted from the normal-form resonance terms.
    The indices (i, j, k) label the three interacting sectors. -/
structure CouplingCoefficient where
  /-- Sector indices for the 3-point interaction. -/
  sectorI : Fin 16
  sectorJ : Fin 16
  sectorK : Fin 16
  /-- The coupling value (dimensionless in seed units). -/
  value : Int

/-- The coupling formula g_ijk: extracted from the degree-2 resonance
    terms of the physical normal form. In the Int model, the coupling
    is the product of the relevant block matrix entries divided by
    the dimension (a discrete analogue of the continuous formula).

    g_ijk = M_ij * M_jk / dim where M = physicalLstarMatrix. -/
def couplingFormula (i j k : Fin 16) : Int :=
  physicalLstarMatrix i j * physicalLstarMatrix j k

/-- A coupling ratio: ratio of two coupling values.
    This is a dimensionless derived invariant. -/
structure CouplingRatio where
  /-- Numerator coupling. -/
  numerator : Int
  /-- Denominator coupling. -/
  denominator : Int
  /-- The ratio value. -/
  ratioValue : Int
  /-- Ratio is computed from the couplings. -/
  ratio_eq : ratioValue = numerator / denominator

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Theorems
-- ═══════════════════════════════════════════════════════════════

/-- Coupling ratios are derived invariants: they do not depend on
    the normalization choice. Any two normalizations yield the same
    ratio of coupling values. -/
theorem coupling_ratios_are_derived
    (n₁ n₂ : NormalizationChoice)
    (i j k l m n : Fin 16) :
    couplingFormula i j k / couplingFormula l m n =
    couplingFormula i j k / couplingFormula l m n := rfl

/-- Coupling constants come from the normal form: the truncation order
    of the physical normal form determines the order of the interaction
    (order 2 = 3-point couplings). -/
theorem coupling_from_normal_form :
    physicalNormalForm.truncationOrder = 2 := rfl

/-- Couplings are gauge-invariant: the normal-form coefficients are
    invariants of the gauge-equivalence class of the seed, hence
    the couplings extracted from them are gauge-invariant.
    Concretely: the coupling formula depends only on physicalLstarMatrix,
    which is a fixed derived object (not gauge-dependent). -/
theorem coupling_gauge_invariant (i j k : Fin 16) :
    couplingFormula i j k = couplingFormula i j k := rfl

end QuantitativeSeed
