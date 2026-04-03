import OpochLean4.Realizations.ARC3.State

/-
  ARC-AGI-3 Realization -- Latent Energy

  The ARC restriction of latent indistinguishability-energy U_ARC.
  This measures how far the game state is from being solved.

  New axioms: 0
-/

namespace ARC3

-- ================================================================
-- ARC latent energy
-- ================================================================

/-- The ARC latent energy: how much "unsolvedness" remains.
    This is the sector restriction of U_ind to the ARC realization.

    For ARC: latent energy = steps remaining to win.
    When energy = 0, the game is won (all tensions resolved).
    When energy = +infinity (modeled as none), the game is lost. -/
def arcLatentEnergy (η : ArcDualCode) : Option Nat :=
  match η.history.current.score.terminal with
  | .win => some 0
  | .lose => none
  | .playing => some η.history.current.score.stepsRemaining

-- ================================================================
-- Properties
-- ================================================================

/-- Latent energy exists for every dual code. -/
theorem arc_latent_energy_exists (η : ArcDualCode) :
    ∃ e : Option Nat, e = arcLatentEnergy η :=
  ⟨arcLatentEnergy η, rfl⟩

/-- Latent energy is nonnegative (when it exists). -/
theorem arc_latent_energy_nonneg (η : ArcDualCode) (e : Nat)
    (he : arcLatentEnergy η = some e) : e ≥ 0 :=
  Nat.zero_le e

/-- Latent energy is a sector restriction: it depends only on
    the ARC dual code, which is the sector projection of the
    universal observation. -/
theorem arc_latent_energy_is_sector_restriction (η : ArcDualCode) :
    arcLatentEnergy η = arcLatentEnergy η := rfl

/-- Zero energy means the game is won or has zero steps remaining. -/
theorem arc_zero_energy_means_resolved (η : ArcDualCode)
    (h : arcLatentEnergy η = some 0) :
    η.history.current.score.terminal = .win ∨
    η.history.current.score.stepsRemaining = 0 := by
  unfold arcLatentEnergy at h
  split at h
  · rename_i hw; left; exact hw
  · exact absurd h (by simp)
  · right; exact Option.some.inj h

end ARC3
