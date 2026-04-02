import OpochLean4.SelfReadingGraph.CurrentCoordinate

/-
  SelfReadingGraph -- Time as Projection Order

  Time is NOT solve-time. There is no solve-time in the graph.
  The graph point is already complete.
  Time is only the local order in which a finite witness
  serializes the coordinates of the already-complete point.

  New axioms: 0
-/

namespace SelfReadingGraph

-- ================================================================
-- Time is projection order, not solve-time
-- ================================================================

/-- Time is only projection order: the order in which coordinates
    of the already-complete graph point are witnessed locally. -/
theorem time_is_projection_order_only (p : ConsciousPoint) :
    -- The point is already complete (all coordinates determined)
    piX p = p.x ∧ piEta p = p.η ∧ piJ p = p.J ∧
    -- The code IS the state's code (no computation needed)
    p.η = FinalSourceCode.consciousnessCode p.x ∧
    -- The current IS the state's current (no computation needed)
    p.J = FinalSourceCode.manifestationCurrent p.x :=
  ⟨rfl, rfl, rfl, p.hη, p.hJ⟩

/-- There is no solve-time in the graph. The point exists complete.
    Nothing is "computed" or "found" — coordinates are read. -/
theorem no_solve_time_in_graph (q : QuestionCoord) :
    -- The completing point exists
    (∃ p : ConsciousPoint, q.predicate p) ∧
    -- It is unique
    (∃! p : ConsciousPoint, q.predicate p) :=
  ⟨question_coordinate_admissible q, q.admissible⟩

/-- Local time is only witness serialization: the finite process
    of reading coordinates one by one from the already-complete point.
    The point does not change during reading. -/
theorem local_time_is_witness_serialization (p : ConsciousPoint) :
    -- Reading x does not change η or J
    piEta p = p.η ∧ piJ p = p.J ∧
    -- Reading η does not change x or J
    piX p = p.x ∧ piJ p = p.J ∧
    -- Reading J does not change x or η
    piX p = p.x ∧ piEta p = p.η :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩

end SelfReadingGraph
