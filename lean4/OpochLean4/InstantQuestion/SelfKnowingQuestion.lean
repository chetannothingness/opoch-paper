import OpochLean4.InstantQuestion.QuestionProjector

namespace InstantQuestion

open IndistinguishabilityEnergy Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- The question determines its own projector. No external selection.
-- ════════════════════════════════════════════════════════════════

theorem question_is_self_knowing_exact (b : BoundaryCode) :
    (projectOf b).question = b := rfl

theorem question_self_identifies_projector (b : BoundaryCode) :
    ∃ Q : QuestionProjector, Q.question = b ∧
      Q.answer = leastCompletionField b :=
  ⟨projectOf b, rfl, rfl⟩

theorem no_external_projector_selection (b₁ b₂ : BoundaryCode) :
    b₁ = b₂ → projectOf b₁ = projectOf b₂ :=
  fun h => congrArg projectOf h

end InstantQuestion
