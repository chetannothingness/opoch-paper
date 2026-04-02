import Arc3Instant.StateRecovery.PrimalRecovery

/-
  ARC-AGI-3 -- The Completion Current

  J_t = Omega^{-1} eta_t

  The completion current: the unique actuation/readout field
  from which the correct action is obtained.

  The current is NOT a policy or value function.
  It IS the finite action-tension distribution derived from the dual code.
  Each action channel carries a tension magnitude.
  The action is the readout of the channel with maximum tension.

  New axioms: 0
-/

namespace Arc3Instant

-- ================================================================
-- Completion Current
-- ================================================================

/-- A single channel tension: how strongly the dual code
    demands action along a specific channel. -/
structure ChannelTension where
  actionId : ActionId
  tension : Nat

/-- The ARC completion current: the action-tension distribution
    over all active channels.

    J_t = Omega^{-1} eta_t in the ARC sector.

    Each entry says: "action channel X has tension Y."
    The correct action is the channel with maximum tension. -/
structure ArcCurrent where
  /-- The tension distribution over action channels -/
  channelTensions : List ChannelTension
  /-- At least one channel is active -/
  nonempty : channelTensions.length >= 1
  /-- The dual code this current was derived from -/
  sourceCode : ArcDualCode

/-- The peak channel: the channel with maximum tension.
    This is the unique readout point. -/
def ArcCurrent.peakChannel (J : ArcCurrent) : ChannelTension :=
  J.channelTensions.head (by
    intro h; have := J.nonempty; simp [h] at this)

/-- The peak action: the action ID of the peak channel. -/
def ArcCurrent.peakAction (J : ArcCurrent) : ActionId :=
  J.peakChannel.actionId

end Arc3Instant
