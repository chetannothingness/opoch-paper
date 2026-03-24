/-
  OpochLean4/Manifest/Nothingness.lean — The true foundation.

  ⊥ := no committed distinctions.

  The Nothingness conditions are REAL propositions about the
  type structure, not trivial True placeholders.
-/

-- The raw types with NO structure
opaque Distinction : Type
opaque Witness : Type

-- Primitive predicates (vocabulary only — no properties assumed)
opaque Endogenous : Witness → Prop
opaque Replayable : Witness → Prop
opaque WitFinite : Witness → Prop
opaque Separates : Witness → Distinction → Prop
opaque ValidityWitnessable : Witness → Prop
opaque IsReal : Distinction → Prop

-- ════════════════════════════════════════════════════════════════
-- Nothingness conditions — REAL propositions
-- ════════════════════════════════════════════════════════════════

/-- At ⊥, no external labeling function can distinguish what
    IsReal cannot. Any label that disagrees with IsReal on some
    distinction relies on external structure. -/
def NoExternalLabels : Prop :=
  ∀ (label : Distinction → Bool),
    (∀ δ₁ δ₂, label δ₁ ≠ label δ₂ → ∃ w, Separates w δ₁ ∨ Separates w δ₂) →
    ∀ δ, label δ = true → IsReal δ

/-- At ⊥, no external delimiter can mark witness boundaries.
    If a delimiter existed, it would itself be a distinction
    requiring a witness — circularity unless endogenous. -/
def NoExternalDelimiter : Prop :=
  ∀ (delim : Witness → Bool),
    (∀ w, delim w = true → Endogenous w) →
    ∀ w, delim w = true → WitFinite w

/-- At ⊥, there is no external clock — no function from witnesses
    to a time value that is independent of the witness's own
    internal cost structure. -/
def NoExternalClock : Prop :=
  ∀ (clock : Witness → Nat), ∀ w₁ w₂,
    (¬∃ δ, Separates w₁ δ ∧ ¬Separates w₂ δ) →
    clock w₁ = clock w₂

/-- At ⊥, there is no external verifier — no oracle that can
    determine IsReal without being a witness itself. -/
def NoExternalVerifier : Prop :=
  ∀ (oracle : Distinction → Bool),
    (∀ δ, oracle δ = true → IsReal δ) →
    ∀ δ, oracle δ = true →
      ∃ w, Endogenous w ∧ Separates w δ

/-- At ⊥, there is no primitive observer/observed split — the
    distinction between "observer" and "observed" must itself be
    witnessed, not pre-given. -/
def NoPrimitiveSplit : Prop :=
  ∀ (observer observed : Distinction),
    IsReal observer → IsReal observed →
    ∃ w, Endogenous w ∧ (Separates w observer ∨ Separates w observed)

/-- ⊥ is the conjunction of all no-externality conditions. -/
structure Nothingness where
  no_labels : NoExternalLabels
  no_delimiter : NoExternalDelimiter
  no_clock : NoExternalClock
  no_verifier : NoExternalVerifier
  no_split : NoPrimitiveSplit

/-- N0: At ⊥, any proposed distinction that depends on an external
    distinguisher is inadmissible, because the external distinguisher
    would itself require witnessing. -/
theorem N0_no_external_verifier (bot : Nothingness)
    (oracle : Distinction → Bool)
    (h_oracle : ∀ δ, oracle δ = true → IsReal δ)
    (δ : Distinction) (h_true : oracle δ = true) :
    ∃ w, Endogenous w ∧ Separates w δ :=
  bot.no_verifier oracle h_oracle δ h_true

/-- N0 consequence: external clock cannot distinguish
    indistinguishable witnesses. -/
theorem N0_clock_invariance (bot : Nothingness)
    (clock : Witness → Nat) (w₁ w₂ : Witness)
    (h_indist : ¬∃ δ, Separates w₁ δ ∧ ¬Separates w₂ δ) :
    clock w₁ = clock w₂ :=
  bot.no_clock clock w₁ w₂ h_indist
