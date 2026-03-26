import OpochLean4.Foundations.Manifestability.Indistinguishability

/-
  Manifestability Block — Residual Class

  The operational residual class: an unresolved class equipped with
  finite multiplicity |W| (the number of alternatives) and entropy S(W).

  Dependencies: Indistinguishability
  New axioms: 0
-/

namespace Manifestability

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Residual Class structure
-- ════════════════════════════════════════════════════════════════

/-- A residual class: an unresolved class with finite multiplicity.
    |W| counts pairwise-indistinguishable alternatives.
    Quotient compatibility inherited from UnresolvedClass. -/
structure ResidualClass where
  cls : UnresolvedClass
  multiplicity : Nat
  multiplicity_pos : multiplicity ≥ 1

/-- The residual class is well-defined: multiplicity ≥ 1. -/
theorem residual_class_well_defined (rc : ResidualClass) :
    rc.multiplicity ≥ 1 :=
  rc.multiplicity_pos

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Entropy
-- ════════════════════════════════════════════════════════════════

/-- Entropy S(W) = multiplicity - 1.
    Measures unresolvedness in Nat (avoiding real logarithms).
    S(W) = 0 iff the class is singleton (fully resolved). -/
def entropy (rc : ResidualClass) : Nat := rc.multiplicity - 1

/-- Entropy is non-negative. -/
theorem entropy_nonneg (rc : ResidualClass) : entropy rc ≥ 0 :=
  Nat.zero_le _

/-- Entropy is zero iff the class is a singleton. -/
theorem entropy_zero_iff_singleton (rc : ResidualClass) :
    entropy rc = 0 ↔ rc.multiplicity = 1 := by
  unfold entropy
  constructor
  · intro h; have := rc.multiplicity_pos; omega
  · intro h; simp [h]

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: Constructors
-- ════════════════════════════════════════════════════════════════

/-- Singleton residual class: fully resolved, entropy zero. -/
def singleton (cls : UnresolvedClass) : ResidualClass where
  cls := cls
  multiplicity := 1
  multiplicity_pos := Nat.le_refl 1

/-- Singleton has zero entropy. -/
theorem singleton_entropy (cls : UnresolvedClass) :
    entropy (singleton cls) = 0 := rfl

/-- Entropy is strictly positive for non-singleton classes. -/
theorem entropy_pos_of_non_singleton (rc : ResidualClass)
    (h : rc.multiplicity > 1) : entropy rc > 0 := by
  simp [entropy]; omega

end Manifestability
