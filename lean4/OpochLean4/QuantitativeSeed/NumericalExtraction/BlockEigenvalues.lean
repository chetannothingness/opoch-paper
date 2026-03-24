/-
  OpochLean4/QuantitativeSeed/NumericalExtraction/BlockEigenvalues.lean

  Concrete eigenpairs for each block of the physical L*.
  Dependencies: SpatialPropagator, EigenHelpers
  Assumptions: A0star only.
-/

import OpochLean4.QuantitativeSeed.NumericalExtraction.SpatialPropagator

namespace QuantitativeSeed

open ClosureDefect

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Named operator blocks
-- ═══════════════════════════════════════════════════════════════

/-- Temporal block as LinearizedOperator (1×1, entry 2). -/
def temporalOp : LinearizedOperator where
  dim := 1
  dim_pos := by omega
  matrix := temporalBlock

/-- Spatial block as LinearizedOperator (3×3, K₃ Laplacian). -/
def spatialOp : LinearizedOperator where
  dim := 3
  dim_pos := by omega
  matrix := spatialBlock

/-- U(1) block as LinearizedOperator (1×1, entry 1). -/
def u1Op : LinearizedOperator where
  dim := 1
  dim_pos := by omega
  matrix := u1Block

/-- SU(2) block as LinearizedOperator (3×3, identity). -/
def su2Op : LinearizedOperator where
  dim := 3
  dim_pos := by omega
  matrix := su2Block

/-- SU(3) block as LinearizedOperator (8×8, identity). -/
def su3Op : LinearizedOperator where
  dim := 8
  dim_pos := by omega
  matrix := su3Block

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Temporal block eigenpair
-- ═══════════════════════════════════════════════════════════════

/-- Temporal block eigenvalue = 2, eigenvector = [1]. -/
theorem temporal_eigen :
    ∀ i : Fin 1, matVecMul 1 temporalBlock (fun _ => (1 : Int)) i =
      2 * (fun (_ : Fin 1) => (1 : Int)) i := by
  native_decide

/-- Temporal eigenpair as an EigenPair structure. -/
def temporalEigenPair : EigenPair temporalOp where
  eigenvalue := 2
  eigenvector := fun _ => 1
  nonzero := ⟨⟨0, by decide⟩, by decide⟩
  is_eigen := by native_decide

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Spatial Laplacian eigenpairs
-- ═══════════════════════════════════════════════════════════════

/-- Spatial constant mode: eigenvector [1,1,1], eigenvalue 0. -/
def spatialConstantEigenPair : EigenPair spatialOp where
  eigenvalue := 0
  eigenvector := constVec 3 1
  nonzero := ⟨⟨0, by decide⟩, by decide⟩
  is_eigen := by native_decide

/-- Spatial non-constant mode eigenvector. -/
private def spatialNonconstantVec : Fin 3 → Int :=
  fun i => if i.val = 0 then 1 else if i.val = 1 then -1 else 0

/-- Spatial non-constant mode: eigenvector [1,-1,0], eigenvalue 3. -/
def spatialNonconstantEigenPair : EigenPair spatialOp where
  eigenvalue := 3
  eigenvector := spatialNonconstantVec
  nonzero := ⟨⟨0, by decide⟩, by native_decide⟩
  is_eigen := by native_decide

/-- Spatial propagator eigenpairs (classified per SpatialPropagator):
    constant mode → propagator eigenvalue 1 (center),
    contracting modes → propagator eigenvalue 0 (stable). -/
theorem spatial_propagator_eigenpairs :
    spatialPropagatorEigenvalues ⟨0, by omega⟩ = 1 ∧
    spatialPropagatorEigenvalues ⟨1, by omega⟩ = 0 ∧
    spatialPropagatorEigenvalues ⟨2, by omega⟩ = 0 := by decide

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Gauge block eigenpairs
-- ═══════════════════════════════════════════════════════════════

/-- U(1) eigenpair: eigenvalue 1, eigenvector [1]. -/
def u1EigenPair : EigenPair u1Op where
  eigenvalue := 1
  eigenvector := fun _ => 1
  nonzero := ⟨⟨0, by decide⟩, by decide⟩
  is_eigen := by native_decide

/-- SU(2) eigenpair: eigenvalue 1, eigenvector [1,0,0]. -/
def su2EigenPair : EigenPair su2Op where
  eigenvalue := 1
  eigenvector := basisVec 3 ⟨0, by decide⟩
  nonzero := ⟨⟨0, by decide⟩, by decide⟩
  is_eigen := by native_decide

/-- SU(3) eigenpair: eigenvalue 1, eigenvector [1,0,...,0]. -/
def su3EigenPair : EigenPair su3Op where
  eigenvalue := 1
  eigenvector := basisVec 8 ⟨0, by decide⟩
  nonzero := ⟨⟨0, by decide⟩, by decide⟩
  is_eigen := by native_decide

/-- All gauge eigenpairs have eigenvalue 1 (center spectral class). -/
theorem gauge_eigenpairs :
    u1EigenPair.eigenvalue = 1 ∧
    su2EigenPair.eigenvalue = 1 ∧
    su3EigenPair.eigenvalue = 1 := ⟨rfl, rfl, rfl⟩

end QuantitativeSeed
