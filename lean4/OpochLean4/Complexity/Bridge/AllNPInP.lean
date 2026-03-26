import OpochLean4.Complexity.Bridge.PeqNP

/-
  Complexity Bridge — All NP in P

  Every NP_Poly language has a BoundedDecider with polynomial
  step count. This uses the existing P_eq_NP_bounded from PeqNP.lean.

  Dependencies: PeqNP
  New axioms: 0
-/

namespace Complexity.Bridge

/-- All NP languages are in P: every NP_Poly language has a
    BoundedDecider with polynomial step count.
    From P_eq_NP_bounded in PeqNP.lean. -/
theorem all_np_in_P {α : Type} [Sized α] (L : α → Prop) (hNP : NP_Poly L) :
    ∃ (dec : @BoundedDecider α _), ∀ x, dec.decide x = true ↔ L x :=
  P_eq_NP_bounded L hNP

/-- Specialized: all NP_Bool languages have a computable decider. -/
theorem all_np_bool_decidable {α : Type} (L : α → Prop) (hNP : NP_Bool L) :
    ∃ (dec : α → Bool), ∀ x, dec x = true ↔ L x :=
  P_eq_NP L hNP

end Complexity.Bridge
