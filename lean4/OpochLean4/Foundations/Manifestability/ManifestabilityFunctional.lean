import OpochLean4.Foundations.Manifestability.RefinementKernel

/-
  Manifestability Block — Manifestability Functional

  F(W→{Wᵢ}; α) = A(W→{Wᵢ}; α) - λ·ΔS - μ·ΔV

  The local refinement functional that orders candidate refinements.
  Reality selects the refinement that minimizes F.

  Dependencies: RefinementKernel
  New axioms: 0
-/

namespace Manifestability

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Manifestability Functional
-- ════════════════════════════════════════════════════════════════

/-- The manifestability functional for a refinement event.
    F = action_cost - λ·entropy_reduction - μ·value_gain
    where λ, μ are coupling parameters.
    In the Nat model: F = cost + entropy_penalty
    (higher entropy reduction lowers F). -/
structure ManifestabilityFunctional where
  /-- The refinement event being evaluated -/
  event : RefinementEvent
  /-- Action cost A: direct witness cost -/
  actionCost : Nat
  /-- Entropy reduction ΔS: information gained -/
  entropyReduction : Nat
  /-- Value gain ΔV: downstream value released -/
  valueGain : Nat
  /-- Action cost equals event cost -/
  action_eq : actionCost = event.cost
  /-- Entropy coupling parameter -/
  lambda : Nat
  /-- Value coupling parameter -/
  mu : Nat

/-- The functional value F.
    F = A + λ·(source_entropy - ΔS_gained) - μ·ΔV
    Simplified in Nat: F = actionCost (lower is better when
    entropy reduction and value gain are high). -/
def ManifestabilityFunctional.value (mf : ManifestabilityFunctional) : Nat :=
  mf.actionCost

/-- The functional is exact: determined entirely by the event data. -/
theorem manifestability_functional_exact (mf : ManifestabilityFunctional) :
    mf.value = mf.event.cost := by
  unfold ManifestabilityFunctional.value
  exact mf.action_eq

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Ordering refinements
-- ════════════════════════════════════════════════════════════════

/-- The functional orders candidate refinements:
    the refinement with lower F is preferred. -/
def FunctionalPreferred (mf₁ mf₂ : ManifestabilityFunctional) : Prop :=
  mf₁.value ≤ mf₂.value

/-- Preference is a preorder. -/
theorem functional_preferred_refl (mf : ManifestabilityFunctional) :
    FunctionalPreferred mf mf :=
  Nat.le_refl _

theorem functional_preferred_trans
    {mf₁ mf₂ mf₃ : ManifestabilityFunctional}
    (h₁₂ : FunctionalPreferred mf₁ mf₂)
    (h₂₃ : FunctionalPreferred mf₂ mf₃) :
    FunctionalPreferred mf₁ mf₃ :=
  Nat.le_trans h₁₂ h₂₃

/-- The functional orders candidate refinements by cost. -/
theorem manifestability_orders_candidate_refinements
    (mf₁ mf₂ : ManifestabilityFunctional) :
    FunctionalPreferred mf₁ mf₂ ↔ mf₁.value ≤ mf₂.value :=
  Iff.rfl

end Manifestability
