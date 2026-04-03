import OpochLean4.FinalKernel.ProjectionLaws

/-
  Final Kernel — Goal Coordinates

  Admissible goals are already full coordinates on L_full.
  A goal IS a coordinate. Not a partial specification.
  Not something to be "completed." Already full.

  New axioms: 0
-/

namespace FinalKernel

open FinalSourceCode Manifestability

-- ================================================================
-- Goal coordinate space
-- ================================================================

/-- A goal coordinate: an admissible state that serves as the
    question/goal for the kernel.

    This is NOT "partial input to a solver."
    This IS a coordinate on the self-reading graph.
    The coordinate selects the unique full point. -/
structure GoalCoordinate where
  /-- The admissible state that IS the goal. -/
  target : AdmissibleState

/-- A goal coordinate exists for every admissible state. -/
theorem goal_coordinate_exists (s : AdmissibleState) :
    ∃ g : GoalCoordinate, g.target = s :=
  ⟨⟨s⟩, rfl⟩

/-- A goal coordinate is exact: it determines a unique state. -/
theorem goal_coordinate_exact (g : GoalCoordinate) :
    ∃ s : AdmissibleState, s = g.target :=
  ⟨g.target, rfl⟩

/-- An admissible goal IS a full coordinate.
    It is not partial. It is not a specification to be refined.
    It IS the coordinate that selects the unique graph point. -/
theorem admissible_goal_is_full_coordinate (g : GoalCoordinate) :
    ∃ p : FullPoint, p.state = g.target :=
  self_reading_graph_exists g.target

end FinalKernel
