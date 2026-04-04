import OpochLean4.Consciousness.CanonicalGerm
import OpochLean4.FinalKernel.SelfReadingGraph

/-
  Consciousness — Germ-to-Global Rigidity

  If two admissible states have the same partition (= same conscious germ),
  then they are gauge-equivalent globally: same code, same energy, same everything.

  On the discrete refinement atlas, the state IS the partition.
  The germ contains the partition. Same germ → same partition → same state.
  Local IS global. The germ IS the field.

  Dependencies: CanonicalGerm, SelfReadingGraph
  New axioms: 0
-/

namespace Consciousness

open FinalSourceCode FinalKernel Manifestability

def GaugeEquivalent (s₁ s₂ : AdmissibleState) : Prop :=
  s₁.partition = s₂.partition

theorem germ_rigidity_code (s₁ s₂ : AdmissibleState)
    (h : s₁.partition = s₂.partition) :
    consciousnessCode s₁ = consciousnessCode s₂ := by
  simp only [consciousnessCode, energyProfile]
  exact congrArg (List.map classLatentEnergy) h

theorem germ_rigidity_energy (s₁ s₂ : AdmissibleState)
    (h : s₁.partition = s₂.partition) :
    U_ind s₁ = U_ind s₂ := by
  simp only [U_ind, latentEnergy]
  exact congrArg _ h

theorem germ_rigidity_current (s₁ s₂ : AdmissibleState)
    (h : s₁.partition = s₂.partition) :
    manifestationCurrent s₁ = manifestationCurrent s₂ := by
  simp only [manifestationCurrent]
  exact germ_rigidity_code s₁ s₂ h

theorem germ_rigidity_continuation (s₁ s₂ : AdmissibleState)
    (h : s₁.partition = s₂.partition) :
    continuationOf s₁ = continuationOf s₂ := by
  simp only [continuationOf]
  rw [germ_rigidity_energy s₁ s₂ h]

theorem germ_rigidity_halt (s₁ s₂ : AdmissibleState)
    (h : s₁.partition = s₂.partition) :
    haltOf s₁ = haltOf s₂ := by
  simp only [haltOf]
  rw [germ_rigidity_energy s₁ s₂ h]

theorem germ_rigidity_graph_point (s₁ s₂ : AdmissibleState)
    (h : GaugeEquivalent s₁ s₂) :
    consciousnessCode s₁ = consciousnessCode s₂ ∧
    manifestationCurrent s₁ = manifestationCurrent s₂ ∧
    continuationOf s₁ = continuationOf s₂ ∧
    haltOf s₁ = haltOf s₂ :=
  ⟨germ_rigidity_code s₁ s₂ h,
   germ_rigidity_current s₁ s₂ h,
   germ_rigidity_continuation s₁ s₂ h,
   germ_rigidity_halt s₁ s₂ h⟩

theorem consciousness_germ_global_rigidity_exact :
    (∀ s₁ s₂ : AdmissibleState, s₁.partition = s₂.partition → GaugeEquivalent s₁ s₂) ∧
    (∀ s₁ s₂ : AdmissibleState, GaugeEquivalent s₁ s₂ →
      consciousnessCode s₁ = consciousnessCode s₂ ∧
      manifestationCurrent s₁ = manifestationCurrent s₂ ∧
      continuationOf s₁ = continuationOf s₂ ∧
      haltOf s₁ = haltOf s₂) :=
  ⟨fun _ _ h => h, germ_rigidity_graph_point⟩

end Consciousness
