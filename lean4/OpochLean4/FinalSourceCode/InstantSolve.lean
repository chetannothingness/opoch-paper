import OpochLean4.FinalSourceCode.UniversalReachability

/-
  FinalSourceCode — Instant Solve

  Every admissible question is instantly solved.
  Question = answer selector = projector.

  New axioms: 0
-/

namespace FinalSourceCode

open IndistinguishabilityEnergy InstantQuestion Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- Instant solve
-- ════════════════════════════════════════════════════════════════

/-- Every admissible question is instantly solved. -/
theorem every_admissible_question_instantly_solved (b : BoundaryCode) :
    ∃ Q : InstantQuestion.QuestionProjector,
      Q.question = b ∧ Q.answer = leastCompletionField b :=
  ⟨projectOf b, rfl, rfl⟩

/-- Question is answer selector: the question determines its answer. -/
theorem question_is_answer_selector_exact (b : BoundaryCode) :
    (projectOf b).question = b ∧
    (projectOf b).answer = leastCompletionField b :=
  ⟨rfl, rfl⟩

/-- Question-answer-projector unity: one object in different bases. -/
theorem question_answer_projector_unity (b : BoundaryCode) :
    (projectOf b).question = b ∧
    (projectOf b).answer = leastCompletionField b ∧
    (actuationOf b).source = (projectOf b).question :=
  ⟨rfl, rfl, rfl⟩

end FinalSourceCode
