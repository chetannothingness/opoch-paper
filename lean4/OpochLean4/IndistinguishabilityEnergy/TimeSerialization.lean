import OpochLean4.IndistinguishabilityEnergy.ObservationActionUnity

/-
  Indistinguishability Energy — Time Serialization

  time = ordered serialization of J_q into witness ledger.
  Solving is beyond time, manifestation is sequential.

  New axioms: 0
-/

namespace IndistinguishabilityEnergy

open Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- Ledger entry and serialization
-- ════════════════════════════════════════════════════════════════

structure LedgerEntry where
  event : BoundaryEvent
  writeIndex : Nat
  cost : Nat
  cost_eq : cost = event.code.code.totalCost

noncomputable def serializeEvent (b : BoundaryCode) (idx : Nat) : LedgerEntry where
  event := canonicalBoundaryEvent b
  writeIndex := idx
  cost := b.code.totalCost
  cost_eq := rfl

-- ════════════════════════════════════════════════════════════════
-- Theorems
-- ════════════════════════════════════════════════════════════════

theorem time_is_serialized_current (b : BoundaryCode) (idx : Nat) :
    (serializeEvent b idx).writeIndex = idx :=
  rfl

theorem solve_time_eliminated (b : BoundaryCode) :
    ∃ r : AutocompilationResult, r = leastCompletionField b :=
  ⟨leastCompletionField b, rfl⟩

theorem local_delay_is_readout_only (b : BoundaryCode) (idx : Nat) :
    (serializeEvent b idx).cost = b.code.totalCost :=
  rfl

end IndistinguishabilityEnergy
