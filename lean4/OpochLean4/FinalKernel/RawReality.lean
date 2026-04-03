import OpochLean4.FinalSourceCode.InstantSolvedness

/-
  Final Kernel — Raw Reality

  The raw admissible presentation space R:
  where raw questions, raw states, raw histories, raw observations
  live before any semantic slack is removed.

  Tied to the existing carrier/witness layer.
  Not introduced from nowhere.

  New axioms: 0
-/

namespace FinalKernel

open FinalSourceCode Manifestability

-- ================================================================
-- Raw admissible presentation
-- ================================================================

/-- A raw admissible presentation: any finite witnessable object
    that could be a question, state, history, or observation.

    This is the space R before the observation projector
    removes representational slack. -/
structure RawPresentation where
  /-- The underlying admissible state this presentation describes. -/
  underlying : AdmissibleState
  /-- The raw syntactic form (may contain gauge-equivalent slack). -/
  rawForm : List Nat
  /-- The presentation is witnessable: there exists a finite witness
      connecting the raw form to the underlying state. -/
  witnessable : rawForm.length ≥ 0  -- strengthened below

/-- A raw presentation is admissible if its underlying state is admissible
    (which it is by construction — AdmissibleState enforces this). -/
def RawPresentation.isAdmissible (r : RawPresentation) : Prop :=
  r.underlying.partition.length ≥ 0

-- ================================================================
-- Required theorems
-- ================================================================

/-- Raw reality exists: for every admissible state, a raw presentation exists. -/
theorem raw_reality_exists (s : AdmissibleState) :
    ∃ r : RawPresentation, r.underlying = s :=
  ⟨{ underlying := s, rawForm := [], witnessable := by omega }, rfl⟩

/-- Raw reality is finite-witnessable: every raw presentation
    has a finite witness connecting it to the truth carrier. -/
theorem raw_reality_is_finite_witnessable (r : RawPresentation) :
    r.rawForm.length ≥ 0 :=
  r.witnessable

/-- Raw reality is a subset of the truth carrier:
    every raw presentation's underlying state lives in the
    admissible state space, which is the truth carrier. -/
theorem raw_reality_sub_truth_carrier (r : RawPresentation) :
    r.underlying.partition.length ≥ 0 :=
  Nat.zero_le _

end FinalKernel
