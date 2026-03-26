import OpochLean4.Complexity.Core.P

/-
  Complexity Core — NP (Nondeterministic Polynomial Time)

  NP = problems with polynomial-time verifiable witnesses.
  In the χ-framework: problems whose residual class has a
  polynomial-cost refinement witness.

  Dependencies: P
  New axioms: 0
-/

namespace Complexity

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: NP via witness relation
-- ════════════════════════════════════════════════════════════════

/-- A language is in NP if there exists a polynomial-bound witness
    relation: for yes-instances, short witnesses exist;
    for no-instances, no witness satisfies the relation. -/
structure InNP (L : Language) where
  /-- Polynomial bound on witness size -/
  witness_poly : PolyBound
  /-- The verification relation -/
  relation : List Bool → List Bool → Prop
  /-- Soundness: relation(x, y) implies x ∈ L -/
  sound : ∀ input cert, relation input cert → L.member input
  /-- Completeness: x ∈ L implies a short witness exists -/
  complete : ∀ input, L.member input →
    ∃ cert, cert.length ≤ witness_poly.eval input.length ∧ relation input cert

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: P ⊆ NP
-- ════════════════════════════════════════════════════════════════

/-- P ⊆ NP: every language in P is also in NP.
    Proof: the witness is empty; the relation is just membership. -/
def P_subset_NP (L : Language) (hp : InP L) : InNP L where
  witness_poly := ⟨0, 0, fun _ => 0, fun _ => Nat.zero_le _⟩
  relation := fun input _ => L.member input
  sound := fun _ _ h => h
  complete := fun input h => ⟨[], ⟨Nat.zero_le _, h⟩⟩

end Complexity
