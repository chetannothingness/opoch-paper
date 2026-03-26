import OpochLean4.Foundations.Manifestability.RefinementThreshold
import OpochLean4.Foundations.Manifestability.ValueEquation

/-
  Corollary — Consciousness as Threshold Selection

  Attention = selection by V−χ (net value).
  Effort = paying χ (the refinement cost).
  Learning = lowering χ (reducing future refinement cost).

  Dependencies: RefinementThreshold, ValueEquation
  New axioms: 0
-/

namespace Corollaries

open Manifestability

/-- Attention: selection of the class with highest net value V−χ. -/
def attentionValue (stateValue : Nat) (rc : ResidualClass)
    (rt : RefinementThreshold rc) : Nat :=
  stateValue - rt.chi

/-- Effort: the cost of refining (= paying χ). -/
def effort (rc : ResidualClass) (rt : RefinementThreshold rc) : Nat :=
  rt.chi

/-- Learning: reducing χ by acquiring a more efficient channel.
    If channel β has lower threshold than α, switching from α to β
    is learning. -/
def learningGain
    {rc : ResidualClass}
    (rt_before rt_after : RefinementThreshold rc)
    (h : rt_after.chi ≤ rt_before.chi) : Nat :=
  rt_before.chi - rt_after.chi

/-- Learning is non-negative. -/
theorem learning_nonneg
    {rc : ResidualClass}
    (rt_before rt_after : RefinementThreshold rc)
    (h : rt_after.chi ≤ rt_before.chi) :
    learningGain rt_before rt_after h ≥ 0 :=
  Nat.zero_le _

/-- More attention goes to classes with higher net value. -/
theorem attention_prefers_higher_net_value
    (v₁ v₂ : Nat) (rc : ResidualClass) (rt : RefinementThreshold rc)
    (h : v₁ ≤ v₂) :
    attentionValue v₁ rc rt ≤ attentionValue v₂ rc rt := by
  unfold attentionValue; omega

end Corollaries
