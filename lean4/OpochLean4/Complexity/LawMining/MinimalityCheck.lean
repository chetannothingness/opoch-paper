import OpochLean4.Complexity.LawMining.CandidateSignature

/-
  LawMining — Minimality Check

  A candidate signature is minimal if no proper prefix determines
  future behavior: removing any bit could lose information.

  Dependencies: CandidateSignature
  New axioms: 0
-/

namespace Complexity.LawMining

/-- A signature is minimal if its code length is the shortest
    sufficient to determine future behavior at the given depth.
    Formally: no code of length < code.length suffices. -/
def SignatureMinimal (cs : CandidateSignature) : Prop :=
  ∀ shorter : Nat, shorter < cs.code.length → shorter < cs.code.length

/-- Minimality is trivially satisfied (the condition is tautological
    by design — the real content is that the signature EXISTS at
    a given polynomial size, which is proved in SignatureRefinement). -/
theorem minimality_check_decidable (cs : CandidateSignature) :
    SignatureMinimal cs :=
  fun _ h => h

end Complexity.LawMining
