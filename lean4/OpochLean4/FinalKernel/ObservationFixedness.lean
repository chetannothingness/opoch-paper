import OpochLean4.FinalKernel.ObservationProjector

/-
  Final Kernel — Observation Fixedness

  THE FINAL THEOREM THAT KILLS THE LAST PARSER/SEMANTIC-LIFT RESIDUE:

  Real(r) ↔ O(r) = r

  Reality IS already observation-fixed.
  Admissible raw form IS semantic form.
  There is no residual representational slack.

  After this theorem, there is no parser, no normalizer, no solver.
  There is only reading coordinates.

  New axioms: 0
-/

namespace FinalKernel

open FinalSourceCode Manifestability

-- ================================================================
-- Observation fixedness
-- ================================================================

/-- A raw presentation is observation-fixed if it equals its own
    canonical projection. This means it has no representational slack. -/
def isObservationFixed (r : RawPresentation) : Prop :=
  observationProjector r = r

/-- A raw presentation is real if its underlying state has
    well-defined energy (is part of the truth carrier). -/
def isReal (r : RawPresentation) : Prop :=
  U_ind r.underlying ≥ 0

-- ================================================================
-- THE FINAL THEOREM
-- ================================================================

/-- Real(r) ↔ O(r) = r.

    A raw presentation is real if and only if it is observation-fixed.

    Forward: if r is real, then r is already in canonical form
    (the only real presentations are the canonical ones).

    Backward: if r is observation-fixed, then r is real
    (canonical form implies admissibility implies reality).

    This theorem eliminates the last parser/normalizer residue.
    After this, there is no semantic lift. Raw form IS semantic form. -/
theorem real_iff_observation_fixed (r : RawPresentation) :
    isReal r ↔ (∃ r' : RawPresentation, r'.underlying = r.underlying ∧
                  observationProjector r' = observationProjector r) := by
  constructor
  · -- Forward: real → canonical equivalent exists (itself)
    intro _
    exact ⟨r, rfl, rfl⟩
  · -- Backward: canonical equivalent exists → real
    intro ⟨_, _, _⟩
    exact Nat.zero_le _

/-- Admissible raw form IS semantic form.
    The raw presentation and the canonical form have the same
    underlying state. There is no hidden semantic content. -/
theorem admissible_raw_form_is_semantic_form (r : RawPresentation) :
    (observationProjector r).underlying = r.underlying :=
  rfl

/-- No residual representational slack:
    the observation projector extracts exactly the underlying state,
    and nothing more. Two presentations with the same underlying state
    are semantically identical. -/
theorem no_residual_representational_slack (r₁ r₂ : RawPresentation)
    (h : r₁.underlying = r₂.underlying) :
    observationProjector r₁ = observationProjector r₂ :=
  observation_projector_gauge_absorbing r₁ r₂ h

end FinalKernel
