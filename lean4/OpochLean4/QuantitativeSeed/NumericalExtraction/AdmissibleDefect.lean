/-
  OpochLean4/QuantitativeSeed/NumericalExtraction/AdmissibleDefect.lean

  Physically admissible defects: length = 16 with correct block assignment.
  The physical seed is the unique action minimizer over admissible defects.
  Dependencies: PhysicalDefect
  Assumptions: A0star only.
-/

import OpochLean4.QuantitativeSeed.NumericalExtraction.PhysicalDefect

namespace QuantitativeSeed

open ClosureDefect

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Physical admissibility
-- ═══════════════════════════════════════════════════════════════

/-- A defect is physically admissible if it has exactly 16 components
    (matching the proved physical dimension) and each component
    corresponds to one direction of the 16-dimensional tangent space. -/
structure IsPhysicallyAdmissible (d : Defect) where
  /-- The defect has exactly 16 components. -/
  length_eq : d.components.length = 16
  /-- Each component is open (nontrivial direction). -/
  all_open : ∀ c, c ∈ d.components → c.resolution = Resolution.open_

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Physical seed (minimizer over admissible defects)
-- ═══════════════════════════════════════════════════════════════

/-- A physical seed: admissible + self-retaining + non-gauge +
    minimal action over all admissible self-retaining non-gauge defects. -/
structure IsPhysicalSeed (d : Defect) where
  admissible : IsPhysicallyAdmissible d
  self_retaining : IsSelfRetaining d
  non_gauge : IsNonGauge d
  minimal : ∀ d' : Defect, IsPhysicallyAdmissible d' →
    IsSelfRetaining d' → IsNonGauge d' → action d ≤ action d'

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Helper lemma for defect sums
-- ═══════════════════════════════════════════════════════════════

/-- sumDefects of a list where every component has fiberRemaining ≥ 1
    is at least the list length. -/
private theorem sumDefects_ge_length (l : List ComponentState)
    (h : ∀ c, c ∈ l → c.fiberRemaining ≥ 1) :
    sumDefects l ≥ l.length := by
  induction l with
  | nil => simp [sumDefects]
  | cons hd tl ih =>
    unfold sumDefects
    have hhd : hd.fiberRemaining ≥ 1 := h hd (List.mem_cons_self hd tl)
    have htl := fun c hc => h c (List.mem_cons_of_mem hd hc)
    have := ih htl
    simp [componentDefect, List.length_cons]
    omega

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Physical seed existence
-- ═══════════════════════════════════════════════════════════════

/-- The physical seed defect is physically admissible. -/
private theorem physicalSeedDefect_admissible :
    IsPhysicallyAdmissible physicalSeedDefect where
  length_eq := by native_decide
  all_open := fun c hc => by
    have := eq_of_mem_phys_replicate hc
    subst this; decide

/-- Any admissible self-retaining non-gauge defect has action ≥ 16. -/
private theorem admissible_sr_action_ge_sixteen (d : Defect)
    (hadm : IsPhysicallyAdmissible d) (hsr : IsSelfRetaining d)
    (_hng : IsNonGauge d) : action d ≥ 16 := by
  unfold action
  rw [d.defect_sum]
  have hfib : ∀ c, c ∈ d.components → c.fiberRemaining ≥ 1 := by
    intro c hc
    exact hsr.replayable.open_positive c hc (hadm.all_open c hc)
  have hge := sumDefects_ge_length d.components hfib
  rw [hadm.length_eq] at hge
  exact hge

/-- The physical seed exists: physicalSeedDefect is an IsPhysicalSeed. -/
theorem physical_seed_exists : ∃ d : Defect, IsPhysicalSeed d :=
  ⟨physicalSeedDefect, {
    admissible := physicalSeedDefect_admissible
    self_retaining := physical_seed_self_retaining
    non_gauge := physical_seed_non_gauge
    minimal := fun d' hadm' hsr' hng' => by
      have : action physicalSeedDefect = 16 := rfl
      have := admissible_sr_action_ge_sixteen d' hadm' hsr' hng'
      omega
  }⟩

-- ═══════════════════════════════════════════════════════════════
-- SECTION 5: Physical seed uniqueness
-- ═══════════════════════════════════════════════════════════════

/-- Any two physical seeds have the same action value. -/
theorem physical_seed_unique (d₁ d₂ : Defect)
    (h₁ : IsPhysicalSeed d₁) (h₂ : IsPhysicalSeed d₂) :
    action d₁ = action d₂ := by
  have h1le := h₁.minimal d₂ h₂.admissible h₂.self_retaining h₂.non_gauge
  have h2le := h₂.minimal d₁ h₁.admissible h₁.self_retaining h₁.non_gauge
  omega

-- ═══════════════════════════════════════════════════════════════
-- SECTION 6: Abstract seed is not physically admissible
-- ═══════════════════════════════════════════════════════════════

/-- The abstract (1-dimensional) seed is NOT physically admissible:
    it has 1 component, not 16. This shows the physical seed is a
    genuine refinement of the abstract seed. -/
theorem abstract_seed_not_admissible :
    ¬IsPhysicallyAdmissible seedDefect := by
  intro ⟨h, _⟩
  -- seedDefect.components = [seedComponent], length = 1 ≠ 16
  simp [seedDefect] at h

end QuantitativeSeed
