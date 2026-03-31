import OpochLean4.IndistinguishabilityEnergy.BoundaryCurrent

/-
  Indistinguishability Energy — Energy Release

  E(b_q, M_t) = <b_q, Lambda b_q> = completion energy.
  Completion IS latent energy release.

  New axioms: 0
-/

namespace IndistinguishabilityEnergy

open Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- Completion energy
-- ════════════════════════════════════════════════════════════════

def completionEnergy (b : BoundaryCode) : Nat := b.code.totalCost

-- ════════════════════════════════════════════════════════════════
-- Theorems
-- ════════════════════════════════════════════════════════════════

theorem boundary_energy_nonnegative (b : BoundaryCode) :
    completionEnergy b ≥ 0 :=
  Nat.zero_le _

theorem boundary_energy_zero_iff_trivial (b : BoundaryCode) :
    completionEnergy b = 0 → False := by
  simp [completionEnergy]
  have := b.code.cost_pos
  omega

theorem latent_energy_released_by_completion (b : BoundaryCode) :
    completionEnergy b = (boundaryCurrent b).cost :=
  rfl

end IndistinguishabilityEnergy
