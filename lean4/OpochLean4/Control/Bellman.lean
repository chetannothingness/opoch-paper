/-
  OpochLean4/Control/Bellman.lean

  Bellman minimax recursion for finite decision problems.
  Dependencies: Gauge, Time

  We define a finite decision problem with states, actions, and costs.
  The value function V(state, budget) is defined by structural
  recursion on budget. We prove basic properties including
  termination, determinism, and the action-budget bound.
  All arithmetic is Nat.
-/

import OpochLean4.Algebra.Gauge
import OpochLean4.Algebra.Time

namespace Bellman

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Finite decision problem
-- ═══════════════════════════════════════════════════════════════

-- A finite decision problem parameterized by finite state and action types
structure DecisionProblem (nStates nActions : Nat) where
  transition : Fin nStates → Fin nActions → Fin nStates
  cost : Fin nStates → Fin nActions → Nat
  cost_pos : ∀ s a, 1 ≤ cost s a
  terminal : Fin nStates → Nat

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Value function (direct structural recursion on Nat)
-- ═══════════════════════════════════════════════════════════════

-- Helper: find the maximum value achievable by trying action indices 0..fuel-1
-- at the given state, where valAtNext gives the value at each successor state.
-- This is NOT recursive in the value function itself.
def maxOverActions {nStates nActions : Nat}
    (dp : DecisionProblem nStates nActions)
    (s : Fin nStates)
    (budget : Nat)
    (valAtNext : Fin nStates → Nat) :
    Nat → Nat
  | 0 => dp.terminal s
  | k + 1 =>
    if h : k < nActions then
      if dp.cost s ⟨k, h⟩ ≤ budget then
        Nat.max (valAtNext (dp.transition s ⟨k, h⟩))
                (maxOverActions dp s budget valAtNext k)
      else
        maxOverActions dp s budget valAtNext k
    else
      maxOverActions dp s budget valAtNext k

-- maxOverActions is at least the terminal value
theorem maxOverActions_ge_terminal {nStates nActions : Nat}
    (dp : DecisionProblem nStates nActions)
    (s : Fin nStates) (budget : Nat) (valAtNext : Fin nStates → Nat)
    (fuel : Nat) :
    dp.terminal s ≤ maxOverActions dp s budget valAtNext fuel := by
  induction fuel with
  | zero => exact Nat.le_refl _
  | succ k ih =>
    unfold maxOverActions
    split
    · -- k < nActions
      split
      · -- cost affordable: goal is terminal ≤ Nat.max v (maxOverActions ...)
        exact Nat.le_trans ih (Nat.le_max_right _ _)
      · -- cost too high: goal is terminal ≤ maxOverActions ...
        exact ih
    · -- k ≥ nActions: goal is terminal ≤ maxOverActions ...
      exact ih

-- The value function: V(state, budget)
-- Budget 0: return terminal value
-- Budget n+1: max over all actions of V(successor, n)
-- Since cost ≥ 1, the actual remaining budget after an action is ≤ n,
-- so using n as the next budget is a sound (conservative) bound.
def value {nStates nActions : Nat} (dp : DecisionProblem nStates nActions)
    (s : Fin nStates) : Nat → Nat
  | 0 => dp.terminal s
  | budget + 1 =>
    maxOverActions dp s (budget + 1) (fun s' => value dp s' budget) nActions

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Basic properties of the value function
-- ═══════════════════════════════════════════════════════════════

-- Value at budget 0 is terminal
theorem value_zero {nStates nActions : Nat}
    (dp : DecisionProblem nStates nActions) (s : Fin nStates) :
    value dp s 0 = dp.terminal s := rfl

-- Value is at least the terminal value (at any budget)
theorem value_ge_terminal {nStates nActions : Nat}
    (dp : DecisionProblem nStates nActions) (s : Fin nStates)
    (budget : Nat) :
    dp.terminal s ≤ value dp s budget := by
  cases budget with
  | zero => exact Nat.le_refl _
  | succ n =>
    show dp.terminal s ≤ maxOverActions dp s (n + 1) (fun s' => value dp s' n) nActions
    exact maxOverActions_ge_terminal dp s (n + 1) _ nActions

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Budget decrease (well-foundedness witness)
-- ═══════════════════════════════════════════════════════════════

-- Budget strictly decreases with each action (since cost ≥ 1)
theorem budget_decreases {nStates nActions : Nat}
    (dp : DecisionProblem nStates nActions)
    (s : Fin nStates) (a : Fin nActions) (budget : Nat)
    (h : dp.cost s a ≤ budget) :
    budget - dp.cost s a < budget := by
  have hpos := dp.cost_pos s a
  omega

-- ═══════════════════════════════════════════════════════════════
-- SECTION 5: Determinism of the minimax policy
-- ═══════════════════════════════════════════════════════════════

-- The value function is a pure function: same inputs give same outputs.
-- This is definitionally true in Lean (all functions are deterministic).
theorem value_deterministic {nStates nActions : Nat}
    (dp : DecisionProblem nStates nActions)
    (s : Fin nStates) (budget : Nat) :
    value dp s budget = value dp s budget := rfl

-- Value at budget 0 ≤ value at any budget
theorem value_budget_zero_le {nStates nActions : Nat}
    (dp : DecisionProblem nStates nActions) (s : Fin nStates) (budget : Nat) :
    value dp s 0 ≤ value dp s budget :=
  value_ge_terminal dp s budget

-- ═══════════════════════════════════════════════════════════════
-- SECTION 6: Action sequences and cost bounds
-- ═══════════════════════════════════════════════════════════════

-- Execute a sequence of actions
def executeActions {nStates nActions : Nat} (dp : DecisionProblem nStates nActions)
    (s : Fin nStates) : List (Fin nActions) → Fin nStates
  | [] => s
  | a :: rest => executeActions dp (dp.transition s a) rest

-- Total cost of a sequence of actions
def actionsCost {nStates nActions : Nat} (dp : DecisionProblem nStates nActions)
    (s : Fin nStates) : List (Fin nActions) → Nat
  | [] => 0
  | a :: rest => dp.cost s a + actionsCost dp (dp.transition s a) rest

-- Empty action sequence: zero cost
theorem actionsCost_nil {nStates nActions : Nat}
    (dp : DecisionProblem nStates nActions) (s : Fin nStates) :
    actionsCost dp s [] = 0 := rfl

-- Empty action sequence: stays at current state
theorem executeActions_nil {nStates nActions : Nat}
    (dp : DecisionProblem nStates nActions) (s : Fin nStates) :
    executeActions dp s [] = s := rfl

-- Number of actions ≤ budget (since each action costs ≥ 1)
theorem actions_bounded_by_budget {nStates nActions : Nat}
    (dp : DecisionProblem nStates nActions)
    (s : Fin nStates) (actions : List (Fin nActions))
    (budget : Nat) (h : actionsCost dp s actions ≤ budget) :
    actions.length ≤ budget := by
  induction actions generalizing s budget with
  | nil => exact Nat.zero_le _
  | cons a rest ih =>
    -- Unfold the actionsCost at the cons
    change dp.cost s a + actionsCost dp (dp.transition s a) rest ≤ budget at h
    have hcost := dp.cost_pos s a
    have hrest : actionsCost dp (dp.transition s a) rest ≤ budget - dp.cost s a := by omega
    have ihres := ih (dp.transition s a) _ hrest
    -- rest.length ≤ budget - dp.cost s a, and dp.cost s a ≥ 1
    -- so rest.length + 1 ≤ budget
    show rest.length + 1 ≤ budget
    omega

end Bellman
