import OpochLean4.Foundations.RefinementAlgebra.Interference

/-
  Refinement Algebra — Latent Energy

  U_lat(W) = ρ(W) · χ(W) for one class: multiplicity × threshold.
  U_lat(P) = Σ U_lat(Wᵢ) for a partition: total hidden distinction-energy.

  This is the stored potential: how much action is needed to fully
  resolve a partition into singletons.

  New axioms: 0
-/

namespace RefinementAlgebra

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Class-level latent energy
-- ════════════════════════════════════════════════════════════════

/-- A refinable class: a residual class equipped with its χ threshold. -/
structure RefinableClass where
  /-- The residual class -/
  cls : RClass
  /-- The refinement threshold χ(W) -/
  chi : Nat

/-- Latent energy of a single class: ρ(W) · χ(W).
    Multiplicity counts how many indistinguishable alternatives;
    chi measures the cost to split one. Product = total cost. -/
def classLatentEnergy (rc : RefinableClass) : Nat :=
  rc.cls.multiplicity * rc.chi

/-- Latent energy is non-negative. -/
theorem classLatentEnergy_nonneg (rc : RefinableClass) :
    classLatentEnergy rc ≥ 0 :=
  Nat.zero_le _

/-- Latent energy is zero when chi is zero (free to refine). -/
theorem classLatentEnergy_zero_of_chi_zero (rc : RefinableClass)
    (h : rc.chi = 0) : classLatentEnergy rc = 0 := by
  simp [classLatentEnergy, h]

/-- Latent energy is positive when chi is positive (costs to refine). -/
theorem classLatentEnergy_pos_of_chi_pos (rc : RefinableClass)
    (h : rc.chi ≥ 1) : classLatentEnergy rc ≥ 1 := by
  simp only [classLatentEnergy]
  have hm := rc.cls.multiplicity_pos
  have := Nat.mul_le_mul hm h
  omega

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Partition-level latent energy
-- ════════════════════════════════════════════════════════════════

/-- A refinable partition: list of refinable classes. -/
abbrev RefinablePartition := List RefinableClass

/-- Total latent energy of a partition: sum of per-class latent energies.
    U_lat(P) = Σ_W ρ(W) · χ(W). -/
def latentEnergy : RefinablePartition → Nat
  | [] => 0
  | rc :: rest => classLatentEnergy rc + latentEnergy rest

/-- Latent energy of empty partition is zero. -/
theorem latentEnergy_empty : latentEnergy [] = 0 := rfl

/-- Latent energy is additive over concatenation. -/
theorem latentEnergy_append (P Q : RefinablePartition) :
    latentEnergy (P ++ Q) = latentEnergy P + latentEnergy Q := by
  induction P with
  | nil => simp [latentEnergy]
  | cons rc rest ih =>
    simp [latentEnergy, ih]
    omega

/-- Latent energy is non-negative. -/
theorem latentEnergy_nonneg (P : RefinablePartition) :
    latentEnergy P ≥ 0 :=
  Nat.zero_le _

/-- Latent energy is monotone: adding a class increases it. -/
theorem latentEnergy_cons_ge (rc : RefinableClass) (P : RefinablePartition) :
    latentEnergy (rc :: P) ≥ latentEnergy P := by
  simp [latentEnergy]

end RefinementAlgebra
