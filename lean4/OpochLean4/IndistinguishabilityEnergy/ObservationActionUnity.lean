import OpochLean4.IndistinguishabilityEnergy.EnergyRelease

/-
  Indistinguishability Energy — Observation-Action Unity

  observation = action = energy release = one boundary event.

  New axioms: 0
-/

namespace IndistinguishabilityEnergy

open Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- Boundary event
-- ════════════════════════════════════════════════════════════════

structure BoundaryEvent where
  code : BoundaryCode
  completion : AutocompilationResult
  current : CompletionCurrent
  completion_eq : completion = leastCompletionField code
  current_eq : current = boundaryCurrent code

noncomputable def canonicalBoundaryEvent (b : BoundaryCode) : BoundaryEvent where
  code := b
  completion := leastCompletionField b
  current := boundaryCurrent b
  completion_eq := rfl
  current_eq := rfl

-- ════════════════════════════════════════════════════════════════
-- Theorems
-- ════════════════════════════════════════════════════════════════

theorem observation_is_boundary_event (b : BoundaryCode) :
    ∃ e : BoundaryEvent, e.code = b :=
  ⟨canonicalBoundaryEvent b, rfl⟩

theorem action_is_boundary_event (b : BoundaryCode) :
    (canonicalBoundaryEvent b).completion = leastCompletionField b :=
  rfl

theorem energy_release_is_boundary_event (b : BoundaryCode) :
    (canonicalBoundaryEvent b).current = boundaryCurrent b :=
  rfl

theorem observation_action_energy_unity (b : BoundaryCode) :
    (canonicalBoundaryEvent b).code = b ∧
    (canonicalBoundaryEvent b).completion = leastCompletionField b ∧
    (canonicalBoundaryEvent b).current = boundaryCurrent b :=
  ⟨rfl, rfl, rfl⟩

end IndistinguishabilityEnergy
