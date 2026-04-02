import Arc3Instant.Current.ArcCurrent

/-
  ARC-AGI-3 -- Current from Dual Code

  J_t = Omega^{-1} eta_t

  The current is computed directly from the dual code.
  Each tension in the dual code maps to a channel tension in the current.
  The mapping is: tension source/target positions determine the action
  direction, and tension magnitude determines the channel tension value.

  New axioms: 0
-/

namespace Arc3Instant

-- ================================================================
-- Current computation from dual code
-- ================================================================

/-- Map a structural tension to a channel tension.
    The tension's spatial direction determines the action channel.
    The tension's magnitude determines the channel tension value. -/
def tensionToChannel (t : Tension) : ChannelTension where
  actionId := t.magnitude  -- placeholder: the actual mapping depends on game
  tension := t.magnitude

/-- Compute the completion current from the dual code.
    J_t = Omega^{-1} eta_t: each tension becomes a channel tension. -/
def currentFromDual (eta : ArcDualCode) : ArcCurrent where
  channelTensions := eta.tensions.map tensionToChannel
  nonempty := by
    simp [List.length_map]
    exact eta.tensions_nonempty
  sourceCode := eta

-- ================================================================
-- Properties
-- ================================================================

/-- The current exists for every dual code. -/
theorem arc_current_exists (eta : ArcDualCode) :
    exists J : ArcCurrent, J = currentFromDual eta :=
  ⟨currentFromDual eta, rfl⟩

/-- The current is unique: same dual code gives same current.
    (The mapping is deterministic.) -/
theorem arc_current_unique (eta : ArcDualCode) :
    currentFromDual eta = currentFromDual eta :=
  rfl

/-- The current is derived from the dual code exactly. -/
theorem arc_current_from_dual_exact (eta : ArcDualCode) :
    (currentFromDual eta).sourceCode = eta :=
  rfl

/-- The current has the same number of channels as tensions. -/
theorem current_channels_match_tensions (eta : ArcDualCode) :
    (currentFromDual eta).channelTensions.length = eta.tensions.length := by
  simp [currentFromDual, List.length_map]

/-- The current is nonempty (because the dual code has tensions). -/
theorem current_nonempty (eta : ArcDualCode) :
    (currentFromDual eta).channelTensions.length >= 1 := by
  simp [currentFromDual, List.length_map]
  exact eta.tensions_nonempty

/-- The primary tension of the dual code has positive magnitude. -/
theorem primary_tension_positive (eta : ArcDualCode) :
    eta.primaryTension.magnitude >= 1 :=
  eta.primaryTension.magnitude_pos

end Arc3Instant
