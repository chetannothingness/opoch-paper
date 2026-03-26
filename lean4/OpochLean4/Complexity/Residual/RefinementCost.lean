import OpochLean4.Complexity.Residual.Signature
import OpochLean4.Foundations.Manifestability.RefinementThreshold

/-
  Complexity Residual — Refinement Cost χ_I(σ,a)

  The exact refinement cost for transitioning residual verifier
  state σ by action a. This is the complexity-side mirror of
  RefinementThreshold.lean.

  Dependencies: Signature, RefinementThreshold
  New axioms: 0
-/

namespace Complexity.Residual

open Manifestability

/-- The refinement cost χ_I(σ,a) for a residual signature σ and action a.
    This is the cost of refining the verifier's state by one step. -/
structure ResidualRefinementCost where
  signature : ResidualSignature
  action : Bool
  cost : Nat
  cost_pos : cost ≥ 1

/-- The total refinement cost for a sequence of actions. -/
def totalRefinementCost (costs : List ResidualRefinementCost) : Nat :=
  (costs.map ResidualRefinementCost.cost).foldl (· + ·) 0

/-- Each action costs at least 1. -/
theorem action_cost_pos (c : ResidualRefinementCost) : c.cost ≥ 1 :=
  c.cost_pos

end Complexity.Residual
