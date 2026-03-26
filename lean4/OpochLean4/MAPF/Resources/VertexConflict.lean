import OpochLean4.MAPF.Core.Instance
import OpochLean4.MAPF.Core.Resources

namespace MAPF.Resources

def HasVertexConflictAt {nV nA H : Nat} (sched : Schedule nV nA H)
    (t : Fin (H + 1)) (v : Vertex nV) : Prop :=
  vertexOccupancy sched t v > vertexCapacity v

def VertexConflictFree {nV nA H : Nat} (sched : Schedule nV nA H) : Prop :=
  ∀ t v, ¬HasVertexConflictAt sched t v

theorem vertex_conflict_free_means_capacity_respected {nV nA H : Nat}
    (sched : Schedule nV nA H)
    (h : VertexConflictFree sched) :
    RespectsVertexCapacity sched := by
  intro t v; exact Nat.le_of_not_gt (h t v)

end MAPF.Resources
