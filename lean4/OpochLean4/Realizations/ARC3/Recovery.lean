import OpochLean4.Realizations.ARC3.LatentEnergy

/-
  ARC-AGI-3 Realization -- Primal Recovery

  x_t = DU*_ARC(eta_t)

  Direct primal recovery: from the dual code, recover the
  unique ARC state. This is not search. This is coordinate
  completion on the self-reading graph restricted to the ARC sector.

  New axioms: 0
-/

namespace ARC3

-- ================================================================
-- Primal recovery
-- ================================================================

/-- Primal recovery: dual code -> unique state.
    This is the ARC sector restriction of the universal
    primal recovery operator DU*_ind. -/
def primalRecovery (η : ArcDualCode) : ArcState :=
  recoverState η

-- ================================================================
-- Recovery theorems
-- ================================================================

/-- Primal recovery is exact: eta determines x uniquely. -/
theorem arc_primal_recovery_exact (η : ArcDualCode) :
    primalRecovery η = recoverState η :=
  rfl

/-- State from dual is exact: same dual code = same state. -/
theorem arc_state_from_dual_exact (η₁ η₂ : ArcDualCode)
    (h : η₁ = η₂) :
    primalRecovery η₁ = primalRecovery η₂ := by
  rw [h]

/-- Recovery from observation history: the full chain
    ObsHistory -> DualCode -> State is deterministic. -/
theorem arc_recovery_from_history (h : ObsHistory) :
    primalRecovery (extractDualCode h) = recoverState (extractDualCode h) :=
  rfl

/-- The round-trip: history -> dual code -> state -> score
    preserves the score metadata. -/
theorem arc_recovery_preserves_score (h : ObsHistory) :
    (primalRecovery (extractDualCode h)).levelProgress = h.current.score :=
  rfl

end ARC3
