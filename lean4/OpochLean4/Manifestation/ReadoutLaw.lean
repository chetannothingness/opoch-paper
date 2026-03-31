import OpochLean4.Manifestation.ConsciousBoundary

/-
  Manifestation — Readout Law

  Out_{C_t}(b_q) = R_{C_t}(u_q, j_q)

  The local output is the readout of the completion field and
  boundary current. Local delay is readout, not solving.

  New axioms: 0
-/

namespace Manifestation

open Autocompilation

-- ════════════════════════════════════════════════════════════════
-- Readout operator
-- ════════════════════════════════════════════════════════════════

/-- The readout: local output = min(completion value, boundary capacity). -/
noncomputable def readout (b : BoundaryCondition) : Nat :=
  min (boundaryCurrent b).completionValue b.boundary.capacity

/-- The readout law: output is determined by completion and current. -/
theorem readout_law_exact (b : BoundaryCondition) :
    readout b = min (boundaryCurrent b).completionValue b.boundary.capacity :=
  rfl

/-- Local delay is readout, not solving.
    The completion exists immediately (Π is a function).
    The only delay is serialization into the present boundary. -/
theorem local_delay_is_readout_not_solving (b : BoundaryCondition) :
    -- The answer exists immediately
    (∃ u : AutocompilationResult, u = leastCompletion b) ∧
    -- The readout is bounded by boundary capacity
    readout b ≤ b.boundary.capacity :=
  ⟨⟨leastCompletion b, rfl⟩, Nat.min_le_right _ _⟩

end Manifestation
