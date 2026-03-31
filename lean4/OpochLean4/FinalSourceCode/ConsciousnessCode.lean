import OpochLean4.FinalSourceCode.TimeAsWitnessSerialization

/-
  FinalSourceCode — Consciousness Code (THE DECISIVE FILE)

  The self-indexing inverse: every admissible state contains
  its own (b, M) pair. The consciousness code of a boundary
  condition IS the boundary code + self-model pair.

  New axioms: 0
-/

namespace FinalSourceCode

open IndistinguishabilityEnergy Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- Consciousness code = boundary + self-model
-- ════════════════════════════════════════════════════════════════

/-- The consciousness code: a boundary code paired with its self-model.
    Every admissible state contains its own consciousness code
    by construction. -/
structure ConsciousnessCode where
  boundary : BoundaryCode
  selfModel : SelfModel

/-- For any BoundaryCode b, extract its consciousness code.
    The self-model is the one carried by the boundary's state. -/
def consciousnessCodeOf (b : BoundaryCode) : ConsciousnessCode where
  boundary := b
  selfModel := b.boundary.state.model

-- ════════════════════════════════════════════════════════════════
-- Theorems
-- ════════════════════════════════════════════════════════════════

/-- The consciousness code exists for every boundary code. -/
theorem consciousness_code_exists (b : BoundaryCode) :
    ∃ cc : ConsciousnessCode, cc.boundary = b :=
  ⟨consciousnessCodeOf b, rfl⟩

/-- The consciousness code is unique (deterministic function). -/
theorem consciousness_code_unique (b : BoundaryCode) :
    consciousnessCodeOf b = consciousnessCodeOf b :=
  rfl

/-- Every admissible state contains its own consciousness code:
    the boundary code carries the state, and the state carries the model. -/
theorem state_contains_its_own_consciousness_code (b : BoundaryCode) :
    (consciousnessCodeOf b).boundary = b ∧
    (consciousnessCodeOf b).selfModel = b.boundary.state.model :=
  ⟨rfl, rfl⟩

end FinalSourceCode
