import OpochLean4.Complexity.SAT.QuotientKernel

/-
  Complexity Residual — Objective Exactness

  V_I(u) = Ω_I(σ_I(u))

  The acceptance value at a prefix equals the objective function
  evaluated at its quotient state. Future-equivalent prefixes
  have the same acceptance value.

  Dependencies: QuotientKernel
  New axioms: 0
-/

namespace Complexity.Residual

/-- Objective exactness: the acceptance value of a prefix is
    determined by its future-equivalence class.
    Two future-equivalent prefixes have the same dagAcceptsFrom. -/
theorem objective_exact (φ : CNF)
    (p₁ p₂ : PartialAssign')
    (h : FutureEquiv' φ p₁ p₂) :
    dagAcceptsFrom φ p₁ ↔ dagAcceptsFrom φ p₂ := by
  constructor
  · intro ⟨s, hs⟩; exact ⟨s, by rw [← h s]; exact hs⟩
  · intro ⟨s, hs⟩; exact ⟨s, by rw [h s]; exact hs⟩

/-- The objective at the root is satisfiability. -/
theorem objective_root (φ : CNF) :
    dagAcceptsFrom φ [] ↔ Sat φ :=
  dag_accepts_iff_sat φ

/-- Objective is well-defined on the quotient: it lifts from
    representatives to QKernelState. -/
theorem objective_quotient_invariant (φ : CNF) :
    ∀ p₁ p₂ : PartialAssign',
      FutureEquiv' φ p₁ p₂ →
      (dagAcceptsFrom φ p₁ ↔ dagAcceptsFrom φ p₂) :=
  fun p₁ p₂ h => objective_exact φ p₁ p₂ h

end Complexity.Residual
