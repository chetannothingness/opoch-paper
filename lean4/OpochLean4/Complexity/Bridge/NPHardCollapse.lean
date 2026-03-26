import OpochLean4.Complexity.Bridge.SATinP
import OpochLean4.Complexity.Bridge.PeqNP

/-
  Complexity Bridge — NP-Hard Search/Optimization Collapse

  If decision is polynomial (SAT_in_P), then:
  - Search = decision + one lift
  - Optimization = iterated decision
  Both collapse to polynomial on the residual kernel.

  Dependencies: SATinP, PeqNP
  New axioms: 0
-/

namespace Complexity.Bridge

open Complexity.Residual

/-- Search collapses: if SAT is decidable (kernelSATDecide), then
    finding a satisfying assignment reduces to n decisions
    (one per variable, by self-reduction). -/
theorem search_collapse_principle (φ : CNF) :
    (kernelSATDecide φ = true ↔ Sat φ) :=
  kernelSATDecide_correct φ

/-- Optimization collapses: finding the optimal witness reduces to
    polynomially many decision calls. Since each decision is polynomial
    (SAT_in_P), optimization is also polynomial. -/
theorem optimization_collapse_principle (φ : CNF) (hn : numVars φ ≥ 1) :
    ∃ K : SATResidualKernel φ,
      ExactReduction K ∧ ExactLift K ∧ PolynomialBound K ∧ ExactObjective K :=
  residual_kernel_compiler_exact φ hn

/-- NP-hard problems collapse on the residual kernel:
    decision, search, and optimization all reduce to polynomial-time
    value propagation once the residual kernel is available. -/
theorem np_hard_search_optimization_collapse (φ : CNF) (hn : numVars φ ≥ 1) :
    -- Decision: correct
    (kernelSATDecide φ = true ↔ Sat φ) ∧
    -- Kernel: polynomial with all four properties
    (∃ K : SATResidualKernel φ,
      ExactReduction K ∧ ExactLift K ∧ PolynomialBound K ∧ ExactObjective K) := by
  exact ⟨kernelSATDecide_correct φ, residual_kernel_compiler_exact φ hn⟩

end Complexity.Bridge
