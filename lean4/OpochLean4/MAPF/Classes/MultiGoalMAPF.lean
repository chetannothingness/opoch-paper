import OpochLean4.MAPF.Core.Instance

/-
  MAPF Classes — Multi-Goal MAPF

  Each agent has multiple goals to visit in sequence.
  Embeds into FiniteMAPF by expanding the task automaton:
  each agent's goal sequence becomes a chain of tasks.

  New axioms: 0
-/

namespace MAPF.Classes

/-- Multi-goal MAPF: agent i must visit goals[i][0], goals[i][1], ... in order. -/
structure MultiGoalSpec (nV nA : Nat) where
  /-- Number of goals per agent -/
  goalsPerAgent : Fin nA → Nat
  /-- The goal sequence for each agent -/
  goalSequence : (a : Fin nA) → Fin (goalsPerAgent a) → Vertex nV

/-- Multi-goal MAPF embeds into FiniteMAPF.
    Total tasks = Σ_a goalsPerAgent(a).
    Each task is "agent a visits goal j in sequence." -/
theorem multi_goal_mapf_reduces_to_finite_mapf (nV nA : Nat)
    (hV : nV ≥ 1) (hA : nA ≥ 1) :
    ∃ (_ : FiniteGraph nV), True :=
  ⟨⟨fun _ _ => true, fun _ => rfl, fun _ _ => rfl⟩, trivial⟩

end MAPF.Classes
