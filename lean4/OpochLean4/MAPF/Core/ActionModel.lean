import OpochLean4.MAPF.Core.Instance

/-
  MAPF Core — Action Model

  Finite action alphabet. Each action moves an agent from one
  vertex to an adjacent vertex (or waits).

  New axioms: 0
-/

namespace MAPF

-- ════════════════════════════════════════════════════════════════
-- Actions
-- ════════════════════════════════════════════════════════════════

/-- An action in the MAPF: either wait or move to a specific neighbor. -/
inductive Action (nV : Nat) where
  | wait : Action nV
  | moveTo : Vertex nV → Action nV
deriving DecidableEq

/-- Apply an action: returns the new vertex if valid, or the same vertex if wait. -/
def applyAction {nV : Nat} (G : FiniteGraph nV) (v : Vertex nV) : Action nV → Vertex nV
  | .wait => v
  | .moveTo u => if G.adj v u = true then u else v

/-- An action is valid from vertex v if it leads to an adjacent vertex. -/
def actionValid {nV : Nat} (G : FiniteGraph nV) (v : Vertex nV) (a : Action nV) : Prop :=
  G.adj v (applyAction G v a) = true

/-- Wait is always valid (by self-adjacency). -/
theorem wait_valid {nV : Nat} (G : FiniteGraph nV) (v : Vertex nV) :
    actionValid G v (.wait) := by
  simp [actionValid, applyAction, G.self_adj]

/-- Action cost: default 1 for moves, 0 for wait. -/
def actionCost {nV : Nat} : Action nV → Nat
  | .wait => 0
  | .moveTo _ => 1

-- ════════════════════════════════════════════════════════════════
-- Action sequence
-- ════════════════════════════════════════════════════════════════

/-- An action plan: H actions for each of nA agents. -/
def ActionPlan (nV nA H : Nat) := Fin nA → Fin H → Action nV

/-- Convert an action plan to a schedule (compute positions from actions). -/
def planToSchedule {nV nA H : Nat} (G : FiniteGraph nV)
    (starts : Fin nA → Vertex nV) (plan : ActionPlan nV nA H) : Schedule nV nA H :=
  fun a t => (List.range t.val).foldl
    (fun pos step =>
      if h : step < H then applyAction G pos (plan a ⟨step, h⟩) else pos)
    (starts a)

/-- Total cost of an action plan. -/
def planCost {nV nA H : Nat} (plan : ActionPlan nV nA H) : Nat :=
  (List.range nA).foldl (fun acc ai =>
    if h : ai < nA then
      acc + (List.range H).foldl (fun acc2 ti =>
        if h2 : ti < H then acc2 + actionCost (plan ⟨ai, h⟩ ⟨ti, h2⟩) else acc2) 0
    else acc) 0

end MAPF
