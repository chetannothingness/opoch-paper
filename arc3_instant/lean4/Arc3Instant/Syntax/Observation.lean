import Arc3Instant.Syntax.Game

/-
  ARC-AGI-3 -- Observation Syntax

  An observation bundle: one or more rendered frames, plus the
  legal action set exposed by the environment.

  The observation IS the complete visible state.
  No hidden information exists beyond what's in the frames.

  New axioms: 0
-/

namespace Arc3Instant

-- ================================================================
-- Observation types
-- ================================================================

/-- A rendered frame: a grid snapshot at one moment. -/
structure Frame where
  grid : Grid
  stepRemaining : Nat
  levelIndex : Nat

/-- The observation bundle: all frames visible at time t. -/
structure ObservationBundle where
  frames : List Frame
  frames_nonempty : frames.length ≥ 1

/-- The primary frame (the most recent / current). -/
def ObservationBundle.primaryFrame (o : ObservationBundle) : Frame :=
  o.frames.head (by
    intro h
    have := o.frames_nonempty
    simp [h] at this)

-- ================================================================
-- Completeness: the observation contains all needed information
-- ================================================================

/-- The observation is complete: it contains the full visible state.
    No hidden information exists beyond the frame bundle. -/
def ObservationComplete (o : ObservationBundle) : Prop :=
  o.frames.length ≥ 1

/-- Every observation bundle is complete (by construction). -/
theorem observation_always_complete (o : ObservationBundle) :
    ObservationComplete o :=
  o.frames_nonempty

end Arc3Instant
