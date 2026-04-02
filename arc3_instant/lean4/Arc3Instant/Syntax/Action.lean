import Arc3Instant.Syntax.Observation

/-
  ARC-AGI-3 -- Action Syntax

  Actions: the legal moves at each step.
  Typically 4 directional (up/down/left/right) plus possible
  coordinate actions (ACTION6).

  The legal action set is explicitly exposed by the environment.

  New axioms: 0
-/

namespace Arc3Instant

-- ================================================================
-- Action types
-- ================================================================

/-- An action ID (the environment uses integers 1-6). -/
abbrev ActionId := Nat

/-- A coordinate action (ACTION6): specifies a grid position. -/
structure CoordinateAction where
  x : Nat
  y : Nat
  x_bound : x < 64
  y_bound : y < 64

/-- The full action type: either a simple action or a coordinate action. -/
inductive Action where
  | simple : ActionId → Action
  | coordinate : CoordinateAction → Action

/-- The legal action set exposed by the environment at time t. -/
structure LegalActionSet where
  actions : List ActionId
  actions_nonempty : actions.length ≥ 1

/-- An action is legal if it's in the legal set. -/
def IsLegalAction (a : Action) (L : LegalActionSet) : Prop :=
  match a with
  | Action.simple id => id ∈ L.actions
  | Action.coordinate _ => 6 ∈ L.actions

-- ================================================================
-- Properties
-- ================================================================

/-- Every legal action set has at least one action. -/
theorem legal_set_nonempty (L : LegalActionSet) : L.actions.length ≥ 1 :=
  L.actions_nonempty

end Arc3Instant
