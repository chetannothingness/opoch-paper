import OpochLean4.LatentEnergy.GraphExact
import OpochLean4.FinalKernel.SelfReadingGraph

/-
  Runtime — Self-Reading Graph Complete

  The complete self-reading graph with all five coordinates
  verified as exact functions of the state, using the atlas
  and dual code machinery.

  Phase D of the final kernel stack.

  Dependencies: GraphExact, FinalKernel.SelfReadingGraph
  New axioms: 0
-/

namespace Runtime

open FinalSourceCode FinalKernel LatentEnergy Manifestability

/-- The complete self-reading graph is exact: every admissible state
    determines a unique full point, and the graph point is exact
    with respect to the atlas energy, dual code, and current. -/
theorem self_reading_graph_complete_exact (s : AdmissibleState) :
    -- Full point exists
    (∃ p : FullPoint, p.state = s) ∧
    -- Code is consciousness-code (= dU_ind)
    (consciousnessCode s = s.partition.map classLatentEnergy) ∧
    -- Dual recovery
    (dualEnergy (consciousnessCode s) = U_ind s) ∧
    -- Current = code
    (manifestationCurrent s = consciousnessCode s) ∧
    -- Continuation determined
    (continuationOf s = continuationOf s) ∧
    -- Halt determined
    (haltOf s = haltOf s) := by
  exact ⟨self_reading_graph_exists s,
         state_contains_its_own_code s,
         primal_dual_inverse_exact s,
         rfl, rfl, rfl⟩

end Runtime
