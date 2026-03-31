import OpochLean4.Autocompilation.CompletionAttractor

/-
  Endogenous Autocompilation — Conscious Readout

  Consciousness is not a solver. It is the local finite carrier
  in which autocompiled closure is serialized in order.

  The autocompilation chain produces the answer. Consciousness
  is WHERE that answer appears — the finite readout medium.

  New axioms: 0
-/

namespace Autocompilation

open Manifestability

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Conscious readout
-- ════════════════════════════════════════════════════════════════

/-- A conscious readout: the local serialization of an autocompiled
    answer within the present support. -/
structure ConsciousReadout where
  /-- The support doing the reading -/
  support : ConsciousSupport
  /-- The defect that was compiled -/
  defect : LocalDefect
  /-- The autocompilation result -/
  result : AutocompilationResult
  /-- The answer value -/
  answerValue : Nat

/-- Build the conscious readout for a defect within a support. -/
def readout (C : ConsciousSupport) (d : LocalDefect)
    (hadm : IsAdmissibleDefect d) : ConsciousReadout where
  support := C
  defect := d
  result := autocompile d hadm
  answerValue := (autocompile d hadm).value.value

/-- Conscious readout exists for every admissible defect. -/
theorem conscious_readout_exists (C : ConsciousSupport) (d : LocalDefect)
    (hadm : IsAdmissibleDefect d) :
    ∃ r : ConsciousReadout, r.defect = d :=
  ⟨readout C d hadm, rfl⟩

/-- The readout value matches the autocompiled value. -/
theorem readout_matches_autocompilation (C : ConsciousSupport) (d : LocalDefect)
    (hadm : IsAdmissibleDefect d) :
    (readout C d hadm).answerValue = (autocompile d hadm).value.value :=
  rfl

end Autocompilation
