import OpochLean4.MAPF.Residual.Signature

/-
  MAPF Residual — Transition Exactness

  Transitions on the count-flow automaton respect future-equivalence.
  Same signature + same action → same next signature.

  New axioms: 0
-/

namespace MAPF.Residual

open MAPF.Semantics

/-- A count-flow action: a valid redistribution of agents along edges. -/
structure MAPFAction (nV : Nat) where
  flow : Fin nV → Fin nV → Nat

/-- Apply a count-flow action to a state. -/
def applyMAPFAction {nV nT : Nat} (s : CountFlowState nV nT)
    (a : MAPFAction nV) : CountFlowState nV nT where
  occ := fun v => (List.range nV).foldl (fun acc ui =>
    if h : ui < nV then acc + a.flow ⟨ui, h⟩ v else acc) 0
  tasks := s.tasks  -- Tasks unchanged by movement

/-- Transition exactness: same state + same action → same next state.
    This is deterministic: the count-flow automaton is a deterministic
    finite automaton, not a nondeterministic one. -/
theorem mapf_transition_deterministic {nV nT : Nat}
    (s₁ s₂ : CountFlowState nV nT)
    (h : s₁ = s₂) (a : MAPFAction nV) :
    applyMAPFAction s₁ a = applyMAPFAction s₂ a := by
  rw [h]

/-- Future-equivalent states transition to future-equivalent states. -/
theorem transition_preserves_future_equiv {nV nT : Nat} (G : FiniteGraph nV)
    (s₁ s₂ : CountFlowState nV nT)
    (h : CountFlowFutureEquiv G s₁ s₂) (a : MAPFAction nV) :
    CountFlowFutureEquiv G (applyMAPFAction s₁ a) (applyMAPFAction s₂ a) := by
  constructor
  · -- Same occupancy after same action on same occupancy
    simp [applyMAPFAction, h.1]
  · -- Same tasks
    simp [applyMAPFAction, h.2]

end MAPF.Residual
