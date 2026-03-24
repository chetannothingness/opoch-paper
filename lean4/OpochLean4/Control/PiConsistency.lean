/-
  OpochLean4/Control/PiConsistency.lean (Step 17)

  Π-consistency: a function on distinctions factors through the truth quotient.
  Gauge transformations are Π-consistent. Π is idempotent.

  Dependencies: TruthQuotient, Gauge
  Assumptions: A0star only.
-/

import OpochLean4.Algebra.TruthQuotient
import OpochLean4.Algebra.Gauge

namespace PiConsistency

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: The Π projection
-- ═══════════════════════════════════════════════════════════════

-- Π is the quotient map from Distinction to TruthClass.
-- It sends each distinction to its equivalence class under Indistinguishable.
def Pi (δ : Distinction) : TruthClass :=
  Quotient.mk distinctionSetoid δ

-- Two distinctions map to the same truth class iff they are indistinguishable
theorem pi_eq_iff (δ₁ δ₂ : Distinction) :
    Pi δ₁ = Pi δ₂ ↔ Indistinguishable δ₁ δ₂ := by
  constructor
  · intro h
    exact Quotient.exact h
  · intro h
    exact Quotient.sound h

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Π-consistency
-- ═══════════════════════════════════════════════════════════════

-- A function f : Distinction → Distinction is Π-consistent if
-- it factors through the truth quotient:
-- whenever Pi(δ₁) = Pi(δ₂), we have Pi(f(δ₁)) = Pi(f(δ₂))
def PiConsistent (f : Distinction → Distinction) : Prop :=
  ∀ δ₁ δ₂, Indistinguishable δ₁ δ₂ → Indistinguishable (f δ₁) (f δ₂)

-- Equivalently: Π ∘ f factors through Π
-- i.e., Pi(δ₁) = Pi(δ₂) → Pi(f(δ₁)) = Pi(f(δ₂))
theorem piConsistent_iff_factors (f : Distinction → Distinction) :
    PiConsistent f ↔
    (∀ δ₁ δ₂, Pi δ₁ = Pi δ₂ → Pi (f δ₁) = Pi (f δ₂)) := by
  constructor
  · intro hpc δ₁ δ₂ heq
    have hindist := (pi_eq_iff δ₁ δ₂).mp heq
    exact (pi_eq_iff (f δ₁) (f δ₂)).mpr (hpc δ₁ δ₂ hindist)
  · intro hfact δ₁ δ₂ hindist
    have heq := (pi_eq_iff δ₁ δ₂).mpr hindist
    exact (pi_eq_iff (f δ₁) (f δ₂)).mp (hfact δ₁ δ₂ heq)

-- The identity is Π-consistent
theorem piConsistent_id : PiConsistent id :=
  fun _ _ h => h

-- Composition of Π-consistent functions is Π-consistent
theorem piConsistent_comp (f g : Distinction → Distinction)
    (hf : PiConsistent f) (hg : PiConsistent g) :
    PiConsistent (f ∘ g) :=
  fun δ₁ δ₂ h => hf (g δ₁) (g δ₂) (hg δ₁ δ₂ h)

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Gauge transformations are Π-consistent
-- ═══════════════════════════════════════════════════════════════

-- Every gauge transformation is Π-consistent: Π ∘ gauge = Π (up to quotient)
-- That is: if g is gauge, then Indistinguishable δ₁ δ₂ → Indistinguishable (g δ₁) (g δ₂)
theorem gauge_is_piConsistent (g : Distinction → Distinction) (hg : IsGauge g) :
    PiConsistent g := by
  intro δ₁ δ₂ hindist
  exact (hg δ₁ δ₂).mp hindist

-- Gauge bijections are Π-consistent
theorem gaugeBij_is_piConsistent (gb : GaugeBijection) :
    PiConsistent gb.forward :=
  gauge_is_piConsistent gb.forward gb.gauge_forward

-- Gauge inverse is also Π-consistent
theorem gaugeBij_inv_piConsistent (gb : GaugeBijection) :
    PiConsistent gb.inverse :=
  gauge_is_piConsistent gb.inverse (gauge_inverse gb)

-- Gauge acts on truth classes: since gauge is Π-consistent,
-- it descends to a well-defined function on the quotient.
-- Pi ∘ gauge agrees on equivalence classes.
theorem gauge_descends_to_quotient (gb : GaugeBijection)
    (δ₁ δ₂ : Distinction) (h : Indistinguishable δ₁ δ₂) :
    Pi (gb.forward δ₁) = Pi (gb.forward δ₂) :=
  (pi_eq_iff (gb.forward δ₁) (gb.forward δ₂)).mpr
    (gauge_is_piConsistent gb.forward gb.gauge_forward δ₁ δ₂ h)

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Π is idempotent
-- ═══════════════════════════════════════════════════════════════

-- We prove Π is idempotent in the sense that the quotient map,
-- when composed with any lift back to Distinction and then projected again,
-- gives the same truth class.
--
-- More precisely: for any section s : TruthClass → Distinction
-- (a right inverse of Pi), Pi ∘ s ∘ Pi = Pi.
-- This is because s picks a representative, and Pi sends it back
-- to the same equivalence class.

-- Any section of Pi satisfies Pi ∘ section = id on TruthClass
-- (stated as: if section picks a representative, Pi sends it back to the same class)
theorem pi_section_roundtrip
    (section_ : TruthClass → Distinction)
    (h_section : ∀ q : TruthClass, Pi (section_ q) = q) :
    ∀ δ : Distinction, Pi (section_ (Pi δ)) = Pi δ := by
  intro δ
  exact h_section (Pi δ)

-- Π is idempotent: applying the quotient map twice is the same as once.
-- Since Π : Distinction → TruthClass and TruthClass = Quotient,
-- this is the statement that Quotient.mk ∘ section ∘ Quotient.mk = Quotient.mk
-- for any section. We prove: the composition is pointwise equal.
theorem pi_idempotent
    (section_ : TruthClass → Distinction)
    (h_section : ∀ q : TruthClass, Pi (section_ q) = q)
    (δ : Distinction) :
    Pi (section_ (Pi δ)) = Pi δ :=
  pi_section_roundtrip section_ h_section δ

-- Alternative idempotency: Π respects its own output.
-- If δ₁ and δ₂ are in the same truth class, they remain so
-- under any Π-consistent function.
theorem pi_stable_under_piConsistent (f : Distinction → Distinction)
    (hf : PiConsistent f) (δ₁ δ₂ : Distinction)
    (h : Pi δ₁ = Pi δ₂) : Pi (f δ₁) = Pi (f δ₂) :=
  ((piConsistent_iff_factors f).mp hf) δ₁ δ₂ h

-- The quotient map is surjective
theorem pi_surjective : ∀ q : TruthClass, ∃ δ : Distinction, Pi δ = q := by
  intro q
  exact Quotient.exists_rep q

-- Π-consistency is preserved by gauge group operations
theorem piConsistent_gauge_comp (g₁ g₂ : GaugeBijection) :
    PiConsistent (gaugeBijComp g₁ g₂).forward :=
  gaugeBij_is_piConsistent (gaugeBijComp g₁ g₂)

end PiConsistency
