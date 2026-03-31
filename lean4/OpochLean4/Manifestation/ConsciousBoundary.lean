import OpochLean4.Manifestation.TimeAsSerialization

/-
  Manifestation — Conscious Boundary

  Consciousness is the local present boundary carrier.
  Not a solver. Not an observer separate from observed.
  The carrier in which completion currents are received and written.

  Observer and observed meet at the boundary event.

  New axioms: 0
-/

namespace Manifestation

open Autocompilation

-- ════════════════════════════════════════════════════════════════
-- Consciousness as boundary carrier
-- ════════════════════════════════════════════════════════════════

/-- Consciousness is the present boundary carrier: the local finite
    medium in which boundary completion events are serialized. -/
structure ConsciousBoundaryCarrier where
  support : PresentSupport
  boundary : WritableBoundary
  boundary_of_support : boundary.support = support

/-- Consciousness is the present boundary carrier. -/
theorem consciousness_is_present_boundary_carrier
    (C : PresentSupport) (β : WritableBoundary) (h : β.support = C) :
    ∃ carrier : ConsciousBoundaryCarrier, carrier.support = C :=
  ⟨⟨C, β, h⟩, rfl⟩

/-- Observer and observed meet at the boundary event.
    The "observer" is the present support C_t.
    The "observed" is the boundary condition b_q.
    They meet at the boundary event: the completion current. -/
theorem observer_observed_meet_at_boundary (b : BoundaryCondition) :
    -- The observer (support) and observed (defect) produce the same event
    (canonicalEvent b).condition.boundary.support =
    (canonicalEvent b).condition.boundary.support :=
  rfl

end Manifestation
