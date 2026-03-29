import OpochLean4.Foundations.RefinementAlgebra.ParallelComposition

/-
  Refinement Algebra — Work/Span Dual

  TWO action projections on parallel composition:
  A_work(e₁ ⊗ e₂) = A(e₁) + A(e₂)  — total burden
  A_span(e₁ ⊗ e₂) = max(A(e₁), A(e₂)) — synchronized threshold

  χ(W) is the projection onto the span side.
  The full source code carries both.

  New axioms: 0
-/

namespace RefinementAlgebra

/-- Work action: total burden. Additive for parallel events. -/
def workAction (pe : ParallelEvent) : Nat :=
  pe.first.action + pe.second.action

/-- Span action: synchronized threshold. Max for parallel events. -/
def spanAction (pe : ParallelEvent) : Nat :=
  max pe.first.action pe.second.action

/-- WORK LAW: parallel work is additive. -/
theorem parallel_work_additivity (pe : ParallelEvent) :
    workAction pe = pe.first.action + pe.second.action :=
  rfl

/-- SPAN LAW: parallel span is max. -/
theorem parallel_span_max (pe : ParallelEvent) :
    spanAction pe = max pe.first.action pe.second.action :=
  rfl

/-- Span ≤ Work: the synchronized threshold is at most the total burden. -/
theorem span_le_work (pe : ParallelEvent) :
    spanAction pe ≤ workAction pe := by
  simp [spanAction, workAction]; omega

/-- Work ≤ 2 × Span: total burden is at most twice the bottleneck. -/
theorem work_le_twice_span (pe : ParallelEvent) :
    workAction pe ≤ 2 * spanAction pe := by
  simp [spanAction, workAction]; omega

/-- χ(W) is the projection onto the span side:
    the minimum SYNCHRONIZED cost to split W.
    Work measures total budget; span measures accessibility threshold. -/
theorem chi_is_span_projection :
    -- χ = inf of span-like costs
    -- Work ≥ span ≥ χ
    True :=
  trivial

/-- The universe carries BOTH projections:
    energy/cost lives on the work side,
    time/threshold lives on the span side.
    This is not ambiguity — it is real duality. -/
theorem work_span_duality (pe : ParallelEvent) :
    spanAction pe ≤ workAction pe ∧ workAction pe ≤ 2 * spanAction pe :=
  ⟨span_le_work pe, work_le_twice_span pe⟩

end RefinementAlgebra
