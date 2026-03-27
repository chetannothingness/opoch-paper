import OpochLean4.MAPF.Core.Instance
import OpochLean4.MAPF.Warehouse.Core.TaskPhase

/-
  Warehouse BAU — Instance and Residual State

  A warehouse BAU instance specializes the generic finite MAPF instance
  for the LoRR warehouse_large problem:
  - Oriented motion (FW/CR/CCR/W) → vertices are (cell, orientation)
  - E→S tasks with lock semantics → 5-phase task automaton
  - 15,000 visible pool with reveal-on-completion → fixed within one BAU window

  The warehouse BAU residual state is the truth quotient state:
  occupancy on orientation-expanded vertices + enriched task phases.
  Robot labels are gauge at this level — the state tracks COUNTS, not names.

  Connection to A0*: The warehouse BAU state is the minimal set of
  distinctions that determines all future legal completions within
  the current BAU window. Robot identity is not such a distinction
  (same occupancy → same score), so it is quotiented out.

  New axioms: 0
-/

namespace MAPF.Warehouse

open MAPF

/-- Abbreviation: an oriented vertex is a cell × orientation.
    nV_expanded = nV_base × 4 (four cardinal orientations). -/
abbrev OrientedVertex (nV_base : Nat) := Fin (nV_base * 4)

/-- A warehouse BAU instance for one receding-horizon window.

    Parameters:
    - nV_base: number of passable cells in the warehouse grid
    - nA: number of robots (10,000 for warehouse_large)
    - nT: number of tasks in the visible pool (15,000 for BAU)

    The vertex space is orientation-expanded: nV_base × 4.
    Each task is an E→S pair (source = E cell, target = S cell).
    Lock semantics: once a robot visits the E cell, the task is locked. -/
structure WarehouseBAUInstance (nV_base nA nT : Nat) where
  /-- Adjacency on orientation-expanded graph.
      adj (v1, o1) (v2, o2) = true iff the robot can transition
      from (cell v1, orientation o1) to (cell v2, orientation o2)
      in one tick via FW, CR, CCR, or W. -/
  adj : OrientedVertex nV_base → OrientedVertex nV_base → Bool
  /-- Self-adjacency (wait action is always valid). -/
  adj_self : ∀ v, adj v v = true
  /-- Starting positions in orientation-expanded space. -/
  start : Fin nA → OrientedVertex nV_base
  /-- Task first waypoints (E cells, embedded into oriented space).
      The orientation component is the arrival orientation. -/
  taskSource : Fin nT → OrientedVertex nV_base
  /-- Task second waypoints (S cells, embedded into oriented space). -/
  taskTarget : Fin nT → OrientedVertex nV_base
  /-- At least one robot. -/
  agents_pos : nA ≥ 1
  /-- At least one task in the visible pool. -/
  tasks_pos : nT ≥ 1

-- ════════════════════════════════════════════════════════════════
-- WAREHOUSE BAU RESIDUAL STATE
-- ════════════════════════════════════════════════════════════════

/-- Occupancy vector on orientation-expanded vertices.
    occ(v) = number of robots at oriented vertex v. -/
def WarehouseOccVec (nV_base : Nat) := OrientedVertex nV_base → Nat

/-- The warehouse BAU residual state.

    This is the ONE clean state type for the warehouse quotient.
    It contains exactly the distinctions needed to determine
    future legal completions within a BAU window:

    1. Occupancy on orientation-expanded vertices (where robots are, how many)
    2. Enriched task phases (which tasks are free/assigned/locked/completed)

    Robot labels are NOT in this state. They are gauge.
    The warehouse score depends only on occupancy at goal vertices
    and task completion counts — not on which robot did what. -/
structure WarehouseBAUState (nV_base nT : Nat) where
  /-- Occupancy vector on oriented vertices. -/
  occ : WarehouseOccVec nV_base
  /-- Enriched task phase vector (5-state). -/
  taskPhases : WarehouseTaskState nT

/-- Initial warehouse BAU state from an instance. -/
def initWarehouseBAUState {nV_base nA nT : Nat}
    (wh : WarehouseBAUInstance nV_base nA nT) : WarehouseBAUState nV_base nT where
  occ := fun v => (List.range nA).foldl (fun acc ai =>
    if h : ai < nA then
      acc + (if wh.start ⟨ai, h⟩ = v then 1 else 0)
    else acc) 0
  taskPhases := initialWarehouseTaskState nT

/-- Vertex capacity on oriented vertices.
    Standard warehouse: capacity 1 per cell (regardless of orientation).
    Two robots at the same cell = vertex conflict. -/
def warehouseVertexCapacity {nV_base : Nat} (_ : OrientedVertex nV_base) : Nat := 1

/-- Warehouse occupancy at an oriented vertex. -/
def warehouseOccupancy {nV_base nT : Nat}
    (s : WarehouseBAUState nV_base nT) (v : OrientedVertex nV_base) : Nat :=
  s.occ v

/-- Warehouse vacancy at an oriented vertex. -/
def warehouseVacancy {nV_base nT : Nat}
    (s : WarehouseBAUState nV_base nT) (v : OrientedVertex nV_base) : Nat :=
  warehouseVertexCapacity v - s.occ v

/-- Vacancy duality for warehouse: occ + vac = capacity. -/
theorem warehouse_vacancy_duality {nV_base nT : Nat}
    (s : WarehouseBAUState nV_base nT) (v : OrientedVertex nV_base)
    (h : s.occ v ≤ warehouseVertexCapacity v) :
    warehouseOccupancy s v + warehouseVacancy s v = warehouseVertexCapacity v := by
  simp [warehouseOccupancy, warehouseVacancy]
  omega

end MAPF.Warehouse
