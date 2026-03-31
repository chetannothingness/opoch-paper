import OpochLean4.FinalSourceCode.LatentIndistinguishabilityEnergy

/-
  FinalSourceCode — First Variation Threshold

  χ = δU_ind = first variation of latent energy.
  χ matches the minimal first release cost.

  New axioms: 0
-/

namespace FinalSourceCode

open IndistinguishabilityEnergy

-- ════════════════════════════════════════════════════════════════
-- χ is first variation of latent energy
-- ════════════════════════════════════════════════════════════════

/-- χ is the first variation of the latent energy functional. -/
theorem chi_is_first_variation_of_latent_energy (s : IndistinguishabilityState)
    (h : s.level ≥ 2) :
    threshold s h = latentEnergy s - latentEnergy ⟨s.level - 1, by omega⟩ :=
  chi_is_first_release_of_latent_energy s h

/-- χ matches the minimal first release cost = 1. -/
theorem chi_matches_minimal_first_release (s : IndistinguishabilityState)
    (h : s.level ≥ 2) :
    threshold s h = 1 :=
  chi_matches_minimal_first_action s h

end FinalSourceCode
