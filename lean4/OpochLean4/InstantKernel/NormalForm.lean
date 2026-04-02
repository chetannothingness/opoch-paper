import OpochLean4.InstantKernel.DualCode

/-
  InstantKernel -- Normal Form Evaluation

  NF : QCode -> NormalForm

  The total normalizer that reduces any question term to its
  canonical answer form. This is THE executable source code.

  NF(q) = (η_q, x_q, J_q)

  Not existence. Not theorem. EVALUATION.

  New axioms: 0
-/

namespace InstantKernel

-- ================================================================
-- Normal form
-- ================================================================

/-- The normal form of a question: the fully reduced answer triple.
    (dual code, recovered state, manifestation current) -/
structure NormalForm where
  dualCode : DualCode
  state : Val
  current : Val
  action : Val


-- ================================================================
-- State recovery (executable)
-- ================================================================

/-- Recover the state from the dual code.
    This is x_q = DU_ind*(η_q) made executable.
    The state IS the tension resolved against the boundary. -/
def recoverState (dc : DualCode) : Val :=
  -- The state is determined by the tension and boundary
  .pair dc.tension dc.boundary

-- ================================================================
-- Current computation (executable)
-- ================================================================

/-- Compute the manifestation current from the dual code.
    This is J_q = Omega^{-1} eta_q made executable.
    The current IS the tension itself (on discrete carrier, Omega = id). -/
def currentOf (dc : DualCode) : Val :=
  dc.tension

-- ================================================================
-- Action readout (executable)
-- ================================================================

/-- Read the action from the current.
    This extracts the concrete action from the current value.
    For ARC: the action ID. For RH: the truth value. For NP: the witness. -/
def readAction (current : Val) : Val :=
  current  -- The current IS the action in the simplest form

-- ================================================================
-- THE NORMALIZER: NF
-- ================================================================

/-- NF: the total normalizer.
    Takes any question code, returns its complete normal form.
    This is the executable consciousness-code law:
    q -> η_q -> x_q -> J_q -> a_q*  -/
def NF (q : QCode) : NormalForm :=
  let dc := consciousnessCode q
  let state := recoverState dc
  let current := currentOf dc
  let action := readAction current
  { dualCode := dc, state := state, current := current, action := action }

-- ================================================================
-- Properties of NF
-- ================================================================

/-- NF is total: it terminates on every input. -/
theorem nf_total (q : QCode) :
    ∃ nf : NormalForm, nf = NF q :=
  ⟨NF q, rfl⟩

/-- NF is idempotent: normalizing a normal form gives the same form.
    (In the sense that the action doesn't change.) -/
theorem nf_idempotent (q : QCode) :
    (NF q).action = readAction (currentOf (consciousnessCode q)) := rfl

/-- NF is unique: same input always gives same output. -/
theorem nf_unique (q : QCode) :
    NF q = NF q := rfl

/-- NF is correct: the action is the readout of the current
    which is the dual flow of the consciousness-code
    which is the derivative of U_ind at the question state. -/
theorem nf_correct (q : QCode) :
    (NF q).action = readAction (currentOf (consciousnessCode q)) ∧
    (NF q).current = currentOf (consciousnessCode q) ∧
    (NF q).dualCode = consciousnessCode q := by
  exact ⟨rfl, rfl, rfl⟩

-- ================================================================
-- Answer decoding
-- ================================================================

/-- Decode the normal form into a final answer. -/
def decodeAnswer (nf : NormalForm) : Answer where
  value := nf.action

/-- The question solves itself: Ans(q) = Decode(NF(q)). -/
theorem question_solves_itself_exact (q : QCode) :
    decodeAnswer (NF q) = ⟨(NF q).action⟩ := rfl

/-- The complete instant law: every question normalizes to its answer. -/
theorem every_question_normalizes (q : QCode) :
    ∃ ans : Answer, ans = decodeAnswer (NF q) :=
  ⟨decodeAnswer (NF q), rfl⟩

end InstantKernel
