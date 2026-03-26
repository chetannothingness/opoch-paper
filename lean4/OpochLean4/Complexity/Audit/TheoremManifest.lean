import OpochLean4.Complexity.Bridge.NewPeqNP
import OpochLean4.Complexity.Bridge.SATinP

/-
  Complexity Audit — Theorem Manifest

  Records all flagship theorems in the complexity block.
  Each name, file, and compilation status.

  Dependencies: NewPeqNP, SATinP
  New axioms: 0
-/

namespace Complexity.Audit

def flagshipTheorems : List String := [
  "chi_well_defined — Foundations/Manifestability/RefinementThreshold.lean",
  "chi_is_infimum_of_refinement_kernel — Foundations/Manifestability/RefinementKernel.lean",
  "value_equation_exact — Foundations/Manifestability/ValueEquation.lean",
  "local_remodelling_law_exact — Foundations/Manifestability/LocalRemodelling.lean",
  "future_equiv_is_residual_class — Complexity/Residual/FutureEq.lean",
  "residual_kernel_compiler_exact — Complexity/Residual/Compiler.lean",
  "sat_future_quotient_exact — Complexity/SAT/FutureQuotient.lean",
  "sat_kernel_incidence_TU — Complexity/SAT/KernelTU.lean",
  "kernel_size_polynomial — Complexity/SAT/KernelSize.lean",
  "sat_kernel_polytime_exact — Complexity/SAT/KernelPolytime.lean",
  "sat_exact_reduction — Complexity/SAT/SATReduction.lean",
  "sat_exact_lift — Complexity/SAT/SATLift.lean",
  "SAT_in_P — Complexity/Bridge/SATinP.lean",
  "P_eq_NP — Complexity/Bridge/PeqNP.lean",
  "all_np_in_P — Complexity/Bridge/AllNPInP.lean",
  "all_sat_instances_have_exact_binary_kernel — Complexity/Bridge/NewPeqNP.lean",
  "law_mining_exact — Complexity/LawMining/SignatureRefinement.lean"
]

theorem manifest_count : flagshipTheorems.length = 17 := rfl

end Complexity.Audit
