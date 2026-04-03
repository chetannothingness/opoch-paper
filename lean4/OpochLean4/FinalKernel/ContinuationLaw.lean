import OpochLean4.FinalKernel.FullCompletionPoint

/-
  Final Kernel — Continuation Law

  Γ is a coordinate of the exact graph point, not searched afterward.
  The next action IS head(Γ).

  New axioms: 0
-/

namespace FinalKernel

open FinalSourceCode Manifestability

theorem continuation_exists (g : GoalCoordinate) :
    ∃ gamma : Continuation, gamma = continuationOf g.target :=
  ⟨continuationOf g.target, rfl⟩

theorem continuation_unique (g : GoalCoordinate)
    (p1 p2 : FullPoint) (h1 : piGoal p1 = g) (h2 : piGoal p2 = g) :
    p1.cont = p2.cont :=
  (full_completion_point_unique g p1 p2 h1 h2).2.2.1

theorem next_action_is_head_of_continuation (p : FullPoint) :
    p.cont = continuationOf p.state :=
  p.cont_eq

end FinalKernel
