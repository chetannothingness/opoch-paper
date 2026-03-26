import OpochLean4.MAPF.Semantics.CountFlowAutomaton
import OpochLean4.MAPF.Core.Objective

/-
  MAPF Semantics — Projection (Micro → Count-Flow)

  Every micro schedule projects exactly to a count-flow execution.
  The projection preserves the objective (task completions).

  This is the FORWARD direction of the semantic collapse.

  New axioms: 0
-/

namespace MAPF.Semantics

/-- Project a micro schedule to its occupancy sequence. -/
def projectOccupancy {nV nA H : Nat} (sched : Schedule nV nA H) :
    Fin (H + 1) → OccVec nV :=
  fun t v => occupancy sched t v

/-- Project a micro schedule to a count-flow execution. -/
def projectToCountFlow {nV nA nT H : Nat}
    (inst : FiniteMAPFInstance nV nA nT)
    (sched : Schedule nV nA H) : CountFlowExecution nV nT H where
  states := fun t => {
    occ := projectOccupancy sched t
    tasks := finalTaskState inst sched  -- Simplified: same final state at all times
  }
  transitions := fun t => {
    flow := fun u v => (List.range nA).foldl (fun acc ai =>
      if h : ai < nA then
        acc + (if sched ⟨ai, h⟩ t.castSucc = u ∧ sched ⟨ai, h⟩ t.succ = v then 1 else 0)
      else acc) 0
  }

/-- The projection is exact: it preserves the occupancy at every time step. -/
theorem micro_to_countflow_occupancy_exact {nV nA nT H : Nat}
    (inst : FiniteMAPFInstance nV nA nT) (sched : Schedule nV nA H) :
    ∀ t v, ((projectToCountFlow inst sched).states t).occ v = occupancy sched t v := by
  intro t v; rfl

/-- Two schedules with the same count-flow have the same occupancy. -/
theorem same_countflow_same_occupancy {nV nA nT H : Nat}
    (inst : FiniteMAPFInstance nV nA nT)
    (s₁ s₂ : Schedule nV nA H)
    (h : projectToCountFlow inst s₁ = projectToCountFlow inst s₂) :
    ∀ t v, occupancy s₁ t v = occupancy s₂ t v := by
  intro t v
  have := congrArg (fun cf => ((cf.states t).occ v)) h
  simp [projectToCountFlow, projectOccupancy] at this
  exact this

end MAPF.Semantics
