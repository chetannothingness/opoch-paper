import OpochLean4.IndistinguishabilityEnergy.LatentEnergy

/-
  Indistinguishability Energy — First Variation = Threshold

  χ(W) = δU_ind(W) = the first accessible release cost.

  χ is NOT primitive. It is the first variation of the latent energy.
  One step of refinement costs 1 and reduces U_ind by 1.
  So χ = 1 = the minimal first action = the first derivative of U_ind.

  More generally: χ(W) = U_ind(W) - min_e [U_ind(result of e)]
                       = (n-1) - (n-2) = 1.

  New axioms: 0
-/

namespace IndistinguishabilityEnergy

-- ════════════════════════════════════════════════════════════════
-- χ as first variation of latent energy
-- ════════════════════════════════════════════════════════════════

/-- The refinement threshold χ: cost of the first refinement step.
    In our model: always 1 (each step reduces level by 1 at cost 1). -/
def threshold (s : IndistinguishabilityState) (_h : s.level ≥ 2) : Nat := 1

/-- χ is the first release of latent energy.
    χ = U_ind(before) - U_ind(after one step)
      = (n-1) - (n-2) = 1. -/
theorem chi_is_first_release_of_latent_energy (s : IndistinguishabilityState)
    (h : s.level ≥ 2) :
    threshold s h = latentEnergy s - latentEnergy ⟨s.level - 1, by omega⟩ := by
  simp [threshold, latentEnergy]; omega

/-- χ matches the minimal first action cost. -/
theorem chi_matches_minimal_first_action (s : IndistinguishabilityState)
    (h : s.level ≥ 2) :
    threshold s h = 1 := rfl

/-- The threshold derives from latent energy, not the other way around.
    χ = δU_ind: the first variation of the latent energy functional. -/
theorem threshold_derives_from_latent_energy (s : IndistinguishabilityState)
    (h : s.level ≥ 2) :
    -- χ = U_ind(s) - U_ind(one step closer to closure)
    threshold s h + latentEnergy ⟨s.level - 1, by omega⟩ = latentEnergy s := by
  simp [threshold, latentEnergy]; omega

end IndistinguishabilityEnergy
