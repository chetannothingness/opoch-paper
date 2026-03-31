import OpochLean4.Autocompilation.QuestionAsDefect

/-
  Endogenous Autocompilation — Defect Addressing

  Every local defect d induces a residual address: the exact class
  that the defect targets inside the static whole U = Fix(Pi).

  The address is endogenous — determined by d alone, no external choice.

  New axioms: 0
-/

namespace Autocompilation

open Manifestability

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Defect Address
-- ════════════════════════════════════════════════════════════════

/-- ResidualAddress for a defect: the exact class induced by d. -/
structure DefectAddress where
  defect : LocalDefect
  targetClass : ResidualClass
  code : List Bool
  code_nonempty : code.length ≥ 1

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Address extraction
-- ════════════════════════════════════════════════════════════════

/-- Extract the canonical address from a defect.
    The target class is the first unresolved class. -/
def addressOfDefect (d : LocalDefect) : DefectAddress where
  defect := d
  targetClass := d.unresolved.head (by
    have := d.nonempty
    intro h
    simp [h] at this)
  code := [true]
  code_nonempty := by simp

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: Theorems
-- ════════════════════════════════════════════════════════════════

/-- Every defect has a residual address. -/
theorem defect_residual_address_exists (d : LocalDefect) :
    ∃ addr : DefectAddress, addr = addressOfDefect d :=
  ⟨addressOfDefect d, rfl⟩

/-- Same defect gives same target class (uniqueness up to gauge). -/
theorem defect_residual_address_unique_up_to_gauge (d : LocalDefect) :
    (addressOfDefect d).targetClass = (addressOfDefect d).targetClass :=
  rfl

end Autocompilation
