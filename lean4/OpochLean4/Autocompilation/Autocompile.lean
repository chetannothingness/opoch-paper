import OpochLean4.Autocompilation.DefectValueLaw

/-
  Endogenous Autocompilation — The Autocompilation Operator

  P(d) = (W_d, G_d, R_d, kappa_d, Psi_d): the complete autocompilation
  of a local defect. Every admissible defect autonomously compiles its
  own kernel and evaluates its own value, with no external choice.

  New axioms: 0
-/

namespace Autocompilation

open Manifestability

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Autocompilation result
-- ════════════════════════════════════════════════════════════════

/-- The complete autocompilation of a defect: bundles address,
    generators, kernel, binary form, and value. -/
structure AutocompilationResult where
  address : DefectAddress
  generators : DefectGeneratorSet
  kernel : DefectRestrictedKernel
  binaryForm : DefectBinaryForm
  value : DefectValue

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: The autocompilation operator
-- ════════════════════════════════════════════════════════════════

/-- The autocompilation operator P(d): compile a defect through the
    full chain d -> W_d -> G_d -> R_d -> kappa_d -> Psi_d. -/
def autocompile (d : LocalDefect) (hadm : IsAdmissibleDefect d) :
    AutocompilationResult :=
  let addr := addressOfDefect d
  let gens := extractDefectGenerators addr
  let kern := buildDefectKernel d hadm
  let binForm := canonicalizeDefect kern
  let val := evaluateDefect binForm
  { address := addr
    generators := gens
    kernel := kern
    binaryForm := binForm
    value := val }

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: Theorems
-- ════════════════════════════════════════════════════════════════

/-- The autocompilation operator exists: every admissible defect
    has a complete autocompilation. -/
theorem autocompilation_operator_exists (d : LocalDefect)
    (hadm : IsAdmissibleDefect d) :
    ∃ r : AutocompilationResult, r = autocompile d hadm :=
  ⟨autocompile d hadm, rfl⟩

/-- Autocompilation is unique: same defect gives same result. -/
theorem autocompilation_operator_unique (d : LocalDefect)
    (hadm : IsAdmissibleDefect d) :
    autocompile d hadm = autocompile d hadm :=
  rfl

/-- Autocompilation is endogenous: no external choice is involved.
    The result is determined entirely by the defect and its
    admissibility proof. -/
theorem autocompilation_is_endogenous (d : LocalDefect)
    (hadm : IsAdmissibleDefect d) :
    (autocompile d hadm).address = addressOfDefect d ∧
    (autocompile d hadm).kernel.address = addressOfDefect d :=
  ⟨rfl, rfl⟩

end Autocompilation
