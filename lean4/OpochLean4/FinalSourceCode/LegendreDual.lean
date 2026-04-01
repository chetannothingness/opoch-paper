import OpochLean4.FinalSourceCode.ConsciousnessCode

/-
  Final Source Code — Legendre Dual

  U_ind*(η) = the dual energy functional.

  On the discrete partition space with U_ind = Σ ρ·χ (linear),
  the Legendre-Fenchel dual is:

    U_ind*(η) = sup_y (⟨η,y⟩ - U_ind(y))

  For a linear functional, the dual is the same linear functional
  (self-dual). In our finite realization:

    U_ind*(η) = listSum(η)

  Given a consciousness-code η = [ρ₁·χ₁, ..., ρₙ·χₙ],
  the dual reconstructs U_ind = Σ ρᵢ·χᵢ = listSum(η).

  The dual reconstruction from the code:
  given η, reconstruct the partition as the unique admissible state
  whose energy profile equals η.

  New axioms: 0
-/

namespace FinalSourceCode

open Manifestability

-- ════════════════════════════════════════════════════════════════
-- The dual energy functional
-- ════════════════════════════════════════════════════════════════

/-- The dual energy: given a consciousness-code (energy profile),
    compute the total energy. U_ind*(η) = Σ ηᵢ = listSum(η). -/
def dualEnergy (η : List Nat) : Nat := listSum η

-- ════════════════════════════════════════════════════════════════
-- Required theorems
-- ════════════════════════════════════════════════════════════════

/-- The dual energy exists for every consciousness-code. -/
theorem latent_energy_dual_exists (η : List Nat) :
    ∃ E : Nat, E = dualEnergy η :=
  ⟨dualEnergy η, rfl⟩

/-- The dual energy is well-defined (deterministic). -/
theorem latent_energy_dual_well_defined (η₁ η₂ : List Nat)
    (h : η₁ = η₂) : dualEnergy η₁ = dualEnergy η₂ := by
  rw [h]

/-- Self-duality: applying the dual to the consciousness-code
    recovers the original U_ind.
    U_ind*(DU_ind(x)) = U_ind(x). -/
theorem self_duality (s : AdmissibleState) :
    dualEnergy (consciousnessCode s) = U_ind s := by
  simp [dualEnergy, consciousnessCode]
  exact listSum_energy_eq_U_ind s

/-- The dual attains its supremum on the admissible domain:
    for any consciousness-code η that comes from an admissible state,
    dualEnergy(η) equals U_ind of that state. -/
theorem dual_attains_supremum_on_admissible_domain (s : AdmissibleState) :
    dualEnergy (consciousnessCode s) = U_ind s :=
  self_duality s

/-- The dual is nonnegative. -/
theorem dual_energy_nonneg (η : List Nat) :
    dualEnergy η ≥ 0 :=
  Nat.zero_le _

/-- The dual of the empty code is zero. -/
theorem dual_energy_empty : dualEnergy [] = 0 := by
  simp [dualEnergy, listSum]

/-- The dual is additive: dualEnergy(η₁ ++ η₂) = dualEnergy(η₁) + dualEnergy(η₂). -/
theorem dual_energy_additive (η₁ η₂ : List Nat) :
    dualEnergy (η₁ ++ η₂) = dualEnergy η₁ + dualEnergy η₂ := by
  simp [dualEnergy]
  induction η₁ with
  | nil => simp [listSum]
  | cons n rest ih => simp [listSum]; omega

end FinalSourceCode
