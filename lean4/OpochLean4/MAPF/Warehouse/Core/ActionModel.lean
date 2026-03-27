import OpochLean4.MAPF.Warehouse.Core.Instance

/-
  Warehouse BAU — Action Model

  The warehouse action model is oriented: FW/CR/CCR/W.
  At the count-flow level, an action is a redistribution of
  robot counts between oriented vertices.

  FW: move one cell in facing direction (changes cell, keeps orientation)
  CR: rotate 90° clockwise (keeps cell, changes orientation)
  CCR: rotate 90° counter-clockwise (keeps cell, changes orientation)
  W: wait (no change)

  At the residual (count-flow) level, individual robot actions
  are aggregated into a flow matrix: how many robots move from
  each oriented vertex to each other oriented vertex.

  New axioms: 0
-/

namespace MAPF.Warehouse

/-- A warehouse BAU action at the count-flow level:
    a redistribution of robot counts along oriented edges.

    flow(u, v) = number of robots moving from oriented vertex u
    to oriented vertex v in one tick.

    This aggregates all individual FW/CR/CCR/W actions into counts.
    Robot labels are not tracked — only flow magnitudes. -/
structure WarehouseBAUAction (nV_base : Nat) where
  /-- Flow from oriented vertex u to oriented vertex v. -/
  flow : OrientedVertex nV_base → OrientedVertex nV_base → Nat

/-- A warehouse action is valid if flow only uses adjacency edges. -/
def warehouseActionValid {nV_base nA nT : Nat}
    (wh : WarehouseBAUInstance nV_base nA nT)
    (a : WarehouseBAUAction nV_base) : Prop :=
  ∀ u v, a.flow u v > 0 → wh.adj u v = true

/-- A warehouse action is conservative: total outflow from each vertex
    equals occupancy at that vertex. -/
def warehouseActionConservative {nV_base nT : Nat}
    (s : WarehouseBAUState nV_base nT)
    (a : WarehouseBAUAction nV_base) : Prop :=
  ∀ u, (List.range (nV_base * 4)).foldl (fun acc vi =>
    if h : vi < nV_base * 4 then acc + a.flow u ⟨vi, h⟩ else acc) 0 = s.occ u

/-- Apply a warehouse action: new occupancy = inflow at each vertex. -/
def applyWarehouseAction {nV_base nT : Nat}
    (s : WarehouseBAUState nV_base nT)
    (a : WarehouseBAUAction nV_base) : WarehouseBAUState nV_base nT where
  occ := fun v => (List.range (nV_base * 4)).foldl (fun acc ui =>
    if h : ui < nV_base * 4 then acc + a.flow ⟨ui, h⟩ v else acc) 0
  taskPhases := s.taskPhases  -- Task phases unchanged by movement alone

/-- The wait action: all robots stay in place. -/
def warehouseWaitAction {nV_base : Nat}
    (s : WarehouseBAUState nV_base nT) : WarehouseBAUAction nV_base where
  flow := fun u v => if u = v then s.occ u else 0

end MAPF.Warehouse
