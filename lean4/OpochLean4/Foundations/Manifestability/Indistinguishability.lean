import OpochLean4.Algebra.TruthQuotient

/-
  Manifestability Block — Indistinguishability

  Extends the truth quotient with the operational notion of unresolved class.
  An unresolved class W is a TruthClass: the set of distinctions that no
  current witness can tell apart. This is the starting point for χ(W).

  Dependencies: Algebra/TruthQuotient (hence Axioms, WitnessStructure)
  New axioms: 0
-/

namespace Manifestability

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Unresolved Class
-- ════════════════════════════════════════════════════════════════

/-- An unresolved class is an equivalence class under indistinguishability.
    Same type as TruthClass, named for the manifestability context:
    it represents what reality has NOT YET resolved. -/
def UnresolvedClass := TruthClass

/-- Construct an unresolved class from a representative distinction. -/
def UnresolvedClass.mk (δ : Distinction) : UnresolvedClass :=
  Quotient.mk distinctionSetoid δ

/-- Two distinctions in the same class are indistinguishable. -/
theorem same_class_indist (δ₁ δ₂ : Distinction)
    (h : UnresolvedClass.mk δ₁ = UnresolvedClass.mk δ₂) :
    Indistinguishable δ₁ δ₂ :=
  Quotient.exact h

/-- Indistinguishable distinctions map to the same class. -/
theorem indist_same_class (δ₁ δ₂ : Distinction)
    (h : Indistinguishable δ₁ δ₂) :
    UnresolvedClass.mk δ₁ = UnresolvedClass.mk δ₂ :=
  Quotient.sound h

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Quotient-compatible properties
-- ════════════════════════════════════════════════════════════════

/-- IsReal lifts to unresolved classes (by Q1). -/
def UnresolvedClass.isReal : UnresolvedClass → Prop :=
  Quotient.lift IsReal (fun _ _ h => propext (Q1_real_quotient_invariant _ _ h))

/-- isReal on the class agrees with IsReal on any representative. -/
theorem isReal_compat (δ : Distinction) :
    (UnresolvedClass.mk δ).isReal = IsReal δ := rfl

/-- Class equality is an equivalence relation. -/
theorem class_eq_equivalence : Equivalence
    (fun (c₁ c₂ : UnresolvedClass) => c₁ = c₂) :=
  ⟨fun _ => rfl, fun h => h.symm, fun h₁ h₂ => h₁.trans h₂⟩

end Manifestability
