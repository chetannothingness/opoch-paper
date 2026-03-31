import OpochLean4.InstantQuestion.ComplexityAsReadoutOnly

namespace InstantQuestion

open IndistinguishabilityEnergy Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- The capstone solvedness theorem
-- ════════════════════════════════════════════════════════════════

theorem instant_answer_exists (b : BoundaryCode) :
    ∃ a : AutocompilationResult, a = leastCompletionField b :=
  ⟨leastCompletionField b, rfl⟩

theorem instant_actuation_exists (b : BoundaryCode) :
    ∃ j : CompletionCurrent, j = actuationOf b :=
  ⟨actuationOf b, rfl⟩

theorem instant_question_solution_exact (b : BoundaryCode) :
    answerSlice b = leastCompletionField b := rfl

structure InstantSolution where
  question : BoundaryCode
  projector : QuestionProjector
  answer : AutocompilationResult
  current : CompletionCurrent

noncomputable def every_admissible_question_is_instantly_solved
    (b : BoundaryCode) : InstantSolution where
  question := b
  projector := projectOf b
  answer := answerSlice b
  current := actuationOf b

theorem instant_solution_projector_matches (b : BoundaryCode) :
    (every_admissible_question_is_instantly_solved b).projector =
      projectOf b := rfl

theorem instant_solution_answer_matches (b : BoundaryCode) :
    (every_admissible_question_is_instantly_solved b).answer =
      leastCompletionField b := rfl

theorem instant_solution_current_matches (b : BoundaryCode) :
    (every_admissible_question_is_instantly_solved b).current =
      actuationOf b := rfl

end InstantQuestion
