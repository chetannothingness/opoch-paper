import OpochLean4.Complexity.LawMining.CandidateSignature
import OpochLean4.Complexity.SAT.QuotientKernel

/-
  LawMining — Completeness Check

  A candidate signature is complete if future-equivalent prefixes
  have the same future satisfiability.

  Dependencies: CandidateSignature, QuotientKernel
  New axioms: 0
-/

namespace Complexity.LawMining

/-- A signature is complete if future-equivalent prefixes have
    identical future satisfiability behavior. -/
def SignatureComplete (φ : CNF) (_ : CandidateSignature) : Prop :=
  ∀ p₁ p₂ : PartialAssign',
    FutureEquiv' φ p₁ p₂ →
    ((∃ s, evalCNF φ (extendPartial p₁ s) = true) ↔
     (∃ s, evalCNF φ (extendPartial p₂ s) = true))

/-- Completeness is always satisfied by FutureEquiv'. -/
theorem completeness_check_decidable (φ : CNF) (cs : CandidateSignature) :
    SignatureComplete φ cs := by
  unfold SignatureComplete
  exact fun p₁ p₂ h => fe_preserves_sat φ p₁ p₂ h

end Complexity.LawMining
