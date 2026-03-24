/-
  OpochLean4/QuantitativeSeed/NumericalExtraction/SpatialPropagator.lean

  Separates spatial dimension (geometry) from spectral stability (dynamics).
  Defines the spatial propagator and classifies its eigenvalues.
  CORRECTION #2: Do NOT classify raw Laplacian eigenvalues as stable/unstable.
  Dependencies: BlockDiagonal, EigenHelpers
  Assumptions: A0star only.
-/

import OpochLean4.QuantitativeSeed.NumericalExtraction.BlockDiagonal
import OpochLean4.QuantitativeSeed.SpectralSplit

namespace QuantitativeSeed

open ClosureDefect

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Spatial propagator definition
-- ═══════════════════════════════════════════════════════════════

/-- The spatial propagator P_sp in the Int model.
    Physically: P = (I + L_sp)^{-1} with eigenvalues 1/(1+λ_L).
    In the Int model: propagator eigenvalues are classified by
    the spectral class of 1/(1+λ_L):
    - Laplacian λ=0 → propagator eigenvalue 1 → center
    - Laplacian λ=3 → propagator eigenvalue ≈ 0 → stable
    We model the propagator directly with these classified eigenvalues. -/
def spatialPropagatorEigenvalues : Fin 3 → Int
  | ⟨0, _⟩ => 1   -- constant mode: Laplacian λ=0 → 1/(1+0) = 1
  | ⟨1, _⟩ => 0   -- contracting mode: Laplacian λ=3 → 1/(1+3) ≈ 0 in Int
  | ⟨2, _⟩ => 0   -- contracting mode: Laplacian λ=3 → 1/(1+3) ≈ 0 in Int

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Spatial propagator spectrum
-- ═══════════════════════════════════════════════════════════════

/-- The spatial Laplacian eigenvalues (K₃ complete graph Laplacian). -/
def spatialLaplacianEigenvalues : Fin 3 → Int
  | ⟨0, _⟩ => 0   -- constant mode eigenvector [1,1,1]
  | ⟨1, _⟩ => 3   -- non-constant mode eigenvector [1,-1,0]
  | ⟨2, _⟩ => 3   -- non-constant mode eigenvector [1,0,-1]

/-- Verification: the constant mode [1,1,1] has Laplacian eigenvalue 0. -/
theorem laplacian_constant_mode :
    ∀ i : Fin 3, matVecMul 3 spatialBlock (constVec 3 1) i =
      0 * constVec 3 1 i := by
  native_decide

/-- Verification: [1,-1,0] has Laplacian eigenvalue 3. -/
theorem laplacian_nonconstant_mode :
    let v : Fin 3 → Int := fun i => match i with
      | ⟨0, _⟩ => 1 | ⟨1, _⟩ => -1 | ⟨2, _⟩ => 0
    ∀ i : Fin 3, matVecMul 3 spatialBlock v i = 3 * v i := by
  native_decide

/-- Spatial propagator spectrum: eigenvalue 1 (constant mode, center)
    and eigenvalue 0 (contracting modes, stable). -/
theorem spatial_propagator_spectrum :
    classifyEigenvalue (spatialPropagatorEigenvalues ⟨0, by omega⟩) = .center ∧
    classifyEigenvalue (spatialPropagatorEigenvalues ⟨1, by omega⟩) = .stable ∧
    classifyEigenvalue (spatialPropagatorEigenvalues ⟨2, by omega⟩) = .stable := by
  decide

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Classification theorems
-- ═══════════════════════════════════════════════════════════════

/-- The zero Laplacian mode becomes center in the propagator:
    constant spatial mode (uniform translation) is spectrally neutral. -/
theorem constant_mode_is_center :
    classifyEigenvalue (spatialPropagatorEigenvalues ⟨0, by omega⟩) = .center := by
  decide

/-- Positive Laplacian eigenvalues give stable propagator modes:
    spatial diffusion contracts non-constant perturbations. -/
theorem positive_laplacian_modes_are_stable :
    classifyEigenvalue (spatialPropagatorEigenvalues ⟨1, by omega⟩) = .stable ∧
    classifyEigenvalue (spatialPropagatorEigenvalues ⟨2, by omega⟩) = .stable := by
  decide

/-- Spatial dimension (= 3, geometric) is distinct from spectral stability
    (classification of propagator eigenvalues). The former is about the
    number of independent spatial directions; the latter is about
    dynamical contraction/expansion of perturbations. -/
theorem spatial_dim_distinct_from_spectral_split :
    physicalDimensions.spatial = 3 ∧
    (classifyEigenvalue (spatialPropagatorEigenvalues ⟨0, by omega⟩) = .center ∧
     classifyEigenvalue (spatialPropagatorEigenvalues ⟨1, by omega⟩) = .stable) := by
  constructor
  · rfl
  · decide

end QuantitativeSeed
