import OpochLean4.FinalSourceCode.FirstVariationThreshold

/-
  FinalSourceCode — Present Support

  C_t is contained in U: the finite writable region of the whole.

  New axioms: 0
-/

namespace FinalSourceCode

open Autocompilation IndistinguishabilityEnergy

-- ════════════════════════════════════════════════════════════════
-- Present support properties
-- ════════════════════════════════════════════════════════════════

/-- Present support is contained in the whole. -/
theorem present_support_sub_whole (C : ConsciousSupport) :
    C.size ≤ C.capacity :=
  Autocompilation.present_support_sub_whole C

/-- Present support is finite in the witness sense: capacity is bounded. -/
theorem present_support_finite_in_witness_sense (C : ConsciousSupport) :
    C.capacity ≥ 1 :=
  C.capacity_pos

end FinalSourceCode
