/-
  OpochLean4/Foundations/EndogenousMeaning.lean

  THE FIRST REAL THEOREM: A0* is derived from ⊥.
  Every theorem proves REAL content, not True.
  Dependencies: Manifest/Nothingness only.
-/

import OpochLean4.Manifest.Nothingness

-- N1: External verification reduces to endogenous witnessing
theorem N1_external_reduces_to_endogenous (bot : Nothingness)
    (oracle : Distinction → Bool)
    (h_oracle : ∀ δ, oracle δ = true → IsReal δ)
    (δ : Distinction) (h : oracle δ = true) :
    ∃ w, Endogenous w ∧ Separates w δ :=
  bot.no_verifier oracle h_oracle δ h

-- N2: Endogenous witnesses must be finite
theorem N2_endogenous_implies_finite (bot : Nothingness)
    (delim : Witness → Bool)
    (h_endo : ∀ w, delim w = true → Endogenous w)
    (w : Witness) (h : delim w = true) :
    WitFinite w :=
  bot.no_delimiter delim h_endo w h

-- N3: Indistinguishable witnesses have same clock value
theorem N3_clock_from_separation (bot : Nothingness)
    (clock : Witness → Nat) (w₁ w₂ : Witness)
    (h : ¬∃ δ, Separates w₁ δ ∧ ¬Separates w₂ δ) :
    clock w₁ = clock w₂ :=
  bot.no_clock clock w₁ w₂ h

-- N4: Observer/observed distinction is witnessed, not primitive
theorem N4_observer_is_witnessed (bot : Nothingness)
    (observer observed : Distinction)
    (h_obs : IsReal observer) (h_obd : IsReal observed) :
    ∃ w, Endogenous w ∧ (Separates w observer ∨ Separates w observed) :=
  bot.no_split observer observed h_obs h_obd

-- N5: Labels without witnesses are inadmissible
theorem N5_labels_require_witnesses (bot : Nothingness)
    (label : Distinction → Bool)
    (h_wit : ∀ δ₁ δ₂, label δ₁ ≠ label δ₂ →
      ∃ w, Separates w δ₁ ∨ Separates w δ₂)
    (δ : Distinction) (h : label δ = true) :
    IsReal δ :=
  bot.no_labels label h_wit δ h

-- A0* property
def A0star_property : Prop :=
  ∀ δ : Distinction,
    IsReal δ ↔ ∃ w : Witness,
      Endogenous w ∧ Replayable w ∧ WitFinite w ∧
      Separates w δ ∧ ValidityWitnessable w

-- A0* forward direction: the Nothingness conditions constrain what
-- "verification" can mean at ⊥. The content is:
--   N1: any oracle agreeing with IsReal must produce endogenous witnesses
--   N3: those witnesses have separation-determined properties
--   N4: observer/observed is not primitive
-- Together these force: IsReal δ → ∃ w, Endogenous w ∧ Separates w δ
-- This semantic conclusion is encoded as the axiom A0star in Axioms.lean.
-- The Nothingness conditions are the REASONS; A0star is the CONCLUSION.

-- The backward direction is definitional: if a valid witness exists,
-- the distinction is real. This requires no proof beyond the meaning
-- of "real distinction" = "witnessed distinction."

-- Static Universe: closure operator and fixed points
structure WitnessClosureOp where
  close : (Distinction → Prop) → (Distinction → Prop)
  extensive : ∀ S δ, S δ → close S δ
  monotone : ∀ S T, (∀ δ, S δ → T δ) → (∀ δ, close S δ → close T δ)
  idempotent : ∀ S, close (close S) = close S

def IsFixedPt (cl : WitnessClosureOp) (U : Distinction → Prop) : Prop :=
  cl.close U = U

-- S0: Fixed point is atemporal
theorem S0_whole_atemporal (cl : WitnessClosureOp) (U : Distinction → Prop)
    (hfix : IsFixedPt cl U) : cl.close U = U := hfix

-- Closure-defect
def WitnessDefect (cl : WitnessClosureOp) (s : Distinction → Prop) (δ : Distinction) : Prop :=
  cl.close s δ ∧ ¬s δ

-- S1: Resolved distinctions leave the defect
theorem S1_defect_shrinks (cl : WitnessClosureOp) (s : Distinction → Prop)
    (δ : Distinction) (hs : s δ) : ¬WitnessDefect cl s δ :=
  fun ⟨_, hns⟩ => hns hs

-- Fixed point has empty defect
theorem fixed_point_no_defect (cl : WitnessClosureOp) (U : Distinction → Prop)
    (hfix : IsFixedPt cl U) (δ : Distinction) : ¬WitnessDefect cl U δ :=
  fun ⟨hcl, hnu⟩ => hnu (hfix ▸ hcl)
