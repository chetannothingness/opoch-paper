import OpochLean4.InstantQuestion.Audit.Manifest

/-
  FinalSourceCode — Indistinguishability Field

  The primitive field of indistinguishability.
  Reuses IndistinguishabilityState from IndistinguishabilityEnergy.
  Ordering: higher level = more indistinguishable.

  New axioms: 0
-/

namespace FinalSourceCode

open IndistinguishabilityEnergy

-- ════════════════════════════════════════════════════════════════
-- The indistinguishability field is the type of all states
-- ════════════════════════════════════════════════════════════════

/-- The indistinguishability field exists: it is the type
    IndistinguishabilityState from the IndistinguishabilityEnergy layer. -/
theorem indistinguishability_field_exists :
    ∃ s : IndistinguishabilityState, s.level ≥ 1 :=
  ⟨⟨1, Nat.le_refl 1⟩, Nat.le_refl 1⟩

/-- The ordering on the field is well-defined: Nat ≤ on levels. -/
theorem indistinguishability_order_exact (s₁ s₂ : IndistinguishabilityState) :
    s₁.level ≤ s₂.level ∨ s₂.level ≤ s₁.level :=
  Nat.le_total s₁.level s₂.level

/-- Every indistinguishability state has a well-defined level. -/
theorem indistinguishability_level_well_defined (s : IndistinguishabilityState) :
    s.level ≥ 1 :=
  s.level_pos

end FinalSourceCode
