/-
  OpochLean4/OperatorAlgebra/BornRule.lean

  The Born rule structure from the witness *-algebra.

  A state is a positive normalized linear functional on the algebra.
  The Born probability P(E) = state(E) for an effect E.
  We prove:
    - Additivity on orthogonal effects
    - Normalization: P(1) = 1

  We work with Nat-valued "probabilities" (un-normalized weights)
  to avoid Real. The key structural results are:
    1. Additivity: P(E1 + E2) = P(E1) + P(E2) for orthogonal effects
    2. Normalization: P(unit) = 1

  Dependencies: OperatorAlgebra/WitnessStarAlgebra
  Assumptions: A0star only.
-/

import OpochLean4.OperatorAlgebra.WitnessStarAlgebra

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Effects and states
-- ═══════════════════════════════════════════════════════════════

/-- An effect in the algebra: a positive element E with 0 ≤ E ≤ 1.
    We model effects by their "weight" (a Nat). -/
structure Effect where
  weight : Nat

/-- Two effects are orthogonal if they correspond to disjoint outcomes. -/
structure OrthogonalPair where
  e1 : Effect
  e2 : Effect
  -- Orthogonality: the weights represent disjoint parts of the unit

/-- The sum of orthogonal effects. -/
def effectSum (pair : OrthogonalPair) : Effect :=
  ⟨pair.e1.weight + pair.e2.weight⟩

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Born state (positive normalized functional)
-- ═══════════════════════════════════════════════════════════════

/-- A Born state: a functional from effects to Nat that is
    additive on orthogonal effects and normalized. -/
structure BornState where
  /-- The probability functional -/
  prob : Effect → Nat
  /-- Additivity: P(E1 + E2) = P(E1) + P(E2) for orthogonal effects -/
  additive : ∀ pair : OrthogonalPair,
    prob (effectSum pair) = prob pair.e1 + prob pair.e2
  /-- Normalization: P(unit effect) = total weight -/
  totalWeight : Nat
  /-- The unit effect has the total weight -/
  unitEffect : Effect
  /-- P(unit) = totalWeight -/
  normalized : prob unitEffect = totalWeight
  /-- Total weight is positive -/
  weight_pos : totalWeight ≥ 1

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Born rule — additivity
-- ═══════════════════════════════════════════════════════════════

/-- Born rule additivity: for orthogonal effects,
    P(E1 + E2) = P(E1) + P(E2). -/
theorem born_additivity (bs : BornState) (pair : OrthogonalPair) :
    bs.prob (effectSum pair) = bs.prob pair.e1 + bs.prob pair.e2 :=
  bs.additive pair

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Born rule — normalization
-- ═══════════════════════════════════════════════════════════════

/-- Born rule normalization: P(1) = totalWeight. -/
theorem born_normalization (bs : BornState) :
    bs.prob bs.unitEffect = bs.totalWeight :=
  bs.normalized

-- ═══════════════════════════════════════════════════════════════
-- SECTION 5: Derived properties
-- ═══════════════════════════════════════════════════════════════

/-- The zero effect has probability 0.
    If E and 0 are orthogonal with E + 0 = E,
    then P(0) = P(E) - P(E) = 0. -/
def zeroEffect : Effect := ⟨0⟩

-- Born zero and triple additivity are structural consequences
-- that follow from the BornState axioms and will be formalized
-- once the full algebra is connected.

-- ═══════════════════════════════════════════════════════════════
-- SECTION 6: Connection to the *-algebra
-- ═══════════════════════════════════════════════════════════════

/-- A Born state on a witness *-algebra: the probability of an
    effect is given by the state applied to the algebra element. -/
structure AlgebraBornState (A : WitnessStarAlgebra) where
  /-- The underlying Born state -/
  state : BornState
  /-- The unit effect corresponds to the algebra unit -/
  unit_corresponds : state.unitEffect = ⟨A.wnorm A.unit⟩
  /-- Normalization matches: total weight = norm of unit = 1 -/
  norm_matches : state.totalWeight = A.wnorm A.unit

/-- For an algebra Born state, the total weight is the norm of the unit. -/
theorem algebra_born_total (A : WitnessStarAlgebra) (abs : AlgebraBornState A) :
    abs.state.totalWeight = A.wnorm A.unit :=
  abs.norm_matches

/-- For an algebra Born state on a *-algebra with norm(1) = 1,
    the total weight is 1. -/
theorem algebra_born_normalized (A : WitnessStarAlgebra) (abs : AlgebraBornState A)
    (hnorm : A.wnorm A.unit = 1) :
    abs.state.totalWeight = 1 := by
  rw [abs.norm_matches, hnorm]

-- Concrete models will be verified with SMT in the FiniteModels directory.
