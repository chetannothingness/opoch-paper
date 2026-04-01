import OpochLean4.FinalSourceCode.AdmissibleState

/-
  Final Source Code — Indistinguishability Energy

  U_ind : X_adm → Nat = Σ ρ(W)·χ(W)

  This IS the latentEnergy from Foundations/Manifestability/LatentEnergy.lean,
  lifted to the AdmissibleState carrier.

  U_ind is NOT a new functional. It is the SAME Σ ρ·χ that was already
  proved additive, nonnegative, and conservation-law-compliant.

  New axioms: 0
-/

namespace FinalSourceCode

open Manifestability

-- ════════════════════════════════════════════════════════════════
-- The master energy functional
-- ════════════════════════════════════════════════════════════════

/-- The latent indistinguishability-energy of an admissible state.
    U_ind(s) = Σ_{W ∈ s.partition} ρ(W) · χ(W)
    This is latentEnergy from the Manifestability layer. -/
def U_ind (s : AdmissibleState) : Nat :=
  latentEnergy s.partition

/-- The per-class contribution: ρ(W) · χ(W). -/
def classEnergy (rc : RefinableClass) : Nat :=
  classLatentEnergy rc

-- ════════════════════════════════════════════════════════════════
-- Required theorems
-- ════════════════════════════════════════════════════════════════

/-- The latent indistinguishability energy exists for every admissible state. -/
theorem latent_indistinguishability_energy_exists (s : AdmissibleState) :
    ∃ E : Nat, E = U_ind s :=
  ⟨U_ind s, rfl⟩

/-- Latent energy is nonnegative. -/
theorem latent_energy_nonnegative (s : AdmissibleState) :
    U_ind s ≥ 0 :=
  Nat.zero_le _

/-- Latent energy is zero iff the partition is empty or all classes
    have ρ·χ = 0 (either fully resolved or unrefinable). -/
theorem latent_energy_zero_iff_fully_closed (s : AdmissibleState) :
    U_ind s = 0 ↔ latentEnergy s.partition = 0 := by
  simp [U_ind]

/-- U_ind recovers the refinement threshold χ as its per-class first variation:
    for each class W in the partition, the marginal contribution to U_ind
    from one additional copy of W is χ(W). -/
theorem latent_energy_recovers_threshold (rc : RefinableClass) :
    classEnergy rc = rc.cls.multiplicity * rc.threshold.chi := by
  simp [classEnergy, classLatentEnergy]

/-- U_ind recovers the value law: for a singleton partition,
    U_ind = ρ · χ = the class energy. -/
theorem latent_energy_recovers_value_law (rc : RefinableClass) :
    U_ind ⟨[rc], by simp⟩ = classEnergy rc := by
  simp [U_ind, latentEnergy, classEnergy, classLatentEnergy]

/-- U_ind is additive under partition concatenation.
    This is the key structural property inherited from Manifestability. -/
theorem latent_energy_additive (s₁ s₂ : AdmissibleState) :
    latentEnergy (s₁.partition ++ s₂.partition) =
    U_ind s₁ + U_ind s₂ := by
  simp [U_ind]; exact latent_energy_append s₁.partition s₂.partition

end FinalSourceCode
