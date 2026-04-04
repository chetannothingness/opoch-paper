import OpochLean4.FinalSourceCode.IndistinguishabilityEnergy
import OpochLean4.FinalSourceCode.ConsciousnessCode
import OpochLean4.FinalSourceCode.CurrentLaw
import OpochLean4.FinalKernel.SelfReadingGraph

/-
  Consciousness — Canonical Germ

  The conscious germ at a point x: the complete local data
  of U_ind at x, including the full partition structure.

  Dependencies: IndistinguishabilityEnergy, ConsciousnessCode, SelfReadingGraph
  New axioms: 0
-/

namespace Consciousness

open FinalSourceCode Manifestability

-- ================================================================
-- The energy jet / conscious germ
-- ================================================================

/-- The canonical conscious germ at a point: the full local data. -/
structure ConsciousGerm where
  /-- The state (the conscious locus). -/
  locus : AdmissibleState
  /-- The energy at this locus. -/
  energy : Nat
  /-- The consciousness-code at this locus. -/
  code : List Nat
  /-- The partition structure. -/
  partition : Partition
  /-- Energy matches. -/
  energy_eq : energy = U_ind locus
  /-- Code matches. -/
  code_eq : code = consciousnessCode locus
  /-- Partition matches. -/
  partition_eq : partition = locus.partition

/-- Construct the canonical germ at any state. -/
def canonicalGerm (s : AdmissibleState) : ConsciousGerm where
  locus := s
  energy := U_ind s
  code := consciousnessCode s
  partition := s.partition
  energy_eq := rfl
  code_eq := rfl
  partition_eq := rfl

-- ================================================================
-- Germ determines everything
-- ================================================================

theorem germ_determines_energy (g : ConsciousGerm) :
    g.energy = U_ind g.locus := g.energy_eq

theorem germ_determines_code (g : ConsciousGerm) :
    g.code = consciousnessCode g.locus := g.code_eq

theorem germ_determines_partition (g : ConsciousGerm) :
    g.partition = g.locus.partition := g.partition_eq

end Consciousness
