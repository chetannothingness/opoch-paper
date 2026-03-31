import OpochLean4.Autocompilation.DefectBinaryNormalForm

/-
  Endogenous Autocompilation — Defect Value Law

  Psi_d = Eval(kappa_d): the value of the defect, computed directly
  from its binary normal form. The value equals the kernel size —
  the remaining cost to resolve the defect.

  New axioms: 0
-/

namespace Autocompilation

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Defect value structure
-- ════════════════════════════════════════════════════════════════

/-- The value of a defect: the completion cost read from its binary form. -/
structure DefectValue where
  form : DefectBinaryForm
  value : Nat

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Evaluation
-- ════════════════════════════════════════════════════════════════

/-- Evaluate a defect binary form: the value is the kernel size
    (the remaining cost to resolve the defect). -/
def evaluateDefect (κ : DefectBinaryForm) : DefectValue where
  form := κ
  value := κ.kernelSize

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: Theorems
-- ════════════════════════════════════════════════════════════════

/-- The defect value law exists: every binary form has a value. -/
theorem defect_value_law_exists (κ : DefectBinaryForm) :
    ∃ v : DefectValue, v = evaluateDefect κ :=
  ⟨evaluateDefect κ, rfl⟩

/-- The defect value is exact: value = kernelSize (the remaining cost). -/
theorem defect_value_law_exact (κ : DefectBinaryForm) :
    (evaluateDefect κ).value = κ.kernelSize :=
  rfl

end Autocompilation
