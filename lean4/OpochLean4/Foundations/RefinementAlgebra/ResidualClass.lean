import OpochLean4.Foundations.Manifestability.RefinementThreshold

/-
  Refinement Algebra — Residual Class (bridge)

  Re-exports UnresolvedClass, ResidualClass, entropy, χ
  from the existing Manifestability block.

  New axioms: 0
-/

namespace RefinementAlgebra

-- Re-export core types
open Manifestability

abbrev RClass := ResidualClass
abbrev UClass := UnresolvedClass
abbrev WChannel := WitnessChannel
abbrev RThreshold := RefinementThreshold

end RefinementAlgebra
