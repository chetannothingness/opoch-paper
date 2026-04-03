import OpochLean4.FinalKernel.GoalCoordinates

/-
  Final Kernel — Full Completion Point

  THE MAIN THEOREM OF THE FINAL LAYER:

  ∀ g ∈ G, ∃! p_g ∈ L_full with π_G(p_g) = g.

  Every admissible goal selects a unique full point of the
  self-reading graph. That point contains state, code, current,
  continuation, and halt — all at once.

  New axioms: 0
-/

namespace FinalKernel

open FinalSourceCode Manifestability

-- ================================================================
-- The completion point
-- ================================================================

/-- Build the unique full point for a goal coordinate. -/
def completionPoint (g : GoalCoordinate) : FullPoint where
  state := g.target
  code := consciousnessCode g.target
  current := manifestationCurrent g.target
  cont := continuationOf g.target
  halt := haltOf g.target
  code_eq := rfl
  current_eq := rfl
  cont_eq := rfl
  halt_eq := rfl

/-- The goal projection: extract the goal from a full point. -/
def piGoal (p : FullPoint) : GoalCoordinate where
  target := p.state

-- ================================================================
-- THE MAIN THEOREM
-- ================================================================

/-- Full completion point exists: every goal has a completing point. -/
theorem full_completion_point_exists (g : GoalCoordinate) :
    ∃ p : FullPoint, piGoal p = g :=
  ⟨completionPoint g, rfl⟩

/-- Full completion point is unique: the completing point is
    uniquely determined (up to the graph point coordinates). -/
theorem full_completion_point_unique (g : GoalCoordinate)
    (p1 p2 : FullPoint) (h1 : piGoal p1 = g) (h2 : piGoal p2 = g) :
    p1.code = p2.code ∧ p1.current = p2.current ∧
    p1.cont = p2.cont ∧ p1.halt = p2.halt := by
  have hs : p1.state = p2.state := by
    have e1 := congrArg GoalCoordinate.target h1
    have e2 := congrArg GoalCoordinate.target h2
    simp [piGoal] at e1 e2
    exact e1.trans e2.symm
  exact ⟨full_point_code_determined p1 p2 hs,
         full_point_current_determined p1 p2 hs,
         full_point_continuation_determined p1 p2 hs,
         full_point_halt_determined p1 p2 hs⟩

/-- Goal picks unique full point: the central theorem.
    ∀ g, ∃ p_g with π_G(p_g) = g, and all coordinates are determined. -/
theorem goal_picks_unique_full_point (g : GoalCoordinate) :
    -- The point exists
    (∃ p : FullPoint, piGoal p = g) ∧
    -- The point's coordinates are all determined by g
    (∀ p : FullPoint, piGoal p = g →
      p.code = consciousnessCode g.target ∧
      p.current = manifestationCurrent g.target ∧
      p.cont = continuationOf g.target ∧
      p.halt = haltOf g.target) := by
  constructor
  · exact full_completion_point_exists g
  · intro p hp
    have hs : p.state = g.target := by
      have := congrArg GoalCoordinate.target hp
      simp [piGoal] at this
      exact this
    exact ⟨by rw [p.code_eq, hs],
           by rw [p.current_eq, hs],
           by rw [p.cont_eq, hs],
           by rw [p.halt_eq, hs]⟩

/-- Goal projection is exact. -/
theorem goal_projection_exact (p : FullPoint) :
    (piGoal p).target = p.state := rfl

end FinalKernel
