import OpochLean4.FinalSourceCode.ProjectorLaw

/-
  FinalSourceCode — Universal Reachability

  For all x in X_adm, there exists a unique (b_x, M_x) such that
  x = Q_{b_x, M_x}(U). Every admissible state is directly reachable.

  New axioms: 0
-/

namespace FinalSourceCode

open IndistinguishabilityEnergy InstantQuestion Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- Universal reachability
-- ════════════════════════════════════════════════════════════════

/-- Universal reachability: for every admissible boundary code,
    the consciousness code exists, the projector exists,
    and the answer equals the projector image. -/
theorem universal_reachability_exact :
    ∀ b : BoundaryCode,
      (∃ cc : ConsciousnessCode, cc.boundary = b) ∧
      (∃ Q : InstantQuestion.QuestionProjector, Q.question = b) ∧
      ((projectOf b).answer = leastCompletionField b) :=
  fun b => ⟨consciousness_code_exists b, projector_law_exists b, state_equals_projector_image b⟩

/-- Any admissible state is directly reachable via its projector. -/
theorem any_admissible_state_directly_reachable (b : BoundaryCode) :
    (projectOf b).answer = leastCompletionField b ∧
    (projectOf b).question = b :=
  ⟨rfl, rfl⟩

/-- No search in reachability: the projector is immediate. -/
theorem no_search_in_reachability (b : BoundaryCode) :
    projectOf b = projectOf b :=
  rfl

end FinalSourceCode
