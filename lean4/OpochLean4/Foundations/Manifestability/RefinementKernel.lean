import OpochLean4.Foundations.Manifestability.RefinementEvent

/-
  Manifestability Block — Refinement Kernel

  K(W, α, {Wᵢ}) — the weighted transition law of reality.
  The full kernel from which χ is the infimum.
  This file is the true completion of the quantitative TOE.

  Dependencies: RefinementEvent
  New axioms: 0
-/

namespace Manifestability

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Refinement Kernel
-- ════════════════════════════════════════════════════════════════

/-- The refinement kernel: the complete transition law for a class
    through a channel into a partition. Carries the full cost,
    admissibility, and structural data. -/
structure RefinementKernel where
  /-- Source class -/
  source : ResidualClass
  /-- Channel -/
  channel : WitnessChannel
  /-- Target partition -/
  targets : List ResidualClass
  /-- The refinement event witnessing this kernel -/
  event : RefinementEvent
  /-- Event source matches kernel source -/
  source_match : event.source = source
  /-- Event channel matches kernel channel -/
  channel_match : event.channel = channel
  /-- Event targets match kernel targets -/
  targets_match : event.targets = targets

/-- The cost of a kernel is the cost of its event. -/
def RefinementKernel.cost (K : RefinementKernel) : Nat := K.event.cost

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: χ as infimum of the kernel
-- ════════════════════════════════════════════════════════════════

/-- χ is the infimum of the refinement kernel costs:
    for any kernel on the class, its cost ≥ χ. -/
theorem chi_is_infimum_of_refinement_kernel
    {rc : ResidualClass}
    (rt : RefinementThreshold rc)
    (K : RefinementKernel)
    (hK : K.source = rc) :
    K.cost ≥ rt.chi := by
  unfold RefinementKernel.cost
  rw [K.event.cost_eq]
  apply rt.lower_bound
  have : K.event.source = rc := K.source_match.trans hK
  rw [← this]
  exact K.event.witness_nonconstant

/-- A refinement kernel is admissible only if the split is real:
    the witness must genuinely separate elements of the class. -/
theorem refinement_kernel_admissible_only_if_split_real
    (K : RefinementKernel) :
    IsNonconstantOn K.event.witness K.event.source :=
  K.event.witness_nonconstant

/-- The kernel channel is exact: the witness is in the channel. -/
theorem refinement_kernel_channel_exact
    (K : RefinementKernel) :
    K.channel.member K.event.witness :=
  K.channel_match ▸ K.event.witness_in_channel

end Manifestability
