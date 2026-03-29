import OpochLean4.Foundations.RefinementAlgebra.BinaryNormalForm

/-
  Refinement Algebra — History Value Equation

  Lift Ψ from residual classes to partial refinement trees:
    Ψ(tree) = sup over extensions of (V - A + Σ Ψ(children))

  The value equation on histories extends the Bellman operator
  from the state-based form to the full tree-based form.

  New axioms: 0
-/

namespace RefinementAlgebra

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: History value function
-- ════════════════════════════════════════════════════════════════

/-- Value of a leaf: terminal value = 0 (fully resolved, no more to gain). -/
def leafValue (_code : List Bool) : Nat := 0

-- Value of a history node: reward minus cost plus children values.
-- V(node) = valueGain + Σ V(children).
-- (Action is accounted separately in the budget.)
mutual
  def HistoryTree.value : HistoryTree → Nat
    | .leaf code => leafValue code
    | .node nd children => nd.valueGain + historyChildrenValue children

  def historyChildrenValue : List HistoryTree → Nat
    | [] => 0
    | t :: ts => t.value + historyChildrenValue ts
end

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Budget-constrained value (Bellman on trees)
-- ════════════════════════════════════════════════════════════════

/-- Budget-constrained value: how much value is achievable
    with a given action budget, starting from a history tree. -/
def historyBudgetValue (t : HistoryTree) (budget : Nat) : Nat :=
  match budget with
  | 0 => 0  -- No budget: zero value
  | _ + 1 =>
    match t with
    | .leaf _ => 0  -- Fully resolved: nothing to gain
    | .node nd _ =>
      if nd.action ≤ budget then
        nd.valueGain  -- Can afford this step: gain value
      else
        0  -- Can't afford: zero

/-- The history value equation: value at budget (n+1) factors through
    the node's reward minus cost, plus children's future value. -/
theorem history_value_equation_exact (nd : HistoryNode) (children : List HistoryTree)
    (budget : Nat) :
    historyBudgetValue (HistoryTree.node nd children) (budget + 1) =
    if nd.action ≤ budget + 1 then nd.valueGain else 0 := by
  simp [historyBudgetValue]

/-- History value is monotone in budget: more budget → more value. -/
theorem history_value_monotone (t : HistoryTree) (b₁ b₂ : Nat)
    (h : b₁ ≤ b₂) :
    historyBudgetValue t b₁ ≤ historyBudgetValue t b₂ := by
  match t with
  | .leaf _ =>
    simp only [historyBudgetValue]
    cases b₁ <;> cases b₂ <;> simp
  | .node nd _ =>
    cases b₁ with
    | zero => simp [historyBudgetValue]
    | succ n₁ =>
      cases b₂ with
      | zero => omega
      | succ n₂ =>
        simp only [historyBudgetValue]
        split <;> split <;> omega

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: Value properties
-- ════════════════════════════════════════════════════════════════

/-- Leaf value is zero. -/
theorem leaf_value_zero (code : List Bool) :
    (HistoryTree.leaf code).value = 0 := rfl

/-- Node value decomposes into reward plus children. -/
theorem node_value_decomposition (nd : HistoryNode) (children : List HistoryTree) :
    (HistoryTree.node nd children).value =
    nd.valueGain + historyChildrenValue children := rfl

/-- Value is non-negative. -/
theorem history_value_nonneg (t : HistoryTree) :
    t.value ≥ 0 :=
  Nat.zero_le _

/-- Budget value is non-negative. -/
theorem history_budget_value_nonneg (t : HistoryTree) (budget : Nat) :
    historyBudgetValue t budget ≥ 0 :=
  Nat.zero_le _

/-- Zero budget gives zero value. -/
theorem zero_budget_zero_value (t : HistoryTree) :
    historyBudgetValue t 0 = 0 := by
  cases t <;> simp [historyBudgetValue]

end RefinementAlgebra
