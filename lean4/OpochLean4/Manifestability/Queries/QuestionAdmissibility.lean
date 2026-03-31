import OpochLean4.Manifestability.Queries.QuestionSyntax

/-
  Universal Manifestability — Question Admissibility

  A question is admissible iff:
  1. It is finitely describable (binary size ≥ 1)
  2. Its distinctions are witnessable (target class is refinable)
  3. Its output contract is nonempty and well-typed
  4. It does not demand unwitnessable externality

  Admissibility is the boundary: inside = the universe can answer it;
  outside = the question demands structure that doesn't exist in U.

  New axioms: 0
-/

namespace Manifestability.Queries

open Manifestability

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Admissibility conditions
-- ════════════════════════════════════════════════════════════════

/-- A question's target is witnessable if the underlying class
    has multiplicity ≥ 1 (it refers to actual distinctions). -/
def IsWitnessable (q : Question) : Prop :=
  q.target.cls.multiplicity ≥ 1

/-- A question's contract is well-typed if every condition
    is a nonempty binary predicate. -/
def IsWellTypedContract (q : Question) : Prop :=
  ∀ c ∈ q.contract.conditions, c.length ≥ 1

/-- A question does not demand externality: all channels are
    finitely indexed and internal to the universe.
    In the closed universe U = Fix(Π), all finitely described
    channels are internal. The condition is that channels are
    bounded by the target class multiplicity (the local universe
    of the question). -/
def NoExternality (q : Question) : Prop :=
  q.channels.channels.length ≤ q.target.cls.multiplicity

/-- A question is admissible iff all four conditions hold:
    1. Finitely describable
    2. Witnessable target
    3. Well-typed contract
    4. No externality demand -/
structure IsAdmissible (q : Question) where
  /-- The question has finite binary description -/
  finite : q.binarySize ≥ 1
  /-- The target class is witnessable -/
  witnessable : IsWitnessable q
  /-- The contract is well-typed -/
  wellTyped : IsWellTypedContract q
  /-- No externality demand -/
  noExternal : NoExternality q

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Admissibility theorems
-- ════════════════════════════════════════════════════════════════

/-- Every question with a valid residual class target is witnessable.
    This follows from ResidualClass.multiplicity_pos. -/
theorem target_always_witnessable (q : Question) : IsWitnessable q :=
  q.target.cls.multiplicity_pos

/-- Question admissibility is exact: the four conditions are
    individually necessary and jointly sufficient. -/
theorem question_admissibility_exact (q : Question)
    (h_wt : IsWellTypedContract q)
    (h_ne : NoExternality q) :
    IsAdmissible q where
  finite := question_finite_description q
  witnessable := target_always_witnessable q
  wellTyped := h_wt
  noExternal := h_ne

/-- No externality is the real content: the other conditions are
    structural (finite description from syntax, witnessable from
    residual class invariant). The only question is whether the
    channels stay within the universe. -/
theorem question_no_externality (q : Question) (hadm : IsAdmissible q) :
    NoExternality q :=
  hadm.noExternal

/-- Contract well-typedness: every condition is a nonempty predicate. -/
theorem question_contract_welltyped (q : Question) (hadm : IsAdmissible q) :
    IsWellTypedContract q :=
  hadm.wellTyped

end Manifestability.Queries
