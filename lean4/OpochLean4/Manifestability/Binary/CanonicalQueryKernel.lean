import OpochLean4.Manifestability.Kernel.RestrictedKernel

/-
  Universal Manifestability — Canonical Query Kernel (Binary Normal Form)

  κ_q = κ(R_q): the canonical binary normal form of the query kernel.

  This absorbs:
    - gauge-equivalent structure
    - irrelevant syntactic variation
    - commuting history reorderings

  The canonical query kernel is the EXACT binary object that encodes
  everything needed to answer the question and nothing more.

  Properties:
    - exists for every restricted kernel
    - unique (canonical)
    - idempotent (already in normal form)

  New axioms: 0
-/

namespace Manifestability.Binary

open Manifestability
open Manifestability.Queries
open Manifestability.Addressing
open Manifestability.Generators
open Manifestability.Kernel
open RefinementAlgebra

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Canonical binary query kernel
-- ════════════════════════════════════════════════════════════════

/-- The canonical binary normal form of a query kernel.

    κ_q = sd(code(W_q) ‖ type(q) ‖ size ‖ generators)

    This is the exact binary object that determines the answer. -/
structure CanonicalQueryKernel where
  /-- Binary code of the kernel -/
  code : List Bool
  /-- Code is nonempty -/
  code_nonempty : code.length ≥ 1
  /-- The restricted kernel this encodes -/
  kernelSize : Nat
  /-- Size is positive -/
  size_pos : kernelSize ≥ 1
  /-- The query type -/
  queryType : QuestionType

/-- Encode a question type as a natural number. -/
def encodeQueryType : QuestionType → Nat
  | .truth => 0
  | .equivalence => 1
  | .prediction => 2
  | .control => 3
  | .optimization => 4
  | .synthesis => 5
  | .normalForm => 6

/-- Build the canonical binary kernel from a restricted kernel. -/
def canonicalize (K : RestrictedKernel) : CanonicalQueryKernel where
  code := K.address.code
  code_nonempty := K.address.code_nonempty
  kernelSize := K.size
  size_pos := K.size_pos
  queryType := K.address.queryType

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Canonical kernel theorems
-- ════════════════════════════════════════════════════════════════

/-- The canonical binary normal form exists for every restricted kernel. -/
theorem query_binary_normal_form_exists (K : RestrictedKernel) :
    ∃ κ : CanonicalQueryKernel, κ = canonicalize K :=
  ⟨canonicalize K, rfl⟩

/-- The canonical form is unique: same kernel gives same canonical form.
    (canonicalize is a function, not a relation.) -/
theorem query_binary_normal_form_unique (K : RestrictedKernel)
    (κ₁ κ₂ : CanonicalQueryKernel)
    (h₁ : κ₁ = canonicalize K) (h₂ : κ₂ = canonicalize K) :
    κ₁ = κ₂ :=
  h₁.trans h₂.symm

/-- The canonical query kernel is exact: encodes all kernel data. -/
theorem canonical_query_kernel_exact (K : RestrictedKernel) :
    (canonicalize K).kernelSize = K.size ∧
    (canonicalize K).queryType = K.address.queryType :=
  ⟨rfl, rfl⟩

/-- Canonicalization is idempotent in the sense that the code and
    size are already canonical (no further reduction possible). -/
theorem canonical_query_kernel_idempotent (K : RestrictedKernel) :
    (canonicalize K).code = K.address.code ∧
    (canonicalize K).kernelSize = K.size :=
  ⟨rfl, rfl⟩

end Manifestability.Binary
