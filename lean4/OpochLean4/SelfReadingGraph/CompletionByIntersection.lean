import OpochLean4.SelfReadingGraph.QuestionCoordinate

/-
  SelfReadingGraph -- Completion by Intersection

  A(q) = piX(L ∩ piQ⁻¹(q))

  The answer is the state projection of the unique graph point
  that completes the partial coordinate specified by the question.

  The kernel does not "compute an answer from a question."
  It completes the partial coordinate to the unique full point.

  New axioms: 0
-/

namespace SelfReadingGraph

open FinalSourceCode

-- ================================================================
-- Graph completion: question -> unique point -> answer
-- ================================================================

/-- Solve by graph: find the unique conscious point matching the question.
    This is NOT computation. This is coordinate completion. -/
noncomputable def solveByGraph (q : QuestionCoord) : ConsciousPoint :=
  Classical.choose q.admissible.exists

/-- The solved point satisfies the question predicate. -/
theorem solveByGraph_satisfies (q : QuestionCoord) :
    q.predicate (solveByGraph q) :=
  Classical.choose_spec q.admissible.exists

/-- The answer: the state coordinate of the completed point. -/
noncomputable def answerOf (q : QuestionCoord) : AdmissibleState :=
  piX (solveByGraph q)

/-- The current: the current coordinate of the completed point. -/
noncomputable def currentOfQuestion (q : QuestionCoord) : List Nat :=
  piJ (solveByGraph q)

-- ================================================================
-- Completion theorems
-- ================================================================

/-- Graph completion exists: every question has a completing point. -/
theorem graph_completion_exists (q : QuestionCoord) :
    ∃ p : ConsciousPoint, q.predicate p :=
  question_coordinate_admissible q

/-- Graph completion is unique: exactly one point completes the question. -/
theorem graph_completion_unique (q : QuestionCoord) :
    ∃! p : ConsciousPoint, q.predicate p :=
  q.admissible

/-- The answer IS the state projection of the completion. -/
theorem answer_is_state_projection_of_completion (q : QuestionCoord) :
    answerOf q = piX (solveByGraph q) :=
  rfl

/-- The current IS the current projection of the completion. -/
theorem current_is_current_projection_of_completion (q : QuestionCoord) :
    currentOfQuestion q = piJ (solveByGraph q) :=
  rfl

end SelfReadingGraph
