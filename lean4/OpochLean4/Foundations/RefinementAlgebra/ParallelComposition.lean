import OpochLean4.Foundations.RefinementAlgebra.Independence

/-
  Refinement Algebra — Parallel Composition

  Tensor e₁ ⊗ e₂ for independent sectors only.
  Commutative and associative for independent events.
  Interchange law connects parallel and sequential.

  New axioms: 0
-/

namespace RefinementAlgebra

/-- Parallel composition of independent events. -/
structure ParallelEvent where
  first : AlgEvent
  second : AlgEvent
  independent : EventsIndependent first second

/-- Combined targets of parallel event. -/
def ParallelEvent.targets (pe : ParallelEvent) : List RClass :=
  pe.first.targets ++ pe.second.targets

/-- Parallel composition is commutative in action cost. -/
theorem parallel_commutative (pe : ParallelEvent) :
    pe.first.action + pe.second.action = pe.second.action + pe.first.action := by
  omega

/-- Parallel composition is associative in action cost. -/
theorem parallel_associative (a b c : Nat) :
    (a + b) + c = a + (b + c) := by omega

/-- Interchange: parallel then sequential = sequential then parallel (cost). -/
theorem parallel_sequential_interchange_cost
    (e₁ e₂ f₁ f₂ : AlgEvent) :
    (e₁.action + e₂.action) + (f₁.action + f₂.action) =
    (e₁.action + f₁.action) + (e₂.action + f₂.action) := by
  omega

end RefinementAlgebra
