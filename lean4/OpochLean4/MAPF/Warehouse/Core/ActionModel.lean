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

-- ════════════════════════════════════════════════════════════════
-- TICK-EXACT OPERATORS
-- ════════════════════════════════════════════════════════════════

/-
  The actual LoRR tick is three operations composed:
    tick_step = reveal ∘ complete ∘ move

  A0* forces this: a refinement event (task completion) and its
  consequence (reveal of new task) are one atomic transition.
  You cannot complete without immediately revealing — that would
  mean reality holds a distinction (completion) without its
  consequence (reveal), violating A0*.

  These three sub-steps are:
  1. stepMove: apply count-flow action (occupancy changes, phases unchanged)
  2. stepComplete: check occupancy at target cells → LockedLeg1 → Completed
  3. stepReveal: replace Completed tasks with new Free tasks from template stream

  The composition is the exact warehouse BAU tick operator.
-/

/-- Step 1: Move — apply count-flow action.
    Occupancy changes according to flow. Task phases unchanged by movement.
    This is the existing applyWarehouseAction. -/
abbrev stepMove {nV_base nT : Nat}
    (s : WarehouseBAUState nV_base nT)
    (a : WarehouseBAUAction nV_base) : WarehouseBAUState nV_base nT :=
  applyWarehouseAction s a

/-- Step 2: Complete — check occupancy at target cells.
    Tasks in LockedLeg1 whose target has occupancy > 0 transition to Completed.
    This is a count-level operation: occupancy at target → phase transition.
    No robot identity needed.

    The targets parameter maps each task to its target oriented vertex.
    In practice this comes from the task pool (not from robot-task binding). -/
def stepComplete {nV_base nT : Nat}
    (s : WarehouseBAUState nV_base nT)
    (targets : Fin nT → OrientedVertex nV_base) : WarehouseBAUState nV_base nT where
  occ := s.occ
  taskPhases := fun t =>
    match s.taskPhases t with
    | .locked_leg1 =>
      -- Complete if there is occupancy at the target vertex
      if s.occ (targets t) > 0 then .completed else .locked_leg1
    | other => other

/-- Step 3: Reveal — replace Completed tasks with new Free tasks.
    This is the window transition: completed tasks leave the pool,
    new templates enter as Free.

    A0* forces this to be immediate: the refinement event (completion)
    and its consequence (reveal) are one atomic transition.

    The reveal count parameter specifies how many tasks to reveal
    (limited by available templates). -/
def stepReveal {nV_base nT : Nat}
    (s : WarehouseBAUState nV_base nT)
    (revealCount : Nat) : WarehouseBAUState nV_base nT where
  occ := s.occ
  taskPhases := fun t =>
    if s.taskPhases t = .completed then
      -- Replace with Free (new template enters the pool)
      -- revealCount > 0 means templates are available
      if revealCount > 0 then .free else .completed
    else s.taskPhases t

/-- The exact warehouse BAU tick operator.
    tick = reveal ∘ complete ∘ move

    This is the actual LoRR tick semantics:
    1. Move (apply count-flow action)
    2. Complete (check occupancy at targets, score)
    3. Reveal (refill pool to target level)

    A0*-forced: completion and reveal are one atomic refinement event. -/
def warehouseTickStep {nV_base nT : Nat}
    (s : WarehouseBAUState nV_base nT)
    (a : WarehouseBAUAction nV_base)
    (targets : Fin nT → OrientedVertex nV_base)
    (revealCount : Nat) : WarehouseBAUState nV_base nT :=
  stepReveal (stepComplete (stepMove s a) targets) revealCount

/-- Move preserves task phases. -/
theorem stepMove_preserves_phases {nV_base nT : Nat}
    (s : WarehouseBAUState nV_base nT)
    (a : WarehouseBAUAction nV_base) :
    (stepMove s a).taskPhases = s.taskPhases :=
  rfl

/-- Complete only advances phases forward (LockedLeg1 → Completed).
    No phase regresses. Lock irreversibility (I4) is preserved. -/
theorem stepComplete_no_regression {nV_base nT : Nat}
    (s : WarehouseBAUState nV_base nT)
    (targets : Fin nT → OrientedVertex nV_base)
    (t : Fin nT) :
    (stepComplete s targets).taskPhases t = .completed ∨
    (stepComplete s targets).taskPhases t = s.taskPhases t := by
  simp [stepComplete]
  split <;> simp_all
  split <;> simp_all

/-- Reveal only changes Completed → Free (new task replaces old).
    No other phase is affected. -/
theorem stepReveal_only_changes_completed {nV_base nT : Nat}
    (s : WarehouseBAUState nV_base nT)
    (revealCount : Nat)
    (t : Fin nT)
    (h : s.taskPhases t ≠ .completed) :
    (stepReveal s revealCount).taskPhases t = s.taskPhases t := by
  simp [stepReveal, h]

/-- The tick operator preserves occupancy from the move step.
    Complete and reveal don't change occupancy. -/
theorem warehouseTickStep_occ {nV_base nT : Nat}
    (s : WarehouseBAUState nV_base nT)
    (a : WarehouseBAUAction nV_base)
    (targets : Fin nT → OrientedVertex nV_base)
    (revealCount : Nat) :
    (warehouseTickStep s a targets revealCount).occ =
    (stepMove s a).occ := by
  simp [warehouseTickStep, stepReveal, stepComplete]

end MAPF.Warehouse
