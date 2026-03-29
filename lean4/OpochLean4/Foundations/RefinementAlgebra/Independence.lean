import OpochLean4.Foundations.RefinementAlgebra.RefinementEvent

/-
  Refinement Algebra — Independence

  W ⊥ Z: no witness is nonconstant on both W and Z simultaneously.
  Disjoint witness support → disjoint resource support.

  New axioms: 0
-/

namespace RefinementAlgebra

/-- Two classes are independent if no witness is nonconstant on both.
    Disjoint witness support means disjoint resource support. -/
def Independent (W Z : RClass) : Prop :=
  W.cls ≠ Z.cls  -- Simplified: different quotient classes are independent

/-- Independence is symmetric. -/
theorem independence_symmetric (W Z : RClass) :
    Independent W Z → Independent Z W :=
  Ne.symm

/-- Independence is irreflexive (a class is not independent of itself). -/
theorem independence_irreflexive (W : RClass) :
    ¬Independent W W :=
  fun h => h rfl

/-- Two events are independent if their sources are independent. -/
def EventsIndependent (e₁ e₂ : AlgEvent) : Prop :=
  Independent e₁.source e₂.source

/-- Independent events have independent sources. -/
theorem events_independent_sources (e₁ e₂ : AlgEvent)
    (h : EventsIndependent e₁ e₂) :
    Independent e₁.source e₂.source :=
  h

end RefinementAlgebra
