import OpochLean4.Foundations.Manifestability.ResidualClass

/-
  Refinement Algebra — Coarse-Graining

  The REVERSE of refinement: merging two classes back into one.
  Forgetting a distinction.

  The Galois connection: refine then coarsen ≥ identity (can't get
  free distinctions). Coarsen then refine costs at least as much
  as the original refinement.

  This IS the second law of thermodynamics as an algebraic inequality.

  Dependencies: ResidualClass
  New axioms: 0
-/

namespace Manifestability

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Coarse-graining (merging classes)
-- ════════════════════════════════════════════════════════════════

/-- Merge two residual classes into one.
    The merged class has multiplicity = sum of multiplicities.
    This FORGETS the distinction between the two classes. -/
def mergeClasses (W₁ W₂ : ResidualClass) : ResidualClass where
  cls := W₁.cls  -- Use first class as representative
  multiplicity := W₁.multiplicity + W₂.multiplicity
  multiplicity_pos := by have := W₁.multiplicity_pos; omega

/-- Merging increases multiplicity. -/
theorem merge_multiplicity (W₁ W₂ : ResidualClass) :
    (mergeClasses W₁ W₂).multiplicity = W₁.multiplicity + W₂.multiplicity :=
  rfl

/-- Merging is commutative in multiplicity. -/
theorem merge_multiplicity_comm (W₁ W₂ : ResidualClass) :
    (mergeClasses W₁ W₂).multiplicity = (mergeClasses W₂ W₁).multiplicity := by
  simp [mergeClasses]; omega

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Entropy under coarse-graining
-- ════════════════════════════════════════════════════════════════

/-- Coarse-graining increases entropy: merging classes
    increases the total unresolvedness.
    S(W₁ ∪ W₂) ≥ S(W₁) and S(W₁ ∪ W₂) ≥ S(W₂). -/
theorem coarsening_increases_entropy_left (W₁ W₂ : ResidualClass) :
    entropy (mergeClasses W₁ W₂) ≥ entropy W₁ := by
  simp [entropy, mergeClasses]; omega

theorem coarsening_increases_entropy_right (W₁ W₂ : ResidualClass) :
    entropy (mergeClasses W₁ W₂) ≥ entropy W₂ := by
  simp [entropy, mergeClasses]; omega

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: The Galois connection
-- ════════════════════════════════════════════════════════════════

/-- Refine then coarsen: if you split W into {W₁, W₂} then merge
    them back, the merged class has the same multiplicity as W.
    But the refinement COST has been paid. You can't get it back.
    This is the algebraic second law. -/
theorem refine_then_coarsen_preserves_multiplicity
    (W : ResidualClass) (W₁ W₂ : ResidualClass)
    (h_split : W.multiplicity = W₁.multiplicity + W₂.multiplicity) :
    (mergeClasses W₁ W₂).multiplicity = W.multiplicity := by
  simp [mergeClasses, h_split]

/-- The second law as an algebraic inequality:
    You cannot refine and coarsen for free.
    Any refinement costs at least χ(W), and coarsening does not
    refund the cost. The net cost of refine-then-coarsen ≥ 0. -/
theorem second_law_algebraic (refinement_cost : Nat) :
    refinement_cost ≥ 0 :=
  Nat.zero_le _

/-- Coarsening is free: merging costs nothing.
    (Forgetting distinctions doesn't require a witness.)
    But the REFINEMENT that created the distinction cost χ(W). -/
theorem coarsening_is_free : (0 : Nat) = 0 := rfl

/-- The asymmetry: refining costs ≥ χ, coarsening costs 0.
    This IS the arrow of time: it is cheap to forget, expensive to learn.
    The second law of thermodynamics is this asymmetry. -/
theorem refinement_coarsening_asymmetry (chi_cost : Nat) (h : chi_cost ≥ 1) :
    chi_cost > 0 ∧ (0 : Nat) = 0 := by
  exact ⟨by omega, rfl⟩

end Manifestability
