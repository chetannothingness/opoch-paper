import Arc3Instant.ObservationHistory.History

/-
  ARC-AGI-3 -- Game Semantics

  The exact semantic structure that each game realizes.

  Every public ARC-AGI-3 game is a finite deterministic system with:
  - A state type (position × phase × inventory × constraints)
  - An action type (the legal moves)
  - A step function T_a : State → State (deterministic transition)
  - A solved predicate (the win condition)
  - Tension atoms χ₁(x),...,χₙ(x) (the unresolved constraints)
  - Weights ρ₁,...,ρₙ (importance of each constraint)

  The energy is: U(x) = Σ ρᵢ · χᵢ(x)
  The release of action a is: Δₐ U(x) = U(x) - U(T_a(x))
  The chosen action is: a* = argmax Δₐ U(x)

  This is not a heuristic. This is the exact source code of the game
  read as a self-reading graph point.

  New axioms: 0
-/

namespace Arc3Instant

-- ================================================================
-- Game Semantic Structure
-- ================================================================

/-- The exact semantic structure of an ARC-AGI-3 game.

    Every public game must be instantiated to this structure.
    The structure captures the complete mathematical content:
    state space, transitions, energy, release law. -/
structure GameSem where
  /-- The semantic state type. -/
  State : Type
  /-- The semantic action type. -/
  Action : Type
  /-- Parse the observation history into the semantic state. -/
  parseHistory : ObsHistory → State
  /-- The legal actions at a given state. -/
  legal : State → List Action
  /-- Legal actions are nonempty. -/
  legal_nonempty : ∀ x : State, (legal x).length ≥ 1
  /-- The deterministic transition function. T_a(x). -/
  step : State → Action → State
  /-- The solved predicate (win condition). -/
  solved : State → Prop
  /-- Solved is decidable. -/
  solved_dec : ∀ x : State, Decidable (solved x)
  /-- Number of tension atoms. -/
  atomCount : Nat
  /-- Tension atoms: χᵢ(x) ∈ ℕ for each atom i. -/
  tension : State → Fin atomCount → Nat
  /-- Weights: ρᵢ for each atom i. -/
  weight : Fin atomCount → Nat

-- ================================================================
-- Energy functional
-- ================================================================

/-- Sum weighted tensions for indices 0..n-1. -/
def sumWeightedTensions (G : GameSem) (x : G.State) : Nat → Nat
  | 0 => 0
  | n + 1 =>
    if h : n < G.atomCount then
      G.weight ⟨n, h⟩ * G.tension x ⟨n, h⟩ + sumWeightedTensions G x n
    else
      sumWeightedTensions G x n

/-- The latent energy of a state: U(x) = Σ ρᵢ · χᵢ(x).
    This is the exact ARC-sector energy, not stepsRemaining. -/
def energy (G : GameSem) (x : G.State) : Nat :=
  sumWeightedTensions G x G.atomCount

/-- The release of an action: Δₐ U(x) = U(x) - U(T_a(x)).
    Positive release means the action reduces energy.
    This uses saturating subtraction (Nat). -/
def release (G : GameSem) (x : G.State) (a : G.Action) : Nat :=
  energy G x - energy G (G.step x a)

-- ================================================================
-- Action choice: argmax release
-- ================================================================

/-- Find the action with maximum release among a list of candidates.
    Canonical tie-break: first in list order. -/
def argmaxRelease (G : GameSem) (x : G.State) : List G.Action → Option (G.Action × Nat)
  | [] => none
  | [a] => some (a, release G x a)
  | a :: rest =>
    match argmaxRelease G x rest with
    | none => some (a, release G x a)
    | some (best, bestRel) =>
      let rel := release G x a
      if rel ≥ bestRel then some (a, rel) else some (best, bestRel)

/-- Choose the action with maximum release.
    This IS the source code readout: a* = argmax Δₐ U(x). -/
def chooseAction (G : GameSem) (x : G.State) : Option G.Action :=
  match argmaxRelease G x (G.legal x) with
  | some (a, _) => some a
  | none => none

-- ================================================================
-- Core theorems
-- ================================================================

/-- Energy is nonnegative (trivial on Nat). -/
theorem energy_nonneg (G : GameSem) (x : G.State) :
    energy G x ≥ 0 :=
  Nat.zero_le _

/-- Release is well-defined for every legal action. -/
theorem release_exists (G : GameSem) (x : G.State) (a : G.Action) :
    ∃ r : Nat, r = release G x a :=
  ⟨release G x a, rfl⟩

/-- argmaxRelease returns Some on nonempty lists. -/
theorem argmaxRelease_nonempty (G : GameSem) (x : G.State)
    (a : G.Action) (rest : List G.Action) :
    ∃ best rel, argmaxRelease G x (a :: rest) = some (best, rel) := by
  induction rest with
  | nil => exact ⟨a, release G x a, rfl⟩
  | cons b rest ih =>
    simp [argmaxRelease]
    match argmaxRelease G x (b :: rest) with
    | none => exact ⟨a, release G x a, by simp [argmaxRelease]⟩
    | some (best, bestRel) =>
      if h : release G x a ≥ bestRel then
        exact ⟨a, release G x a, by simp [argmaxRelease, h]⟩
      else
        exact ⟨best, bestRel, by simp [argmaxRelease, h]⟩

/-- chooseAction returns Some when legal actions are nonempty. -/
theorem chooseAction_exists (G : GameSem) (x : G.State)
    (h : (G.legal x).length ≥ 1) :
    ∃ a : G.Action, chooseAction G x = some a := by
  simp [chooseAction]
  match G.legal x, h with
  | a :: rest, _ =>
    obtain ⟨best, rel, hbr⟩ := argmaxRelease_nonempty G x a rest
    rw [hbr]
    exact ⟨best, rfl⟩

end Arc3Instant
