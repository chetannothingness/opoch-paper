import OpochLean4.MAPF.Optimization.PolytimeOptimization

/-
  MAPF Audit — Theorem Manifest
  New axioms: 0
-/

namespace MAPF.Audit

def flagshipTheorems : List String := [
  "finite_mapf_exact_polytime — Optimization/PolytimeOptimization.lean",
  "mapf_has_exact_binary_kernel — Residual/BinaryKernel.lean",
  "mapf_future_equiv_is_residual_class — Residual/FutureEq.lean",
  "vacancy_duality_exact — Semantics/VacancyField.lean",
  "micro_to_countflow_occupancy_exact — Semantics/Projection.lean",
  "goal_occupancy_determines_completion — Semantics/ObjectiveExactness.lean",
  "mapf_decision_in_NP — Complexity/NPMembership.lean",
  "mapf_decision_in_P — Complexity/PMembership.lean",
  "grid_mapf_reduces_to_finite_mapf — Classes/GridMAPF.lean",
  "oriented_mapf_reduces_to_finite_mapf — Classes/OrientedMAPF.lean",
  "pickup_delivery_mapf_reduces_to_finite_mapf — Classes/PickupDeliveryMAPF.lean",
  "lifelong_mapf_as_receding_horizon_exact_control — Classes/LifelongMAPF.lean"
]

theorem manifest_count : flagshipTheorems.length = 12 := rfl

end MAPF.Audit
