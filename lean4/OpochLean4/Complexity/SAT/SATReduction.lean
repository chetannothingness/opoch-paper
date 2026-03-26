import OpochLean4.Complexity.SAT.QuotientKernel
import OpochLean4.Complexity.SAT.KernelBuilder

/-
  SAT Reduction — Exact Reduction from SAT to Kernel

  Sat φ → dagAcceptsFrom φ []: a satisfying assignment IS
  an accepting path in the quotient DAG.

  Dependencies: QuotientKernel, KernelBuilder
  New axioms: 0
-/

namespace Complexity.SAT

/-- Exact reduction: Sat φ implies the DAG accepts from the root.
    A satisfying assignment σ gives a suffix from the empty prefix
    that makes evalCNF true. -/
theorem sat_exact_reduction (φ : CNF) :
    Sat φ → dagAcceptsFrom φ [] :=
  (dag_accepts_iff_sat φ).mpr

/-- The reduction is polynomial: the encoded DAG has polynomial nodes. -/
theorem sat_reduction_polynomial (φ : CNF) :
    polyBound φ ≤ (cnfFullSize φ + 1) ^ 3 :=
  polyBound_le_fullSize_cubed φ

/-- The reduction is correct: the decision procedure agrees. -/
theorem sat_reduction_correct (φ : CNF) :
    kernelSATDecide φ = true ↔ Sat φ :=
  kernelSATDecide_correct φ

end Complexity.SAT
