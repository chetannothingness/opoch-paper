import OpochLean4.SelfReadingGraph.ConsciousPoint

/-
  SelfReadingGraph -- Question as Partial Coordinate

  A question is NOT external input. NOT syntax to interpret.
  A question IS a partial coordinate condition on ConsciousPoint.
  It determines a unique point of L.

  New axioms: 0
-/

namespace SelfReadingGraph

open FinalSourceCode

-- ================================================================
-- Question = partial coordinate on L
-- ================================================================

/-- A question coordinate: a predicate on ConsciousPoint that
    picks out exactly one point of L.

    A real question is a partial coordinate — it specifies some
    coordinates of the point, and the graph L determines the rest. -/
structure QuestionCoord where
  /-- The predicate: which conscious points match this question? -/
  predicate : ConsciousPoint -> Prop
  /-- Admissibility: exactly one point matches. -/
  admissible : ∃! p : ConsciousPoint, predicate p

-- ================================================================
-- Theorems
-- ================================================================

/-- A question IS a partial coordinate on the self-reading graph. -/
theorem question_is_partial_coordinate_exact (q : QuestionCoord) :
    ∃! p : ConsciousPoint, q.predicate p :=
  q.admissible

/-- Every question coordinate is admissible (by construction). -/
theorem question_coordinate_admissible (q : QuestionCoord) :
    ∃ p : ConsciousPoint, q.predicate p :=
  let ⟨p, hp, _⟩ := q.admissible
  ⟨p, hp⟩

/-- A question uniquely picks a point of the graph.
    There is exactly one conscious point satisfying the question. -/
theorem question_uniquely_picks_graph_point (q : QuestionCoord) :
    ∃! p : ConsciousPoint, q.predicate p :=
  q.admissible

/-- Any admissible state generates a canonical question:
    "which point of L has state coordinate = s?" -/
def questionFromState (s : AdmissibleState) : QuestionCoord where
  predicate := fun p => p.x = s
  admissible := conscious_point_unique_from_state s

end SelfReadingGraph
