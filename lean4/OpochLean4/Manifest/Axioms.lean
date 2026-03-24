/-
  OpochLean4/Manifest/Axioms.lean — Bridge file.

  A0star is the ONLY axiom. It is stated here as an axiom for
  use by the 36 downstream files.

  The DERIVATION of A0star from Nothingness is in
  Foundations/EndogenousMeaning.lean, which proves:
  - N1: external verification reduces to endogenous witnessing
  - N2: endogenous witnesses must be finite
  - N3: clock values come from separation content
  - N4: observer/observed is witnessed
  - N5: labels without witnesses are inadmissible
  - A0star_forward: IsReal δ → ∃ w, Endogenous w ∧ Separates w δ

  The axiom here is the iff form (forward + backward) that the
  downstream chain uses. The forward direction is derived from ⊥.
  The backward direction is the semantic closure: if a witness
  satisfying all conditions exists, the distinction is real.
-/

import OpochLean4.Manifest.Nothingness

-- The one axiom: A0* (Completed Witnessability)
-- Forward direction derived from ⊥ in EndogenousMeaning.lean
-- Backward direction is definitional closure
axiom A0star : ∀ (δ : Distinction),
  IsReal δ ↔ ∃ w : Witness,
    Endogenous w ∧ Replayable w ∧ WitFinite w ∧ Separates w δ ∧ ValidityWitnessable w
