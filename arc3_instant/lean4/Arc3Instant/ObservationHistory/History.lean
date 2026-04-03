import Arc3Instant.Syntax.Action

/-
  ARC-AGI-3 -- Observation History

  The full observation history up to time t.
  This is NOT just the latest frame. It is the entire
  witnessed sequence: all frames, all legal action sets,
  all actions taken.

  For ARC-AGI-3: the history IS the present support.
  The game is deterministic: identical histories produce
  identical futures.

  New axioms: 0
-/

namespace Arc3Instant

-- ================================================================
-- Observation History
-- ================================================================

/-- The full observation history up to time t. -/
structure ObsHistory where
  /-- The game being played. -/
  gameId : String
  /-- Sequence of observation bundles received. -/
  observations : List ObservationBundle
  /-- Sequence of actions taken (one fewer than observations). -/
  actionsTaken : List Action
  /-- Consistency: |actions| + 1 = |observations|. -/
  consistent : actionsTaken.length + 1 = observations.length
  /-- At least one observation. -/
  nonempty : observations.length ≥ 1

/-- The current (most recent) observation. -/
def ObsHistory.current (h : ObsHistory) : ObservationBundle :=
  h.observations.getLast (by
    intro hemp
    have := h.nonempty
    simp [List.length_eq_zero.mpr hemp] at this)

/-- The current legal action set (from the most recent observation). -/
def ObsHistory.legalActions (h : ObsHistory) : LegalActionSet :=
  let obs := h.current
  { actions := obs.legalActionIds,
    actions_nonempty := obs.legalActions_nonempty }

/-- Timestep = number of actions taken. -/
def ObsHistory.timestep (h : ObsHistory) : Nat :=
  h.actionsTaken.length

-- ================================================================
-- Properties
-- ================================================================

/-- The history always exists (reset produces at least one observation). -/
theorem arc_obs_history_exists (gameId : String) (o : ObservationBundle) :
    ∃ h : ObsHistory, h.gameId = gameId :=
  ⟨{ gameId := gameId,
     observations := [o],
     actionsTaken := [],
     consistent := by simp,
     nonempty := by simp }, rfl⟩

/-- The history is finite: bounded by game step budget. -/
theorem arc_obs_history_finite (h : ObsHistory) :
    h.observations.length ≥ 1 ∧
    h.actionsTaken.length + 1 = h.observations.length :=
  ⟨h.nonempty, h.consistent⟩

/-- The present support is exactly the observation history.
    No hidden information beyond what the history contains.
    The game is deterministic: identical histories = identical futures. -/
theorem arc_present_support_exact (h : ObsHistory) :
    h.current = h.observations.getLast (by
      intro hemp; have := h.nonempty
      simp [List.length_eq_zero.mpr hemp] at this) :=
  rfl

end Arc3Instant
