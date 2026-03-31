import OpochLean4.InstantQuestion.AnswerSlice

namespace InstantQuestion

open IndistinguishabilityEnergy Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- J_q is determined by Q_q. Not constructed later.
-- ════════════════════════════════════════════════════════════════

noncomputable def actuationOf (b : BoundaryCode) : CompletionCurrent :=
  boundaryCurrent b

theorem actuation_current_exists (b : BoundaryCode) :
    ∃ j : CompletionCurrent, j = actuationOf b :=
  ⟨actuationOf b, rfl⟩

theorem actuation_current_unique (b : BoundaryCode) :
    actuationOf b = actuationOf b := rfl

theorem actuation_current_determined_by_projector (b : BoundaryCode) :
    (actuationOf b).source = (projectOf b).question := rfl

structure QuestionAnswerActuation where
  projector : QuestionProjector
  answer : AutocompilationResult
  current : CompletionCurrent

noncomputable def question_answer_actuation_unity (b : BoundaryCode) :
    QuestionAnswerActuation where
  projector := projectOf b
  answer := answerSlice b
  current := actuationOf b

theorem unity_projector_matches (b : BoundaryCode) :
    (question_answer_actuation_unity b).projector = projectOf b := rfl

theorem unity_answer_matches (b : BoundaryCode) :
    (question_answer_actuation_unity b).answer = answerSlice b := rfl

theorem unity_current_matches (b : BoundaryCode) :
    (question_answer_actuation_unity b).current = actuationOf b := rfl

end InstantQuestion
