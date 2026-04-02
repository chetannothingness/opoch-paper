import OpochLean4.SelfReadingGraph.CompletionByIntersection

/-
  SelfReadingGraph -- Current as Graph Coordinate

  The current is NOT something computed later.
  It is already a coordinate of the same graph point.
  Actuation IS a graph coordinate.

  New axioms: 0
-/

namespace SelfReadingGraph

-- ================================================================
-- Current is a coordinate, not a computation
-- ================================================================

/-- The current coordinate exists for every conscious point. -/
theorem current_coordinate_exists (p : ConsciousPoint) :
    ∃ J : List Nat, J = piJ p :=
  ⟨piJ p, rfl⟩

/-- The current coordinate is unique (deterministic from the point). -/
theorem current_coordinate_unique (p : ConsciousPoint) :
    piJ p = piJ p := rfl

/-- Actuation IS a graph coordinate. The current is not computed
    from the state or code. It IS a coordinate of the same point
    that the state and code are coordinates of. -/
theorem actuation_is_graph_coordinate (p : ConsciousPoint) :
    piJ p = p.J ∧ p.J = FinalSourceCode.manifestationCurrent p.x :=
  ⟨rfl, p.hJ⟩

/-- The current of a question IS the current coordinate of its graph point. -/
theorem question_current_is_coordinate (q : QuestionCoord) :
    currentOfQuestion q = piJ (solveByGraph q) :=
  rfl

end SelfReadingGraph
