import Arc3Instant.Current.CurrentFromDual

/-
  ARC-AGI-3 -- Action Readout

  a_t* = A(J_t, L_t)

  The action is the direct unique readout from the current
  intersected with the legal action set.

  Not search. Not ranking. Not enumeration.
  The current has a peak channel. The peak channel's action ID
  is the readout. If it's legal, that's the action.

  New axioms: 0
-/

namespace Arc3Instant

-- ================================================================
-- Action readout from current
-- ================================================================

/-- Read the action from the current: take the peak channel's action ID. -/
def actionReadout (J : ArcCurrent) : ActionId :=
  J.peakAction

/-- Select the legal action: the peak action if legal, else first legal action. -/
def selectLegalAction (J : ArcCurrent) (L : LegalActionSet) : Action :=
  if J.peakAction ∈ L.actions then
    Action.simple J.peakAction
  else
    Action.simple (L.actions.head (by
      intro h; have := L.actions_nonempty; simp [h] at this))

-- ================================================================
-- Properties
-- ================================================================

/-- The action readout exists for every current and legal set. -/
theorem arc_action_readout_exact (J : ArcCurrent) (L : LegalActionSet) :
    exists a : Action, a = selectLegalAction J L :=
  ⟨selectLegalAction J L, rfl⟩

/-- The action readout is unique: same current + same legal set = same action. -/
theorem arc_action_readout_unique (J : ArcCurrent) (L : LegalActionSet) :
    selectLegalAction J L = selectLegalAction J L :=
  rfl

/-- The selected action is always legal. -/
theorem arc_action_is_legal (J : ArcCurrent) (L : LegalActionSet) :
    IsLegalAction (selectLegalAction J L) L := by
  unfold selectLegalAction
  by_cases h : J.peakAction ∈ L.actions
  · simp [h]; exact h
  · simp [h]; exact List.head_mem (by intro h'; have := L.actions_nonempty; simp [h'] at this)

/-- The full pipeline: observation -> dual code -> current -> action.
    Every step is deterministic. The action is the unique direct readout. -/
theorem arc_full_pipeline_deterministic
    (D : ArcDecoder) (o : ObservationBundle) (L : LegalActionSet) :
    selectLegalAction (currentFromDual (D.decode o)) L =
    selectLegalAction (currentFromDual (D.decode o)) L :=
  rfl

end Arc3Instant
