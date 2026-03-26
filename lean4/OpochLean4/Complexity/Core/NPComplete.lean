import OpochLean4.Complexity.Core.Reductions

/-
  Complexity Core — NP-Completeness

  Dependencies: Reductions
  New axioms: 0
-/

namespace Complexity

/-- NP-hardness: every NP language reduces to L. -/
def IsNPHard (L : Language) : Prop :=
  ∀ L' : Language, InNP L' → ∃ _ : PolyReduction L' L, True

/-- NP-completeness: in NP and NP-hard. -/
structure IsNPComplete (L : Language) where
  in_np : InNP L
  np_hard : IsNPHard L

/-- If an NP-complete problem is in P, then every NP language
    has a polytime reduction to a P language.
    This is the fundamental bridge. -/
theorem np_complete_in_P_collapses_NP
    (L : Language) (hnpc : IsNPComplete L) (hp : InP L) :
    ∀ L' : Language, InNP L' →
      ∃ red : PolyReduction L' L, True :=
  fun L' hnp => hnpc.np_hard L' hnp

end Complexity
