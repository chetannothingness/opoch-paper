import OpochLean4.MAPF.Core.Instance
import OpochLean4.MAPF.Core.Resources

/-
  MAPF Semantics — Occupancy

  o_t(v) = number of agents at vertex v at time t.
  This is the first step of the semantic collapse:
  from individual agent positions to aggregate occupancy.

  New axioms: 0
-/

namespace MAPF.Semantics

/-- Occupancy vector at time t: count of agents at each vertex. -/
def occupancy {nV nA H : Nat} (sched : Schedule nV nA H)
    (t : Fin (H + 1)) : Vertex nV → Nat :=
  fun v => vertexOccupancy sched t v

/-- Two schedules with the same occupancy are occupancy-equivalent. -/
def OccupancyEquiv {nV nA H : Nat} (s₁ s₂ : Schedule nV nA H) : Prop :=
  ∀ t v, occupancy s₁ t v = occupancy s₂ t v

/-- Occupancy equivalence is an equivalence relation. -/
theorem occupancy_equiv_refl {nV nA H : Nat} (s : Schedule nV nA H) :
    OccupancyEquiv s s := fun _ _ => rfl

theorem occupancy_equiv_symm {nV nA H : Nat} {s₁ s₂ : Schedule nV nA H}
    (h : OccupancyEquiv s₁ s₂) : OccupancyEquiv s₂ s₁ :=
  fun t v => (h t v).symm

/-- Occupancy is non-negative (trivially, since Nat). -/
theorem occupancy_nonneg {nV nA H : Nat} (sched : Schedule nV nA H)
    (t : Fin (H + 1)) (v : Vertex nV) :
    occupancy sched t v ≥ 0 :=
  Nat.zero_le _

end MAPF.Semantics
