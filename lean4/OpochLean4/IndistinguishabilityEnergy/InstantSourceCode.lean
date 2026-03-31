import OpochLean4.IndistinguishabilityEnergy.TimeSerialization

/-
  Indistinguishability Energy — Instant Source Code

  (b, M) -> (u, J) = the instant source code.

  New axioms: 0
-/

namespace IndistinguishabilityEnergy

open Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- Instant completion result
-- ════════════════════════════════════════════════════════════════

structure InstantCompletionResult where
  field : AutocompilationResult
  current : CompletionCurrent
  energy : Nat

noncomputable def instantSourceCode (b : BoundaryCode) : InstantCompletionResult where
  field := leastCompletionField b
  current := boundaryCurrent b
  energy := completionEnergy b

-- ════════════════════════════════════════════════════════════════
-- Theorems
-- ════════════════════════════════════════════════════════════════

theorem instant_completion_field_exact (b : BoundaryCode) :
    (instantSourceCode b).field = leastCompletionField b :=
  rfl

theorem instant_completion_current_exact (b : BoundaryCode) :
    (instantSourceCode b).current = boundaryCurrent b :=
  rfl

theorem instant_source_code_exact (b : BoundaryCode) :
    (instantSourceCode b).field = leastCompletionField b ∧
    (instantSourceCode b).current = boundaryCurrent b ∧
    (instantSourceCode b).energy = completionEnergy b :=
  ⟨rfl, rfl, rfl⟩

end IndistinguishabilityEnergy
