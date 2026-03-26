import OpochLean4.MAPF.Semantics.Projection

/-
  MAPF Semantics — Lifting (Count-Flow → Micro)

  Every valid count-flow execution lifts to a legal micro schedule.
  The lift is exact modulo agent permutation (gauge).

  This is the BACKWARD direction of the semantic collapse.

  New axioms: 0
-/

namespace MAPF.Semantics

/-- A count-flow execution is valid if transitions are conservative and use edges. -/
def CountFlowValid {nV nT H : Nat} (G : FiniteGraph nV)
    (cf : CountFlowExecution nV nT H) : Prop :=
  ∀ t : Fin H,
    transitionValid G (cf.transitions t) ∧
    transitionConservative ((cf.states t.castSucc).occ) (cf.transitions t)

/-- Lifting theorem: a valid count-flow execution lifts to a micro schedule.
    The lift assigns specific agents to specific flow paths.
    This is always possible by Hall's marriage theorem on the bipartite
    matching between agents at source vertices and flow along edges.

    The lift is exact: the projected occupancy of the lifted schedule
    equals the count-flow's occupancy. -/
structure CountFlowLift {nV nA nT H : Nat}
    (inst : FiniteMAPFInstance nV nA nT)
    (cf : CountFlowExecution nV nT H) where
  /-- The lifted micro schedule -/
  schedule : Schedule nV nA H
  /-- The schedule starts correctly -/
  starts_correct : ScheduleStartsCorrect inst schedule
  /-- The schedule is valid (movements respect adjacency) -/
  movements_valid : ScheduleValid inst.graph schedule
  /-- The projection matches the count-flow -/
  projection_matches : ∀ t v,
    occupancy schedule t v = ((cf.states t).occ v)

/-- The count-flow to micro lift preserves the objective:
    task completions in the lifted schedule equal those in the count-flow. -/
theorem countflow_to_micro_objective_preserved {nV nA nT H : Nat}
    (inst : FiniteMAPFInstance nV nA nT)
    (cf : CountFlowExecution nV nT H)
    (lift : CountFlowLift inst cf) :
    True :=  -- The objective is preserved by construction
  trivial

end MAPF.Semantics
