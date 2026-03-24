/-
  OpochLean4/Algebra/TruthQuotient.lean

  Truth quotient: indistinguishable distinctions are identified.
  Dependencies: Manifest/Axioms, Foundations/WitnessStructure
-/

import OpochLean4.Foundations.WitnessStructure

-- Two distinctions are indistinguishable if no witness separates one but not the other
def Indistinguishable (δ₁ δ₂ : Distinction) : Prop :=
  ∀ w : Witness, Separates w δ₁ ↔ Separates w δ₂

-- Indistinguishability is reflexive
theorem indist_refl (δ : Distinction) : Indistinguishable δ δ :=
  fun _ => Iff.rfl

-- Indistinguishability is symmetric
theorem indist_symm (δ₁ δ₂ : Distinction) (h : Indistinguishable δ₁ δ₂) :
    Indistinguishable δ₂ δ₁ :=
  fun w => (h w).symm

-- Indistinguishability is transitive
theorem indist_trans (δ₁ δ₂ δ₃ : Distinction)
    (h₁₂ : Indistinguishable δ₁ δ₂) (h₂₃ : Indistinguishable δ₂ δ₃) :
    Indistinguishable δ₁ δ₃ :=
  fun w => (h₁₂ w).trans (h₂₃ w)

-- Indistinguishability is an equivalence relation
theorem indist_equivalence : Equivalence Indistinguishable :=
  ⟨indist_refl, indist_symm _ _, indist_trans _ _ _⟩

-- The setoid on Distinction
instance distinctionSetoid : Setoid Distinction where
  r := Indistinguishable
  iseqv := indist_equivalence

-- The truth quotient: distinctions modulo indistinguishability
def TruthClass := Quotient distinctionSetoid

-- A property is quotient-invariant if it respects indistinguishability
def QuotientInvariant (P : Distinction → Prop) : Prop :=
  ∀ δ₁ δ₂, Indistinguishable δ₁ δ₂ → (P δ₁ ↔ P δ₂)

-- Q1 (Qualitative Forcing): IsReal is quotient-invariant
-- If two distinctions are indistinguishable, they are either both real or both not real.
theorem Q1_real_quotient_invariant : QuotientInvariant IsReal := by
  intro δ₁ δ₂ hindist
  constructor
  · intro hr₁
    obtain ⟨w, hendo, hrep, hfin, hsep, hval⟩ := (A0star δ₁).mp hr₁
    exact (A0star δ₂).mpr ⟨w, hendo, hrep, hfin, (hindist w).mp hsep, hval⟩
  · intro hr₂
    obtain ⟨w, hendo, hrep, hfin, hsep, hval⟩ := (A0star δ₂).mp hr₂
    exact (A0star δ₁).mpr ⟨w, hendo, hrep, hfin, (hindist w).mpr hsep, hval⟩

-- Gauge: a transformation is gauge if it preserves indistinguishability
def IsGauge (g : Distinction → Distinction) : Prop :=
  ∀ δ₁ δ₂, Indistinguishable δ₁ δ₂ ↔ Indistinguishable (g δ₁) (g δ₂)

-- Gauge identity
theorem gauge_id : IsGauge id :=
  fun _ _ => Iff.rfl

-- Gauge composition
theorem gauge_comp (g₁ g₂ : Distinction → Distinction)
    (hg₁ : IsGauge g₁) (hg₂ : IsGauge g₂) : IsGauge (g₁ ∘ g₂) :=
  fun δ₁ δ₂ => (hg₂ δ₁ δ₂).trans (hg₁ (g₂ δ₁) (g₂ δ₂))
