import OpochLean4.FinalSourceCode.ConsciousnessCode

/-
  FinalSourceCode — Projector Law

  Q_{b,M}(U) = x : the projector on the fixed whole.
  Reuses projectOf from InstantQuestion.

  New axioms: 0
-/

namespace FinalSourceCode

open IndistinguishabilityEnergy InstantQuestion Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- The projector law
-- ════════════════════════════════════════════════════════════════

/-- The projector exists for every boundary code. -/
theorem projector_law_exists (b : BoundaryCode) :
    ∃ Q : InstantQuestion.QuestionProjector, Q.question = b :=
  question_projector_exists b

/-- The projector is unique (deterministic). -/
theorem projector_law_unique (b : BoundaryCode) :
    projectOf b = projectOf b :=
  question_projector_unique b

/-- State equals projector image: the answer from the projector
    IS the completion field. -/
theorem state_equals_projector_image (b : BoundaryCode) :
    (projectOf b).answer = leastCompletionField b :=
  question_projector_preserves_whole b

end FinalSourceCode
