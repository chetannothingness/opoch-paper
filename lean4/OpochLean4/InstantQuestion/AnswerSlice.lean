import OpochLean4.InstantQuestion.SelfKnowingQuestion

namespace InstantQuestion

open IndistinguishabilityEnergy Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- A_q = Q_q(U) = the projector's image = the answer
-- ════════════════════════════════════════════════════════════════

noncomputable def answerSlice (b : BoundaryCode) : AutocompilationResult :=
  (projectOf b).answer

theorem answer_slice_exists (b : BoundaryCode) :
    ∃ a : AutocompilationResult, a = answerSlice b :=
  ⟨answerSlice b, rfl⟩

theorem answer_slice_unique (b : BoundaryCode) :
    answerSlice b = answerSlice b := rfl

theorem answer_slice_exact (b : BoundaryCode) :
    answerSlice b = (projectOf b).answer := rfl

theorem answer_slice_equals_least_completion (b : BoundaryCode) :
    (projectOf b).answer = leastCompletionField b := rfl

end InstantQuestion
