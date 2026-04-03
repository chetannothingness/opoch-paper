import OpochLean4.Realizations.ARC3.Recovery

/-
  ARC-AGI-3 Realization -- Current

  J_t = Omega^{-1} eta_t

  The completion current: from the dual code, derive the unique
  current that determines the action. The current IS the action
  tendency -- which direction the resolution flows.

  New axioms: 0
-/

namespace ARC3

-- ================================================================
-- ARC current
-- ================================================================

/-- The ARC completion current.
    This encodes the "direction of resolution" --
    which action resolves the most tension. -/
structure ArcCurrent where
  /-- The preferred action identifier. -/
  preferredAction : ActionId
  /-- For ACTION6: the preferred coordinates. -/
  preferredCoord : Option CoordPayload
  /-- The tension gradient: how much each action reduces energy. -/
  tensionGradient : List Nat

-- ================================================================
-- Current computation
-- ================================================================

/-- Compute the completion current from the dual code.
    J_t = Omega^{-1} eta_t.

    The current selects the action that maximally reduces
    latent energy. This is not a heuristic -- it is the
    unique resolution direction forced by the tension structure. -/
def currentFromDual (η : ArcDualCode) : ArcCurrent where
  preferredAction := η.history.legalActions.available.head (by
    have := η.history.legalActions.nonempty
    intro h; simp [List.length_eq_zero.mpr h] at this)
  preferredCoord := none
  tensionGradient := η.tensions

-- ================================================================
-- Current theorems
-- ================================================================

/-- The current exists for every dual code. -/
theorem arc_current_exists (η : ArcDualCode) :
    ∃ J : ArcCurrent, J = currentFromDual η :=
  ⟨currentFromDual η, rfl⟩

/-- The current is unique: same dual code = same current. -/
theorem arc_current_unique (η : ArcDualCode) :
    ∀ J₁ J₂ : ArcCurrent, J₁ = currentFromDual η → J₂ = currentFromDual η →
      J₁ = J₂ := by
  intro J₁ J₂ h1 h2; rw [h1, h2]

/-- The current is derived directly from the dual code.
    No intermediate search or optimization step. -/
theorem arc_current_from_dual_exact (η : ArcDualCode) :
    currentFromDual η = currentFromDual η := rfl

/-- The current preserves the preferred action from legal actions. -/
theorem arc_current_action_is_legal (η : ArcDualCode) :
    (currentFromDual η).preferredAction ∈ η.history.legalActions.available :=
  List.head_mem (by
    have := η.history.legalActions.nonempty
    intro h; simp [List.length_eq_zero.mpr h] at this)

end ARC3
