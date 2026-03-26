import OpochLean4.Complexity.Core.TM

/-
  Complexity Core — P (Polynomial Time)

  P = the class of decision problems solvable in polynomial time.
  In the χ-framework: problems whose residual future-defect algebra
  admits polynomial-cost value propagation.

  Dependencies: TM
  New axioms: 0
-/

namespace Complexity

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Language / Decision problem
-- ════════════════════════════════════════════════════════════════

/-- A language: a decidable set of binary strings. -/
structure Language where
  member : List Bool → Prop

/-- An instance of a language: a specific input. -/
structure InstanceOf (L : Language) where
  input : List Bool
  size : Nat
  size_eq : size = input.length

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: P
-- ════════════════════════════════════════════════════════════════

/-- A language is in P if there exists a computation model and
    polynomial bound such that the model decides the language
    in polynomial time. -/
structure InP (L : Language) where
  nStates : Nat
  model : ComputationModel nStates
  poly : PolyBound
  polytime : RunsInPolyTime model poly
  decides : ∀ (input : List Bool),
    (∃ trace : ComputationTrace nStates,
      trace.input = input ∧
      (traceAccepts model trace = true ↔ L.member input))

end Complexity
