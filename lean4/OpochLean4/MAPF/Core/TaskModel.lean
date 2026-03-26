import OpochLean4.MAPF.Core.Instance

/-
  MAPF Core — Task Model

  Finite task automaton: each task has a source, destination,
  and states (idle, in_progress, completed).

  New axioms: 0
-/

namespace MAPF

-- ════════════════════════════════════════════════════════════════
-- Task phases
-- ════════════════════════════════════════════════════════════════

/-- Task phase: idle (not started), active (agent en route), completed (delivered). -/
inductive TaskPhase where
  | idle : TaskPhase
  | active : TaskPhase
  | completed : TaskPhase
deriving DecidableEq, Repr

/-- A task state: tracks the phase of each task. -/
def TaskState (nT : Nat) := Fin nT → TaskPhase

/-- Initial task state: all idle. -/
def initialTaskState (nT : Nat) : TaskState nT :=
  fun _ => .idle

/-- A task is completed in a state. -/
def taskCompleted {nT : Nat} (ts : TaskState nT) (task : Fin nT) : Bool :=
  match ts task with
  | .completed => true
  | _ => false

/-- Count of completed tasks. -/
def completedTaskCount {nT : Nat} (ts : TaskState nT) : Nat :=
  (List.range nT).foldl (fun acc i =>
    if h : i < nT then
      acc + (if taskCompleted ts ⟨i, h⟩ then 1 else 0)
    else acc) 0

-- ════════════════════════════════════════════════════════════════
-- Task completion check
-- ════════════════════════════════════════════════════════════════

/-- Check if an agent at a goal vertex completes a task. -/
def checkTaskCompletion {nV nT : Nat}
    (taskGoal : Fin nT → Vertex nV)
    (agentPos : Vertex nV) (task : Fin nT) : Bool :=
  agentPos == taskGoal task

/-- Update task state: if agent is at goal of an idle task, complete it. -/
def updateTaskState {nV nT : Nat}
    (taskGoal : Fin nT → Vertex nV)
    (ts : TaskState nT) (agentPos : Vertex nV) : TaskState nT :=
  fun task =>
    match ts task with
    | .idle => if checkTaskCompletion taskGoal agentPos task then .completed else .idle
    | other => other

end MAPF
