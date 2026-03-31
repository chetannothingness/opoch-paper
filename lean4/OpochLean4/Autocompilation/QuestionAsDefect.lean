import OpochLean4.Autocompilation.LocalDefect
import OpochLean4.Manifestability.Queries.QuestionAdmissibility

/-
  Endogenous Autocompilation — Question as Local Defect

  Every admissible question corresponds to an admissible local defect.
  The question is not primitive — it is the external name for a local
  gap in the present support that closure demands to fill.

  Once this is proved, "question" becomes a derived concept.
  The fundamental object is the defect.

  New axioms: 0
-/

namespace Autocompilation

open Manifestability
open Manifestability.Queries

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Question → Defect correspondence
-- ════════════════════════════════════════════════════════════════

/-- Convert an admissible question to a local defect.
    The question's target class IS the unresolved defect.
    The question's binary size determines the defect cost. -/
def questionToDefect (q : Question) (_hadm : IsAdmissible q) : LocalDefect where
  unresolved := [q.target.cls]
  nonempty := by simp
  totalCost := q.target.cls.multiplicity
  cost_pos := q.target.cls.multiplicity_pos

/-- Every admissible question corresponds to an admissible local defect. -/
theorem question_as_local_defect_exact (q : Question) (hadm : IsAdmissible q) :
    IsAdmissibleDefect (questionToDefect q hadm) := by
  constructor
  · simp [questionToDefect]
  · intro rc hrc
    simp [questionToDefect] at hrc
    rw [hrc]
    exact q.target.cls.multiplicity_pos

/-- The defect induced by a question has the same target class. -/
theorem question_defect_target (q : Question) (hadm : IsAdmissible q) :
    (questionToDefect q hadm).unresolved = [q.target.cls] :=
  rfl

/-- The defect size is 1 (one question = one unresolved class). -/
theorem question_defect_size (q : Question) (hadm : IsAdmissible q) :
    (questionToDefect q hadm).size = 1 :=
  rfl

/-- Purification descends: purified question gives the same defect class. -/
theorem purification_descends_to_defect (q : Question) (hadm : IsAdmissible q)
    (hadm' : IsAdmissible q.purify) :
    (questionToDefect q.purify hadm').unresolved =
    (questionToDefect q hadm).unresolved := by
  simp [questionToDefect, Question.purify]

end Autocompilation
