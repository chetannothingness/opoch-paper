import OpochLean4.Autocompilation.ConsciousReadout

/-
  Endogenous Autocompilation — Manifestation Bandwidth

  ℓ*(d) = minimal witness length to resolve defect d.
  B_t = local bandwidth of present support C_t.

  One-shot manifestation iff ℓ*(d) ≤ B_t.
  Failure of one-shot is not unsolvedness — only finite readout limitation.
  The answer exists regardless; manifestation is about serialization capacity.

  New axioms: 0
-/

namespace Autocompilation

open Manifestability

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Manifestation bandwidth
-- ════════════════════════════════════════════════════════════════

/-- Minimal witness length: the minimum number of refinement steps
    to fully resolve defect d. This is the defect's total cost. -/
def minWitnessLength (d : LocalDefect) : Nat :=
  d.totalCost

/-- Local bandwidth: the remaining capacity in the support.
    How many more resolved classes can fit. -/
def localBandwidth (C : ConsciousSupport) : Nat :=
  C.capacity - C.resolved.length

/-- Manifestation bandwidth is exact: it is the gap between
    capacity and current resolution. -/
theorem manifestation_bandwidth_exact (C : ConsciousSupport) :
    localBandwidth C = C.capacity - C.resolved.length :=
  rfl

/-- One-shot manifestation: the entire defect can be resolved
    in one pass iff the witness length fits in the bandwidth. -/
def OneShotManifestable (C : ConsciousSupport) (d : LocalDefect) : Prop :=
  minWitnessLength d ≤ localBandwidth C

/-- One-shot manifestation iff bandwidth sufficient. -/
theorem one_shot_manifestation_iff_bandwidth (C : ConsciousSupport) (d : LocalDefect) :
    OneShotManifestable C d ↔ d.totalCost ≤ C.capacity - C.resolved.length :=
  Iff.rfl

/-- Failure of one-shot manifestation is NOT unsolvedness.
    The defect still autocompiles and has a completion trajectory.
    The limitation is only in serialization capacity, not in solvability. -/
theorem bandwidth_failure_not_unsolvedness (C : ConsciousSupport) (d : LocalDefect)
    (hadm : IsAdmissibleDefect d) (_h_no_oneshot : ¬OneShotManifestable C d) :
    ∃ r : AutocompilationResult, r = autocompile d hadm :=
  ⟨autocompile d hadm, rfl⟩

end Autocompilation
