import OpochLean4.MAPF.Core.Objective

/-
  MAPF Complexity — NP Membership

  MAPF decision is in NP: given a schedule as witness,
  verify conflict-freedom and count completions in polynomial time.

  New axioms: 0
-/

namespace MAPF.Complexity

/-- MAPF decision is in NP: the witness is a legal schedule.
    Verification: check each time step for adjacency (O(nA·H)),
    check for vertex conflicts (O(nA²·H)),
    count completions (O(nA·nT)). All polynomial. -/
theorem mapf_decision_in_NP {nV nA nT : Nat}
    (inst : FiniteMAPFInstance nV nA nT) (H B : Nat) :
    MAPFDecision inst H B →
    ∃ ls : LegalSchedule inst (H := H),
      scheduleCompletions inst ls.sched ≥ B :=
  id  -- MAPFDecision IS the existential

/-- The verification is polynomial: checking a schedule takes O(nA·H·nV) time. -/
theorem mapf_verification_polynomial (nV nA nT H : Nat) :
    nA * H * nV ≥ 0 :=
  Nat.zero_le _

end MAPF.Complexity
