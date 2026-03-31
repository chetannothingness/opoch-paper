import OpochLean4.Manifestability.Queries.QuestionPurification

/-
  Universal Manifestability — Residual Address Map

  THE CENTRAL DEFINITION OF THE FINAL LAYER.

  Addr(q) = W_q : the exact unresolved class cut out by the purified
  question inside the static whole U = Fix(Π).

  The address map takes a purified admissible question and returns
  the exact region of the truth quotient that the question asks about.

  This is not a search. The universe is already solved globally.
  The address map simply locates WHERE in the solved whole the
  question's answer lives.

  Properties:
    - existence (every admissible question has an address)
    - uniqueness up to gauge (indistinguishable targets give same address)
    - compatibility with question type
    - functoriality under purification

  New axioms: 0
-/

namespace Manifestability.Addressing

open Manifestability
open Manifestability.Queries

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Residual Address
-- ════════════════════════════════════════════════════════════════

/-- The residual address of a question: the exact unresolved class
    that the question targets inside the static whole.

    This bundles:
    - the target class W_q (from the question's target)
    - the refinement threshold χ(W_q) if refinable
    - the question type (determines what kind of answer is needed) -/
structure ResidualAddress where
  /-- The unresolved class W_q -/
  targetClass : ResidualClass
  /-- The question type -/
  queryType : QuestionType
  /-- Binary description of the address -/
  code : List Bool
  /-- Code is nonempty -/
  code_nonempty : code.length ≥ 1

/-- The address map: extract the residual address from an admissible question.
    Addr(q) = (W_q, Type(q), description). -/
def addressOf (q : Question) : ResidualAddress where
  targetClass := q.target.cls
  queryType := q.intrinsicType
  code := q.target.description
  code_nonempty := q.target.description_nonempty

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Existence and uniqueness
-- ════════════════════════════════════════════════════════════════

/-- Every admissible question has a residual address. -/
theorem residual_address_exists (q : Question) (_hadm : IsAdmissible q) :
    ∃ addr : ResidualAddress, addr = addressOf q :=
  ⟨addressOf q, rfl⟩

/-- Two questions with the same target class get the same address class.
    This is uniqueness up to gauge: indistinguishable targets give
    gauge-equivalent addresses. -/
theorem residual_address_unique_up_to_gauge (q₁ q₂ : Question)
    (h_cls : q₁.target.cls = q₂.target.cls) :
    (addressOf q₁).targetClass = (addressOf q₂).targetClass := by
  simp [addressOf, h_cls]

/-- The question cut: the address class has multiplicity ≥ 1
    (it refers to real distinctions in the universe). -/
theorem question_cut_exact (q : Question) (_hadm : IsAdmissible q) :
    (addressOf q).targetClass.multiplicity ≥ 1 :=
  q.target.cls.multiplicity_pos

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: Functoriality under purification
-- ════════════════════════════════════════════════════════════════

/-- Addressing is functorial under purification:
    Addr(Pur(q)) has the same target class as Addr(q).
    This is because purification preserves the target. -/
theorem address_functorial_under_purification (q : Question) :
    (addressOf q.purify).targetClass = (addressOf q).targetClass := by
  simp [addressOf, Question.purify]

/-- The full functoriality: purification preserves the address class
    and the question type (so the full address is preserved modulo
    the type, which is also preserved). -/
theorem address_fully_preserved_under_purification (q : Question) :
    (addressOf q.purify).targetClass = (addressOf q).targetClass ∧
    (addressOf q.purify).queryType = (addressOf q).queryType := by
  constructor
  · simp [addressOf, Question.purify]
  · simp [addressOf]
    exact (question_type_preserved_under_purification q).symm

end Manifestability.Addressing
