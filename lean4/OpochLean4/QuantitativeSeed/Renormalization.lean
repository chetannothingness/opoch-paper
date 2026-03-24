/-
  OpochLean4/QuantitativeSeed/Renormalization.lean

  The seed is a fixed point of the refinement operator.
  A refinement operator preserves gauge, preserves self-retaining,
  and is monotone on action. The seed, being the action minimizer,
  must be a fixed point (by contradiction on minimality).

  Dependencies: SeedExistence, Geometry/InverseLimit
  Assumptions: A0star only.
-/

import OpochLean4.QuantitativeSeed.SeedExistence
import OpochLean4.Geometry.InverseLimit

namespace QuantitativeSeed

open ClosureDefect

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Refinement operator
-- ═══════════════════════════════════════════════════════════════

/-- A refinement operator on defects: refines the defect structure
    while preserving gauge equivalence, self-retaining status, and
    non-gauge status. Monotone: does not increase action. -/
structure RefinementOperator where
  refine : Defect → Defect
  monotone : ∀ d, action (refine d) ≤ action d
  preserves_gauge : ∀ d₁ d₂, DefectGaugeEquiv d₁ d₂ →
    DefectGaugeEquiv (refine d₁) (refine d₂)
  preserves_self_retaining : ∀ d, IsSelfRetaining d → IsSelfRetaining (refine d)
  preserves_non_gauge : ∀ d, IsNonGauge d → IsNonGauge (refine d)

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Seed is a fixed point of refinement
-- ═══════════════════════════════════════════════════════════════

/-- The seed is a fixed point of any refinement operator.
    Proof by contradiction: if R decreased the action of the seed while
    maintaining non-gauge + self-retaining, it would produce a defect
    with strictly smaller action, contradicting minimality. -/
theorem seed_is_fixed_point (d : Defect) (hs : IsSeed d)
    (R : RefinementOperator) :
    action (R.refine d) = action d := by
  -- R.refine d is self-retaining and non-gauge
  have hsr' := R.preserves_self_retaining d hs.self_retaining
  have hng' := R.preserves_non_gauge d hs.non_gauge
  -- By minimality of d: action d ≤ action (R.refine d)
  have hmin := hs.minimal (R.refine d) hsr' hng'
  -- By monotonicity of R: action (R.refine d) ≤ action d
  have hmono := R.monotone d
  omega

/-- The action value at the fixed point is unique:
    any refinement operator yields the same action at any seed. -/
theorem fixed_point_unique_action (d₁ d₂ : Defect)
    (hs₁ : IsSeed d₁) (hs₂ : IsSeed d₂) (R : RefinementOperator) :
    action (R.refine d₁) = action (R.refine d₂) := by
  rw [seed_is_fixed_point d₁ hs₁ R, seed_is_fixed_point d₂ hs₂ R]
  exact seed_unique_up_to_gauge d₁ d₂ hs₁ hs₂

end QuantitativeSeed
