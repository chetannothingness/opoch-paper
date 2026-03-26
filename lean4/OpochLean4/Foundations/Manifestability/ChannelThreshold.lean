import OpochLean4.Foundations.Manifestability.RefinementThreshold

/-
  Manifestability Block — Channel Threshold

  χ_α(W) = inf{c(τ) : τ ∈ α, τ|_W nonconstant}

  Generalizes χ to witness channels. Different channels yield
  different thresholds. This is what gives hidden sectors,
  dark channels, and presentation-dependent hardness.

  Dependencies: RefinementThreshold
  New axioms: 0
-/

namespace Manifestability

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Channel-restricted nonconstancy
-- ════════════════════════════════════════════════════════════════

/-- A witness is nonconstant on a class VIA a specific channel. -/
def IsNonconstantViaChannel (w : Witness) (α : WitnessChannel)
    (rc : ResidualClass) : Prop :=
  α.member w ∧ IsNonconstantOn w rc

/-- A class is refinable via channel α. -/
def IsRefinableVia (α : WitnessChannel) (rc : ResidualClass) : Prop :=
  ∃ w : Witness, IsNonconstantViaChannel w α rc

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Channel Threshold χ_α(W)
-- ════════════════════════════════════════════════════════════════

/-- Channel-dependent refinement threshold χ_α(W).
    Restricts the infimum to witnesses in channel α. -/
structure ChannelThreshold (α : WitnessChannel) (rc : ResidualClass) where
  chi_channel : Nat
  refinable_via : IsRefinableVia α rc
  lower_bound : ∀ w : Witness, IsNonconstantViaChannel w α rc →
    witnessCost w ≥ chi_channel
  achieves : ∃ w : Witness, IsNonconstantViaChannel w α rc ∧
    witnessCost w = chi_channel

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: Theorems
-- ════════════════════════════════════════════════════════════════

/-- χ_α(W) is well-defined. -/
theorem chi_channel_well_defined {α : WitnessChannel} {rc : ResidualClass}
    (ct₁ ct₂ : ChannelThreshold α rc) :
    ct₁.chi_channel = ct₂.chi_channel := by
  obtain ⟨w₁, hw₁, hc₁⟩ := ct₁.achieves
  obtain ⟨w₂, hw₂, hc₂⟩ := ct₂.achieves
  have := ct₂.lower_bound w₁ hw₁
  have := ct₁.lower_bound w₂ hw₂
  omega

/-- χ_α(W) ≥ χ(W): restricting to a subchannel can only increase the threshold.
    The universal channel gives the global minimum. -/
theorem chi_channel_ge_chi {α : WitnessChannel} {rc : ResidualClass}
    (ct : ChannelThreshold α rc) (rt : RefinementThreshold rc) :
    ct.chi_channel ≥ rt.chi := by
  obtain ⟨w, ⟨_, hw_nc⟩, hw_cost⟩ := ct.achieves
  have := rt.lower_bound w hw_nc
  omega

/-- χ_α is gauge-invariant: same class ⟹ same channel threshold. -/
theorem chi_channel_gauge_invariant {α : WitnessChannel}
    {rc₁ rc₂ : ResidualClass}
    (hcls : rc₁.cls = rc₂.cls)
    (ct₁ : ChannelThreshold α rc₁) (ct₂ : ChannelThreshold α rc₂) :
    ct₁.chi_channel = ct₂.chi_channel := by
  obtain ⟨w₁, ⟨hm₁, hnc₁⟩, hc₁⟩ := ct₁.achieves
  obtain ⟨w₂, ⟨hm₂, hnc₂⟩, hc₂⟩ := ct₂.achieves
  have hnc₁₂ : IsNonconstantViaChannel w₁ α rc₂ := by
    constructor
    · exact hm₁
    · obtain ⟨δ₁, δ₂, h₁, h₂, hs₁, hs₂⟩ := hnc₁
      exact ⟨δ₁, δ₂, hcls ▸ h₁, hcls ▸ h₂, hs₁, hs₂⟩
  have hnc₂₁ : IsNonconstantViaChannel w₂ α rc₁ := by
    constructor
    · exact hm₂
    · obtain ⟨δ₁, δ₂, h₁, h₂, hs₁, hs₂⟩ := hnc₂
      exact ⟨δ₁, δ₂, hcls ▸ h₁, hcls ▸ h₂, hs₁, hs₂⟩
  have := ct₂.lower_bound w₁ hnc₁₂
  have := ct₁.lower_bound w₂ hnc₂₁
  omega

end Manifestability
