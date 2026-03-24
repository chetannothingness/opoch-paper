/-
  OpochLean4/QuantitativeSeed/NumericalExtraction/EigenHelpers.lean

  Helper definitions for eigenpair computations on concrete matrices.
  Dependencies: SpectralOperator
  Assumptions: A0star only.
-/

import OpochLean4.QuantitativeSeed.SpectralOperator

namespace QuantitativeSeed

open ClosureDefect

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Basis vectors and diagonal matrices
-- ═══════════════════════════════════════════════════════════════

/-- Standard basis vector: e_k has 1 at position k, 0 elsewhere. -/
def basisVec (n : Nat) (k : Fin n) : Fin n → Int :=
  fun i => if i = k then 1 else 0

/-- Diagonal matrix from a vector of diagonal entries. -/
def diagMatrix (n : Nat) (d : Fin n → Int) : Fin n → Fin n → Int :=
  fun i j => if i = j then d i else 0

/-- Constant vector: all entries equal to v. -/
def constVec (n : Nat) (v : Int) : Fin n → Int :=
  fun _ => v

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Concrete 1×1 eigenpair verification
-- ═══════════════════════════════════════════════════════════════

/-- For a 1×1 matrix [[2]], eigenvector [1] has eigenvalue 2. -/
theorem rowDot_one_val2 :
    ∀ i : Fin 1, matVecMul 1 (fun _ _ => (2 : Int)) (fun _ => 1) i = 2 * 1 := by
  native_decide

/-- For a 1×1 matrix [[1]], eigenvector [1] has eigenvalue 1. -/
theorem rowDot_one_val1 :
    ∀ i : Fin 1, matVecMul 1 (fun _ _ => (1 : Int)) (fun _ => 1) i = 1 * 1 := by
  native_decide

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Concrete 3×3 identity eigenpair
-- ═══════════════════════════════════════════════════════════════

/-- For a 3×3 identity matrix, basis vector e₀ = [1,0,0] has eigenvalue 1. -/
theorem identity_eigenpair :
    let M : Fin 3 → Fin 3 → Int := fun i j => if i = j then 1 else 0
    let v : Fin 3 → Int := basisVec 3 ⟨0, by omega⟩
    ∀ i : Fin 3, matVecMul 3 M v i = 1 * v i := by
  native_decide

/-- For a 3×3 K₃ Laplacian, constant vector [1,1,1] has eigenvalue 0. -/
theorem laplacian_constant_eigenpair :
    let M : Fin 3 → Fin 3 → Int := fun i j => if i = j then 2 else -1
    let v : Fin 3 → Int := constVec 3 1
    ∀ i : Fin 3, matVecMul 3 M v i = 0 * v i := by
  native_decide

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Concrete 8×8 identity eigenpair
-- ═══════════════════════════════════════════════════════════════

/-- For an 8×8 identity matrix, basis vector e₀ has eigenvalue 1. -/
theorem diagonal_eigenpair :
    let M : Fin 8 → Fin 8 → Int := fun i j => if i = j then 1 else 0
    let v : Fin 8 → Int := basisVec 8 ⟨0, by omega⟩
    ∀ i : Fin 8, matVecMul 8 M v i = 1 * v i := by
  native_decide

end QuantitativeSeed
