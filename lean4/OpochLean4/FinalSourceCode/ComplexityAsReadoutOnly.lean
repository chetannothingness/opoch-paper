import OpochLean4.FinalSourceCode.InstantSolve

/-
  FinalSourceCode — Complexity as Readout Only

  Complexity is irrelevant to solvedness.
  It affects readout length only.
  Local manifestation size is the only variable.

  New axioms: 0
-/

namespace FinalSourceCode

open IndistinguishabilityEnergy InstantQuestion Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- Complexity is readout only
-- ════════════════════════════════════════════════════════════════

/-- Complexity is irrelevant to solvedness: every question has a projector. -/
theorem complexity_irrelevant_to_solvedness (b : BoundaryCode) :
    ∃ Q : InstantQuestion.QuestionProjector, Q.question = b :=
  InstantQuestion.complexity_irrelevant_to_solvedness b

/-- Complexity affects readout only: readout size ≤ boundary capacity. -/
theorem complexity_affects_readout_only (b : BoundaryCode) :
    ReadoutSize b ≤ b.boundary.boundaryCapacity :=
  InstantQuestion.complexity_affects_readout_only b

/-- Local manifestation size is the only cost. -/
theorem local_manifestation_size_only (b : BoundaryCode) :
    (projectOf b).answer = leastCompletionField b ∧
    ReadoutSize b = b.code.totalCost :=
  InstantQuestion.local_delay_is_manifestation_only b

end FinalSourceCode
