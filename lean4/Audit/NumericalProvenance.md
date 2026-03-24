# Numerical Provenance

Every concrete number appearing in the Opoch formalization, with full provenance.
All values are theorem-forced from the seed (which is derived from bottom) unless marked normalization-fixed.

---

## Provenance Table

| Quantity | Value | Theorem | File | Status |
|----------|-------|---------|------|--------|
| Spatial dimension | 3 | `spatial_dimension_is_three` | Dimensionality.lean | theorem-forced |
| Temporal dimension | 1 | `time_monotone` | Time.lean | theorem-forced |
| U(1) gauge dim | 1 | `u1Dim` | SplitLaw.lean | theorem-forced |
| SU(2) gauge dim | 3 | `suDim 2` | SplitLaw.lean | theorem-forced |
| SU(3) gauge dim | 8 | `suDim 3` | SplitLaw.lean | theorem-forced |
| Total physical dim | 16 | `physical_dim_is_sixteen` | PhysicalDefect.lean | theorem-forced |
| Temporal block entry | 2 | `temporal_eigen` | BlockEigenvalues.lean | theorem-forced |
| Spatial Laplacian diag | 2 | `laplacian_constant_eigenpair` | EigenHelpers.lean | theorem-forced |
| Spatial Laplacian off | -1 | `laplacian_nonconstant_mode` | SpatialPropagator.lean | theorem-forced |
| Gauge block entry | 1 | `gauge_eigenpairs` | BlockEigenvalues.lean | theorem-forced |
| Temporal eigenvalue | 2 | `temporalEigenPair` | BlockEigenvalues.lean | theorem-forced |
| Spatial eigenvalues | 0, 3, 3 | `spatialConstantEigenPair`, `spatialNonconstantEigenPair` | BlockEigenvalues.lean | theorem-forced |
| Gauge eigenvalue | 1 | `u1EigenPair` / `su2EigenPair` / `su3EigenPair` | BlockEigenvalues.lean | theorem-forced |
| Unstable dim | 1 | `time_from_unstable_direction` | PhysicalSpectralSplit.lean | theorem-forced |
| Center dim | 13 | `forces_from_center_sector` | PhysicalSpectralSplit.lean | theorem-forced |
| Stable dim | 2 | `space_from_stable_modes` | PhysicalSpectralSplit.lean | theorem-forced |
| SU(2) center order | 2 | `su2_center_Z2` | ChargeQuantization.lean | theorem-forced |
| SU(3) center order | 3 | `su3_triality_Z3` | ChargeQuantization.lean | theorem-forced |
| Vacuum trace (renorm) | 6 | `renormalized_vacuum_trace` | VacuumCurvature.lean | theorem-forced |
| Lambda numerator | 6 | `vacuum_curvature_invariant` | VacuumCurvature.lean | theorem-forced |
| Lambda denominator | 16 | `vacuum_curvature_invariant` | VacuumCurvature.lean | theorem-forced |
| hbar* | 1 | `seed_unit_normalization` | Normalization.lean | normalization-fixed |
| c* | 1 | `seed_unit_normalization` | Normalization.lean | normalization-fixed |
| Spectral gap | 1 | `spectral_gap_value` | PhysicalComplexity.lean | theorem-forced |

---

## Status Key

- **theorem-forced**: Value is uniquely determined by the derivation chain from bottom. No freedom.
- **normalization-fixed**: Value is fixed by the seed-natural unit convention. The convention itself is forced (one must normalize); the choice hbar* = c* = 1 is the canonical one.

## Provenance Chain

Every theorem-forced value traces through:

```
bottom --> N1-N5 --> A0star --> witness structure --> carrier/encoding
  --> gauge + time + quotient --> geometry + C*-algebra
    --> split law (1+3+8) --> seed existence/uniqueness
      --> defect space (dim 16) --> block diagonalization
        --> eigenvalue extraction --> all numbers
```

No value is inserted by hand. No value depends on empirical measurement.
The two normalization-fixed values (hbar*, c*) are unit choices, not physical content.

## Completeness

The `all_entries_classified` theorem in ExtractionAudit.lean and `parameter_audit_complete` in ParameterAudit.lean jointly certify that this table is exhaustive: every numerical quantity appearing in the formalization is accounted for, and every entry is either theorem-forced or normalization-fixed.
