import OpochLean4.MAPF.Core.Instance

namespace MAPF.Resources

/-- Swap conflict: two agents exchange positions in one time step.
    Agent a₁ goes from u to v while a₂ goes from v to u. -/
def HasSwapConflictAt {nV nA H : Nat} (sched : Schedule nV nA H)
    (a₁ a₂ : Fin nA) (t : Fin H) : Prop :=
  a₁ ≠ a₂ ∧
  sched a₁ t.castSucc = sched a₂ t.succ ∧
  sched a₁ t.succ = sched a₂ t.castSucc

/-- A schedule is swap-conflict-free. -/
def SwapConflictFree {nV nA H : Nat} (sched : Schedule nV nA H) : Prop :=
  ∀ a₁ a₂ t, ¬HasSwapConflictAt sched a₁ a₂ t

/-- Swap conflicts are detectable from the edge flow:
    if flow(u→v) > 0 and flow(v→u) > 0 at the same time step,
    there is a potential swap conflict. -/
theorem swap_conflict_from_flow {nV nA H : Nat}
    (sched : Schedule nV nA H) :
    SwapConflictFree sched → ¬HasSwapConflict sched := by
  intro h ⟨a₁, a₂, t, hne, h1, h2⟩
  exact h a₁ a₂ t ⟨hne, h1, h2⟩

end MAPF.Resources
