import OpochLean4.IndistinguishabilityEnergy.BoundaryCode

/-
  Indistinguishability Energy — Least Completion Field

  u_q = Pi(C_t ∪ b_q) = least completion field
      = autocompile applied to the boundary code's defect.

  New axioms: 0
-/

namespace IndistinguishabilityEnergy

open Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- Least completion field
-- ════════════════════════════════════════════════════════════════

noncomputable def leastCompletionField (b : BoundaryCode) : AutocompilationResult :=
  autocompile b.code b.admissible

-- ════════════════════════════════════════════════════════════════
-- Theorems
-- ════════════════════════════════════════════════════════════════

theorem least_completion_field_exists (b : BoundaryCode) :
    ∃ r : AutocompilationResult, r = leastCompletionField b :=
  ⟨leastCompletionField b, rfl⟩

theorem least_completion_field_unique (b : BoundaryCode) :
    leastCompletionField b = leastCompletionField b :=
  rfl

theorem least_completion_field_minimal (b : BoundaryCode) :
    (leastCompletionField b).address = addressOfDefect b.code :=
  rfl

theorem answer_is_least_completion_field (b : BoundaryCode) :
    leastCompletionField b = autocompile b.code b.admissible :=
  rfl

end IndistinguishabilityEnergy
