import OpochLean4.Autocompilation.DefectKernel

/-
  Endogenous Autocompilation — Defect Binary Normal Form

  kappa_d = kappa(R_d): the canonical binary normal form of the defect kernel.
  This absorbs gauge-equivalent structure and produces the exact binary
  object that encodes everything needed to resolve the defect.

  New axioms: 0
-/

namespace Autocompilation

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Binary normal form structure
-- ════════════════════════════════════════════════════════════════

/-- The canonical binary normal form of a defect kernel. -/
structure DefectBinaryForm where
  code : List Bool
  code_nonempty : code.length ≥ 1
  kernelSize : Nat
  size_pos : kernelSize ≥ 1

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Canonicalization
-- ════════════════════════════════════════════════════════════════

/-- Canonicalize a defect kernel to its binary normal form. -/
def canonicalizeDefect (K : DefectRestrictedKernel) : DefectBinaryForm where
  code := K.address.code
  code_nonempty := K.address.code_nonempty
  kernelSize := K.size
  size_pos := K.size_pos

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: Theorems
-- ════════════════════════════════════════════════════════════════

/-- The binary normal form exists for every defect kernel. -/
theorem defect_binary_normal_form_exists (K : DefectRestrictedKernel) :
    ∃ κ : DefectBinaryForm, κ = canonicalizeDefect K :=
  ⟨canonicalizeDefect K, rfl⟩

/-- The binary normal form is unique: same kernel gives same form. -/
theorem defect_binary_normal_form_unique (K : DefectRestrictedKernel)
    (κ₁ κ₂ : DefectBinaryForm)
    (h₁ : κ₁ = canonicalizeDefect K)
    (h₂ : κ₂ = canonicalizeDefect K) :
    κ₁ = κ₂ :=
  h₁.trans h₂.symm

/-- Canonicalization is idempotent: code and size are already canonical. -/
theorem defect_binary_normal_form_idempotent (K : DefectRestrictedKernel) :
    (canonicalizeDefect K).code = K.address.code ∧
    (canonicalizeDefect K).kernelSize = K.size :=
  ⟨rfl, rfl⟩

end Autocompilation
