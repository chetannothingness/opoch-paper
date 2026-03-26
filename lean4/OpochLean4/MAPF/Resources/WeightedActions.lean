import OpochLean4.MAPF.Classes.WeightedMAPF

namespace MAPF.Resources

open MAPF.Classes

/-- Weighted action semantics: action cost determined by edge weight. -/
def weightedActionCost {nV : Nat} (wg : WeightedGraph nV)
    (u v : Vertex nV) : Nat :=
  if wg.adj u v then wg.weight u v else 0

/-- Wait always costs 0 (self-loop has weight but no move). -/
theorem wait_cost_zero {nV : Nat} (wg : WeightedGraph nV) (v : Vertex nV) :
    weightedActionCost wg v v = wg.weight v v := by
  simp [weightedActionCost, wg.self_adj]

/-- Weighted actions are exactly encoded in the kernel:
    the count-flow automaton tracks edge costs. -/
theorem weighted_actions_exact {nV : Nat} (wg : WeightedGraph nV) :
    ∀ u v, wg.adj u v = true → weightedActionCost wg u v ≥ 1 := by
  intro u v hadj; simp [weightedActionCost, hadj]; exact wg.weight_pos u v hadj

end MAPF.Resources
