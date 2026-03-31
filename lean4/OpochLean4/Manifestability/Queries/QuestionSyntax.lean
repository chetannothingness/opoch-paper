import OpochLean4.Foundations.Manifestability.RootBridge
import OpochLean4.Foundations.RefinementAlgebra.RefinementAlgebra

/-
  Universal Manifestability — Question Syntax

  Questions are FIRST-CLASS KERNEL OBJECTS, not informal strings.
  A question is a finite coded contract over distinctions:
    - query target (what class of distinctions is being asked about)
    - output kind (what form the answer takes)
    - contract (what conditions the answer must satisfy)
    - allowed channels (which witness modalities are permitted)
    - value ordering (optional preference over answers)

  This is the syntax layer. Admissibility is separate.

  New axioms: 0
-/

namespace Manifestability.Queries

open Manifestability
open RefinementAlgebra

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Question components
-- ════════════════════════════════════════════════════════════════

/-- A query target: the region of the truth quotient being asked about.
    Specified as a residual class (unresolved equivalence class of distinctions). -/
structure QueryTarget where
  /-- The unresolved class being queried -/
  cls : ResidualClass
  /-- Binary description of the target -/
  description : List Bool
  /-- Description is nonempty -/
  description_nonempty : description.length ≥ 1

/-- Output kind: what form the answer takes. -/
inductive OutputKind where
  /-- Boolean: yes/no (truth query) -/
  | boolean : OutputKind
  /-- Witness: produce a separating witness -/
  | witness : OutputKind
  /-- Value: compute a numerical value -/
  | value : OutputKind
  /-- Class: identify an equivalence class -/
  | classId : OutputKind
  /-- Sequence: produce an action sequence -/
  | sequence : OutputKind
  /-- NormalForm: produce canonical binary form -/
  | normalForm : OutputKind
  deriving DecidableEq

/-- A contract: conditions the answer must satisfy.
    Encoded as a list of binary predicates on the answer. -/
structure AnswerContract where
  /-- Binary encoding of the contract conditions -/
  conditions : List (List Bool)
  /-- At least one condition (nonempty contract) -/
  nonempty : conditions.length ≥ 1

/-- Channel restriction: which witness modalities are permitted. -/
structure ChannelRestriction where
  /-- Permitted channel identifiers -/
  channels : List Nat
  /-- At least one channel (otherwise question is trivially unanswerable) -/
  nonempty : channels.length ≥ 1

/-- Value ordering: optional preference over answers (for optimization queries). -/
structure ValueOrdering where
  /-- Whether an ordering is specified -/
  hasOrdering : Bool
  /-- If specified, the ordering criterion (binary-encoded) -/
  criterion : List Bool

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Question structure
-- ════════════════════════════════════════════════════════════════

/-- A Question is a finite coded contract over the binary carrier.
    It specifies WHAT is being asked, WHAT form the answer takes,
    WHAT conditions it must satisfy, and THROUGH which channels.

    This is a first-class kernel object, not an informal string.
    Every question is a finite binary object in the same universe
    it asks about. -/
structure Question where
  /-- What region of distinctions is being queried -/
  target : QueryTarget
  /-- What form the answer should take -/
  outputKind : OutputKind
  /-- What conditions the answer must satisfy -/
  contract : AnswerContract
  /-- Which witness channels are permitted -/
  channels : ChannelRestriction
  /-- Optional value ordering for optimization -/
  ordering : ValueOrdering

/-- Total binary size of a question: the finite description length. -/
def Question.binarySize (q : Question) : Nat :=
  q.target.description.length +
  q.contract.conditions.foldl (fun acc c => acc + c.length) 0 +
  q.channels.channels.length +
  q.ordering.criterion.length + 1

/-- Every question has finite binary size ≥ 1. -/
theorem question_finite_description (q : Question) :
    q.binarySize ≥ 1 := by
  simp only [Question.binarySize]
  have := q.target.description_nonempty
  omega

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: Question equality and canonical form
-- ════════════════════════════════════════════════════════════════

/-- Two questions are syntactically equal if all components match. -/
def Question.syntacticEq (q₁ q₂ : Question) : Prop :=
  q₁.target.description = q₂.target.description ∧
  q₁.outputKind = q₂.outputKind ∧
  q₁.contract.conditions = q₂.contract.conditions ∧
  q₁.channels.channels = q₂.channels.channels ∧
  q₁.ordering.criterion = q₂.ordering.criterion

/-- Syntactic equality is reflexive. -/
theorem syntacticEq_refl (q : Question) : q.syntacticEq q :=
  ⟨rfl, rfl, rfl, rfl, rfl⟩

/-- Syntactic equality is symmetric. -/
theorem syntacticEq_symm (q₁ q₂ : Question) (h : q₁.syntacticEq q₂) :
    q₂.syntacticEq q₁ :=
  ⟨h.1.symm, h.2.1.symm, h.2.2.1.symm, h.2.2.2.1.symm, h.2.2.2.2.symm⟩

/-- Syntactic equality is transitive. -/
theorem syntacticEq_trans (q₁ q₂ q₃ : Question)
    (h₁₂ : q₁.syntacticEq q₂) (h₂₃ : q₂.syntacticEq q₃) :
    q₁.syntacticEq q₃ :=
  ⟨h₁₂.1.trans h₂₃.1, h₁₂.2.1.trans h₂₃.2.1,
   h₁₂.2.2.1.trans h₂₃.2.2.1, h₁₂.2.2.2.1.trans h₂₃.2.2.2.1,
   h₁₂.2.2.2.2.trans h₂₃.2.2.2.2⟩

end Manifestability.Queries
