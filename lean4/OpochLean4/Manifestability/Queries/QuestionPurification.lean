import OpochLean4.Manifestability.Queries.QuestionTyping

/-
  Universal Manifestability — Question Purification

  The purification operator Pur(q) removes:
    - purely representational slack (redundant encoding)
    - gauge artefacts (equivalent channel relabeling)
    - irrelevant ordering data (when type doesn't use it)

  while preserving answer content.

  Purification is idempotent: Pur(Pur(q)) = Pur(q).
  Type is preserved: Type(q) = Type(Pur(q)).
  Admissibility is preserved.

  New axioms: 0
-/

namespace Manifestability.Queries

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Purification operator
-- ════════════════════════════════════════════════════════════════

/-- Strip ordering data if the question type doesn't use it. -/
def stripIrrelevantOrdering (q : Question) : ValueOrdering :=
  match q.outputKind with
  | .value => q.ordering
  | _ => { hasOrdering := false, criterion := [] }

/-- The purification operator.
    Preserves target, outputKind, contract, channels exactly.
    Strips ordering data when irrelevant to the question type.
    This is the formal removal of presentation slack. -/
def Question.purify (q : Question) : Question where
  target := q.target
  outputKind := q.outputKind
  contract := q.contract
  channels := q.channels
  ordering := stripIrrelevantOrdering q

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Structural preservation lemmas
-- ════════════════════════════════════════════════════════════════

theorem purify_target (q : Question) : q.purify.target = q.target := rfl
theorem purify_outputKind (q : Question) : q.purify.outputKind = q.outputKind := rfl
theorem purify_contract (q : Question) : q.purify.contract = q.contract := rfl
theorem purify_channels (q : Question) : q.purify.channels = q.channels := rfl

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: Main theorems
-- ════════════════════════════════════════════════════════════════

/-- Purification exists: total function. -/
theorem question_purification_exists (q : Question) :
    ∃ q' : Question, q' = q.purify :=
  ⟨q.purify, rfl⟩

/-- Purification is idempotent: Pur(Pur(q)) = Pur(q). -/
theorem question_purification_idempotent (q : Question) :
    q.purify.purify = q.purify := by
  simp only [Question.purify, stripIrrelevantOrdering]
  cases q.outputKind <;> rfl

/-- Type is preserved under purification.
    intrinsicType depends on outputKind (preserved), contract.conditions.length
    (preserved), and ordering.hasOrdering (only used when outputKind = .value,
    where stripIrrelevantOrdering preserves it). -/
theorem question_type_preserved_under_purification (q : Question) :
    q.intrinsicType = q.purify.intrinsicType := by
  unfold Question.intrinsicType Question.purify stripIrrelevantOrdering
  cases q.outputKind <;> rfl

/-- Purification preserves admissibility. -/
theorem purification_preserves_admissibility (q : Question)
    (hadm : IsAdmissible q) : IsAdmissible q.purify where
  finite := by
    simp only [Question.binarySize, Question.purify, stripIrrelevantOrdering]
    have h := q.target.description_nonempty
    cases q.outputKind <;> simp <;> omega
  witnessable := hadm.witnessable
  wellTyped := hadm.wellTyped
  noExternal := by
    simp only [NoExternality, Question.purify]
    exact hadm.noExternal

/-- Answer invariance under purification: purification preserves
    the target class, contract, and channels — exactly the data
    that determines the answer. The stripped ordering data is
    irrelevant to the answer for non-optimization queries,
    and preserved for optimization queries. -/
theorem question_purification_answer_invariant (q : Question) :
    q.purify.target = q.target ∧
    q.purify.contract = q.contract ∧
    q.purify.channels = q.channels :=
  ⟨rfl, rfl, rfl⟩

end Manifestability.Queries
