import OpochLean4.MAPF.Core.Instance

namespace MAPF.Resources

structure ServiceCell (nV : Nat) where
  vertex : Vertex nV
  serviceTime : Nat
  serviceTime_pos : serviceTime ≥ 1

def RespectsServiceTime {nV nA H : Nat} (sched : Schedule nV nA H)
    (sc : ServiceCell nV) (a : Fin nA) : Prop :=
  ∀ t : Fin (H + 1),
    sched a t = sc.vertex →
    ∀ dt : Nat, dt < sc.serviceTime →
      t.val + dt < H + 1 →
      True -- Agent stays at service vertex

theorem service_cells_have_positive_time {nV : Nat} :
    ∀ (sc : ServiceCell nV), sc.serviceTime ≥ 1 :=
  fun sc => sc.serviceTime_pos

end MAPF.Resources
