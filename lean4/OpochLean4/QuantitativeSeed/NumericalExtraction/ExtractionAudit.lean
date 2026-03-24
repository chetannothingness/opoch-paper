/-
  OpochLean4/QuantitativeSeed/NumericalExtraction/ExtractionAudit.lean

  Integrity audit for the numerical extraction layer.
  For each key theorem: verify accessibility + provide falsifiability witness.
  Dependencies: ALL NumericalExtraction files, ParameterAudit
  Assumptions: A0star only.
-/

import OpochLean4.QuantitativeSeed.NumericalExtraction.ParameterAudit

namespace QuantitativeSeed.NumericalExtraction.Audit

open ClosureDefect QuantitativeSeed

-- ═══════════════════════════════════════════════════════════════
-- AUDIT 1: physical_dim_is_sixteen
-- ═══════════════════════════════════════════════════════════════

/-- Audit: physical_dim_is_sixteen compiles and is accessible. -/
theorem audit_physical_dim_is_sixteen :
    physicalDimensions.total = 16 := physical_dim_is_sixteen

/-- Falsifiability: if spatial were 2 instead of 3, total would be 15, not 16. -/
theorem audit_dim_falsifiable :
    2 + 1 + 1 + 3 + 8 ≠ 16 := by decide

-- ═══════════════════════════════════════════════════════════════
-- AUDIT 2: physical_operator_selected_uniquely
-- ═══════════════════════════════════════════════════════════════

/-- Audit: physical_operator_selected_uniquely compiles. -/
theorem audit_physical_operator_selected_uniquely
    (L : LinearizedOperator) (bd₁ bd₂ : BlockDecomposition L) :
    bd₁.total_dim = bd₂.total_dim :=
  physical_operator_selected_uniquely L bd₁ bd₂

-- ═══════════════════════════════════════════════════════════════
-- AUDIT 3: block_structure_forced
-- ═══════════════════════════════════════════════════════════════

/-- Audit: block_structure_forced compiles. -/
theorem audit_block_structure_forced
    (L : LinearizedOperator) (bd : BlockDecomposition L) :
    L.dim = 16 := block_structure_forced L bd

-- ═══════════════════════════════════════════════════════════════
-- AUDIT 4: spatial_propagator_spectrum
-- ═══════════════════════════════════════════════════════════════

/-- Audit: spatial_propagator_spectrum compiles. -/
theorem audit_spatial_propagator_spectrum :
    classifyEigenvalue (spatialPropagatorEigenvalues ⟨0, by omega⟩) = .center ∧
    classifyEigenvalue (spatialPropagatorEigenvalues ⟨1, by omega⟩) = .stable ∧
    classifyEigenvalue (spatialPropagatorEigenvalues ⟨2, by omega⟩) = .stable :=
  spatial_propagator_spectrum

/-- Falsifiability: if propagator eigenvalue were 2 instead of 1,
    classification would be unstable, not center. -/
theorem audit_propagator_falsifiable :
    classifyEigenvalue 2 = .unstable := by decide

-- ═══════════════════════════════════════════════════════════════
-- AUDIT 5: temporal_is_unstable
-- ═══════════════════════════════════════════════════════════════

/-- Audit: temporal_is_unstable compiles. -/
theorem audit_temporal_is_unstable :
    classifyEigenvalue temporalEigenPair.eigenvalue = .unstable :=
  temporal_is_unstable

-- ═══════════════════════════════════════════════════════════════
-- AUDIT 6: gauge_is_center
-- ═══════════════════════════════════════════════════════════════

/-- Audit: gauge_is_center compiles. -/
theorem audit_gauge_is_center :
    classifyEigenvalue u1EigenPair.eigenvalue = .center ∧
    classifyEigenvalue su2EigenPair.eigenvalue = .center ∧
    classifyEigenvalue su3EigenPair.eigenvalue = .center :=
  gauge_is_center

-- ═══════════════════════════════════════════════════════════════
-- AUDIT 7: planck_relation
-- ═══════════════════════════════════════════════════════════════

/-- Audit: planck_relation compiles. -/
theorem audit_planck_relation :
    (massFromEigenvalue 0).massNormalized = 0 :=
  planck_relation 0

-- ═══════════════════════════════════════════════════════════════
-- AUDIT 8: charge_data_structure (Z × Z₂ × Z₃)
-- ═══════════════════════════════════════════════════════════════

/-- Audit: charge_data_structure compiles.
    Full charge data: Z × Z₂ × Z₃. -/
theorem audit_charge_data_structure :
    su2HolonomyGroup.order = 2 ∧ su3HolonomyGroup.order = 3 :=
  ⟨su2_center_Z2, su3_triality_Z3⟩

-- ═══════════════════════════════════════════════════════════════
-- AUDIT 9: cosmological_constant_from_vacuum_curvature
-- ═══════════════════════════════════════════════════════════════

/-- Audit: cosmological_constant_from_vacuum_curvature compiles. -/
theorem audit_cosmological_constant :
    cosmologicalLambda.lambda_numerator = vacuumCurvatureValue.numerator ∧
    cosmologicalLambda.lambda_denominator = vacuumCurvatureValue.denominator :=
  cosmological_constant_from_vacuum_curvature

-- ═══════════════════════════════════════════════════════════════
-- AUDIT 10: all_entries_classified
-- ═══════════════════════════════════════════════════════════════

/-- Audit: all_entries_classified compiles. -/
theorem audit_all_entries_classified :
    ∀ e ∈ allAuditedEntries,
      e.provenance = .theoremForced ∨
      e.provenance = .normalizationFixed ∨
      e.provenance = .toBeComputed :=
  all_entries_classified

end QuantitativeSeed.NumericalExtraction.Audit
