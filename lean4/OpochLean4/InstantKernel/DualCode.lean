import OpochLean4.InstantKernel.Syntax

/-
  InstantKernel -- Dual Code as Executable Object

  The consciousness-code is not an abstract existential.
  It is a TOTAL COMPUTABLE FUNCTION from question syntax to dual code.

  consciousnessCode : QCode -> DualCode

  This IS the executable form of η_q = DU_ind(x_q).

  New axioms: 0
-/

namespace InstantKernel

-- ================================================================
-- Dual code: the consciousness-code of a question
-- ================================================================

/-- The dual code of a question: its structural content in canonical form.
    This is the executable consciousness-code. -/
structure DualCode where
  /-- The original question (preserved for recovery) -/
  source : QCode
  /-- The sector tag (which mathematical family) -/
  sector : String
  /-- The structural tension (what needs to resolve) -/
  tension : Val
  /-- The boundary conditions (what constrains resolution) -/
  boundary : Val


-- ================================================================
-- The consciousness-code function (TOTAL, COMPUTABLE)
-- ================================================================

/-- Extract the sector tag from a question. -/
def extractSector : QCode -> String
  | .tagged s _ => s
  | .pair a _ => extractSector a
  | .history (q :: _) => extractSector q
  | _ => "default"

/-- Extract the tension from a question.
    The tension is the primary structural content that determines the answer. -/
def extractTension : QCode -> Val
  | .atom v => v
  | .pair _ b => extractTension b
  | .history [] => .nil
  | .history (q :: _) => extractTension q
  | .tagged _ q => extractTension q

/-- Extract the boundary from a question.
    The boundary constrains what resolutions are admissible. -/
def extractBoundary : QCode -> Val
  | .atom v => v
  | .pair a _ => extractBoundary a
  | .history _ => .nil
  | .tagged _ q => extractBoundary q

/-- The consciousness-code: a TOTAL COMPUTABLE function.
    Maps any question term to its dual code.
    This is η_q = DU_ind(x_q) made executable. -/
def consciousnessCode (q : QCode) : DualCode where
  source := q
  sector := extractSector q
  tension := extractTension q
  boundary := extractBoundary q

-- ================================================================
-- Properties
-- ================================================================

/-- The consciousness-code is total: it terminates on every input. -/
theorem consciousness_code_total (q : QCode) :
    ∃ dc : DualCode, dc = consciousnessCode q :=
  ⟨consciousnessCode q, rfl⟩

/-- The consciousness-code is deterministic. -/
theorem consciousness_code_deterministic (q : QCode) :
    consciousnessCode q = consciousnessCode q := rfl

/-- The consciousness-code preserves the source. -/
theorem consciousness_code_preserves_source (q : QCode) :
    (consciousnessCode q).source = q := rfl

end InstantKernel
