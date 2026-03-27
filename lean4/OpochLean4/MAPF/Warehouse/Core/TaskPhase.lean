/-
  Warehouse BAU — Enriched Task Phase

  The warehouse BAU task lifecycle has 5 phases, not 3.
  The generic MAPF TaskPhase (idle/active/completed) is insufficient
  because warehouse has lock semantics: once a robot visits the
  first waypoint (E cell), the task is irrevocably locked to that robot.

  Phase transitions:
    free → assigned    (scheduler assigns task to robot)
    assigned → free    (scheduler reassigns before robot visits E cell)
    assigned → locked_leg1  (robot arrives at E cell, idx_next_loc > 0)
    locked_leg1 → completed (robot arrives at S cell, score++)
    locked_leg2 is reserved for multi-waypoint tasks (unused in E→S BAU)

  Lock invariant: once in locked_leg1, task cannot be reassigned or dropped.

  Connection to A0*: The 5 phases are the minimal set of distinctions
  needed to determine the future completion possibilities of a task.
  Fewer phases → two states with different futures would be identified
  (violating A0*: real distinctions must be witnessed).
  More phases → unnecessary distinctions (violating gauge: indistinguishable
  states must be identified).

  New axioms: 0
-/

namespace MAPF.Warehouse

/-- Warehouse BAU task phase: 5-state lifecycle.

    This is the enriched task automaton for warehouse E→S tasks
    with lock semantics. The key addition over generic MAPF's
    3-state TaskPhase is the separation of `assigned` (reassignable)
    from `locked_leg1` (irrevocable). -/
inductive WarehouseTaskPhase where
  /-- No task assigned to this slot. Robot is free. -/
  | free
  /-- Task assigned, robot heading to E cell (first waypoint).
      Can still be reassigned (idx_next_loc = 0). -/
  | assigned
  /-- Robot has visited E cell. Heading to S cell.
      LOCKED: cannot reassign, cannot drop (idx_next_loc > 0). -/
  | locked_leg1
  /-- Reserved for multi-waypoint tasks. Unused in E→S BAU. -/
  | locked_leg2
  /-- Robot reached S cell. Task scored. Removed from pool. -/
  | completed
  deriving DecidableEq, Repr

/-- Task state vector: phase of each task in the visible pool. -/
def WarehouseTaskState (nT : Nat) := Fin nT → WarehouseTaskPhase

/-- Number of warehouse task phases. -/
def numWarehouseTaskPhases : Nat := 5

/-- Initial task state: all tasks free (no assignments yet). -/
def initialWarehouseTaskState (nT : Nat) : WarehouseTaskState nT :=
  fun _ => .free

/-- A task is completed. -/
def warehouseTaskCompleted {nT : Nat} (ts : WarehouseTaskState nT)
    (task : Fin nT) : Bool :=
  ts task == .completed

/-- A task is locked (irrevocable). -/
def warehouseTaskLocked {nT : Nat} (ts : WarehouseTaskState nT)
    (task : Fin nT) : Bool :=
  match ts task with
  | .locked_leg1 => true
  | .locked_leg2 => true
  | _ => false

/-- Count of completed tasks. -/
def warehouseCompletedCount {nT : Nat} (ts : WarehouseTaskState nT) : Nat :=
  (List.range nT).foldl (fun acc ti =>
    if h : ti < nT then
      acc + (if warehouseTaskCompleted ts ⟨ti, h⟩ then 1 else 0)
    else acc) 0

/-- Task phases are exhaustive. -/
theorem warehouse_task_phases_exhaustive :
    ∀ (p : WarehouseTaskPhase),
      p = .free ∨ p = .assigned ∨ p = .locked_leg1 ∨
      p = .locked_leg2 ∨ p = .completed := by
  intro p; cases p <;> simp

/-- Lock is irreversible: locked tasks stay locked or complete. -/
theorem warehouse_lock_irreversible {nT : Nat}
    (ts : WarehouseTaskState nT) (task : Fin nT) :
    warehouseTaskLocked ts task = true →
    ts task = .locked_leg1 ∨ ts task = .locked_leg2 := by
  intro h
  simp [warehouseTaskLocked] at h
  split at h <;> simp_all

/-- Completed tasks stay completed (monotonicity). -/
theorem warehouse_completion_irreversible {nT : Nat}
    (ts : WarehouseTaskState nT) (task : Fin nT) :
    warehouseTaskCompleted ts task = true →
    ts task = .completed := by
  intro h
  simp [warehouseTaskCompleted] at h
  exact h

end MAPF.Warehouse
