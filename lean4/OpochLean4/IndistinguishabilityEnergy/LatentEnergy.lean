import OpochLean4.IndistinguishabilityEnergy.NothingnessAsIndistinguishability

/-
  Indistinguishability Energy — Latent Energy Functional

  U_ind(W) = inf_{e:W→{Wᵢ}} [A(e) + Σᵢ U_ind(Wᵢ)]

  The true primitive: the total latent completion-energy of an
  unresolved indistinguishability class. This is the Bellman
  recursion on energy, not on strategy.

  χ(W) was the first-step cost. U_ind(W) is the full cost.
  χ = δU_ind (first variation). U_ind is primary.

  New axioms: 0
-/

namespace IndistinguishabilityEnergy

-- ════════════════════════════════════════════════════════════════
-- Latent energy functional
-- ════════════════════════════════════════════════════════════════

/-- The latent indistinguishability-energy of a state.
    For a state with level n:
    - level 1 (resolved): energy = 0
    - level n > 1: energy = n - 1 (the total work to fully resolve)

    This is the closed-form solution of the Bellman recursion
    when each refinement step reduces multiplicity by 1 at cost 1:
    U_ind(n) = inf [1 + U_ind(n-1)] = 1 + U_ind(n-1) = ... = n - 1. -/
def latentEnergy (s : IndistinguishabilityState) : Nat :=
  s.level - 1

/-- Latent energy exists for every indistinguishability state. -/
theorem latent_indistinguishability_energy_exists (s : IndistinguishabilityState) :
    ∃ E : Nat, E = latentEnergy s :=
  ⟨latentEnergy s, rfl⟩

/-- Latent energy is nonnegative. -/
theorem latent_energy_nonnegative (s : IndistinguishabilityState) :
    latentEnergy s ≥ 0 :=
  Nat.zero_le _

/-- The Bellman recursion: U_ind(W) = inf [A(e) + Σ U_ind(Wᵢ)].

    For our model: each step reduces level by 1 at cost 1.
    So U_ind(n) = 1 + U_ind(n-1) for n ≥ 2.
    This gives U_ind(n) = n - 1. -/
theorem latent_energy_bellman_exact (s : IndistinguishabilityState)
    (h : s.level ≥ 2) :
    latentEnergy s = 1 + latentEnergy ⟨s.level - 1, by omega⟩ := by
  simp [latentEnergy]; omega

/-- Latent energy is zero iff the state is already closed (fully resolved). -/
theorem latent_energy_zero_iff_already_closed (s : IndistinguishabilityState) :
    latentEnergy s = 0 ↔ s.level = 1 := by
  simp [latentEnergy]; have := s.level_pos; omega

/-- Latent energy is positive iff the state has unresolved distinction. -/
theorem latent_energy_positive_iff_unresolved (s : IndistinguishabilityState) :
    latentEnergy s ≥ 1 ↔ s.level ≥ 2 := by
  simp [latentEnergy]; have := s.level_pos; omega

end IndistinguishabilityEnergy
