import OpochLean4.Riemann.Analytic.ZeroSet

/-
  Riemann Hypothesis — Critical Defect

  δ(ρ) = Re(ρ) - 1/2. Zero iff on critical line.
  E(ρ) = δ(ρ)² ≥ 0. Zero iff on line.
  RH ↔ defect set empty ↔ all E = 0 ↔ all zeros have form 1/2+it₀.

  New axioms: 0
-/

namespace Riemann

open Complex

noncomputable def criticalDefect (ρ : ℂ) : ℝ := ρ.re - (1/2 : ℝ)

theorem critical_defect_zero_iff_on_line (ρ : ℂ) :
    criticalDefect ρ = 0 ↔ ρ.re = 1/2 := by
  simp [criticalDefect, sub_eq_zero]

theorem critical_defect_antisymmetric (ρ : ℂ) :
    criticalDefect (1 - ρ) = -criticalDefect ρ := by
  simp [criticalDefect, Complex.sub_re, Complex.one_re]; ring

noncomputable def defectEnergy (ρ : ℂ) : ℝ := criticalDefect ρ ^ 2

theorem defect_energy_nonneg (ρ : ℂ) : defectEnergy ρ ≥ 0 := sq_nonneg _

theorem defect_energy_zero_iff_critical (ρ : ℂ) :
    defectEnergy ρ = 0 ↔ ρ.re = 1/2 := by
  rw [defectEnergy, sq_eq_zero_iff, critical_defect_zero_iff_on_line]

theorem off_line_positive_defect_energy (ρ : ℂ) (h : ρ.re ≠ 1/2) :
    defectEnergy ρ > 0 := by
  simp only [defectEnergy, criticalDefect]
  exact sq_pos_of_ne_zero (sub_ne_zero.mpr h)

def RiemannHypothesisStatement : Prop :=
  ∀ ρ : ℂ, IsNontrivialZero ρ → ρ.re = 1/2

theorem rh_iff_zero_defect_energy :
    RiemannHypothesisStatement ↔
    ∀ ρ : ℂ, IsNontrivialZero ρ → defectEnergy ρ = 0 := by
  constructor
  · intro h ρ hnt; rw [defect_energy_zero_iff_critical]; exact h ρ hnt
  · intro h ρ hnt; rw [← defect_energy_zero_iff_critical]; exact h ρ hnt

theorem rh_iff_Xi_zeros_real :
    RiemannHypothesisStatement ↔
    (∀ ρ : ℂ, IsNontrivialZero ρ → ∃ t₀ : ℝ, ρ = (1/2 : ℂ) + I * (t₀ : ℂ)) := by
  constructor
  · intro h ρ hnt
    have hre := h ρ hnt
    exact ⟨ρ.im, by
      apply Complex.ext
      · simp [Complex.add_re, Complex.mul_re, Complex.I_re, Complex.I_im,
              Complex.ofReal_re, Complex.ofReal_im]; linarith
      · simp [Complex.add_im, Complex.mul_im, Complex.I_re, Complex.I_im,
              Complex.ofReal_re, Complex.ofReal_im]⟩
  · intro h ρ hnt
    obtain ⟨t₀, ht₀⟩ := h ρ hnt
    rw [ht₀]
    simp [Complex.add_re, Complex.mul_re, Complex.I_re, Complex.I_im,
          Complex.ofReal_re, Complex.ofReal_im]

end Riemann
