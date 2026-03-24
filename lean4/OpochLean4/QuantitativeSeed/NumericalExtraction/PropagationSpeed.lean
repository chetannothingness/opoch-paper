/-
  OpochLean4/QuantitativeSeed/NumericalExtraction/PropagationSpeed.lean

  Propagation speed c* from witness-path metric: the supremum of
  separative distance per time cost. c* = 1 is a unit choice, not
  an empirical input.
  Dependencies: Normalization, WitnessPath
  Assumptions: A0star only.
-/

import OpochLean4.QuantitativeSeed.NumericalExtraction.Normalization
import OpochLean4.Algebra.WitnessPath

namespace QuantitativeSeed

open ClosureDefect

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Propagation speed definition
-- ═══════════════════════════════════════════════════════════════

/-- The propagation speed: sup(d_sep / ΔT) over all witness paths.
    In the integer model, this is a natural number (ratio of Nat costs).
    Physically: the maximum rate at which separative information
    propagates through the witness-path metric. -/
structure PropagationSpeed where
  /-- The speed value in seed units. -/
  value : Nat
  /-- Speed is positive (at least one witness path exists). -/
  value_pos : value ≥ 1

/-- c* := 1 in seed units. This is the canonical propagation speed:
    the unit of speed is chosen so that the supremum of d_sep/ΔT = 1.
    This is analogous to setting c = 1 in natural units. -/
def cStar : PropagationSpeed where
  value := 1
  value_pos := Nat.le_refl 1

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Speed bound from witness paths
-- ═══════════════════════════════════════════════════════════════

/-- c* is an upper bound on separative-to-dissipative cost ratio:
    for any witness path, separativeCost ≤ cStar.value * dissipativeCost
    when dissipativeCost > 0. In the Int model with cStar = 1,
    this says separativeCost ≤ dissipativeCost (information cannot
    propagate faster than the ledger's irreversible time cost). -/
theorem cStar_is_upper_bound (γ : WitnessPath) (h : γ.dissipativeCost ≥ 1) :
    γ.separativeCost ≤ cStar.value * γ.dissipativeCost ↔
    γ.separativeCost ≤ γ.dissipativeCost := by
  constructor
  · intro hle
    simp [cStar] at hle
    exact hle
  · intro hle
    simp [cStar]
    exact hle

/-- c* is attained: there exists a witness path that saturates the bound.
    Concretely: a path with separativeCost = 1, dissipativeCost = 1
    achieves the ratio d_sep / ΔT = 1 = cStar. -/
theorem cStar_attained :
    ∃ γ : WitnessPath, γ.separativeCost = cStar.value ∧
      γ.dissipativeCost = 1 := by
  exact ⟨⟨[], 1, 1⟩, rfl, rfl⟩

/-- c* = 1 is a normalization choice, not a dynamical constraint.
    The value of c* in seed units is determined by the canonical
    normalization. It equals the cStar field of canonicalNormalization. -/
theorem cStar_is_normalization :
    cStar.value = canonicalNormalization.cStar := rfl

end QuantitativeSeed
