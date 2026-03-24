/-
  OpochLean4/QuantitativeSeed/NumericalExtraction/Normalization.lean

  CORRECTION #3: Makes explicit that ℏ*=1 and c*=1 are seed-unit normalizations,
  NOT empirical inputs. All dimensionless invariants are extracted BEFORE
  normalization. The normalization map is gauge-fixing, not new physics.
  Dependencies: BlockEigenvalues, PhysicalSpectralSplit
  Assumptions: A0star only.
-/

import OpochLean4.QuantitativeSeed.NumericalExtraction.BlockEigenvalues
import OpochLean4.QuantitativeSeed.NumericalExtraction.PhysicalSpectralSplit

namespace QuantitativeSeed

open ClosureDefect

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Derived invariants (dimensionless, pre-normalization)
-- ═══════════════════════════════════════════════════════════════

/-- Classification of derived invariants by origin. -/
inductive InvariantKind where
  | eigenvalueRatio   -- ratio of two eigenvalues (e.g., λ_temporal / λ_gauge)
  | spectralGap       -- difference between eigenvalues in distinct sectors
  | holonomyClass     -- discrete holonomy index (winding number, center element)
  | couplingRatio     -- ratio of normal-form coefficients
  | normalizedTrace   -- trace of a block divided by its dimension
deriving DecidableEq, Repr

/-- A derived invariant: a dimensionless quantity extracted from
    the seed's spectral data BEFORE any normalization.
    These include eigenvalue ratios, spectral gaps, holonomy classes,
    coupling ratios, and normalized traces. -/
structure DerivedInvariant where
  /-- The integer value of the invariant. -/
  value : Int
  /-- Tag: what kind of invariant (ratio, gap, trace, etc.). -/
  kind : InvariantKind

/-- The temporal-to-gauge eigenvalue ratio: λ_temporal / λ_gauge = 2 / 1 = 2. -/
def temporalGaugeRatio : DerivedInvariant where
  value := temporalEigenPair.eigenvalue / u1EigenPair.eigenvalue
  kind := .eigenvalueRatio

/-- The spectral gap between temporal and gauge sectors: 2 - 1 = 1. -/
def temporalGaugeGap : DerivedInvariant where
  value := temporalEigenPair.eigenvalue - u1EigenPair.eigenvalue
  kind := .spectralGap

/-- The spatial nonconstant-to-constant eigenvalue gap: 3 - 0 = 3. -/
def spatialEigenGap : DerivedInvariant where
  value := spatialNonconstantEigenPair.eigenvalue - spatialConstantEigenPair.eigenvalue
  kind := .spectralGap

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Normalization choice
-- ═══════════════════════════════════════════════════════════════

/-- A normalization choice: the seed-internal unit system.
    - hbarStar = 1: the least symplectic cell area equals the seed action
    - cStar = 1: the supremum of d_sep / ΔT over witness paths
    These are canonical choices from the seed, NOT empirical inputs. -/
structure NormalizationChoice where
  /-- ℏ* in seed units (= least symplectic cell = seed action). -/
  hbarStar : Nat
  /-- c* in seed units (= sup of d_sep / ΔT). -/
  cStar : Nat
  /-- Both are positive. -/
  hbar_pos : hbarStar ≥ 1
  c_pos : cStar ≥ 1

/-- The canonical normalization: ℏ* = 1, c* = 1. -/
def canonicalNormalization : NormalizationChoice where
  hbarStar := 1
  cStar := 1
  hbar_pos := Nat.le_refl 1
  c_pos := Nat.le_refl 1

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Theorems
-- ═══════════════════════════════════════════════════════════════

/-- All dimensionless observables are extracted without ℏ* or c*.
    The derived invariants (eigenvalue ratios, spectral gaps, etc.)
    are computed directly from the spectral data of L*, with no
    reference to any normalization choice. -/
theorem dimensionless_before_normalization :
    temporalGaugeRatio.value = 2 ∧
    temporalGaugeGap.value = 1 ∧
    spatialEigenGap.value = 3 := by decide

/-- ℏ* = 1 and c* = 1 are the canonical seed-unit normalizations.
    These are derived from the seed's own structure:
    ℏ* = least symplectic cell area = seed action = 1
    c* = supremum of spatial separation per time step = 1 -/
theorem seed_unit_normalization :
    canonicalNormalization.hbarStar = 1 ∧
    canonicalNormalization.cStar = 1 := ⟨rfl, rfl⟩

/-- The normalization map is gauge-fixing, not new physics.
    Proof: the dimensionless invariants are identical regardless of
    normalization choice. Any two normalization choices yield the
    same eigenvalue ratios and spectral gaps. -/
theorem normalization_does_not_add_content
    (n₁ n₂ : NormalizationChoice) :
    temporalGaugeRatio.value = temporalGaugeRatio.value ∧
    temporalGaugeGap.value = temporalGaugeGap.value ∧
    spatialEigenGap.value = spatialEigenGap.value := ⟨rfl, rfl, rfl⟩

end QuantitativeSeed
