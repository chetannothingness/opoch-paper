import OpochLean4.Riemann.Analytic.FunctionalEquation

/-
  Riemann Hypothesis — Zero Set

  Nontrivial zeros: ξ(ρ) = 0, ρ ≠ 0, ρ ≠ 1.
  Zeros preserved under involution.

  New axioms: 0
-/

namespace Riemann

open Complex

def IsNontrivialZero (ρ : ℂ) : Prop :=
  xi ρ = 0 ∧ ρ ≠ 0 ∧ ρ ≠ 1

theorem sigma_preserves_nontrivial (ρ : ℂ) (h : IsNontrivialZero ρ) :
    IsNontrivialZero (1 - ρ) := by
  refine ⟨zero_preserved_under_sigma ρ h.1, ?_, ?_⟩
  · intro heq; apply h.2.2; have : (1:ℂ) - ρ = 0 := heq
    have := sub_eq_zero.mp this; exact this.symm
  · intro heq; apply h.2.1
    have h1 : (1:ℂ) - ρ = 1 := heq
    have h2 : (1:ℂ) - ρ - 1 = 0 := by rw [h1]; ring
    have h3 : -ρ = (0:ℂ) := by ring_nf at h2 ⊢; exact h2
    exact neg_eq_zero.mp h3

end Riemann
