import OpochLean4.FinalKernel.ContinuationLaw

/-
  Final Kernel — Halt Law

  h is a coordinate of the exact graph point.
  The halt flag IS determined by the state.

  New axioms: 0
-/

namespace FinalKernel

open FinalSourceCode Manifestability

theorem halt_law_exists (g : GoalCoordinate) :
    ∃ h : HaltFlag, h = haltOf g.target :=
  ⟨haltOf g.target, rfl⟩

theorem halt_law_unique (g : GoalCoordinate)
    (p1 p2 : FullPoint) (h1 : piGoal p1 = g) (h2 : piGoal p2 = g) :
    p1.halt = p2.halt :=
  (full_completion_point_unique g p1 p2 h1 h2).2.2.2

theorem halt_is_graph_coordinate (p : FullPoint) :
    p.halt = haltOf p.state :=
  p.halt_eq

end FinalKernel
