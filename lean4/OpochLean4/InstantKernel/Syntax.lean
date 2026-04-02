/-
  InstantKernel -- Finite Syntax for Admissible Questions

  The final source code is not complete until every admissible question
  term reduces by a total normalizer to its unique dual/state/current
  answer form inside the kernel itself.

  New axioms: 0
-/

namespace InstantKernel

-- ================================================================
-- Concrete finite syntax for questions
-- ================================================================

/-- A finite value: the atomic data in any question. -/
inductive Val where
  | nat : Nat -> Val
  | bool : Bool -> Val
  | pair : Val -> Val -> Val
  | nil : Val

/-- A question code: a finite syntactic term that can be normalized. -/
inductive QCode where
  | atom : Val -> QCode
  | pair : QCode -> QCode -> QCode
  | history : List QCode -> QCode
  | tagged : String -> QCode -> QCode

-- ================================================================
-- Answers
-- ================================================================

/-- An answer: the result of normalizing a question. -/
structure Answer where
  value : Val

end InstantKernel
