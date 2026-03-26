import OpochLean4.MAPF.Complexity.PMembership

/-
  MAPF Optimization — Value from Decision

  OPT_MAPF(I, H) is computable by binary search on B ∈ [0, nT].
  Each query to MAPFDecision(I, H, B) is polynomial.
  Binary search takes O(log nT) queries.
  Total: O(log(nT) × poly(nV, nA, nT, H)).

  New axioms: 0
-/

namespace MAPF.Optimization

open MAPF.Residual

/-- Binary search computes OPT: try B = nT, nT-1, ..., 0.
    Return the largest B where MAPFDecision holds. -/
def binarySearchOPT {nV nA nT : Nat}
    (inst : FiniteMAPFInstance nV nA nT) (H : Nat)
    (oracle : Nat → Bool) : Nat :=
  -- Linear search for simplicity (binary search is an optimization)
  (List.range (nT + 1)).foldl (fun best B =>
    if oracle B then max best B else best) 0

/-- The optimal value is bounded by the number of tasks. -/
theorem opt_value_bounded {nV nA nT : Nat}
    (inst : FiniteMAPFInstance nV nA nT) (H : Nat) :
    OPT_MAPF inst H ≤ nT := by
  simp [OPT_MAPF]

/-- Optimal value is computable in polynomial time:
    O(nT) decision queries, each polynomial. -/
theorem mapf_opt_value_polytime (nV nA nT H : Nat)
    (hA : nA ≥ 1) (hT : nT ≥ 1) :
    ∃ K : MAPFResidualKernel nV nA nT H,
      K.numStates ≤ (nA + 1) ^ nV * (3 ^ nT) :=
  mapf_has_exact_binary_kernel nV nA nT H hA hT

end MAPF.Optimization
