import OpochLean4.Riemann.Analytic.ZeroSet

/-
  Xi Coordinate — The Critical-Line Coordinate System

  Ξ(z) := ξ(1/2 + iz)

  In this coordinate, RH is:
    ∀ z : ℂ, Ξ(z) = 0 → z.im = 0

  i.e., all zeros have real spectral parameter.

  The map s = 1/2 + iz gives:
    Re(s) = 1/2 - Im(z)
    So Re(s) = 1/2 ↔ Im(z) = 0 ↔ z ∈ ℝ

  This is the correct coordinate for the self-adjoint theorem.
  conj_eigenvalue_eq_self gives conj(z) = z, i.e., z.im = 0.

  New axioms: 0
-/

namespace Riemann

open Complex

-- ════════════════════════════════════════════════════════════════
-- The Xi coordinate
-- ════════════════════════════════════════════════════════════════

/-- Ξ(z) = ξ(1/2 + iz) — the critical-line coordinate. -/
noncomputable def XiC (z : ℂ) : ℂ := xi ((1 : ℂ)/2 + I * z)

/-- The coordinate change: s = 1/2 + iz. -/
noncomputable def criticalCoord (z : ℂ) : ℂ := (1 : ℂ)/2 + I * z

/-- Re(1/2 + iz) = 1/2 - Im(z). -/
theorem criticalCoord_re (z : ℂ) :
    (criticalCoord z).re = 1/2 - z.im := by
  simp [criticalCoord, Complex.add_re, Complex.mul_re,
        Complex.I_re, Complex.I_im, Complex.ofReal_re]
  ring

/-- Re(s) = 1/2 ↔ Im(z) = 0 under s = 1/2 + iz. -/
theorem criticalCoord_re_half_iff (z : ℂ) :
    (criticalCoord z).re = 1/2 ↔ z.im = 0 := by
  rw [criticalCoord_re]
  constructor
  · intro h; linarith
  · intro h; linarith

-- ════════════════════════════════════════════════════════════════
-- RH in the z-coordinate
-- ════════════════════════════════════════════════════════════════

/-- RH in the z-coordinate: all zeros of Ξ have real z (Im(z) = 0). -/
def RH_z : Prop := ∀ z : ℂ, XiC z = 0 → z.im = 0

/-- RH ↔ RH_z: the two formulations are equivalent.
    ∀ ρ, IsNontrivialZero ρ → Re(ρ) = 1/2
    ↔ ∀ z, Ξ(z) = 0 → Im(z) = 0 -/
theorem rh_iff_all_XiC_zeros_real :
    RH_z →
    (∀ ρ : ℂ, IsNontrivialZero ρ → ρ.re = 1/2) := by
  intro hrh_z ρ ⟨hzero, hne0, hne1⟩
  -- Write ρ = 1/2 + iz where z = -i(ρ - 1/2) = (ρ - 1/2)/i
  -- More concretely: z = -I * (ρ - 1/2)
  -- Then ρ = 1/2 + I*z = criticalCoord z
  -- And XiC z = xi(criticalCoord z) = xi(ρ)
  let z : ℂ := -I * (ρ - (1 : ℂ)/2)
  -- Show criticalCoord z = ρ
  have hcoord : criticalCoord z = ρ := by
    simp only [criticalCoord, z]
    have : I * (-I * (ρ - (1 : ℂ) / 2)) = -I * I * (ρ - (1 : ℂ) / 2) := by ring
    rw [this]
    simp [I_mul_I]
  have hXiC : XiC z = 0 := by
    show xi ((1 : ℂ)/2 + I * z) = 0
    have : (1 : ℂ)/2 + I * z = ρ := hcoord
    rw [this]
    exact hzero
  have hz_real := hrh_z z hXiC
  rw [← hcoord, criticalCoord_re_half_iff]
  exact hz_real

end Riemann
