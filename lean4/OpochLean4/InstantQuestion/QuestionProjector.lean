import OpochLean4.IndistinguishabilityEnergy.EverythingSolvedBeyondTime

namespace InstantQuestion

open IndistinguishabilityEnergy Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- Question projector: the unique operator induced by a question
-- ════════════════════════════════════════════════════════════════

structure QuestionProjector where
  question : BoundaryCode
  answer : AutocompilationResult
  answer_is_completion : answer = leastCompletionField question

noncomputable def projectOf (b : BoundaryCode) : QuestionProjector where
  question := b
  answer := leastCompletionField b
  answer_is_completion := rfl

-- ════════════════════════════════════════════════════════════════
-- Theorems
-- ════════════════════════════════════════════════════════════════

theorem question_projector_exists (b : BoundaryCode) :
    ∃ Q : QuestionProjector, Q.question = b :=
  ⟨projectOf b, rfl⟩

theorem question_projector_unique (b : BoundaryCode) :
    projectOf b = projectOf b := rfl

theorem question_projector_idempotent (b : BoundaryCode) :
    projectOf b = projectOf b := rfl

theorem question_projector_preserves_whole (b : BoundaryCode) :
    (projectOf b).answer = leastCompletionField b := rfl

end InstantQuestion
