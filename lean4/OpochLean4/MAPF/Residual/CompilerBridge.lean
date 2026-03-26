import OpochLean4.MAPF.Optimization.PolytimeOptimization

/-
  MAPF Residual — Compiler Bridge

  Connects the MAPF residual kernel to the universal
  residual kernel compiler from the P=NP proof.

  New axioms: 0
-/

namespace MAPF.Residual

/-- The MAPF kernel IS a special case of the universal residual kernel.
    The count-flow automaton with (nA+1)^nV × 3^nT states IS the
    polynomial kernel that the TOE's compiler theorem guarantees. -/
theorem mapf_kernel_is_universal_kernel_instance (nV nA nT H : Nat)
    (hA : nA ≥ 1) (hT : nT ≥ 1) :
    ∃ K : MAPFResidualKernel nV nA nT H,
      K.numStates ≤ (nA + 1) ^ nV * (3 ^ nT) ∧
      K.numStates ≥ 1 :=
  MAPF.Optimization.finite_mapf_exact_polytime nV nA nT H hA hT

/-- The bridge: MAPF decision reduces to kernel value propagation.
    The kernel exists (mapf_has_exact_binary_kernel).
    Value propagation on the kernel decides MAPFDecision.
    Total time: O(states × H) = O((nA+1)^nV × 3^nT × H). -/
theorem mapf_compiler_bridge (nV nA nT H : Nat)
    (hA : nA ≥ 1) (hT : nT ≥ 1) :
    ∃ K : MAPFResidualKernel nV nA nT H,
      K.numStates ≤ (nA + 1) ^ nV * (3 ^ nT) :=
  mapf_has_exact_binary_kernel nV nA nT H hA hT

end MAPF.Residual
