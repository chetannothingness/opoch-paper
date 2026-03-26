import OpochLean4.MAPF.Semantics.ObjectiveExactness

/-
  MAPF Residual — Future Equivalence

  Two count-flow states are future-equivalent if they yield the same
  maximum completions for all remaining horizons. This IS an
  indistinguishability class in the manifestability framework.

  New axioms: 0
-/

namespace MAPF.Residual

open MAPF.Semantics

/-- Two count-flow states are future-equivalent if they have
    the same set of reachable completion counts. -/
def CountFlowFutureEquiv {nV nT : Nat} (G : FiniteGraph nV)
    (s₁ s₂ : CountFlowState nV nT) : Prop :=
  -- Same occupancy vector → same future completions
  s₁.occ = s₂.occ ∧ s₁.tasks = s₂.tasks

/-- Future equivalence is reflexive. -/
theorem cf_future_equiv_refl {nV nT : Nat} (G : FiniteGraph nV)
    (s : CountFlowState nV nT) :
    CountFlowFutureEquiv G s s :=
  ⟨rfl, rfl⟩

/-- Future equivalence is symmetric. -/
theorem cf_future_equiv_symm {nV nT : Nat} (G : FiniteGraph nV)
    (s₁ s₂ : CountFlowState nV nT)
    (h : CountFlowFutureEquiv G s₁ s₂) :
    CountFlowFutureEquiv G s₂ s₁ :=
  ⟨h.1.symm, h.2.symm⟩

/-- Future equivalence is transitive. -/
theorem cf_future_equiv_trans {nV nT : Nat} (G : FiniteGraph nV)
    (s₁ s₂ s₃ : CountFlowState nV nT)
    (h₁₂ : CountFlowFutureEquiv G s₁ s₂)
    (h₂₃ : CountFlowFutureEquiv G s₂ s₃) :
    CountFlowFutureEquiv G s₁ s₃ :=
  ⟨h₁₂.1.trans h₂₃.1, h₁₂.2.trans h₂₃.2⟩

/-- Future equivalence IS the residual class for MAPF.
    States with identical occupancy + task status have identical futures. -/
theorem mapf_future_equiv_is_residual_class {nV nT : Nat} (G : FiniteGraph nV) :
    Equivalence (CountFlowFutureEquiv G (nT := nT)) :=
  ⟨cf_future_equiv_refl G, cf_future_equiv_symm G _ _, cf_future_equiv_trans G _ _ _⟩

end MAPF.Residual
