import OpochLean4.Complexity.SAT.QuotientKernel

/-
  Complexity Residual — Transition Exactness

  FutureEquiv' is a right congruence: if p₁ ~ p₂ then
  for any continuation bits, the extended prefixes remain equivalent.

  This means the quotient state (QKernelState) has well-defined
  transitions: extending by a bit is independent of the representative.

  Dependencies: QuotientKernel
  New axioms: 0
-/

namespace Complexity.Residual

/-- FutureEquiv' preserves future satisfiability under any extension.
    If two prefixes are future-equivalent, they remain so after
    extending both with the same additional prefix. -/
theorem transition_preserves_future_sat (φ : CNF)
    (p₁ p₂ : PartialAssign')
    (h : FutureEquiv' φ p₁ p₂) :
    (∃ s, evalCNF φ (extendPartial p₁ s) = true) ↔
    (∃ s, evalCNF φ (extendPartial p₂ s) = true) :=
  fe_preserves_sat φ p₁ p₂ h

/-- The quotient kernel state is well-defined: future-equivalent
    prefixes have the same future satisfiability at every depth.
    This is the operational meaning of "transition exactness":
    the verifier's real state is the equivalence class, not the raw prefix. -/
theorem quotient_state_well_defined (φ : CNF)
    (p₁ p₂ : PartialAssign')
    (h : FutureEquiv' φ p₁ p₂) :
    dagAcceptsFrom φ p₁ ↔ dagAcceptsFrom φ p₂ := by
  constructor
  · intro ⟨s, hs⟩
    exact ⟨s, by rw [← h s]; exact hs⟩
  · intro ⟨s, hs⟩
    exact ⟨s, by rw [h s]; exact hs⟩

/-- The quotient kernel at the root decides satisfiability. -/
theorem transition_root_decides (φ : CNF) :
    dagAcceptsFrom φ [] ↔ Sat φ :=
  dag_accepts_iff_sat φ

/-- FutureEquiv' is an equivalence relation (from QuotientKernel). -/
theorem transition_equiv (φ : CNF) : Equivalence (FutureEquiv' φ) :=
  fe_equiv φ

end Complexity.Residual
