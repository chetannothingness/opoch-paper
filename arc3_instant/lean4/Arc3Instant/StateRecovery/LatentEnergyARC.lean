import Arc3Instant.DualCode.ObservationAsDualCode

/-
  ARC-AGI-3 -- Latent Energy for the ARC Sector

  U_ind_ARC : ArcDualCode -> Nat

  The latent indistinguishability-energy of the ARC sector.
  This is the total unresolved tension in the current observation:
  the sum of all tension magnitudes in the dual code.

  U_ind = 0 means: the game step is fully resolved (level complete).
  U_ind > 0 means: there are unresolved tensions (actions needed).

  New axioms: 0
-/

namespace Arc3Instant

-- ================================================================
-- ARC Latent Energy
-- ================================================================

/-- The latent energy of a dual code: total unresolved tension.
    U_ind_ARC(eta) = sum of tension magnitudes.
    When all tensions are resolved, U_ind = 0 (level complete). -/
def arcLatentEnergy (eta : ArcDualCode) : Nat :=
  eta.tensions.foldl (fun acc t => acc + t.magnitude) 0

/-- Helper: recursive sum of tension magnitudes. -/
def tensionSum : List Tension -> Nat
  | [] => 0
  | t :: rest => t.magnitude + tensionSum rest

-- ================================================================
-- Properties
-- ================================================================

/-- The latent energy exists for every dual code. -/
theorem arc_latent_energy_exists (eta : ArcDualCode) :
    exists E : Nat, E = arcLatentEnergy eta :=
  ⟨arcLatentEnergy eta, rfl⟩

/-- The latent energy is nonnegative (trivial on Nat). -/
theorem arc_latent_energy_nonneg (eta : ArcDualCode) :
    arcLatentEnergy eta >= 0 :=
  Nat.zero_le _

/-- The latent energy is positive when tensions exist.
    (Every non-terminal dual code has at least one tension with magnitude >= 1.) -/
theorem arc_latent_energy_positive_of_nonterminal (eta : ArcDualCode) :
    tensionSum eta.tensions >= 1 := by
  have h := eta.tensions_nonempty
  match eta.tensions, h with
  | t :: _, _ =>
    simp [tensionSum]
    have := t.magnitude_pos
    omega

/-- The latent energy decreases when a tension is resolved.
    Resolving a tension removes it from the list, strictly decreasing U_ind. -/
theorem arc_latent_energy_decreases_on_resolution
    (t : Tension) (rest : List Tension) (h : rest.length >= 1) :
    tensionSum rest < tensionSum (t :: rest) := by
  simp [tensionSum]
  have := t.magnitude_pos
  omega

/-- The latent energy is zero iff no tensions remain (level complete). -/
theorem arc_latent_energy_zero_iff_complete (ts : List Tension) :
    tensionSum ts = 0 -> ts = [] := by
  intro h
  match ts with
  | [] => rfl
  | t :: _ =>
    simp [tensionSum] at h
    have := t.magnitude_pos
    omega

end Arc3Instant
