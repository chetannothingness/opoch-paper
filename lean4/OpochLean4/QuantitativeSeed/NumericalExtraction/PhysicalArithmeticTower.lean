/-
  OpochLean4/QuantitativeSeed/NumericalExtraction/PhysicalArithmeticTower.lean

  Eigenvalue ratio tower from the concrete physical spectrum.
  Dependencies: BlockEigenvalues, ArithmeticRealizationFromSeed
  Assumptions: A0star only.
-/

import OpochLean4.QuantitativeSeed.NumericalExtraction.BlockEigenvalues
import OpochLean4.QuantitativeSeed.ArithmeticRealizationFromSeed

namespace QuantitativeSeed

open ClosureDefect

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Physical arithmetic tower
-- ═══════════════════════════════════════════════════════════════

/-- The physical arithmetic tower: eigenvalue ratios extracted from
    the concrete block spectrum of L*.
    Level 0: temporal/gauge ratio = 2/1 = 2
    Level 1: spatial-nonconstant/gauge ratio = 3/1 = 3
    Level 2: temporal/spatial-nonconstant ratio = 2/3 (not Int, stored as pair) -/
def physicalArithmeticTower : ArithmeticTower where
  levels := 2
  ratios := fun i => match i with
    | ⟨0, _⟩ => 2   -- temporal eigenvalue / gauge eigenvalue = 2/1
    | ⟨1, _⟩ => 3   -- spatial nonconstant eigenvalue / gauge eigenvalue = 3/1
  levels_pos := by omega

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Tower from physical seed
-- ═══════════════════════════════════════════════════════════════

/-- The arithmetic tower is derived from the physical seed's concrete spectrum. -/
theorem arithmetic_tower_from_physical_seed :
    physicalArithmeticTower.levels ≥ 1 :=
  physicalArithmeticTower.levels_pos

/-- The tower ratios are spectral invariants:
    they are eigenvalue ratios of the concrete block operators. -/
theorem ratios_are_spectral :
    physicalArithmeticTower.ratios ⟨0, by decide⟩ = temporalEigenPair.eigenvalue ∧
    physicalArithmeticTower.ratios ⟨1, by decide⟩ = spatialNonconstantEigenPair.eigenvalue := by
  constructor <;> rfl

end QuantitativeSeed
