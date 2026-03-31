import OpochLean4.IndistinguishabilityEnergy.SelfModelCoupling

/-
  Indistinguishability Energy — Present Boundary

  Present support, writable boundary, locality inside the whole.

  New axioms: 0
-/

namespace IndistinguishabilityEnergy

open Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- Present boundary
-- ════════════════════════════════════════════════════════════════

structure PresentBoundary where
  state : LocalDynamicState
  boundaryCapacity : Nat
  capacity_pos : boundaryCapacity ≥ 1

-- ════════════════════════════════════════════════════════════════
-- Theorems
-- ════════════════════════════════════════════════════════════════

theorem present_support_sub_whole (pb : PresentBoundary) :
    pb.state.support.size ≤ pb.state.support.capacity :=
  pb.state.support.within_capacity

theorem present_boundary_exists (lds : LocalDynamicState) :
    ∃ pb : PresentBoundary, pb.state = lds :=
  ⟨⟨lds, 1, Nat.le_refl 1⟩, rfl⟩

theorem present_boundary_writable (pb : PresentBoundary) :
    pb.boundaryCapacity ≥ 1 :=
  pb.capacity_pos

end IndistinguishabilityEnergy
