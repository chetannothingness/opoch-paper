import OpochLean4.Complexity.SAT.QuotientKernel

/-
  SAT Lift — Exact Lift from Kernel to Assignment

  dagAcceptsFrom φ [] → ∃ σ, evalCNF φ σ = true:
  an accepting DAG path gives a real satisfying assignment.

  Dependencies: QuotientKernel
  New axioms: 0
-/

namespace Complexity.SAT

/-- Exact lift: an accepting path in the DAG gives a satisfying assignment.
    dagAcceptsFrom φ [] unfolds to ∃ suffix, evalCNF φ (extendPartial [] suffix) = true.
    Since extendPartial [] suffix = suffix, this gives ∃ σ, evalCNF φ σ = true = Sat φ. -/
theorem sat_exact_lift (φ : CNF) :
    dagAcceptsFrom φ [] → Sat φ :=
  (dag_accepts_iff_sat φ).mp

/-- The lift produces a real assignment: from the existential in dagAcceptsFrom,
    we get an actual Assign that satisfies the formula. -/
theorem sat_lift_gives_witness (φ : CNF)
    (h : dagAcceptsFrom φ []) :
    ∃ σ : Assign, evalCNF φ σ = true :=
  (dag_accepts_iff_sat φ).mp h

/-- Reduction + Lift = biconditional: the kernel exactly characterizes SAT. -/
theorem sat_reduction_lift_exact (φ : CNF) :
    dagAcceptsFrom φ [] ↔ Sat φ :=
  dag_accepts_iff_sat φ

end Complexity.SAT
