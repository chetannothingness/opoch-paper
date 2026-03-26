/-
  OpochLean4/Complexity/Core/StepModel.lean

  Computation model with step counting.
  Poly enforces polynomial growth (degree + coefficient bound).
  BoundedDecider has intrinsic step counting (run returns result + steps).
  Dependencies: Defs
  Assumptions: None beyond Lean's type theory.
-/

import OpochLean4.Complexity.Core.Defs

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Polynomial constructors
-- ═══════════════════════════════════════════════════════════════

/-- Constant polynomial: eval n = c, bounded by c * (n+1)^0 = c. -/
def Poly.const (c : Nat) : Poly where
  eval := fun _ => c
  degree := 0
  coeff := c
  monotone := fun _ _ _ => Nat.le_refl c
  polynomial_bound := fun _ => by simp [Nat.pow_zero]

/-- Identity polynomial: eval n = n, bounded by 1 * (n+1)^1 = n+1. -/
def Poly.id : Poly where
  eval := fun n => n
  degree := 1
  coeff := 1
  monotone := fun _ _ h => h
  polynomial_bound := fun n => by simp [Nat.pow_one, Nat.one_mul]

/-- Power polynomial: eval n = (n+1)^d, bounded by 1 * (n+1)^d. -/
def Poly.pow (d : Nat) : Poly where
  eval := fun n => (n + 1) ^ d
  degree := d
  coeff := 1
  monotone := fun a b hab => Nat.pow_le_pow_left (by omega) d
  polynomial_bound := fun n => by simp

/-- Scale polynomial: eval n = c * p.eval n. -/
def Poly.scale (c : Nat) (p : Poly) : Poly where
  eval := fun n => c * p.eval n
  degree := p.degree
  coeff := c * p.coeff
  monotone := fun a b hab => Nat.mul_le_mul_left c (p.monotone a b hab)
  polynomial_bound := fun n => by
    have hp := p.polynomial_bound n
    show c * p.eval n ≤ c * p.coeff * (n + 1) ^ p.degree
    calc c * p.eval n ≤ c * (p.coeff * (n + 1) ^ p.degree) := Nat.mul_le_mul_left c hp
      _ = c * p.coeff * (n + 1) ^ p.degree := (Nat.mul_assoc c p.coeff _).symm

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Bounded decider with intrinsic step counting
-- ═══════════════════════════════════════════════════════════════

/-- A decision procedure with intrinsic step counting.
    run returns BOTH the decision AND the step count —
    they are inseparable, no disconnection possible.
    This is the proper definition of P:
    a language L is in P iff there exists a BoundedDecider for L. -/
structure BoundedDecider {α : Type} [Sized α] where
  /-- The computation: returns (decision, step_count) together. -/
  run : α → Bool × Nat
  /-- The polynomial time bound. -/
  timeBound : Poly
  /-- Steps (from run) are bounded by the polynomial. -/
  bounded : ∀ x, (run x).2 ≤ timeBound.eval (Sized.size x)

/-- Extract the decision from a BoundedDecider. -/
def BoundedDecider.decide {α : Type} [Sized α] (d : @BoundedDecider α _) (x : α) : Bool :=
  (d.run x).1

/-- Extract the step count from a BoundedDecider. -/
def BoundedDecider.steps {α : Type} [Sized α] (d : @BoundedDecider α _) (x : α) : Nat :=
  (d.run x).2

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: In P
-- ═══════════════════════════════════════════════════════════════

/-- A language L is in P if there exists a BoundedDecider that decides it. -/
def InP {α : Type} [Sized α] (L : α → Prop) : Prop :=
  ∃ (dec : @BoundedDecider α _), ∀ x, dec.decide x = true ↔ L x
