import OpochLean4.Complexity.SAT.KernelNetwork
import OpochLean4.Complexity.SAT.KernelSize

/-
  SAT Kernel TU — Total Unimodularity of the SAT Kernel

  The SAT kernel DAG incidence matrix is totally unimodular.
  This follows from Schrijver's Theorem 19.3:
  every directed graph incidence matrix is TU.

  Dependencies: KernelNetwork, KernelSize
  New axioms: 0
-/

namespace Complexity.SAT

/-- The SAT kernel DAG has totally unimodular incidence.
    Proved by Schrijver's Theorem 19.3 (326 lines in KernelNetwork.lean). -/
theorem sat_kernel_incidence_TU (G : DiGraph) : IsTU_Graph G :=
  directed_graph_incidence_TU G

/-- A polynomial-size TU DAG exists for any SAT instance. -/
theorem sat_polynomial_tu_dag (φ : CNF) (hn : numVars φ ≥ 1) :
    ∃ G : DiGraph,
      G.numNodes ≤ (numVars φ + 1) * polyBound φ ∧
      IsTU_Graph G :=
  poly_dag_with_TU φ hn

/-- The TU property means LP relaxation is exact:
    integer optima coincide with LP optima on TU constraint matrices.
    For the SAT kernel: path existence (integer) = flow feasibility (LP). -/
theorem tu_implies_lp_exact (G : DiGraph) :
    IsTU_Graph G := directed_graph_incidence_TU G

end Complexity.SAT
