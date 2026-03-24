/-
  OpochLean4/QuantitativeSeed/NumericalExtraction/BlockDiagonal.lean

  Concrete 16×16 block-diagonal L* with five blocks:
    temporal(1), spatial(3), U(1)(1), SU(2)(3), SU(3)(8).
  Dependencies: EigenHelpers, PhysicalRefinement
  Assumptions: A0star only.
-/

import OpochLean4.QuantitativeSeed.NumericalExtraction.EigenHelpers
import OpochLean4.QuantitativeSeed.NumericalExtraction.PhysicalRefinement

namespace QuantitativeSeed

open ClosureDefect

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Individual block matrices
-- ═══════════════════════════════════════════════════════════════

/-- Temporal block (1×1): entry 2.
    Binary branching of ledger: each append doubles state space. -/
def temporalBlock : Fin 1 → Fin 1 → Int := fun _ _ => 2

/-- Spatial block (3×3): K₃ complete graph Laplacian.
    Forced by spatial isotropy (conductance_unique) + n=3
    (spatial_dimension_is_three). Diagonal=2, off-diagonal=-1. -/
def spatialBlock : Fin 3 → Fin 3 → Int :=
  fun i j => if i = j then 2 else -1

/-- U(1) block (1×1): entry 1.
    Kähler phase preserved at fixed point. -/
def u1Block : Fin 1 → Fin 1 → Int := fun _ _ => 1

/-- SU(2) block (3×3): identity I₃.
    Weak gauge phases preserved at fixed point. -/
def su2Block : Fin 3 → Fin 3 → Int :=
  fun i j => if i = j then 1 else 0

/-- SU(3) block (8×8): identity I₈.
    Color gauge phases preserved at fixed point. -/
def su3Block : Fin 8 → Fin 8 → Int :=
  fun i j => if i = j then 1 else 0

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Full 16×16 physical L*
-- ═══════════════════════════════════════════════════════════════

/-- The full 16×16 physical L*: block-diagonal with the five blocks.
    Block layout: temporal [0], spatial [1-3], U(1) [4],
    SU(2) [5-7], SU(3) [8-15]. -/
def physicalLstarMatrix : Fin 16 → Fin 16 → Int := fun i j =>
  -- Temporal block: index 0
  if i.val = 0 ∧ j.val = 0 then 2
  -- Spatial block: indices 1-3, K₃ Laplacian
  else if i.val ≥ 1 ∧ i.val ≤ 3 ∧ j.val ≥ 1 ∧ j.val ≤ 3 then
    if i.val = j.val then 2 else -1
  -- U(1) block: index 4
  else if i.val = 4 ∧ j.val = 4 then 1
  -- SU(2) block: indices 5-7, identity
  else if i.val ≥ 5 ∧ i.val ≤ 7 ∧ j.val ≥ 5 ∧ j.val ≤ 7 then
    if i.val = j.val then 1 else 0
  -- SU(3) block: indices 8-15, identity
  else if i.val ≥ 8 ∧ j.val ≥ 8 then
    if i.val = j.val then 1 else 0
  -- Off-diagonal between blocks: 0
  else 0

/-- The physical L* as a LinearizedOperator. -/
def physicalLstar : LinearizedOperator where
  dim := 16
  dim_pos := by omega
  matrix := physicalLstarMatrix

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Block-diagonal verification
-- ═══════════════════════════════════════════════════════════════

/-- physicalLstar is block-diagonal: representative cross-block entries are zero.
    temporal(0) × spatial(1) = 0, temporal(0) × U(1)(4) = 0,
    spatial(1) × SU(2)(5) = 0, U(1)(4) × SU(3)(8) = 0. -/
theorem physicalLstar_block_diagonal :
    physicalLstarMatrix ⟨0, by omega⟩ ⟨1, by omega⟩ = 0 ∧
    physicalLstarMatrix ⟨0, by omega⟩ ⟨4, by omega⟩ = 0 ∧
    physicalLstarMatrix ⟨1, by omega⟩ ⟨5, by omega⟩ = 0 ∧
    physicalLstarMatrix ⟨4, by omega⟩ ⟨8, by omega⟩ = 0 := by
  decide

/-- The block offsets sum correctly: 1+3+1+3+8=16. -/
theorem block_offsets_sum : 1 + 3 + 1 + 3 + 8 = 16 := by decide

end QuantitativeSeed
