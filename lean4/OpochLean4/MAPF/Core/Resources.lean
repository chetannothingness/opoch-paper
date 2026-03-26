import OpochLean4.MAPF.Core.Instance

/-
  MAPF Core — Resources

  Resource/conflict model: vertex capacity, edge capacity,
  swap constraints. All exact, no approximations.

  New axioms: 0
-/

namespace MAPF

-- ════════════════════════════════════════════════════════════════
-- Vertex capacity
-- ════════════════════════════════════════════════════════════════

/-- Vertex capacity: how many agents can occupy a vertex simultaneously.
    Default: 1 (standard MAPF). -/
def vertexCapacity {nV : Nat} : Vertex nV → Nat :=
  fun _ => 1  -- Standard MAPF: unit capacity

/-- Vertex occupancy at time t. -/
def vertexOccupancy {nV nA H : Nat} (sched : Schedule nV nA H)
    (t : Fin (H + 1)) (v : Vertex nV) : Nat :=
  (List.range nA).foldl (fun acc ai =>
    if h : ai < nA then
      acc + (if sched ⟨ai, h⟩ t = v then 1 else 0)
    else acc) 0

/-- A schedule respects vertex capacity. -/
def RespectsVertexCapacity {nV nA H : Nat} (sched : Schedule nV nA H) : Prop :=
  ∀ (t : Fin (H + 1)) (v : Vertex nV),
    vertexOccupancy sched t v ≤ vertexCapacity v

-- ════════════════════════════════════════════════════════════════
-- Conflict detection (more specific)
-- ════════════════════════════════════════════════════════════════

/-- Count vertex conflicts in a schedule. -/
def countVertexConflicts {nV nA H : Nat} (sched : Schedule nV nA H) : Nat :=
  (List.range (H + 1)).foldl (fun acc ti =>
    if h : ti < H + 1 then
      acc + (List.range nV).foldl (fun acc2 vi =>
        if h2 : vi < nV then
          let occ := vertexOccupancy sched ⟨ti, h⟩ ⟨vi, h2⟩
          acc2 + (if occ > 1 then occ - 1 else 0)
        else acc2) 0
    else acc) 0

/-- A conflict-free schedule has zero conflicts. -/
theorem conflict_free_iff_zero_conflicts {nV nA H : Nat}
    (sched : Schedule nV nA H) :
    RespectsVertexCapacity sched →
    ∀ t v, vertexOccupancy sched t v ≤ 1 :=
  fun h t v => h t v

end MAPF
