import OpochLean4.Complexity.Core.NP

/-
  Complexity Core — Polytime Reductions

  Dependencies: NP
  New axioms: 0
-/

namespace Complexity

/-- A polytime reduction from L₁ to L₂. -/
structure PolyReduction (L₁ L₂ : Language) where
  reduce : List Bool → List Bool
  poly_size : PolyBound
  output_bound : ∀ input, (reduce input).length ≤ poly_size.eval input.length
  correct : ∀ input, L₁.member input ↔ L₂.member (reduce input)

/-- Reductions preserve membership (forward). -/
theorem reduction_forward {L₁ L₂ : Language}
    (r : PolyReduction L₁ L₂) (input : List Bool)
    (h : L₁.member input) : L₂.member (r.reduce input) :=
  (r.correct input).mp h

/-- Reductions preserve membership (backward). -/
theorem reduction_backward {L₁ L₂ : Language}
    (r : PolyReduction L₁ L₂) (input : List Bool)
    (h : L₂.member (r.reduce input)) : L₁.member input :=
  (r.correct input).mpr h

end Complexity
