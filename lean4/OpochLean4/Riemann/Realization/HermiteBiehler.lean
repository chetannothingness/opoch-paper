import Mathlib.Analysis.Complex.Basic
import Mathlib.Analysis.Normed.Field.Basic
import OpochLean4.Riemann.Analytic.XiCoordinate

/-
  Hermite-Biehler / de Branges Realization

  E is HB: ‖E(conj z)‖ < ‖E(z)‖ for Im z > 0.
  A(z) = (E(z) + E#(z)) / 2 has only real zeros.

  New axioms: 0
-/

noncomputable section

namespace Riemann.Realization

open Complex

-- ════════════════════════════════════════════════════════════════
-- Definitions
-- ════════════════════════════════════════════════════════════════

def Esharp (E : ℂ → ℂ) (z : ℂ) : ℂ := starRingEnd ℂ (E (starRingEnd ℂ z))

def A_from_E (E : ℂ → ℂ) (z : ℂ) : ℂ := (E z + Esharp E z) / 2

structure SelfDualHB where
  E : ℂ → ℂ
  hb_ineq : ∀ z : ℂ, z.im > 0 → ‖E (starRingEnd ℂ z)‖ < ‖E z‖

-- ════════════════════════════════════════════════════════════════
-- Key lemma: A(z) = 0 → E(z) = -E#(z)
-- ════════════════════════════════════════════════════════════════

theorem A_zero_implies_E_neg_Esharp (E : ℂ → ℂ) (z : ℂ)
    (hz : A_from_E E z = 0) : E z = -(Esharp E z) := by
  have h : E z + Esharp E z = 0 := by
    have := hz; simp only [A_from_E] at this; field_simp at this; exact this
  have := add_eq_zero_iff_eq_neg.mp h
  exact this

-- ════════════════════════════════════════════════════════════════
-- Key lemma: ‖E#(z)‖ = ‖E(conj z)‖
-- ════════════════════════════════════════════════════════════════

theorem norm_Esharp (E : ℂ → ℂ) (z : ℂ) :
    ‖Esharp E z‖ = ‖E (starRingEnd ℂ z)‖ := by
  simp [Esharp, map_star, norm_star]

-- ════════════════════════════════════════════════════════════════
-- The Hermite-Biehler theorem: A zeros are real
-- ════════════════════════════════════════════════════════════════

/-- If E is Hermite-Biehler and A(z) = 0 with E(z) ≠ 0,
    then z.im = 0.

    Proof: A(z) = 0 → E(z) = -E#(z) → ‖E(z)‖ = ‖E#(z)‖ = ‖E(conj z)‖.
    But HB says ‖E(conj z)‖ < ‖E(z)‖ if im z > 0.
    So ‖E(z)‖ < ‖E(z)‖. Contradiction.
    Similarly for im z < 0 via conj symmetry. -/
theorem hb_A_zero_im_zero (H : SelfDualHB) (z : ℂ)
    (hz : A_from_E H.E z = 0) (hEnz : H.E z ≠ 0) : z.im = 0 := by
  by_contra him
  rcases lt_or_gt_of_ne him with him_neg | him_pos
  · -- im z < 0: consider w = conj z which has im w > 0
    -- We need: A(conj z) = 0 too, or work with the norm directly
    -- From A(z) = 0: E(z) = -E#(z), so ‖E(z)‖ = ‖E#(z)‖ = ‖E(conj z)‖
    have h_eq := A_zero_implies_E_neg_Esharp H.E z hz
    have h_norm : ‖H.E z‖ = ‖H.E (starRingEnd ℂ z)‖ := by
      rw [h_eq, norm_neg, norm_Esharp]
    -- conj z has im > 0 (since im z < 0, im(conj z) = -im z > 0)
    have h_conj_im : (starRingEnd ℂ z).im > 0 := by
      simp [Complex.conj_im]; linarith
    -- HB at conj z: ‖E(conj(conj z))‖ < ‖E(conj z)‖
    -- conj(conj z) = z, so ‖E(z)‖ < ‖E(conj z)‖
    have h_hb := H.hb_ineq (starRingEnd ℂ z) h_conj_im
    -- h_hb : ‖E(conj(conj z))‖ < ‖E(conj z)‖
    -- conj(conj z) = z
    simp only [starRingEnd_self_apply] at h_hb
    -- h_hb : ‖E z‖ < ‖E(conj z)‖
    -- But h_norm : ‖E z‖ = ‖E(conj z)‖
    -- Contradiction
    linarith
  · -- im z > 0: direct HB argument
    have h_eq := A_zero_implies_E_neg_Esharp H.E z hz
    have h_norm : ‖H.E z‖ = ‖H.E (starRingEnd ℂ z)‖ := by
      rw [h_eq, norm_neg, norm_Esharp]
    -- HB at z: ‖E(conj z)‖ < ‖E(z)‖
    have h_hb := H.hb_ineq z him_pos
    -- h_hb : ‖E(conj z)‖ < ‖E z‖
    -- h_norm : ‖E z‖ = ‖E(conj z)‖
    -- Contradiction: ‖E(conj z)‖ < ‖E z‖ = ‖E(conj z)‖
    linarith

end Riemann.Realization
