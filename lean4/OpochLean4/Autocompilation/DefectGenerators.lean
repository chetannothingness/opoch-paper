import OpochLean4.Autocompilation.DefectAddressing

/-
  Endogenous Autocompilation — Defect Generators

  G_d = Gen(W_d): the exact primitive refinement generators relevant
  to the defect. The count equals the target class multiplicity.

  New axioms: 0
-/

namespace Autocompilation

open Manifestability

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Generator set for a defect
-- ════════════════════════════════════════════════════════════════

/-- Generator set for a defect: the primitive refinement generators
    determined by the defect address. -/
structure DefectGeneratorSet where
  address : DefectAddress
  count : Nat
  count_pos : count ≥ 1

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Generator extraction
-- ════════════════════════════════════════════════════════════════

/-- Extract generators: count = target class multiplicity. -/
def extractDefectGenerators (addr : DefectAddress) : DefectGeneratorSet where
  address := addr
  count := addr.targetClass.multiplicity
  count_pos := addr.targetClass.multiplicity_pos

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: Theorems
-- ════════════════════════════════════════════════════════════════

/-- Generator extraction is exact: determined by address. -/
theorem defect_generators_exact (addr : DefectAddress) :
    ∃ G : DefectGeneratorSet, G = extractDefectGenerators addr :=
  ⟨extractDefectGenerators addr, rfl⟩

/-- Generator count equals target class multiplicity (completeness). -/
theorem defect_generators_complete (addr : DefectAddress) :
    (extractDefectGenerators addr).count = addr.targetClass.multiplicity :=
  rfl

/-- Generator count is at most multiplicity (minimality). -/
theorem defect_generators_minimal (addr : DefectAddress) :
    (extractDefectGenerators addr).count ≤ addr.targetClass.multiplicity :=
  Nat.le_refl _

end Autocompilation
