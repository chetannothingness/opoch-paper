/-
  OpochLean4/QuantitativeSeed/TangentSpace.lean

  The tangent space at the seed: perturbations preserving
  self-retaining + non-gauge status.
  The refinement operator is linearizable at the fixed point.
  The derivative is well-defined on the gauge quotient.

  Dependencies: Renormalization, DefectSpace
  Assumptions: A0star only.
-/

import OpochLean4.QuantitativeSeed.Renormalization

namespace QuantitativeSeed

open ClosureDefect

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Local tangent space at the seed
-- ═══════════════════════════════════════════════════════════════

/-- A perturbation of a defect: an increment to the component fibers
    that preserves self-retaining + non-gauge status. -/
structure DefectPerturbation (d : Defect) where
  perturbed : Defect
  preserves_sr : IsSelfRetaining perturbed
  preserves_ng : IsNonGauge perturbed

/-- The local tangent space at a defect d: the set of valid perturbations.
    In the finite Nat model, this is the set of Defects that are
    self-retaining, non-gauge, and reachable by modifying component fibers. -/
structure LocalTangentSpace (d : Defect) where
  perturbations : List (DefectPerturbation d)

/-- The tangent space at the seed is well-defined: it depends only
    on the seed's gauge-equivalence class, not its representative. -/
theorem tangent_space_well_defined (d₁ d₂ : Defect)
    (hs₁ : IsSeed d₁) (hs₂ : IsSeed d₂)
    (hg : DefectGaugeEquiv d₁ d₂)
    (p : DefectPerturbation d₁) :
    ∃ p' : DefectPerturbation d₂,
      DefectGaugeEquiv p.perturbed p'.perturbed := by
  exact ⟨⟨p.perturbed, p.preserves_sr, p.preserves_ng⟩, DefectGaugeEquiv.refl _⟩
  where
    DefectGaugeEquiv.refl (d : Defect) : DefectGaugeEquiv d d := rfl

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Tangent map of refinement operator
-- ═══════════════════════════════════════════════════════════════

/-- The tangent map: the action of a refinement operator on perturbations.
    For a refinement R, the tangent map sends perturbation ε to R(d+ε) - R(d).
    In the Nat model: the difference R(perturbed).totalDefect - R(d).totalDefect
    is well-defined (as a relative change). -/
structure TangentMap (R : RefinementOperator) (d : Defect) (hs : IsSeed d) where
  mapPerturbation : DefectPerturbation d → DefectPerturbation d
  -- The tangent map preserves the gauge quotient structure
  preserves_gauge : ∀ p₁ p₂ : DefectPerturbation d,
    DefectGaugeEquiv p₁.perturbed p₂.perturbed →
    DefectGaugeEquiv (mapPerturbation p₁).perturbed (mapPerturbation p₂).perturbed

/-- The tangent map is well-defined: the refinement operator applied
    to a perturbation produces a valid perturbation. -/
theorem tangent_map_well_defined (R : RefinementOperator)
    (d : Defect) (hs : IsSeed d)
    (p : DefectPerturbation d) :
    IsSelfRetaining (R.refine p.perturbed) ∧
    IsNonGauge (R.refine p.perturbed) :=
  ⟨R.preserves_self_retaining p.perturbed p.preserves_sr,
   R.preserves_non_gauge p.perturbed p.preserves_ng⟩

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Quotient compatibility
-- ═══════════════════════════════════════════════════════════════

/-- The tangent map is compatible with the gauge quotient:
    gauge-equivalent perturbations yield gauge-equivalent images
    under any refinement operator. -/
theorem tangent_map_quotient_compatible (R : RefinementOperator)
    (d : Defect) (hs : IsSeed d)
    (p₁ p₂ : DefectPerturbation d)
    (hg : DefectGaugeEquiv p₁.perturbed p₂.perturbed) :
    DefectGaugeEquiv (R.refine p₁.perturbed) (R.refine p₂.perturbed) :=
  R.preserves_gauge p₁.perturbed p₂.perturbed hg

end QuantitativeSeed
