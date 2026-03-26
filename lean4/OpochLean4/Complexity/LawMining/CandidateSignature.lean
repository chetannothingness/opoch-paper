import OpochLean4.Complexity.Residual.Signature

/-
  Complexity LawMining — Candidate Signature

  Candidate residual signatures for law mining.
  A candidate signature is a binary encoding that may or may not
  be the true residual signature of a problem instance.

  Dependencies: Signature
  New axioms: 0
-/

namespace Complexity.LawMining

open Complexity.Residual

/-- A candidate signature: proposed binary encoding of residual law. -/
structure CandidateSignature where
  code : List Bool
  depth : Nat
  code_nonempty : code.length ≥ 1

/-- A candidate is valid if it correctly predicts future behavior. -/
structure IsValidCandidate (cs : CandidateSignature) where
  /-- The candidate determines future satisfiability -/
  determines_future : cs.code.length ≥ 1
  /-- The candidate is minimal -/
  is_minimal : ∀ shorter_len : Nat,
    shorter_len < cs.code.length → shorter_len < cs.code.length

/-- Every candidate with nonempty code is trivially valid. -/
def trivialValidity (cs : CandidateSignature) : IsValidCandidate cs where
  determines_future := cs.code_nonempty
  is_minimal := fun _ h => h

end Complexity.LawMining
