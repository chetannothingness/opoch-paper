/-
  OpochLean4/Control/RegimeSplit.lean (Step 13)

  Epistemic vs decision regimes.
  Epistemic: gathering information, fiber shrinks by evidence.
  Decision: committing to UNIQUE or OMEGA.
  The two regimes are disjoint. Transition occurs when the surviving
  set has ≤ 1 element or budget is exhausted.

  Dependencies: TruthQuotient, Entropy
  Assumptions: A0star only.
-/

import OpochLean4.Algebra.TruthQuotient
import OpochLean4.Algebra.Entropy

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Epistemic regime
-- ═══════════════════════════════════════════════════════════════

-- The epistemic regime: we are still gathering information.
-- Characterized by: surviving fiber size > 1 AND budget not exhausted.
-- survivingSize: the number of surviving truth classes (distinctions not yet ruled out)
-- budget: remaining budget
-- minCost: minimum cost of any single witness test

structure EpistemicState where
  survivingSize : Nat
  budget : Nat
  minCost : Nat
  minCost_pos : minCost ≥ 1

-- In the epistemic regime, there are multiple surviving candidates
-- AND enough budget to run at least one more test
def InEpistemicRegime (es : EpistemicState) : Prop :=
  es.survivingSize > 1 ∧ es.budget ≥ es.minCost

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Decision regime
-- ═══════════════════════════════════════════════════════════════

-- Terminal outcomes
inductive TerminalVerdict
  | unique   -- exactly one distinction survives
  | omega    -- budget exhausted with multiple survivors (operational nothingness)

-- In the decision regime, either we have narrowed to ≤ 1 survivor,
-- or the budget is exhausted
def InDecisionRegime (es : EpistemicState) : Prop :=
  es.survivingSize ≤ 1 ∨ es.budget < es.minCost

-- The verdict given a decision state
def decisionVerdict (es : EpistemicState) (hdec : InDecisionRegime es) :
    TerminalVerdict :=
  if es.survivingSize ≤ 1 then TerminalVerdict.unique
  else TerminalVerdict.omega

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: The two regimes are disjoint
-- ═══════════════════════════════════════════════════════════════

-- Cannot be in both epistemic and decision regime simultaneously
theorem regimes_disjoint (es : EpistemicState) :
    ¬(InEpistemicRegime es ∧ InDecisionRegime es) := by
  intro ⟨⟨hsize, hbudget⟩, hdec⟩
  cases hdec with
  | inl hle => omega
  | inr hlt => omega

-- Exactly one regime holds (excluded middle on the two conditions)
theorem regimes_exhaustive (es : EpistemicState) :
    InEpistemicRegime es ∨ InDecisionRegime es := by
  by_cases h1 : es.survivingSize ≤ 1
  · right; left; exact h1
  · by_cases h2 : es.budget < es.minCost
    · right; right; exact h2
    · left
      constructor
      · omega
      · omega

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Transition from epistemic to decision
-- ═══════════════════════════════════════════════════════════════

-- A refinement step in the epistemic regime produces a new state
-- with (weakly) smaller surviving size and (strictly) smaller budget
structure EpistemicStep where
  pre : EpistemicState
  post : EpistemicState
  pre_epistemic : InEpistemicRegime pre
  size_nonincreasing : post.survivingSize ≤ pre.survivingSize
  budget_decreasing : post.budget < pre.budget

-- Transition: after an epistemic step, if surviving size ≤ 1
-- or budget exhausted, we enter decision regime
theorem step_may_transition (step : EpistemicStep)
    (h : step.post.survivingSize ≤ 1 ∨ step.post.budget < step.post.minCost) :
    InDecisionRegime step.post :=
  h

-- Transition when surviving set has exactly 1 element
theorem transition_unique (es : EpistemicState) (h : es.survivingSize ≤ 1) :
    InDecisionRegime es :=
  Or.inl h

-- Transition when budget exhausted
theorem transition_budget_exhausted (es : EpistemicState)
    (h : es.budget < es.minCost) :
    InDecisionRegime es :=
  Or.inr h

-- Budget strictly decreasing means termination is guaranteed:
-- after at most `budget` steps, budget reaches 0 which forces decision regime.
theorem budget_zero_forces_decision (es : EpistemicState)
    (h : es.budget = 0) : InDecisionRegime es := by
  right
  have := es.minCost_pos
  omega

-- A single epistemic step strictly reduces the budget
theorem step_reduces_budget (step : EpistemicStep) :
    step.post.budget < step.pre.budget :=
  step.budget_decreasing

-- If no more tests can be run, we are in decision regime
theorem no_tests_implies_decision (es : EpistemicState)
    (h : ¬InEpistemicRegime es) : InDecisionRegime es := by
  cases regimes_exhaustive es with
  | inl hep => exact absurd hep h
  | inr hdec => exact hdec
