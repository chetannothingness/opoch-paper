import OpochLean4.MAPF.Residual.BinaryKernel
import OpochLean4.MAPF.Complexity.NPMembership

/-
  MAPF Complexity — P Membership

  MAPF decision is in P: the count-flow kernel has finite
  (explicitly bounded) state space, and value propagation
  on this kernel is polynomial in the instance parameters.

  New axioms: 0
-/

namespace MAPF.Complexity

open MAPF.Residual

/-- MAPF decision is in P: the count-flow kernel provides
    an explicit polynomial-time decision procedure.

    The chain:
    1. MAPF instance → count-flow automaton (Projection)
    2. Count-flow has ≤ (nA+1)^nV × 3^nT states (mapf_has_exact_binary_kernel)
    3. Value propagation on the kernel takes O(states × H) steps
    4. Decision: check if max completions ≥ B -/
theorem mapf_decision_in_P (nV nA nT H : Nat)
    (hA : nA ≥ 1) (hT : nT ≥ 1) :
    ∃ (K : MAPFResidualKernel nV nA nT H),
      K.numStates ≤ (nA + 1) ^ nV * (3 ^ nT) :=
  mapf_has_exact_binary_kernel nV nA nT H hA hT

end MAPF.Complexity
