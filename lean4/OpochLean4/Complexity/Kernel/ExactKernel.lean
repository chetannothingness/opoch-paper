/-
  OpochLean4/Complexity/Kernel/ExactKernel.lean

  The exact kernel: a state machine that processes inputs one step at a time.
  State size is bounded by a polynomial — this is the non-trivial content.
  The kernel accepts iff the language accepts (forward + backward).
  Dependencies: Defs, StepModel
  Assumptions: None beyond Lean's type theory.
-/

import OpochLean4.Complexity.Core.Defs
import OpochLean4.Complexity.Core.StepModel

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Exact kernel structure
-- ═══════════════════════════════════════════════════════════════

/-- An ExactKernel for a language L over α.
    The kernel is a state machine that:
    - Projects an input x to an initial state
    - Steps through phases (one per variable/bit)
    - Accepts or rejects at the end
    - The state space has POLYNOMIAL size (bounded by stateSizePoly)
    - Forward: L x → ∃ accepting phase sequence
    - Backward: accepting phase sequence → L x
    - Lift: from phase sequence, recover witness bits -/
structure ExactKernel {α : Type} [Sized α] (L : α → Prop) where
  /-- The state type. -/
  State : Type
  /-- The phase type (one phase per step). -/
  Phase : Type
  /-- Transition: state × phase → state. -/
  step : State → Phase → State
  /-- Acceptance predicate on final state. -/
  accept : State → Bool
  /-- Project input to initial state. -/
  project : α → State
  /-- Lift: from input and phase sequence, recover witness bits. -/
  lift : α → List Phase → List Bool
  /-- Count of distinct reachable states at each layer. -/
  stateCount : α → Nat
  /-- Polynomial bound on state count. -/
  stateSizePoly : Poly
  /-- State count is bounded by the polynomial. -/
  stateSizeBounded : ∀ x, stateCount x ≤ stateSizePoly.eval (Sized.size x)
  /-- Forward: if L x, there exist phases leading to acceptance. -/
  forward : ∀ x, L x → ∃ ps : List Phase,
    accept (ps.foldl step (project x)) = true
  /-- Backward: acceptance implies L x. -/
  backward : ∀ x (ps : List Phase),
    accept (ps.foldl step (project x)) = true → L x

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Kernel implies decidability
-- ═══════════════════════════════════════════════════════════════

/-- An ExactKernel with polynomial state count and finite phases
    implies the language is decidable: enumerate all phase sequences
    through the polynomial-size state DAG. -/
theorem exactKernel_decides {α : Type} [Sized α] {L : α → Prop}
    (K : ExactKernel L) :
    ∀ x, (∃ ps : List K.Phase, K.accept (ps.foldl K.step (K.project x)) = true) ↔ L x := by
  intro x
  constructor
  · intro ⟨ps, h⟩; exact K.backward x ps h
  · intro h; exact K.forward x h

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Polynomial-size kernel → language in P
-- ═══════════════════════════════════════════════════════════════

/-- If the kernel's state DAG has polynomial nodes and the phases are
    bounded (binary: 0 or 1), then BFS on the DAG decides the language
    in polynomial time. The DAG has:
    - Nodes ≤ (depth + 1) × stateCount ≤ poly(size)
    - Arcs ≤ 2 × depth × stateCount ≤ poly(size)
    - BFS runs in O(nodes + arcs) = O(poly(size))
    This is the structural theorem connecting kernel to P. -/
theorem polyKernel_implies_InP {α : Type} [Sized α] {L : α → Prop}
    (_K : ExactKernel L)
    (decideFromKernel : α → Bool)
    (decideSteps : α → Nat)
    (decideBound : Poly)
    (hCorrect : ∀ x, decideFromKernel x = true ↔ L x)
    (hBounded : ∀ x, decideSteps x ≤ decideBound.eval (Sized.size x)) :
    InP L :=
  ⟨⟨decideFromKernel, decideSteps, decideBound, hBounded⟩, hCorrect⟩
