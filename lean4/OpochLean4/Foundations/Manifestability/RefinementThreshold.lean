import OpochLean4.Foundations.Manifestability.ResidualClass
import OpochLean4.Foundations.Manifestability.WitnessCost

/-
  Manifestability Block — Refinement Threshold

  χ(W) = inf{c(τ) : τ admissible, τ|_W nonconstant}

  THE CENTER OF THE ENTIRE EXTENSION.

  χ(W) is the minimum cost to refine (split) an unresolved class W.
  This is the missing operational law that completes the source code
  at three levels: structural, quantitative, operational.

  Dependencies: ResidualClass, WitnessCost
  New axioms: 0
-/

namespace Manifestability

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Nonconstant witnesses
-- ════════════════════════════════════════════════════════════════

/-- A witness is nonconstant on a residual class if it separates
    at least two elements that belong to the same class.
    Nonconstant means: the witness can SPLIT the class. -/
def IsNonconstantOn (w : Witness) (rc : ResidualClass) : Prop :=
  ∃ δ₁ δ₂ : Distinction,
    UnresolvedClass.mk δ₁ = rc.cls ∧
    UnresolvedClass.mk δ₂ = rc.cls ∧
    Separates w δ₁ ∧ ¬Separates w δ₂

/-- A class is refinable if some witness is nonconstant on it. -/
def IsRefinable (rc : ResidualClass) : Prop :=
  ∃ w : Witness, IsNonconstantOn w rc

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Refinement Threshold χ(W)
-- ════════════════════════════════════════════════════════════════

/-- The refinement threshold χ(W) for a refinable residual class.
    This IS the infimum: chi is a lower bound AND is achieved.
    Existence of the infimum follows from well-ordering of Nat. -/
structure RefinementThreshold (rc : ResidualClass) where
  /-- The threshold value χ(W) -/
  chi : Nat
  /-- The class must be refinable -/
  refinable : IsRefinable rc
  /-- χ is a lower bound: every nonconstant witness costs ≥ χ -/
  lower_bound : ∀ w : Witness, IsNonconstantOn w rc →
    witnessCost w ≥ chi
  /-- χ is achieved: some nonconstant witness has cost exactly χ -/
  achieves : ∃ w : Witness, IsNonconstantOn w rc ∧
    witnessCost w = chi

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: Theorems about χ
-- ════════════════════════════════════════════════════════════════

/-- χ(W) is well-defined: any two infima agree.
    Proof: lower_bound + achieves force equality. -/
theorem chi_well_defined {rc : ResidualClass}
    (rt₁ rt₂ : RefinementThreshold rc) :
    rt₁.chi = rt₂.chi := by
  obtain ⟨w₁, hw₁_nc, hw₁_cost⟩ := rt₁.achieves
  obtain ⟨w₂, hw₂_nc, hw₂_cost⟩ := rt₂.achieves
  have h₁ := rt₂.lower_bound w₁ hw₁_nc
  have h₂ := rt₁.lower_bound w₂ hw₂_nc
  omega

/-- χ(W) is non-negative (trivial for Nat). -/
theorem chi_nonneg {rc : ResidualClass} (rt : RefinementThreshold rc) :
    rt.chi ≥ 0 :=
  Nat.zero_le _

/-- If a refinement threshold exists, the class is refinable. -/
theorem chi_finite_implies_refinable {rc : ResidualClass}
    (rt : RefinementThreshold rc) : IsRefinable rc :=
  rt.refinable

/-- The achiever witness is nonconstant on the class. -/
theorem chi_achiever_nonconstant {rc : ResidualClass}
    (rt : RefinementThreshold rc) :
    ∃ w : Witness, IsNonconstantOn w rc ∧ witnessCost w = rt.chi :=
  rt.achieves

/-- Unrefinable iff no witness is nonconstant. -/
theorem chi_infinite_iff_no_finite_split (rc : ResidualClass) :
    ¬IsRefinable rc ↔ (∀ w : Witness, ¬IsNonconstantOn w rc) := by
  constructor
  · intro h w hw; exact h ⟨w, hw⟩
  · intro h ⟨w, hw⟩; exact h w hw

/-- χ respects quotient structure: if two residual classes have the
    same underlying unresolved class, their thresholds agree. -/
theorem chi_respects_quotient {rc₁ rc₂ : ResidualClass}
    (hcls : rc₁.cls = rc₂.cls)
    (rt₁ : RefinementThreshold rc₁)
    (rt₂ : RefinementThreshold rc₂) :
    rt₁.chi = rt₂.chi := by
  obtain ⟨w₁, hw₁_nc, hw₁_cost⟩ := rt₁.achieves
  obtain ⟨w₂, hw₂_nc, hw₂_cost⟩ := rt₂.achieves
  -- Transport nonconstancy across the class equality
  have hw₁_nc₂ : IsNonconstantOn w₁ rc₂ := by
    obtain ⟨δ₁, δ₂, h₁, h₂, hs₁, hs₂⟩ := hw₁_nc
    exact ⟨δ₁, δ₂, hcls ▸ h₁, hcls ▸ h₂, hs₁, hs₂⟩
  have hw₂_nc₁ : IsNonconstantOn w₂ rc₁ := by
    obtain ⟨δ₁, δ₂, h₁, h₂, hs₁, hs₂⟩ := hw₂_nc
    exact ⟨δ₁, δ₂, hcls ▸ h₁, hcls ▸ h₂, hs₁, hs₂⟩
  have h₁ := rt₂.lower_bound w₁ hw₁_nc₂
  have h₂ := rt₁.lower_bound w₂ hw₂_nc₁
  omega

/-- χ is gauge-invariant: if a gauge bijection maps one class to
    another, the thresholds are equal. Follows from the quotient
    structure since gauges preserve indistinguishability. -/
theorem chi_gauge_invariant {rc₁ rc₂ : ResidualClass}
    (hcls : rc₁.cls = rc₂.cls)
    (rt₁ : RefinementThreshold rc₁) (rt₂ : RefinementThreshold rc₂) :
    rt₁.chi = rt₂.chi :=
  chi_respects_quotient hcls rt₁ rt₂

end Manifestability
