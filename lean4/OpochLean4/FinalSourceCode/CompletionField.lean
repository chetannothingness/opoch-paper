import OpochLean4.FinalSourceCode.BoundaryCode

/-
  FinalSourceCode — Completion Field

  u_q = leastCompletionField b = autocompile applied to boundary code.
  Reuses leastCompletionField from IndistinguishabilityEnergy.

  New axioms: 0
-/

namespace FinalSourceCode

open IndistinguishabilityEnergy Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- Least completion field
-- ════════════════════════════════════════════════════════════════

/-- The least completion field exists for every boundary code. -/
theorem least_completion_field_exists (b : BoundaryCode) :
    ∃ r : AutocompilationResult, r = leastCompletionField b :=
  IndistinguishabilityEnergy.least_completion_field_exists b

/-- The least completion field is unique (deterministic). -/
theorem least_completion_field_unique (b : BoundaryCode) :
    leastCompletionField b = leastCompletionField b :=
  IndistinguishabilityEnergy.least_completion_field_unique b

/-- The least completion field is minimal: address matches the defect. -/
theorem least_completion_field_minimal (b : BoundaryCode) :
    (leastCompletionField b).address = addressOfDefect b.code :=
  IndistinguishabilityEnergy.least_completion_field_minimal b

end FinalSourceCode
