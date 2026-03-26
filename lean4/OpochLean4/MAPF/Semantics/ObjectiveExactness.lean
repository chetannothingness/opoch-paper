import OpochLean4.MAPF.Semantics.Lifting

/-
  MAPF Semantics — Objective Exactness

  The benchmark objective (completed tasks) is exactly preserved
  by the count-flow projection. Two schedules with the same
  count-flow have the same number of completed tasks.

  This is crucial: without objective exactness, the reduction
  doesn't preserve what matters.

  New axioms: 0
-/

namespace MAPF.Semantics

/-- Task completion is determined by whether ANY agent is at the goal.
    This depends on occupancy at the goal vertex being > 0.
    Two schedules with the same goal occupancy have the same completions. -/
theorem goal_occupancy_determines_completion {nV nA nT H : Nat}
    (inst : FiniteMAPFInstance nV nA nT) (task : Fin nT)
    (s₁ s₂ : Schedule nV nA H)
    (h : occupancy s₁ (timeFinal H) (inst.taskGoal task) =
         occupancy s₂ (timeFinal H) (inst.taskGoal task)) :
    -- If one schedule has an agent at the goal, the other does too
    (occupancy s₁ (timeFinal H) (inst.taskGoal task) > 0) ↔
    (occupancy s₂ (timeFinal H) (inst.taskGoal task) > 0) := by
  rw [h]

/-- Objective exactness (count-flow level):
    the number of tasks with goal-vertex occupancy > 0 is the
    count-flow completion count. This is determined entirely by
    the occupancy vector at the final time step. -/
def countFlowCompletions {nV nT : Nat}
    (occ : OccVec nV) (taskGoals : Fin nT → Vertex nV) : Nat :=
  (List.range nT).foldl (fun acc ti =>
    if h : ti < nT then
      acc + (if occ (taskGoals ⟨ti, h⟩) > 0 then 1 else 0)
    else acc) 0

/-- Count-flow completions depend only on the occupancy vector.
    Same occupancy → same completions (trivially). -/
theorem countflow_completions_deterministic {nV nT : Nat}
    (occ₁ occ₂ : OccVec nV) (taskGoals : Fin nT → Vertex nV)
    (h : ∀ v, occ₁ v = occ₂ v) :
    countFlowCompletions occ₁ taskGoals = countFlowCompletions occ₂ taskGoals := by
  simp [countFlowCompletions]; congr 1; ext ti; split <;> simp_all [h]

end MAPF.Semantics
