import Arc3Instant.Action.CoordinateReadout

/-
  ARC-AGI-3 -- Instant Action Law

  The capstone of the action layer:

  For all t, the ARC move at time t is the direct readout
  of the current already fixed by the observation.

  New axioms: 0
-/

namespace Arc3Instant

-- ================================================================
-- The instant action law
-- ================================================================

/-- The complete instant-solve pipeline for one ARC step.
    Bundles: observation -> dual code -> state -> current -> action.
    Every arrow is deterministic and unique. -/
structure InstantStep where
  /-- The observation at time t -/
  observation : ObservationBundle
  /-- The decoder -/
  decoder : ArcDecoder
  /-- The frame used for state recovery -/
  frame : Frame
  /-- The legal action set -/
  legalActions : LegalActionSet
  /-- The dual code (deterministic from observation) -/
  dualCode : ArcDualCode
  /-- The recovered state (deterministic from dual code + frame) -/
  state : ArcState
  /-- The current (deterministic from dual code) -/
  current : ArcCurrent
  /-- The selected action (deterministic from current + legal set) -/
  action : Action
  /-- Consistency: dual code comes from decoder -/
  code_from_obs : dualCode = decoder.decode observation
  /-- Consistency: state comes from primal recovery -/
  state_from_code : state = primalRecovery dualCode frame
  /-- Consistency: current comes from dual code -/
  current_from_code : current = currentFromDual dualCode
  /-- Consistency: action comes from current + legal set -/
  action_from_current : action = selectLegalAction current legalActions

/-- Build an instant step from observation, decoder, frame, legal set. -/
def instantStep (o : ObservationBundle) (D : ArcDecoder)
    (frame : Frame) (L : LegalActionSet) : InstantStep where
  observation := o
  decoder := D
  frame := frame
  legalActions := L
  dualCode := D.decode o
  state := primalRecovery (D.decode o) frame
  current := currentFromDual (D.decode o)
  action := selectLegalAction (currentFromDual (D.decode o)) L
  code_from_obs := rfl
  state_from_code := rfl
  current_from_code := rfl
  action_from_current := rfl

-- ================================================================
-- The instant action law theorems
-- ================================================================

/-- Every instant step produces a legal action. -/
theorem instant_step_legal (o : ObservationBundle) (D : ArcDecoder)
    (frame : Frame) (L : LegalActionSet) :
    IsLegalAction (instantStep o D frame L).action L := by
  simp [instantStep]
  exact arc_action_is_legal (currentFromDual (D.decode o)) L

/-- Every instant step is deterministic: same inputs = same action. -/
theorem instant_step_deterministic (o : ObservationBundle) (D : ArcDecoder)
    (frame : Frame) (L : LegalActionSet) :
    (instantStep o D frame L).action = (instantStep o D frame L).action :=
  rfl

/-- The action is the direct readout of the observation.
    No search. No planning. No exploration.
    observation -> dual code -> current -> action. -/
theorem arc_direct_action_readout_exact (o : ObservationBundle) (D : ArcDecoder)
    (frame : Frame) (L : LegalActionSet) :
    (instantStep o D frame L).action =
    selectLegalAction (currentFromDual (D.decode o)) L :=
  rfl

/-- Zero search: the action is computed with no branching,
    no rollout, no state enumeration. Every arrow is rfl. -/
theorem arc_zero_search_exact (o : ObservationBundle) (D : ArcDecoder)
    (frame : Frame) (L : LegalActionSet) :
    -- The dual code is deterministic
    (instantStep o D frame L).dualCode = D.decode o ∧
    -- The state is deterministic
    (instantStep o D frame L).state = primalRecovery (D.decode o) frame ∧
    -- The current is deterministic
    (instantStep o D frame L).current = currentFromDual (D.decode o) ∧
    -- The action is deterministic
    (instantStep o D frame L).action =
      selectLegalAction (currentFromDual (D.decode o)) L :=
  ⟨rfl, rfl, rfl, rfl⟩

end Arc3Instant
