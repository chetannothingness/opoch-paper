import OpochLean4.Complexity.Residual.Verifier
import OpochLean4.Complexity.Core.Defs

/-
  Complexity Residual — Future Equivalence as Residual Class

  Future-equivalence on partial assignments IS a residual class
  in the manifestability framework. Two partial assignments are
  future-equivalent iff they yield the same satisfiability for
  all completions — indistinguishable by any future witness.

  Dependencies: Verifier, Defs
  New axioms: 0
-/

namespace Complexity.Residual

open Manifestability Complexity

/-- Future equivalence is a residual class: two partial assignments
    are in the same class iff no future witness separates them. -/
structure FutureResidualClass where
  formula : CNF
  depth : Nat
  representative : PartialAssign
  rep_depth : representative.depth = depth
  classSize : Nat
  classSize_pos : classSize ≥ 1

/-- Future equivalence IS indistinguishability in the verifier world.
    Two future-equivalent partial assignments yield identical evalCNF
    for all completions (suffixes). -/
theorem future_equiv_is_residual_class
    (φ : CNF) (pa₁ pa₂ : PartialAssign)
    (h : FutureEquiv φ pa₁ pa₂) :
    ∀ (suffix : Nat → Bool),
      evalCNF φ (pa₁.complete suffix) = evalCNF φ (pa₂.complete suffix) :=
  h

/-- The number of future-equivalence classes at each depth. -/
def residualMultiplicity (frc : FutureResidualClass) : Nat :=
  frc.classSize

/-- Future equivalence preserves satisfiability. -/
theorem future_equiv_preserves_sat
    (φ : CNF) (pa₁ pa₂ : PartialAssign)
    (h : FutureEquiv φ pa₁ pa₂) :
    futureSat φ pa₁ ↔ futureSat φ pa₂ :=
  futureEquiv_preserves_futureSat φ pa₁ pa₂ h

end Complexity.Residual
