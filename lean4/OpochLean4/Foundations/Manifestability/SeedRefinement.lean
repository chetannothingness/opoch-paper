import OpochLean4.Foundations.Manifestability.RefinementThreshold
import OpochLean4.QuantitativeSeed.SeedExistence

/-
  Manifestability Block — Seed Refinement

  Connects the seed δ★ to the refinement threshold χ.
  The seed is the minimal refinable class: it is the first
  distinction that can be accessed from nothingness.

  δ★ = argmin_{W≠W⊥} χ(W)

  Dependencies: RefinementThreshold, SeedExistence
  New axioms: 0
-/

namespace Manifestability

open QuantitativeSeed ClosureDefect

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Seed as minimal refinable class
-- ════════════════════════════════════════════════════════════════

/-- A residual class is seed-compatible if its multiplicity matches
    the seed's action value. The seed has action = 1, which is the
    minimum non-gauge defect. -/
structure IsSeedClass (rc : ResidualClass) where
  /-- The seed exists -/
  seed : Defect
  /-- The seed satisfies IsSeed -/
  is_seed : IsSeed seed
  /-- The residual class has multiplicity matching seed action -/
  mult_matches : rc.multiplicity = action seed

/-- The seed is the minimal refinable class: its action (= multiplicity)
    is minimal among all non-gauge self-retaining defects.
    This connects χ-theory to the existing seed package. -/
theorem seed_as_minimal_refinable_class
    (rc : ResidualClass) (hsc : IsSeedClass rc) :
    rc.multiplicity = 1 := by
  rw [hsc.mult_matches]
  have := hsc.is_seed.minimal seedDefect seedDefect_self_retaining seedDefect_non_gauge
  have hseed : action seedDefect = 1 := rfl
  have hother := hsc.is_seed.non_gauge
  have hmin := non_gauge_action_ge_one _ hother
  have hle := hsc.is_seed.minimal seedDefect seedDefect_self_retaining seedDefect_non_gauge
  omega

/-- The big bang seed is the first accessible distinction:
    the seed defect has the minimum possible action (= 1),
    which means it is the first thing nothingness can manifest.
    Any non-trivial self-retaining defect has action ≥ 1. -/
theorem bigbang_seed_is_first_accessible_distinction :
    ∃ d : Defect, IsSeed d ∧ action d = 1 := by
  obtain ⟨d, hd⟩ := exists_action_minimizer
  refine ⟨d, hd, ?_⟩
  have h_le : action d ≤ action seedDefect :=
    hd.minimal seedDefect seedDefect_self_retaining seedDefect_non_gauge
  have h_seed_val : action seedDefect = 1 := rfl
  have h_pos : action d ≥ 1 := hd.non_gauge
  omega

end Manifestability
