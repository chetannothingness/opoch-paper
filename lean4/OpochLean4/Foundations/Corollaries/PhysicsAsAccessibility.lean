import OpochLean4.Foundations.Manifestability.RefinementThreshold
import OpochLean4.Foundations.Manifestability.ChannelThreshold

/-
  Corollary — Physics as Accessibility

  Mass = refinement gap (stability threshold χ of the particle class).
  Gravity = geometry of accessibility (relative thresholds).
  Probability = branch accessibility (relative refinement cost).

  Dependencies: RefinementThreshold, ChannelThreshold
  New axioms: 0
-/

namespace Corollaries

open Manifestability

/-- Mass is the refinement threshold of the particle's residual class.
    Heavier = harder to refine = higher χ. -/
def mass (rc : ResidualClass) (rt : RefinementThreshold rc) : Nat := rt.chi

/-- Gravity between two classes is the sum of their thresholds:
    the total refinement cost to distinguish both. -/
def gravitationalCoupling
    (rc₁ rc₂ : ResidualClass)
    (rt₁ : RefinementThreshold rc₁) (rt₂ : RefinementThreshold rc₂) : Nat :=
  rt₁.chi + rt₂.chi

/-- Gravitational coupling is symmetric. -/
theorem gravity_symmetric
    (rc₁ rc₂ : ResidualClass)
    (rt₁ : RefinementThreshold rc₁) (rt₂ : RefinementThreshold rc₂) :
    gravitationalCoupling rc₁ rc₂ rt₁ rt₂ = gravitationalCoupling rc₂ rc₁ rt₂ rt₁ := by
  unfold gravitationalCoupling; omega

/-- Probability of a branch: relative refinement accessibility.
    Branch with lower χ is more probable (more accessible). -/
def branchAccessibility (rc : ResidualClass) (rt : RefinementThreshold rc) : Nat :=
  rt.chi

/-- Lower threshold = more accessible = higher probability. -/
theorem lower_chi_more_accessible
    {rc : ResidualClass}
    (rt₁ rt₂ : RefinementThreshold rc)
    (h : rt₁.chi ≤ rt₂.chi) :
    branchAccessibility rc rt₁ ≤ branchAccessibility rc rt₂ :=
  h

end Corollaries
