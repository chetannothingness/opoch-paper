import OpochLean4.FinalSourceCode.NothingnessAsMaxIndistinguishability

/-
  FinalSourceCode — Latent Indistinguishability Energy

  U_ind(W) = latent energy functional.
  Reuses latentEnergy from IndistinguishabilityEnergy.

  New axioms: 0
-/

namespace FinalSourceCode

open IndistinguishabilityEnergy

-- ════════════════════════════════════════════════════════════════
-- Latent energy: the primitive functional
-- ════════════════════════════════════════════════════════════════

/-- Latent indistinguishability energy exists for every state. -/
theorem latent_indistinguishability_energy_exists (s : IndistinguishabilityState) :
    ∃ E : Nat, E = latentEnergy s :=
  IndistinguishabilityEnergy.latent_indistinguishability_energy_exists s

/-- Latent energy is nonnegative. -/
theorem latent_energy_nonnegative (s : IndistinguishabilityState) :
    latentEnergy s ≥ 0 :=
  IndistinguishabilityEnergy.latent_energy_nonnegative s

/-- Bellman recursion: U_ind(n) = 1 + U_ind(n-1). -/
theorem latent_energy_bellman_exact (s : IndistinguishabilityState)
    (h : s.level ≥ 2) :
    latentEnergy s = 1 + latentEnergy ⟨s.level - 1, by omega⟩ :=
  IndistinguishabilityEnergy.latent_energy_bellman_exact s h

/-- Latent energy is zero iff closure is complete. -/
theorem latent_energy_zero_iff_closure_complete (s : IndistinguishabilityState) :
    latentEnergy s = 0 ↔ s.level = 1 :=
  IndistinguishabilityEnergy.latent_energy_zero_iff_already_closed s

end FinalSourceCode
