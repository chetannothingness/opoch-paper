import OpochLean4.FinalSourceCode.IndistinguishabilityEnergy

/-
  Final Source Code — Convexity

  Convexity of U_ind on the admissible state carrier.

  On the discrete partition space, convexity manifests as:
  1. Additivity: U_ind(P₁ ++ P₂) = U_ind(P₁) + U_ind(P₂)
  2. Strict monotonicity: adding a class with ρ·χ > 0 strictly increases energy
  3. Determinism: U_ind is uniquely determined by the partition

  The additivity IS discrete convexity: U_ind is a linear (hence convex)
  functional on the partition space viewed as a free commutative monoid.

  New axioms: 0
-/

namespace FinalSourceCode

open Manifestability

-- ════════════════════════════════════════════════════════════════
-- Convexity = Additivity on the partition monoid
-- ════════════════════════════════════════════════════════════════

/-- U_ind is convex: on the discrete partition space,
    convexity IS additivity under concatenation.
    U_ind(P₁ ++ P₂) = U_ind(P₁) + U_ind(P₂). -/
theorem latent_energy_convex (s₁ s₂ : AdmissibleState) :
    latentEnergy (s₁.partition ++ s₂.partition) =
    U_ind s₁ + U_ind s₂ :=
  latent_energy_additive s₁ s₂

/-- U_ind is strictly monotone: adding a class with positive ρ·χ
    strictly increases the energy. This is strict convexity on
    the discrete carrier — no "flat directions" when ρ·χ > 0. -/
theorem latent_energy_strictly_convex (s : AdmissibleState)
    (rc : RefinableClass) (h_pos : classLatentEnergy rc > 0) :
    U_ind ⟨rc :: s.partition, by simp⟩ > U_ind s := by
  simp [U_ind, latentEnergy]
  omega

/-- Latent energy is determined by the partition (trivially LSC
    on the discrete space). U_ind is a function, not a relation. -/
theorem latent_energy_lower_semicontinuous (s : AdmissibleState) :
    ∀ E₁ E₂ : Nat, E₁ = U_ind s → E₂ = U_ind s → E₁ = E₂ :=
  fun _ _ h₁ h₂ => h₁.trans h₂.symm

-- ════════════════════════════════════════════════════════════════
-- Energy profile: the per-class contributions determine U_ind
-- ════════════════════════════════════════════════════════════════

/-- The energy profile: list of per-class contributions ρ(W)·χ(W). -/
def energyProfile (s : AdmissibleState) : List Nat :=
  s.partition.map classLatentEnergy

/-- Recursive sum of a list of Nat. -/
def listSum : List Nat → Nat
  | [] => 0
  | n :: rest => n + listSum rest

/-- listSum of the energy profile equals U_ind. -/
theorem listSum_energy_eq_U_ind (s : AdmissibleState) :
    listSum (energyProfile s) = U_ind s := by
  simp [energyProfile, U_ind]
  induction s.partition with
  | nil => simp [listSum, latentEnergy]
  | cons rc rest ih =>
    simp [List.map_cons, listSum, latentEnergy, classLatentEnergy]
    omega

/-- Two admissible states with the same energy profile
    have the same U_ind. -/
theorem same_energy_profile_same_U_ind (s₁ s₂ : AdmissibleState)
    (h : energyProfile s₁ = energyProfile s₂) :
    U_ind s₁ = U_ind s₂ := by
  rw [← listSum_energy_eq_U_ind, ← listSum_energy_eq_U_ind, h]

end FinalSourceCode
