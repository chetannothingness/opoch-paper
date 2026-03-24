/-
  OpochLean4/Foundations/WitnessStructure.lean

  First theorem block: W1–W8 from A0star.
  Dependencies: Manifest/Axioms only.
-/

import OpochLean4.Manifest.Axioms

-- Admissible witness: satisfies all A0* conditions
def Admissible (w : Witness) (δ : Distinction) : Prop :=
  Endogenous w ∧ Replayable w ∧ WitFinite w ∧ Separates w δ ∧ ValidityWitnessable w

-- W1: Finite encodability
-- Every admissible witness is finite.
theorem W1_finite (w : Witness) (δ : Distinction) (h : Admissible w δ) : WitFinite w :=
  h.2.2.1

-- W2: Replayability
-- Every admissible witness is replayable.
theorem W2_replayable (w : Witness) (δ : Distinction) (h : Admissible w δ) : Replayable w :=
  h.2.1

-- W8: Internal validity
-- Every admissible witness has witnessable validity.
theorem W8_validity (w : Witness) (δ : Distinction) (h : Admissible w δ) : ValidityWitnessable w :=
  h.2.2.2.2

-- W4: Separation
-- Every admissible witness separates.
theorem W4_separates (w : Witness) (δ : Distinction) (h : Admissible w δ) : Separates w δ :=
  h.2.2.2.1

-- W1+W2: Endogenous and replayable
theorem W1W2_endogenous_replayable (w : Witness) (δ : Distinction) (h : Admissible w δ) :
    Endogenous w ∧ Replayable w :=
  ⟨h.1, h.2.1⟩

-- IsReal distinctions have admissible witnesses
theorem real_has_admissible (δ : Distinction) (hr : IsReal δ) :
    ∃ w, Admissible w δ :=
  (A0star δ).mp hr

-- Admissible witnesses make distinctions real
theorem admissible_makes_real (δ : Distinction) (w : Witness) (h : Admissible w δ) :
    IsReal δ :=
  (A0star δ).mpr ⟨w, h⟩

-- Master extraction: from IsReal δ, extract all properties
theorem real_witness_properties (δ : Distinction) (hr : IsReal δ) :
    ∃ w, Endogenous w ∧ Replayable w ∧ WitFinite w ∧ Separates w δ ∧ ValidityWitnessable w :=
  (A0star δ).mp hr
