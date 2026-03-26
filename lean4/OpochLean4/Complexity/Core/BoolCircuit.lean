import OpochLean4.Complexity.Core.Defs

/-
  Boolean Circuit Model

  A concrete computation model: Boolean gates with AND, OR, NOT.
  Every gate is finite, every evaluation is deterministic.
  This is the standard model for Cook-Levin.

  Dependencies: Defs (for CNF, Literal, Clause)
  New axioms: 0
-/

namespace Complexity

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Gate (Boolean Circuit)
-- ════════════════════════════════════════════════════════════════

/-- A Boolean circuit gate. Inputs are indexed by Nat.
    The circuit is a tree of AND/OR/NOT gates over input variables. -/
inductive Gate where
  | input : Nat → Gate
  | const : Bool → Gate
  | not : Gate → Gate
  | and : Gate → Gate → Gate
  | or : Gate → Gate → Gate
deriving Repr

/-- Evaluate a gate on an assignment of input variables. -/
def Gate.eval : Gate → (Nat → Bool) → Bool
  | .input i, σ => σ i
  | .const b, _ => b
  | .not g, σ => !g.eval σ
  | .and g₁ g₂, σ => g₁.eval σ && g₂.eval σ
  | .or g₁ g₂, σ => g₁.eval σ || g₂.eval σ

/-- Size of a circuit (number of gates). -/
def Gate.size : Gate → Nat
  | .input _ => 1
  | .const _ => 1
  | .not g => 1 + g.size
  | .and g₁ g₂ => 1 + g₁.size + g₂.size
  | .or g₁ g₂ => 1 + g₁.size + g₂.size

/-- Number of input variables referenced. -/
def Gate.maxVar : Gate → Nat
  | .input i => i + 1
  | .const _ => 0
  | .not g => g.maxVar
  | .and g₁ g₂ => max g₁.maxVar g₂.maxVar
  | .or g₁ g₂ => max g₁.maxVar g₂.maxVar

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Basic properties
-- ════════════════════════════════════════════════════════════════

/-- Size is always ≥ 1. -/
theorem Gate.size_pos (g : Gate) : g.size ≥ 1 := by
  cases g <;> simp [Gate.size] <;> omega

/-- Evaluation is deterministic: same gate, same assignment → same result. -/
theorem Gate.eval_deterministic (g : Gate) (σ : Nat → Bool) :
    g.eval σ = g.eval σ := rfl

/-- const true always evaluates to true. -/
theorem Gate.eval_const_true (σ : Nat → Bool) :
    (Gate.const true).eval σ = true := rfl

/-- const false always evaluates to false. -/
theorem Gate.eval_const_false (σ : Nat → Bool) :
    (Gate.const false).eval σ = false := rfl

/-- NOT inverts. -/
theorem Gate.eval_not (g : Gate) (σ : Nat → Bool) :
    (Gate.not g).eval σ = !(g.eval σ) := rfl

/-- AND is conjunction. -/
theorem Gate.eval_and (g₁ g₂ : Gate) (σ : Nat → Bool) :
    (Gate.and g₁ g₂).eval σ = (g₁.eval σ && g₂.eval σ) := rfl

/-- OR is disjunction. -/
theorem Gate.eval_or (g₁ g₂ : Gate) (σ : Nat → Bool) :
    (Gate.or g₁ g₂).eval σ = (g₁.eval σ || g₂.eval σ) := rfl

end Complexity
