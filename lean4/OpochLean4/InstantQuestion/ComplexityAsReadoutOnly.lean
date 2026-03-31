import OpochLean4.InstantQuestion.ActuationLaw

namespace InstantQuestion

open IndistinguishabilityEnergy Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- Complexity does not affect solvedness. Only readout length.
-- ════════════════════════════════════════════════════════════════

def ReadoutSize (b : BoundaryCode) : Nat := b.code.totalCost

theorem complexity_irrelevant_to_solvedness (b : BoundaryCode) :
    ∃ Q : QuestionProjector, Q.question = b :=
  question_projector_exists b

theorem complexity_irrelevant_to_projector (b₁ b₂ : BoundaryCode)
    (h : b₁ = b₂) :
    projectOf b₁ = projectOf b₂ :=
  congrArg projectOf h

theorem complexity_affects_readout_only (b : BoundaryCode) :
    ReadoutSize b ≤ b.boundary.boundaryCapacity :=
  b.fits

theorem local_delay_is_manifestation_only (b : BoundaryCode) :
    (projectOf b).answer = leastCompletionField b ∧
    ReadoutSize b = b.code.totalCost :=
  ⟨rfl, rfl⟩

end InstantQuestion
