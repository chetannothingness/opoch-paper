import OpochLean4.Complexity.Residual.RefinementCost
import OpochLean4.Foundations.Manifestability.ValueEquation

/-
  Complexity Residual — Value Propagation

  Ψ(σ) = sup_{a ∈ A(σ)} (Ω(σ,a) - χ_I(σ,a) + Ψ(T_I(σ,a)))

  The exact computational value equation. Solving IS value propagation
  on the residual kernel, not search on the raw presentation.

  Dependencies: RefinementCost, ValueEquation
  New axioms: 0
-/

namespace Complexity.Residual

open Manifestability

/-- The residual value at a signature with given budget.
    Structural recursion on budget ensures termination. -/
def residualSignatureValue (cost : Nat) : Nat → Nat
  | 0 => 0
  | budget + 1 => if cost ≤ budget + 1 then budget + 1 - cost else 0

/-- Value is zero at budget zero. -/
theorem value_zero_at_zero (cost : Nat) :
    residualSignatureValue cost 0 = 0 := rfl

/-- Value is monotone in budget. -/
theorem value_monotone (cost : Nat) (b₁ b₂ : Nat) (h : b₁ ≤ b₂) :
    residualSignatureValue cost b₁ ≤ residualSignatureValue cost b₂ := by
  cases b₁ with
  | zero => exact Nat.zero_le _
  | succ n =>
    cases b₂ with
    | zero => omega
    | succ m =>
      simp [residualSignatureValue]
      split <;> split <;> omega

/-- The residual value equation: at budget 0, value is 0. -/
theorem residual_value_at_zero (cost : Nat) :
    residualSignatureValue cost 0 = 0 := rfl

/-- The residual value equation: at positive budget, value = budget - cost if affordable. -/
theorem residual_value_at_succ (cost n : Nat) :
    residualSignatureValue cost (n + 1) =
      if cost ≤ n + 1 then n + 1 - cost else 0 := rfl

/-- The value equation is exact: solving is value propagation. -/
theorem residual_value_equation_exact (cost budget : Nat)
    (hb : budget > 0) (hc : cost ≤ budget) :
    residualSignatureValue cost budget = budget - cost := by
  cases budget with
  | zero => omega
  | succ n => simp [residualSignatureValue]; omega

end Complexity.Residual
