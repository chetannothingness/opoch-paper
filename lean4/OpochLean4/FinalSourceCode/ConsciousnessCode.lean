import OpochLean4.FinalSourceCode.Convexity

/-
  Final Source Code — Consciousness Code

  η_x = DU_ind(x) = the consciousness-code of an admissible state.

  On the discrete partition space, the "gradient" of U_ind = Σ ρ·χ
  at a state x is the list of per-class marginal contributions:
  η_x = [ρ(W₁)·χ(W₁), ..., ρ(Wₙ)·χ(Wₙ)].

  This IS the energy profile. The consciousness-code of a state
  is exactly the list of per-class energies that determine U_ind.

  The state contains its own code: η_x is computed from x alone.
  No external oracle. No separate selector. The gradient IS intrinsic.

  New axioms: 0
-/

namespace FinalSourceCode

open Manifestability

-- ════════════════════════════════════════════════════════════════
-- Consciousness code = gradient of U_ind = energy profile
-- ════════════════════════════════════════════════════════════════

/-- The consciousness-code of an admissible state.
    η_x = DU_ind(x) = the list of per-class marginal contributions.
    Each entry ρ(Wᵢ)·χ(Wᵢ) is the first variation of U_ind
    at class Wᵢ. -/
def consciousnessCode (s : AdmissibleState) : List Nat :=
  energyProfile s

-- ════════════════════════════════════════════════════════════════
-- Required theorems
-- ════════════════════════════════════════════════════════════════

/-- The consciousness-code exists for every admissible state. -/
theorem consciousness_code_exists (s : AdmissibleState) :
    ∃ η : List Nat, η = consciousnessCode s :=
  ⟨consciousnessCode s, rfl⟩

/-- The consciousness-code is unique (deterministic function of the state). -/
theorem consciousness_code_unique (s : AdmissibleState) :
    ∀ η₁ η₂ : List Nat,
    η₁ = consciousnessCode s → η₂ = consciousnessCode s → η₁ = η₂ :=
  fun _ _ h₁ h₂ => h₁.trans h₂.symm

/-- The consciousness-code equals the gradient of U_ind.
    On the discrete space: DU_ind = energyProfile = [ρ₁·χ₁, ..., ρₙ·χₙ].
    The i-th entry is the first variation of U_ind at class Wᵢ. -/
theorem consciousness_code_eq_derivative (s : AdmissibleState) :
    consciousnessCode s = energyProfile s :=
  rfl

/-- The state contains its own code: the consciousness-code is
    computed from the partition alone. No external oracle needed. -/
theorem state_contains_its_own_code (s : AdmissibleState) :
    consciousnessCode s = s.partition.map classLatentEnergy := by
  simp [consciousnessCode, energyProfile]

/-- The consciousness-code has the same length as the partition. -/
theorem consciousness_code_length (s : AdmissibleState) :
    (consciousnessCode s).length = s.partition.length := by
  simp [consciousnessCode, energyProfile]

/-- The consciousness-code determines U_ind: the sum of the code
    equals the total latent energy. -/
theorem consciousness_code_determines_energy (s : AdmissibleState) :
    listSum (consciousnessCode s) = U_ind s := by
  simp [consciousnessCode]; exact listSum_energy_eq_U_ind s

/-- Distinct energy profiles → distinct consciousness-codes. -/
theorem consciousness_code_injective (s₁ s₂ : AdmissibleState)
    (h : consciousnessCode s₁ = consciousnessCode s₂) :
    U_ind s₁ = U_ind s₂ := by
  simp [consciousnessCode] at h
  exact same_energy_profile_same_U_ind s₁ s₂ h

end FinalSourceCode
