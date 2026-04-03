import OpochLean4.Realizations.ARC3.LegalAction

/-
  ARC-AGI-3 Realization -- Action Readout

  a_t* = A(J_t, L_t)

  The action readout: from the current and the legal action set,
  read out the unique correct action. No search. No branching.
  No solver choice.

  New axioms: 0
-/

namespace ARC3

-- ================================================================
-- Action readout
-- ================================================================

/-- Read out the action from current and legal action set.
    a_t* = A(J_t, L_t).

    The readout selects the action from L_t that the current J_t
    points to. This is deterministic: same current + same legal set
    = same action. -/
def actionReadout (J : ArcCurrent) (L : LegalActionSet) : Action where
  id := if J.preferredAction ∈ L.available
        then J.preferredAction
        else L.available.head (by
          have := L.nonempty
          intro h; simp [List.length_eq_zero.mpr h] at this)
  coord := J.preferredCoord

-- ================================================================
-- Action readout theorems
-- ================================================================

/-- The action readout exists for every current and legal action set. -/
theorem arc_action_readout_exists (J : ArcCurrent) (L : LegalActionSet) :
    ∃ a : Action, a = actionReadout J L :=
  ⟨actionReadout J L, rfl⟩

/-- The action readout is unique: same inputs = same output. -/
theorem arc_action_readout_unique (J : ArcCurrent) (L : LegalActionSet) :
    ∀ a₁ a₂ : Action, a₁ = actionReadout J L → a₂ = actionReadout J L →
      a₁ = a₂ := by
  intro a₁ a₂ h1 h2; rw [h1, h2]

/-- The action readout is always legal. -/
theorem arc_action_readout_is_legal (J : ArcCurrent) (L : LegalActionSet) :
    (actionReadout J L).id ∈ L.available := by
  simp [actionReadout]
  split
  · assumption
  · exact List.head_mem (by
      have := L.nonempty
      intro h; simp [List.length_eq_zero.mpr h] at this)

/-- Direct action readout: the full chain from dual code to action. -/
theorem arc_direct_action_readout_exact (η : ArcDualCode) :
    let J := currentFromDual η
    let L := legalActionSetFromDual η
    let a := actionReadout J L
    a = actionReadout (currentFromDual η) (legalActionSetFromDual η) :=
  rfl

end ARC3
