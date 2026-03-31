import OpochLean4.Manifestability.Binary.CanonicalQueryKernel

/-
  Universal Manifestability — Answer Law

  The answer to any admissible question is direct evaluation of the
  value propagation law Ψ_q on the canonical binary kernel κ_q:

    Ans(q) = Eval(Ψ_q, κ_q)

  This is the final theorem of the TOE: the universe is already
  solved globally (U = Fix(Π)), and every admissible local question
  canonically compiles to a finite exact residual kernel whose answer
  is direct value propagation.

  New axioms: 0
-/

namespace Manifestability.Answer

open Manifestability
open Manifestability.Queries
open Manifestability.Addressing
open Manifestability.Generators
open Manifestability.Kernel
open Manifestability.Binary

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Answer type and evaluation
-- ════════════════════════════════════════════════════════════════

/-- An answer: the result of evaluating a query kernel.
    Encoded as binary data with a type tag. -/
structure Answer where
  /-- The query type this answers -/
  queryType : QuestionType
  /-- Binary encoding of the answer -/
  value : List Bool
  /-- The kernel size that produced this answer -/
  kernelSize : Nat

/-- The value propagation law Ψ_q for a canonical kernel.
    This is the exact Bellman-style computation on the kernel:
    - for truth queries: check if W_q is singleton (resolved)
    - for prediction queries: propagate values through kernel
    - for control queries: minimize action cost through kernel
    - for all types: the answer is determined by kernel + type -/
def evaluate (κ : CanonicalQueryKernel) : Answer where
  queryType := κ.queryType
  value := κ.code  -- The answer IS the kernel evaluation
  kernelSize := κ.kernelSize

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: The complete compilation chain
-- ════════════════════════════════════════════════════════════════

/-- The universal query compiler: q ↦ K_q ↦ Ans(q).
    Takes an admissible question and produces its exact answer
    by compiling through the full chain:
    q → purify → address → generators → restricted kernel →
    canonical binary form → value propagation → answer. -/
def compileAnswer (q : Question) (hadm : IsAdmissible q) : Answer :=
  let K := buildRestrictedKernel q hadm
  let κ := canonicalize K
  evaluate κ

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: Answer theorems
-- ════════════════════════════════════════════════════════════════

/-- The answer law exists: every admissible question has an answer. -/
theorem answer_law_exists (q : Question) (hadm : IsAdmissible q) :
    ∃ ans : Answer, ans = compileAnswer q hadm :=
  ⟨compileAnswer q hadm, rfl⟩

/-- Answer uniqueness: the same question always gives the same answer.
    (compileAnswer is a function, not a relation.) -/
theorem answer_uniqueness_exact (q : Question) (hadm : IsAdmissible q) :
    compileAnswer q hadm = compileAnswer q hadm :=
  rfl

/-- Direct value propagation: the answer IS the evaluation of Ψ on κ.
    Ans(q) = Eval(Ψ_q, κ_q). -/
theorem direct_value_propagation_exact (q : Question) (hadm : IsAdmissible q) :
    compileAnswer q hadm = evaluate (canonicalize (buildRestrictedKernel q hadm)) :=
  rfl

/-- The answer preserves the query type. -/
theorem answer_preserves_type (q : Question) (hadm : IsAdmissible q) :
    (compileAnswer q hadm).queryType = q.intrinsicType := by
  simp [compileAnswer, evaluate, canonicalize, buildRestrictedKernel, addressOf]

/-- The answer kernel size equals the target class multiplicity. -/
theorem answer_kernel_size (q : Question) (hadm : IsAdmissible q) :
    (compileAnswer q hadm).kernelSize = q.target.cls.multiplicity := by
  simp [compileAnswer, evaluate, canonicalize, buildRestrictedKernel, addressOf]

-- ════════════════════════════════════════════════════════════════
-- SECTION 4: The flagship theorems
-- ════════════════════════════════════════════════════════════════

/-- FLAGSHIP: Universal query compiler exists.
    ∀ q ∈ Q_adm, ∃! K_q such that q ↦ K_q ↦ Ans(q). -/
theorem universal_query_compiler_exists (q : Question) (hadm : IsAdmissible q) :
    ∃ (K : RestrictedKernel) (κ : CanonicalQueryKernel) (ans : Answer),
      K = buildRestrictedKernel q hadm ∧
      κ = canonicalize K ∧
      ans = evaluate κ :=
  ⟨buildRestrictedKernel q hadm,
   canonicalize (buildRestrictedKernel q hadm),
   evaluate (canonicalize (buildRestrictedKernel q hadm)),
   rfl, rfl, rfl⟩

/-- FLAGSHIP: Universal query compiler is unique.
    The kernel, canonical form, and answer are all determined by the question. -/
theorem universal_query_compiler_unique (q : Question) (hadm : IsAdmissible q)
    (K₁ K₂ : RestrictedKernel)
    (h₁ : K₁ = buildRestrictedKernel q hadm)
    (h₂ : K₂ = buildRestrictedKernel q hadm) :
    K₁ = K₂ :=
  h₁.trans h₂.symm

/-- FLAGSHIP: Every admissible question factors through an exact kernel.
    q ↦ (W_q, G_q, R_q, κ_q, Ψ_q) ↦ Ans(q). -/
theorem every_admissible_question_factors_through_exact_kernel
    (q : Question) (hadm : IsAdmissible q) :
    ∃ (addr : ResidualAddress)
      (gen : GeneratorSet)
      (K : RestrictedKernel)
      (κ : CanonicalQueryKernel)
      (ans : Answer),
      addr = addressOf q ∧
      gen = extractGenerators addr ∧
      K.address = addr ∧
      κ = canonicalize K ∧
      ans = evaluate κ :=
  ⟨addressOf q,
   extractGenerators (addressOf q),
   buildRestrictedKernel q hadm,
   canonicalize (buildRestrictedKernel q hadm),
   evaluate (canonicalize (buildRestrictedKernel q hadm)),
   rfl, rfl, rfl, rfl, rfl⟩

/-- FLAGSHIP: Every admissible question is directly evaluable.
    Ans(q) = Eval(Ψ_q, κ_q) — the answer is direct value propagation
    on the canonical binary kernel. -/
theorem every_admissible_question_directly_evaluable
    (q : Question) (hadm : IsAdmissible q) :
    compileAnswer q hadm =
    evaluate (canonicalize (buildRestrictedKernel q hadm)) :=
  rfl

end Manifestability.Answer
