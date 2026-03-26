import OpochLean4.Foundations.Manifestability.RefinementThreshold

/-
  Complexity Core — Turing Machine / Computation Model

  Step-counted computation where steps ARE χ-costs.
  A computation step is a refinement of the verifier's residual state.

  Dependencies: Manifestability/RefinementThreshold
  New axioms: 0
-/

namespace Complexity

open Manifestability

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Step-counted computation
-- ════════════════════════════════════════════════════════════════

/-- A computation model: finite state machine with step costs.
    Each step is a refinement event on the state space. -/
structure ComputationModel (nStates : Nat) where
  transition : Fin nStates → Bool → Fin nStates
  accept : Fin nStates → Bool
  stepCost : Fin nStates → Nat
  stepCost_pos : ∀ s, stepCost s ≥ 1

/-- A computation trace: sequence of states visited. -/
structure ComputationTrace (nStates : Nat) where
  states : List (Fin nStates)
  input : List Bool
  states_nonempty : states.length ≥ 1

/-- Total cost of a computation trace. -/
def traceCost {nStates : Nat} (cm : ComputationModel nStates)
    (trace : ComputationTrace nStates) : Nat :=
  (trace.states.map cm.stepCost).foldl (· + ·) 0

/-- A computation accepts if the final state is accepting. -/
def traceAccepts {nStates : Nat} (cm : ComputationModel nStates)
    (trace : ComputationTrace nStates) : Bool :=
  match trace.states.getLast? with
  | some s => cm.accept s
  | none => false

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Polynomial bound
-- ════════════════════════════════════════════════════════════════

/-- A polynomial bound: a function p with p(n) ≤ c·n^d + c. -/
structure PolyBound where
  coeff : Nat
  degree : Nat
  eval : Nat → Nat
  bound : ∀ n, eval n ≤ coeff * n ^ degree + coeff

/-- A computation runs in polynomial time if its cost on inputs
    of size n is bounded by p(n) for some polynomial p. -/
def RunsInPolyTime {nStates : Nat} (cm : ComputationModel nStates)
    (p : PolyBound) : Prop :=
  ∀ (trace : ComputationTrace nStates),
    traceCost cm trace ≤ p.eval trace.input.length

end Complexity
