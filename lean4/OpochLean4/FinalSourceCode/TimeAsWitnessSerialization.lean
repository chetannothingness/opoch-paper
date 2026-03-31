import OpochLean4.FinalSourceCode.CompletionCurrent

/-
  FinalSourceCode — Time as Witness Serialization

  Time = serialized current into witness ledger.
  Solving is beyond time; manifestation is sequential.

  New axioms: 0
-/

namespace FinalSourceCode

open IndistinguishabilityEnergy Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- Time = serialization of the completion current
-- ════════════════════════════════════════════════════════════════

/-- Time is serialized current: the ledger index records the event. -/
theorem time_is_serialized_current (b : BoundaryCode) (idx : Nat) :
    (serializeEvent b idx).writeIndex = idx :=
  IndistinguishabilityEnergy.time_is_serialized_current b idx

/-- Solve time is eliminated: the completion field exists immediately. -/
theorem solve_time_eliminated (b : BoundaryCode) :
    ∃ r : AutocompilationResult, r = leastCompletionField b :=
  IndistinguishabilityEnergy.solve_time_eliminated b

/-- Local delay is witness-only: cost is readout, not computation. -/
theorem local_delay_is_witness_only (b : BoundaryCode) (idx : Nat) :
    (serializeEvent b idx).cost = b.code.totalCost :=
  IndistinguishabilityEnergy.local_delay_is_readout_only b idx

end FinalSourceCode
