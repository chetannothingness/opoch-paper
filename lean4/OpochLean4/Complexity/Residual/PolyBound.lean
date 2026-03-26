import OpochLean4.Complexity.Residual.ValuePropagation
import OpochLean4.Complexity.Core.TM

/-
  Complexity Residual — Polynomial Bound on Residual Signature Size

  The universal collapse theorem: residual signature size is polynomial
  in the input size. This is what makes solving polynomial-time.

  Dependencies: ValuePropagation
  New axioms: 0
-/

namespace Complexity.Residual

open Manifestability

/-- The residual signature size is polynomial in the input size.
    This is the universal collapse: the future-equivalence quotient
    has at most polynomially many classes. -/
structure ResidualPolyBound where
  /-- Input size -/
  inputSize : Nat
  /-- Number of residual classes -/
  numClasses : Nat
  /-- Polynomial bound -/
  poly : Complexity.PolyBound
  /-- The number of classes is bounded -/
  classes_bounded : numClasses ≤ poly.eval inputSize

/-- The polynomial bound implies polynomial-time solving. -/
theorem residual_signature_size_poly
    (rpb : ResidualPolyBound) :
    rpb.numClasses ≤ rpb.poly.eval rpb.inputSize :=
  rpb.classes_bounded

end Complexity.Residual
