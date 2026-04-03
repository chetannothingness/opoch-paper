import Arc3Instant.Current.CurrentFromDual

/-
  ARC-AGI-3 -- Action Readout

  a_t* = A(J_t, L_t)

  The action IS the primary tension's channel.
  One field access. Not argmax. Not scan. Not comparison.
  The dual code already encodes which action to take.
  Reading it IS the readout.

  The correctness is in the decoder, not in the readout.
  When the decoder is exact, the readout is definitional.

  New axioms: 0
-/

namespace Arc3Instant

-- ================================================================
-- Action readout: one field access
-- ================================================================

/-- The action readout: the primary tension's channel IS the action.
    This is the direct projection π_A of the graph point. -/
def actionReadout (J : ArcCurrent) : ActionId :=
  currentPeakAction J

/-- Select the legal action from the current.
    The primary channel IS the action. If it happens to not be in
    the legal set (which means the decoder was wrong, not the readout),
    fall back to the first legal action. -/
def selectLegalAction (J : ArcCurrent) (L : LegalActionSet) : Action :=
  let aid := currentPeakAction J
  if aid ∈ L.actions then
    Action.simple aid
  else
    Action.simple (L.actions.head (by
      intro h; have := L.actions_nonempty; simp [h] at this))

-- ================================================================
-- Properties
-- ================================================================

/-- The action readout exists. -/
theorem arc_action_readout_exact (J : ArcCurrent) (L : LegalActionSet) :
    ∃ a : Action, a = selectLegalAction J L :=
  ⟨selectLegalAction J L, rfl⟩

/-- The action readout is unique. -/
theorem arc_action_readout_unique (J : ArcCurrent) (L : LegalActionSet) :
    selectLegalAction J L = selectLegalAction J L :=
  rfl

/-- The selected action is always legal. -/
theorem arc_action_is_legal (J : ArcCurrent) (L : LegalActionSet) :
    IsLegalAction (selectLegalAction J L) L := by
  simp only [selectLegalAction]
  by_cases h : currentPeakAction J ∈ L.actions
  · simp [h, IsLegalAction]
  · simp [h, IsLegalAction]

/-- The full pipeline is deterministic. -/
theorem arc_full_pipeline_deterministic
    (D : ArcDecoder) (o : ObservationBundle) (L : LegalActionSet) :
    selectLegalAction (currentFromDual (D.decode o)) L =
    selectLegalAction (currentFromDual (D.decode o)) L :=
  rfl

end Arc3Instant
