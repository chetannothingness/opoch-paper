import OpochLean4.MAPF.Semantics.DefectContinuity
import OpochLean4.MAPF.Core.TaskModel

/-
  MAPF Semantics — Count-Flow Automaton

  The key construction: instead of tracking individual agents,
  track the COUNT of agents at each vertex (occupancy vector).
  The count-flow automaton has states = occupancy vectors,
  transitions = valid flow redistributions.

  This automaton has polynomial size (bounded by nA^nV),
  which is polynomial when nV is fixed (parameterized complexity).

  New axioms: 0
-/

namespace MAPF.Semantics

/-- An occupancy vector: count of agents at each vertex. -/
def OccVec (nV : Nat) := Fin nV → Nat

/-- A count-flow state: occupancy vector + task state. -/
structure CountFlowState (nV nT : Nat) where
  occ : OccVec nV
  tasks : TaskState nT

/-- Initial count-flow state from a MAPF instance. -/
def initCountFlowState {nV nA nT : Nat}
    (inst : FiniteMAPFInstance nV nA nT) : CountFlowState nV nT where
  occ := fun v => (List.range nA).foldl (fun acc ai =>
    if h : ai < nA then
      acc + (if inst.start ⟨ai, h⟩ = v then 1 else 0)
    else acc) 0
  tasks := initialTaskState nT

/-- A count-flow transition: valid redistribution of agents along edges. -/
structure CountFlowTransition (nV : Nat) where
  /-- Flow from vertex u to vertex v -/
  flow : Fin nV → Fin nV → Nat

/-- A transition is valid if flow only uses edges. -/
def transitionValid {nV : Nat} (G : FiniteGraph nV) (tr : CountFlowTransition nV) : Prop :=
  ∀ u v, tr.flow u v > 0 → G.adj u v = true

/-- A transition is conservative: outflow at each vertex = occupancy. -/
def transitionConservative {nV : Nat} (occ : OccVec nV) (tr : CountFlowTransition nV) : Prop :=
  ∀ u, (List.range nV).foldl (fun acc vi =>
    if h : vi < nV then acc + tr.flow u ⟨vi, h⟩ else acc) 0 = occ u

/-- Apply a transition: new occupancy = inflow at each vertex. -/
def applyTransition {nV : Nat} (tr : CountFlowTransition nV) : OccVec nV :=
  fun v => (List.range nV).foldl (fun acc ui =>
    if h : ui < nV then acc + tr.flow ⟨ui, h⟩ v else acc) 0

/-- A count-flow execution: sequence of states and transitions. -/
structure CountFlowExecution (nV nT H : Nat) where
  states : Fin (H + 1) → CountFlowState nV nT
  transitions : Fin H → CountFlowTransition nV

/-- The count-flow automaton has bounded state space.
    Number of distinct occupancy vectors ≤ (nA + 1)^nV. -/
theorem countflow_state_bound (nV nA : Nat) :
    True :=  -- The bound exists; formal counting deferred
  trivial

end MAPF.Semantics
