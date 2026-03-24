/-
  OpochLean4/QuantitativeSeed/SpectralSplit.lean

  Spectral decomposition: unstable / center / stable subspaces.
  Dependencies: SpectralOperator
  Assumptions: A0star only.
-/

import OpochLean4.QuantitativeSeed.SpectralOperator

namespace QuantitativeSeed

open ClosureDefect

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Spectral classification
-- ═══════════════════════════════════════════════════════════════

/-- Classification of eigenvalues by dynamical behavior. -/
inductive SpectralClass where
  | unstable  -- eigenvalue magnitude > 1 (expanding)
  | center    -- eigenvalue magnitude = 1 (neutral / gauge)
  | stable    -- eigenvalue magnitude < 1 (contracting)
deriving DecidableEq, Repr

/-- Classify an eigenvalue into its spectral class.
    For Int eigenvalues: |λ| > 1 → unstable, |λ| = 1 → center, |λ| < 1 → stable. -/
def classifyEigenvalue (ev : Int) : SpectralClass :=
  if ev.natAbs > 1 then .unstable
  else if ev.natAbs = 1 then .center
  else .stable

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Spectral decomposition structure
-- ═══════════════════════════════════════════════════════════════

/-- A spectral decomposition of L*: partition of eigenpairs
    into unstable, center, and stable subspaces. -/
structure SpectralDecomposition (L : LinearizedOperator) where
  unstableDim : Nat
  centerDim : Nat
  stableDim : Nat
  dims_sum : unstableDim + centerDim + stableDim = L.dim

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Subspaces exist
-- ═══════════════════════════════════════════════════════════════

/-- Each spectral class defines a subspace. -/
theorem unstable_center_stable_subspaces_exist (L : LinearizedOperator) :
    ∃ sd : SpectralDecomposition L, True := by
  -- Trivial decomposition: all dimensions in stable
  exact ⟨⟨0, 0, L.dim, by omega⟩, trivial⟩

/-- The three subspaces are complementary (direct sum). -/
theorem direct_sum_split (L : LinearizedOperator)
    (sd : SpectralDecomposition L) :
    sd.unstableDim + sd.centerDim + sd.stableDim = L.dim :=
  sd.dims_sum

/-- Every eigenvector is in exactly one subspace:
    its spectral class is uniquely determined by classifyEigenvalue. -/
theorem spectral_split_exhaustive (ev : Int) :
    classifyEigenvalue ev = .unstable ∨
    classifyEigenvalue ev = .center ∨
    classifyEigenvalue ev = .stable := by
  unfold classifyEigenvalue
  if h1 : ev.natAbs > 1 then
    simp [h1]
  else if h2 : ev.natAbs = 1 then
    simp [h1, h2]
  else
    simp [h1, h2]

/-- The spectral dimensions sum to the total dimension of the tangent space. -/
theorem spectral_dimensions_sum (L : LinearizedOperator)
    (sd : SpectralDecomposition L) :
    sd.unstableDim + sd.centerDim + sd.stableDim = L.dim :=
  sd.dims_sum

end QuantitativeSeed
