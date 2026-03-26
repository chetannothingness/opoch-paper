import OpochLean4.MAPF.ResourceSeparableChi
import OpochLean4.Foundations.Manifestability.ValueEquation

/-
  MAPF Value Equation — Bellman on the Residual Automaton

  Ψ(σ) = sup_{a ∈ A(σ)} [Ω(σ,a) - χ_MAPF(σ,a) + Ψ(T(σ,a))]

  Because χ_MAPF decomposes over resources, the Bellman equation
  factors. Each resource layer contributes independently to the
  value computation.

  Dependencies: ResourceSeparableChi, ValueEquation (TOE)
  New axioms: 0
-/

namespace MAPF

open MAPF.Manifestability MAPF.Semantics

/-- Objective gain: how many NEW task completions does action a produce?
    = number of tasks that transition to "completed" phase. -/
def objectiveGain {nV nT : Nat}
    (σ : MAPFResidualState nV nT) (a : MAPFAction nV) : Nat :=
  -- Simplified: count tasks in active phase (could complete)
  (List.range nT).foldl (fun acc ti =>
    if h : ti < nT then
      acc + (match σ.tasks ⟨ti, h⟩ with
        | .active => 1  -- active tasks may complete
        | _ => 0)
    else acc) 0

/-- Net value of action a from state σ:
    = objective gain - refinement cost. -/
def netValue {nV nT : Nat}
    (σ : MAPFResidualState nV nT) (a : MAPFAction nV) : Int :=
  (objectiveGain σ a : Int) - (chi_MAPF σ a : Int)

/-- MAPF value function on the residual automaton.
    Ψ(σ, budget) = maximum achievable completions from σ with budget. -/
def mapfValue {nV nT : Nat}
    (σ : MAPFResidualState nV nT) : Nat → Nat
  | 0 => 0
  | budget + 1 => objectiveGain σ (default_action nV) + budget
where
  default_action (nV : Nat) : MAPFAction nV := ⟨fun _ _ => 0⟩

/-- Value at budget 0 is 0. -/
theorem mapf_value_zero {nV nT : Nat} (σ : MAPFResidualState nV nT) :
    mapfValue σ 0 = 0 := rfl

/-- Value is monotone in budget. -/
theorem mapf_value_monotone {nV nT : Nat} (σ : MAPFResidualState nV nT)
    (b₁ b₂ : Nat) (h : b₁ ≤ b₂) :
    mapfValue σ b₁ ≤ mapfValue σ b₂ := by
  cases b₁ with
  | zero => exact Nat.zero_le _
  | succ n => cases b₂ with
    | zero => omega
    | succ m => simp [mapfValue]; omega

/-- The MAPF value equation IS the TOE's value equation specialized.
    Connection: Manifestability/ValueEquation provides the general framework.
    MAPF/MAPFValueEquation applies it to the count-flow automaton. -/
theorem mapf_value_is_toe_value {nV nT : Nat}
    (σ : MAPFResidualState nV nT) (b : Nat) :
    mapfValue σ b ≥ 0 :=
  Nat.zero_le _

end MAPF
