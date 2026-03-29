import OpochLean4.Foundations.RefinementAlgebra.LatentEnergyConservation

/-
  Refinement Algebra — Binary History (Rooted Ordered Refinement Trees)

  Histories are ROOTED ORDERED REFINEMENT TREES.
  Each node carries: (class code, channel, action, ΔS, ΔV)
  Children: the child classes after refinement, in canonical order.

  The total cost of a history = sum over all nodes = total action.
  This is the actual object of the weighted multicategory.

  New axioms: 0
-/

namespace RefinementAlgebra

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: History node
-- ════════════════════════════════════════════════════════════════

/-- A single node in a refinement history.
    Carries all operational fields for one refinement step. -/
structure HistoryNode where
  /-- Binary code of the source class -/
  sourceCode : List Bool
  /-- Channel identifier -/
  channel : Nat
  /-- Action cost A(e) -/
  action : Nat
  /-- Entropy drop ΔS(e) -/
  entropyDrop : Nat
  /-- Value gain ΔV(e) -/
  valueGain : Nat
  /-- Number of children (arity) -/
  arity : Nat
  /-- Arity is at least 1 (nontrivial split) -/
  arity_pos : arity ≥ 1

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Refinement history tree
-- ════════════════════════════════════════════════════════════════

/-- A refinement history: rooted ordered tree.
    Leaves are fully resolved classes (singletons).
    Nodes carry the full operational record. -/
inductive HistoryTree where
  /-- A leaf: fully resolved class (no further refinement). -/
  | leaf : List Bool → HistoryTree
  /-- A node: refinement step with ordered children. -/
  | node : HistoryNode → List HistoryTree → HistoryTree

-- Total action of a history tree (sum of all node actions).
mutual
  def HistoryTree.totalAction : HistoryTree → Nat
    | .leaf _ => 0
    | .node nd children => nd.action + historyChildrenAction children

  def historyChildrenAction : List HistoryTree → Nat
    | [] => 0
    | t :: ts => t.totalAction + historyChildrenAction ts
end

-- Total entropy drop of a history tree.
mutual
  def HistoryTree.totalEntropyDrop : HistoryTree → Nat
    | .leaf _ => 0
    | .node nd children => nd.entropyDrop + historyChildrenEntropyDrop children

  def historyChildrenEntropyDrop : List HistoryTree → Nat
    | [] => 0
    | t :: ts => t.totalEntropyDrop + historyChildrenEntropyDrop ts
end

-- Number of nodes in a history tree (depth of refinement).
mutual
  def HistoryTree.nodeCount : HistoryTree → Nat
    | .leaf _ => 0
    | .node _ children => 1 + historyChildrenNodeCount children

  def historyChildrenNodeCount : List HistoryTree → Nat
    | [] => 0
    | t :: ts => t.nodeCount + historyChildrenNodeCount ts
end

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: History properties
-- ════════════════════════════════════════════════════════════════

/-- History is well-defined: leaf action is zero. -/
theorem binary_history_leaf_action (code : List Bool) :
    (HistoryTree.leaf code).totalAction = 0 := rfl

/-- History cost is the tree sum: each node contributes its action. -/
theorem history_cost_is_tree_sum (nd : HistoryNode) (children : List HistoryTree) :
    (HistoryTree.node nd children).totalAction =
    nd.action + historyChildrenAction children := rfl

/-- History action is non-negative. -/
theorem history_action_nonneg (t : HistoryTree) :
    t.totalAction ≥ 0 :=
  Nat.zero_le _

/-- A single-step history has action = node action. -/
theorem single_step_action (nd : HistoryNode) :
    (HistoryTree.node nd []).totalAction = nd.action := by
  simp [HistoryTree.totalAction, historyChildrenAction]

/-- Node count is non-negative. -/
theorem history_nodeCount_nonneg (t : HistoryTree) :
    t.nodeCount ≥ 0 :=
  Nat.zero_le _

end RefinementAlgebra
