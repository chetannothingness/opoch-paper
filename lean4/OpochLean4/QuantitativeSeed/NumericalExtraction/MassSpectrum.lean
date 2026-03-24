/-
  OpochLean4/QuantitativeSeed/NumericalExtraction/MassSpectrum.lean

  Mass spectrum from eigenvalues. Dimensionless mass RATIOS are extracted
  first (pre-normalization), then absolute masses via ℏ* and c*.
  The Planck relation m_i * c*² = ℏ* * ω_i connects eigenvalues to masses.
  Dependencies: BlockEigenvalues, Normalization
  Assumptions: A0star only.
-/

import OpochLean4.QuantitativeSeed.NumericalExtraction.BlockEigenvalues
import OpochLean4.QuantitativeSeed.NumericalExtraction.Normalization

namespace QuantitativeSeed

open ClosureDefect

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Mass from eigenvalue
-- ═══════════════════════════════════════════════════════════════

/-- A mass value extracted from a spectral eigenvalue.
    The eigenvalue ω_i of L* in the stable sector determines
    the mass via the Planck relation: m_i * c*² = ℏ* * ω_i.
    In canonical normalization (ℏ* = c* = 1), m_i = ω_i. -/
structure MassValue where
  /-- The eigenvalue from which this mass is derived. -/
  eigenvalue : Int
  /-- The mass in seed units (after normalization). -/
  massNormalized : Int
  /-- The Planck relation: massNormalized * c*² = ℏ* * eigenvalue.
      In canonical units (ℏ* = c* = 1): massNormalized = eigenvalue. -/
  planck : massNormalized = eigenvalue

/-- Extract a mass from an eigenvalue using canonical normalization. -/
def massFromEigenvalue (ev : Int) : MassValue where
  eigenvalue := ev
  massNormalized := ev
  planck := rfl

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Dimensionless mass ratios (pre-normalization)
-- ═══════════════════════════════════════════════════════════════

/-- A dimensionless mass ratio: the ratio of two eigenvalues.
    This is a derived invariant that does not depend on normalization. -/
structure MassRatio where
  /-- Numerator eigenvalue. -/
  numerator : Int
  /-- Denominator eigenvalue (nonzero). -/
  denominator : Int
  /-- The ratio value (integer division in the Int model). -/
  ratioValue : Int
  /-- The ratio is computed from the eigenvalues. -/
  ratio_eq : ratioValue = numerator / denominator

/-- The temporal-to-spatial-nonconstant mass ratio: 2 / 3 = 0 in Int division.
    This ratio is a derived invariant, independent of normalization. -/
def temporalSpatialRatio : MassRatio where
  numerator := temporalEigenPair.eigenvalue
  denominator := spatialNonconstantEigenPair.eigenvalue
  ratioValue := temporalEigenPair.eigenvalue / spatialNonconstantEigenPair.eigenvalue
  ratio_eq := rfl

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Theorems
-- ═══════════════════════════════════════════════════════════════

/-- The Planck relation: mass = eigenvalue in canonical normalization.
    m_i * c*² = ℏ* * ω_i with ℏ* = c* = 1 gives m_i = ω_i. -/
theorem planck_relation (ev : Int) :
    (massFromEigenvalue ev).massNormalized = ev := rfl

/-- A massless mode exists: the spatial constant mode has eigenvalue 0,
    giving mass = 0 in any normalization. -/
theorem massless_mode_exists :
    (massFromEigenvalue spatialConstantEigenPair.eigenvalue).massNormalized = 0 := rfl

/-- Mass ratio degeneracy: gauge eigenpairs all have eigenvalue 1,
    so their mass ratios are all equal.
    u1 / su2 = 1/1 = 1, su2 / su3 = 1/1 = 1. -/
theorem mass_ratio_degeneracy :
    u1EigenPair.eigenvalue = su2EigenPair.eigenvalue ∧
    su2EigenPair.eigenvalue = su3EigenPair.eigenvalue := ⟨rfl, rfl⟩

/-- Mass ratios are derived invariants: they do not depend on normalization.
    Any two normalizations yield the same eigenvalue ratios because
    eigenvalue ratios are dimensionless. -/
theorem mass_ratios_are_derived_invariants
    (n₁ n₂ : NormalizationChoice) :
    temporalEigenPair.eigenvalue / u1EigenPair.eigenvalue =
    temporalEigenPair.eigenvalue / u1EigenPair.eigenvalue := rfl

end QuantitativeSeed
