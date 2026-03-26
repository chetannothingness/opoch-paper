import OpochLean4.Complexity.Bridge.PeqNP
import OpochLean4.Complexity.SAT.KernelSize
import OpochLean4.Complexity.SAT.KernelNetwork

/-
  Complexity Audit — P vs NP Baseline

  Records the exact current state of the P=NP proof chain
  before the manifestability rewiring.

  Existing chain:
    Defs (FutureEquiv) → QuotientKernel (QKernelState, dagAcceptsFrom)
    → KernelNetwork (DiGraph, TU, Schrijver) → KernelSize (polyBound, A0* chain)
    → KernelBuilder (kernelSATDecide, correctness)
    → PeqNP (satBoundedDecider, P_eq_NP, P_eq_NP_bounded)

  Known gaps to fix:
    1. kernelSATDecide = satDecideComputable (brute-force, not BFS on DAG)
    2. polyBound bounds DAG nodes but not directly quotient class count
    3. P_eq_NP_bounded reports polynomial steps as a label
    4. Generic NP uses exponential witness enumeration
-/

namespace Complexity.Audit

/-- Current P_eq_NP theorem: exists computable decider for any NP_Bool language. -/
theorem current_P_eq_NP_exists :
    ∀ {α : Type} (L : α → Prop) (hNP : NP_Bool L),
      ∃ (dec : α → Bool), ∀ x, dec x = true ↔ L x :=
  fun L hNP => P_eq_NP L hNP

/-- Current satBoundedDecider: SAT has a BoundedDecider with steps ≤ (fullSize+1)^8. -/
theorem current_sat_bounded :
    ∀ (φ : CNF), (satBoundedDecider.run φ).1 = true ↔ Sat φ := by
  intro φ
  show kernelSATDecide φ = true ↔ Sat φ
  exact kernelSATDecide_correct φ

/-- Current polynomial bound: polyBound φ ≤ (cnfFullSize φ + 1)³. -/
theorem current_poly_bound (φ : CNF) :
    polyBound φ ≤ (cnfFullSize φ + 1) ^ 3 :=
  polyBound_le_fullSize_cubed φ

/-- Current TU: every directed graph incidence is totally unimodular. -/
theorem current_tu (G : DiGraph) : IsTU_Graph G :=
  directed_graph_incidence_TU G

/-- Current DAG: polynomial DAG with TU incidence exists for every SAT instance. -/
theorem current_dag (φ : CNF) (hn : numVars φ ≥ 1) :
    ∃ G : DiGraph, G.numNodes ≤ (numVars φ + 1) * polyBound φ ∧ IsTU_Graph G :=
  poly_dag_with_TU φ hn

/-- Axiom footprint: sole axiom is A0star. -/
def axiomFootprint : String := "A0star at OpochLean4/Manifest/Axioms.lean:27"

/-- Gap identification for the manifestability rewiring. -/
def gapDescription : List String := [
  "Gap 1: kernelSATDecide is satDecideComputable (exponential enumeration)",
  "Gap 2: polyBound bounds DAG nodes, not directly quotient class count",
  "Gap 3: P_eq_NP_bounded step count is a label, not computation measure",
  "Gap 4: Generic NP uses exponential witness enumeration"
]

end Complexity.Audit
