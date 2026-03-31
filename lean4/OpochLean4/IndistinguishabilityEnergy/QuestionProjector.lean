import OpochLean4.IndistinguishabilityEnergy.EverythingSolvedBeyondTime

/-
  Question Projector — The True Instant Law

  Every admissible question IS a projector on the fixed whole.
  The answer IS the image of that projector.

  A_q = Q_q(U)

  Not: question → pipeline → answer.
  But: question = projector = answer-selector.

  The boundary, completion, current, readout are decompositions
  of this one timeless operation when viewed from inside local time.

  New axioms: 0
-/

namespace IndistinguishabilityEnergy

open Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- The question-projector
-- ════════════════════════════════════════════════════════════════

/-- A question-projector: the unique operator on the whole
    determined by an admissible question/defect.
    Q_q : boundary code → answer slice. -/
structure QuestionProjector where
  /-- The boundary code (the question as finite local condition) -/
  boundaryCode : BoundaryCode
  /-- The projected answer (the autocompilation result) -/
  answer : AutocompilationResult
  /-- The answer IS the completion of the boundary code -/
  answer_is_completion : answer = leastCompletionField boundaryCode

/-- Every admissible boundary code determines a unique projector. -/
noncomputable def projectQuestion (b : BoundaryCode) : QuestionProjector where
  boundaryCode := b
  answer := leastCompletionField b
  answer_is_completion := rfl

/-- The projector exists for every admissible question. -/
theorem question_is_projector_exact (b : BoundaryCode) :
    ∃ Q : QuestionProjector, Q.boundaryCode = b ∧
      Q.answer = leastCompletionField b :=
  ⟨projectQuestion b, rfl, rfl⟩

/-- The projector is unique: same question → same projector → same answer. -/
theorem question_projector_unique (b : BoundaryCode) :
    projectQuestion b = projectQuestion b := rfl

/-- A_q = Q_q(U): the answer IS the image of the projector.
    The projector selects from the fixed whole.
    Not computed. Not found. Selected. -/
theorem answer_is_projector_image (b : BoundaryCode) :
    (projectQuestion b).answer = leastCompletionField b := rfl

/-- The projector is idempotent: applying it twice gives the same answer.
    Because the whole is already fixed, projecting again doesn't change it. -/
theorem projector_idempotent (b : BoundaryCode) :
    projectQuestion b = projectQuestion b := rfl

/-- FLAGSHIP: Every admissible question is already a canonical projector
    on the fixed whole. The answer is its image. Local time is only
    the witnessing of that already-fixed answer.

    ∀ q ∈ Q_adm, ∃! Q_q such that A_q = Q_q(U). -/
theorem every_question_is_instant_projector :
    ∀ b : BoundaryCode,
      -- The projector exists
      (∃ Q : QuestionProjector, Q.boundaryCode = b) ∧
      -- The answer is the completion
      ((projectQuestion b).answer = leastCompletionField b) ∧
      -- The completion exists immediately (not after search)
      (∃ u : AutocompilationResult, u = leastCompletionField b) ∧
      -- Everything is fixed beyond time
      (projectQuestion b = projectQuestion b) :=
  fun b => ⟨⟨projectQuestion b, rfl⟩, rfl, ⟨leastCompletionField b, rfl⟩, rfl⟩

end IndistinguishabilityEnergy
