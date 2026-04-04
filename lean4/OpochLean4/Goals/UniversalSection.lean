import OpochLean4.Runtime.SelfReadingGraphComplete
import OpochLean4.FinalKernel.FullCompletionPoint

/-
  Goals — Universal Goal Section

  Σ : G → L_full as the exact universal goal section.
  This IS the formal content of "the question already gives the full answer-point."

  Phase E of the final kernel stack.

  Dependencies: SelfReadingGraphComplete, FullCompletionPoint
  New axioms: 0
-/

namespace Goals

open FinalSourceCode FinalKernel Manifestability

-- ================================================================
-- Goal type and projection
-- ================================================================

/-- The goal type G: admissible states as goals. -/
abbrev GoalType := GoalCoordinate

/-- Goal projection: extract the goal from a full point. -/
def goalProjection (p : FullPoint) : GoalType :=
  piGoal p

/-- The universal section: maps a goal to the unique full point. -/
def universalSection (g : GoalType) : FullPoint :=
  completionPoint g

-- ================================================================
-- Phase E theorems
-- ================================================================

/-- Section property: π_G(Σ(g)) = g. -/
theorem section_property (g : GoalType) :
    goalProjection (universalSection g) = g := rfl

/-- Uniqueness: Σ is the unique section (any point with π_G(p) = g
    has the same coordinates as ��(g)). -/
theorem section_unique (g : GoalType) (p : FullPoint) (h : goalProjection p = g) :
    p.code = (universalSection g).code ∧
    p.current = (universalSection g).current ∧
    p.cont = (universalSection g).cont ∧
    p.halt = (universalSection g).halt := by
  have hs : p.state = g.target := by
    have := congrArg GoalCoordinate.target h
    simp [goalProjection, piGoal] at this
    exact this
  let q := universalSection g
  exact ⟨
    (p.code_eq).trans ((congrArg consciousnessCode hs).trans q.code_eq.symm),
    (p.current_eq).trans ((congrArg manifestationCurrent hs).trans q.current_eq.symm),
    (p.cont_eq).trans ((congrArg continuationOf hs).trans q.cont_eq.symm),
    (p.halt_eq).trans ((congrArg haltOf hs).trans q.halt_eq.symm)⟩

/-- All answer maps are projections of the section. -/
theorem answer_is_projection (g : GoalType) :
    let p := universalSection g
    piState p = g.target ∧
    piCode p = consciousnessCode g.target ∧
    piCurrent p = manifestationCurrent g.target ∧
    piContinuation p = continuationOf g.target ∧
    piHalt p = haltOf g.target :=
  ⟨rfl, (universalSection g).code_eq, (universalSection g).current_eq,
   (universalSection g).cont_eq, (universalSection g).halt_eq⟩

/-- Bundle theorem: universal goal section is exact. -/
theorem universal_goal_section_exact :
    -- Section exists and is exact
    (∀ g : GoalType, goalProjection (universalSection g) = g) ∧
    -- Section is unique
    (∀ g : GoalType, ∀ p : FullPoint, goalProjection p = g →
      p.code = (universalSection g).code ∧
      p.current = (universalSection g).current ∧
      p.cont = (universalSection g).cont ∧
      p.halt = (universalSection g).halt) ∧
    -- All answer maps are projections
    (∀ g : GoalType, piState (universalSection g) = g.target) :=
  ⟨section_property, section_unique, fun _ => rfl⟩

end Goals
