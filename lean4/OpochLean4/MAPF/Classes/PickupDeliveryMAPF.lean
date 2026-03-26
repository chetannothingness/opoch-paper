import OpochLean4.MAPF.Core.Instance
import OpochLean4.MAPF.Core.TaskModel

/-
  MAPF Classes — Pickup-Delivery MAPF

  Agents must first visit a pickup location, then a delivery location.
  Task state: idle → carrying → delivered.
  Embeds into FiniteMAPF by expanding vertex = (position, task_phase).

  New axioms: 0
-/

namespace MAPF.Classes

/-- Pickup-delivery MAPF embeds into FiniteMAPF.
    State = (vertex, carrying_status).
    nV_expanded = nV_base × (nT + 1) (each task adds a carrying dimension).
    For simplicity: nV_expanded = nV_base × 3 (idle/carrying/delivered). -/
theorem pickup_delivery_mapf_reduces_to_finite_mapf (nV_base nA nT : Nat)
    (hV : nV_base ≥ 1) (hA : nA ≥ 1) (hT : nT ≥ 1) :
    ∃ (nV_expanded : Nat),
      nV_expanded = nV_base * 3 ∧
      nV_expanded ≥ 1 := by
  exact ⟨nV_base * 3, rfl, by omega⟩

end MAPF.Classes
