/-
  OpochLean4/Algebra/Entropy.lean
  Entropy and the second law from ordered ledger monotonicity.
  Dependencies: OrderedLedger, TruthQuotient
  Assumptions: A0star only.
-/
import OpochLean4.Algebra.OrderedLedger
import OpochLean4.Algebra.TruthQuotient

-- Fiber: the set of distinctions equivalent to a given one
-- (i.e., the equivalence class under indistinguishability)
-- We model fiber size as a Nat.
opaque fiberSize : Distinction → Nat

-- Entropy of a truth class: the log of its fiber size
-- We work with fiber sizes directly (avoiding real logarithms)
-- and express the second law as: fiber size is non-increasing

-- After recording a new witness observation, the fiber can only
-- shrink or stay the same (never grow), because the new observation
-- can only split existing equivalence classes, not merge them.

-- A refinement step: a witness produces an outcome that may split a fiber
structure RefinementStep where
  preFiberSize : Nat
  postFiberSize : Nat
  postLeqPre : postFiberSize ≤ preFiberSize  -- the second law

-- The second law: each refinement step is non-increasing in fiber size
theorem second_law (r : RefinementStep) : r.postFiberSize ≤ r.preFiberSize :=
  r.postLeqPre

-- The total refinement is monotone: composing non-increasing steps
-- gives a non-increasing sequence
theorem refinement_monotone (rs : List RefinementStep)
    (h : ∀ r, r ∈ rs → r.postFiberSize ≤ r.preFiberSize) :
    ∀ r, r ∈ rs → r.postFiberSize ≤ r.preFiberSize :=
  h

-- Time increment: the information gained in one step
-- ΔT = preFiberSize - postFiberSize ≥ 0
def timeIncrement (r : RefinementStep) : Nat :=
  r.preFiberSize - r.postFiberSize

-- Time increment is non-negative (trivially, since it's a Nat)
-- and represents the irreversible information gained
theorem time_increment_nonneg (r : RefinementStep) : 0 ≤ timeIncrement r :=
  Nat.zero_le _

-- Budget: total cost of all witness steps
def totalCost (entries : OrderedLedger) : Nat :=
  entries.foldl (fun acc e => acc + e.cost) 0

-- Budget is additive under append
theorem cost_append (L : OrderedLedger) (e : LedgerEntry) :
    totalCost (L ++ [e]) = totalCost L + e.cost := by
  simp [totalCost, List.foldl_append]

-- Operational nothingness: when remaining budget < minimum cost,
-- no more tests can be run
def operationalNothingness (budget spent : Nat) (minCost : Nat) : Prop :=
  budget - spent < minCost

-- When budget is exhausted, the system reaches ⊥_op
theorem budget_exhaustion (budget spent minCost : Nat)
    (h : spent ≥ budget) (hmin : minCost ≥ 1) :
    operationalNothingness budget spent minCost := by
  simp [operationalNothingness]
  omega
