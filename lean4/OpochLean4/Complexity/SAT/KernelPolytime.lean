import OpochLean4.Complexity.SAT.KernelSize

/-
  SAT Kernel Polytime — Polynomial Time on the SAT Kernel

  The SAT kernel DAG traversal runs in polynomial time:
  nodes ≤ (fullSize+1)^4, steps ≤ nodes² ≤ (fullSize+1)^8.

  Dependencies: KernelSize
  New axioms: 0
-/

namespace Complexity.SAT

/-- SAT kernel nodes are polynomial in formula size. -/
theorem sat_kernel_nodes_poly (φ : CNF) :
    (numVars φ + 1) * polyBound φ ≤ (cnfFullSize φ + 1) ^ 4 :=
  kernel_nodes_le_fullSize_pow4 φ

/-- SAT kernel traversal steps are polynomial: ≤ (fullSize+1)^8. -/
theorem sat_kernel_polytime_exact (φ : CNF) :
    ((numVars φ + 1) * polyBound φ) ^ 2 ≤ (cnfFullSize φ + 1) ^ 8 := by
  calc ((numVars φ + 1) * polyBound φ) ^ 2
      ≤ ((cnfFullSize φ + 1) ^ 4) ^ 2 :=
        Nat.pow_le_pow_left (kernel_nodes_le_fullSize_pow4 φ) 2
    _ = (cnfFullSize φ + 1) ^ 8 := by ring

/-- polyBound itself is polynomial: ≤ (fullSize+1)^3. -/
theorem sat_polybound_cubic (φ : CNF) :
    polyBound φ ≤ (cnfFullSize φ + 1) ^ 3 :=
  polyBound_le_fullSize_cubed φ

/-- The polynomial bound is A0*-forced via spectral curvature = 1. -/
theorem sat_bound_forced_by_curvature (φ : CNF) :
    quotientBoundFromCurvature QuantitativeSeed.physicalSeparatorCurvature φ = polyBound φ :=
  physical_curvature_bound φ

end Complexity.SAT
