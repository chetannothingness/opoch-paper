import Mathlib.Analysis.InnerProductSpace.Spectrum
import OpochLean4.Riemann.Analytic.XiCoordinate

/-
  Positive Self-Dual Sector — Zero-Confinement from Self-Adjointness

  The abstract fact:
  If T is a symmetric linear map on an inner product space over ℂ,
  and μ is an eigenvalue of T, then conj(μ) = μ, i.e., μ.im = 0.

  This is Mathlib's LinearMap.IsSymmetric.conj_eigenvalue_eq_self.

  For RH: z is the spectral parameter. If z is an eigenvalue of a
  self-adjoint operator, then conj(z) = z, so z.im = 0.
  Then s = 1/2 + iz has Re(s) = 1/2.

  The sector-specific content: building the self-adjoint operator
  from the positive theta kernel and connecting its eigenvalues to
  zeros of Ξ(z).

  New axioms: 0
-/

namespace Riemann.Spectral

open Complex

-- ════════════════════════════════════════════════════════════════
-- The abstract confinement theorem (from Mathlib)
-- ════════════════════════════════════════════════════════════════

-- Mathlib gives:
-- LinearMap.IsSymmetric.conj_eigenvalue_eq_self :
--   T.IsSymmetric → HasEigenvalue T μ → conj μ = μ
--
-- conj μ = μ means μ.im = 0 (μ is real).
--
-- This is the abstract zero-confinement theorem.
-- We just need to apply it to the xi-sector.

/-- conj z = z iff z.im = 0. -/
theorem conj_eq_self_iff_im_zero (z : ℂ) :
    starRingEnd ℂ z = z ↔ z.im = 0 := by
  constructor
  · intro h
    have := congr_arg Complex.im h
    simp [Complex.conj_im] at this
    linarith
  · intro h
    apply Complex.ext
    · simp [Complex.conj_re]
    · simp [Complex.conj_im, h]

/-- If z is an eigenvalue of a symmetric operator, then z.im = 0. -/
theorem symmetric_eigenvalue_im_zero
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E]
    {T : E →ₗ[ℂ] E} (hT : T.IsSymmetric) {z : ℂ}
    (hz : Module.End.HasEigenvalue T z) :
    z.im = 0 := by
  have := hT.conj_eigenvalue_eq_self hz
  rwa [conj_eq_self_iff_im_zero] at this

-- ════════════════════════════════════════════════════════════════
-- The zero-confinement principle
-- ════════════════════════════════════════════════════════════════

/-- The zero-confinement principle:
    If zeros of a spectral function correspond to eigenvalues of
    a symmetric operator, then the spectral parameter is real.

    This is the abstract version. The xi-sector instantiation
    connects Ξ(z) = 0 to eigenvalues of a self-adjoint operator
    built from the positive theta kernel. -/
theorem zero_confinement_principle
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E]
    {T : E →ₗ[ℂ] E} (hT : T.IsSymmetric)
    {Delta : ℂ → ℂ}
    (hconnect : ∀ z, Delta z = 0 → Module.End.HasEigenvalue T z)
    (z : ℂ) (hz : Delta z = 0) :
    z.im = 0 :=
  symmetric_eigenvalue_im_zero hT (hconnect z hz)

end Riemann.Spectral
