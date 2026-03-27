import OpochLean4.MAPF.Warehouse.Core.Instance

/-
  Warehouse BAU — Canonical Signature

  The canonical signature of a warehouse BAU state: the occupancy vector
  on orientation-expanded vertices plus the enriched task phase vector.

  Same signature → same future legal completions within a BAU window.
  This is the warehouse analogue of the generic MAPF signature
  (Residual/Signature.lean), enriched with orientation and lock semantics.

  Connection to A0*: The signature contains exactly the distinctions
  that determine future completions. Two states with the same signature
  are indistinguishable by any future witness — they ARE the same
  residual class under A0*.

  New axioms: 0
-/

namespace MAPF.Warehouse.Residual

open MAPF.Warehouse

/-- The canonical signature of a warehouse BAU state.

    Contains:
    1. Occupancy on orientation-expanded vertices (Fin (nV_base * 4) → Nat)
    2. Enriched task phases (Fin nT → WarehouseTaskPhase)

    Does NOT contain robot labels. Robot identity is gauge. -/
structure WarehouseBAUSignature (nV_base nT : Nat) where
  /-- Occupancy at each oriented vertex. -/
  occupancy : OrientedVertex nV_base → Nat
  /-- Phase of each task in the visible pool. -/
  taskPhases : Fin nT → WarehouseTaskPhase

instance {nV_base nT : Nat} : DecidableEq (WarehouseBAUSignature nV_base nT) :=
  fun s₁ s₂ => by
    cases s₁; cases s₂
    simp [WarehouseBAUSignature.mk.injEq]
    exact inferInstance

/-- Extract the canonical signature from a warehouse BAU state. -/
def warehouseStateSignature {nV_base nT : Nat}
    (s : WarehouseBAUState nV_base nT) : WarehouseBAUSignature nV_base nT where
  occupancy := s.occ
  taskPhases := s.taskPhases

/-- Signature completeness: same signature → same occupancy. -/
theorem warehouse_signature_occ_eq {nV_base nT : Nat}
    (s₁ s₂ : WarehouseBAUState nV_base nT)
    (h : warehouseStateSignature s₁ = warehouseStateSignature s₂) :
    s₁.occ = s₂.occ := by
  have := congrArg WarehouseBAUSignature.occupancy h
  simp [warehouseStateSignature] at this
  exact this

/-- Signature completeness: same signature → same task phases. -/
theorem warehouse_signature_tasks_eq {nV_base nT : Nat}
    (s₁ s₂ : WarehouseBAUState nV_base nT)
    (h : warehouseStateSignature s₁ = warehouseStateSignature s₂) :
    s₁.taskPhases = s₂.taskPhases := by
  have := congrArg WarehouseBAUSignature.taskPhases h
  simp [warehouseStateSignature] at this
  exact this

end MAPF.Warehouse.Residual
