# Dependency Spine

The theorem DAG from bottom to concrete numbers.
Each node is a theorem or theorem cluster; arrows indicate logical dependency.

---

## Layer 0: Absolute Ground

```
                              bottom (False)
                                 |
                     +-----------+-----------+
                     |           |           |
                    N1          N2          N3
              (witnessability) (distinguishability) (finiteness)
                     |           |           |
                     +-----+-----+     +-----+
                           |           |
                          N4          N5
                    (self-reference) (completeness)
                           |           |
                           +-----+-----+
                                 |
                              A0star
                      (completed witnessability)
```

## Layer 1: Carrier and Encoding

```
                              A0star
                                 |
                     +-----------+-----------+
                     |                       |
              unary_no_distinctions    binary_minimal
                     |                       |
                     +-----+-----+-----------+
                           |
                     sd_injective
                  (prefix-free encoding)
                           |
                  prefix_free_unique
```

## Layer 2: Algebraic Structure

```
                     sd_injective
                           |
          +--------+-------+-------+--------+
          |        |               |        |
   truth_quotient  gauge_group  ledger    time_monotone
   _well_defined      _law    _irreversibility  |
          |        |               |     second_law
          +--------+-------+-------+
                           |
                    witness_path
                     algebra
```

## Layer 3: Geometry and Operator Algebra

```
                    witness_path_algebra
                           |
          +--------+-------+-------+--------+
          |        |       |       |        |
   fisher_metric  dirichlet conductance  cstar_from
    _positive    _form_closed _determined  _witnesses
          |        |       |       |        |
          +--------+--+----+       +--------+
                      |                     |
              inverse_limit_exists   born_rule_derived
                      |                     |
            j_squared_neg_id                |
              (Kahler)                      |
                      |                     |
                      +----------+----------+
                                 |
                   spatial_dimension_is_three (= 3)
```

## Layer 4: Physics — Split Law

```
                spatial_dimension_is_three
                           |
                  anomaly_forces_rank_3
                           |
                  gauge_dimension_derived
                     (1, 3, 8)
                           |
                      split_unique
                  U(1) x SU(2) x SU(3)
```

## Layer 5: Seed Existence and Uniqueness

```
                      split_unique
                           |
              +------------+------------+
              |            |            |
       defect_space   action_functional  holonomy
       _finite_dim    _has_minimizer    _trivial
              |            |            |
              +------+-----+------+-----+
                     |            |
          seed_unique_up_to_gauge |
                     |            |
              seed_is_fixed_point |
                     |            |
              normal_form_exists  |
                     |            |
              renormalization_finite
```

## Layer 6: Spectral Decomposition

```
              seed_is_fixed_point
                     |
          +----------+----------+
          |          |          |
   spectrum    spectral_split  linearization
   _nonempty   _exhaustive    _well_defined
          |          |          |
          +-----+----+----+----+
                |         |
     tangent_space    quantitative
     _identified       _closure
                |         |
                +----+----+
                     |
        dimensionless_observable_decomposition
                     |
              all_physics_from_seed
```

## Layer 7: Numerical Extraction — Dimension and Block Structure

```
              all_physics_from_seed
                     |
          +----------+----------+
          |                     |
   physical_dim_is_sixteen   block_diagonal
        (= 16)               _structure
          |                     |
          +----------+----------+
                     |
          +----------+----------+----------+
          |          |          |          |
     temporal   spatial    gauge     admissible
      block     block      block    _defect
      (1x1)     (3x3)    (12x12)  _characterized
```

## Layer 8: Eigenvalue Extraction

```
     temporal_block          spatial_block            gauge_block
          |                       |                        |
   temporal_eigen (=2)    +-------+-------+         gauge_eigenpairs (=1)
          |               |               |                |
   temporalEigenPair  laplacian_     laplacian_       u1/su2/su3
        (=2)        constant_    nonconstant_       EigenPair (=1)
                    eigenpair(=2)  mode(=-1)
                         |               |
                  spatialConstant  spatialNonconstant
                  EigenPair (=0)   EigenPair (=3,3)
```

## Layer 9: Physical Spectral Split

```
          temporalEigenPair    spatialEigenPairs    gaugeEigenPairs
                |                     |                   |
                +----------+----------+----------+--------+
                           |
              physical_spectral_split
                           |
          +----------------+----------------+
          |                |                |
   temporal_is_unstable  space_from    gauge_is_center
   (unstable dim = 1)   _stable_modes  (center dim = 13)
                        (stable dim = 2)
```

## Layer 10: Charges, Constants, and Closure

```
          gauge_is_center (dim 13)
                |
       +--------+--------+
       |                  |
  su2_center_Z2     su3_triality_Z3
  (order = 2)       (order = 3)
       |                  |
  charge_data_structure   |
       |                  |
       +--------+---------+
                |
   vacuum_curvature_invariant
   (numerator = 6, denominator = 16)
                |
   renormalized_vacuum_trace (= 6)
                |
   cosmological_constant_derived (= 6/16)
                |
       +--------+---------+
       |                  |
  spectral_gap_value  seed_unit_normalization
       (= 1)          (hbar* = c* = 1)
                          |
               all_entries_classified
               parameter_audit_complete
```

---

## Summary

```
Layer 0:  bottom --> N1-N5 --> A0star                     (from nothing)
Layer 1:  carrier, binary encoding                        (alphabet forced)
Layer 2:  gauge, time, entropy, truth quotient            (algebra forced)
Layer 3:  metric, Kahler, C*-algebra, Born rule           (geometry forced)
Layer 4:  dim=3, anomaly --> U(1)xSU(2)xSU(3)            (physics forced)
Layer 5:  seed existence, uniqueness, fixed point         (seed forced)
Layer 6:  spectral decomposition, quantitative closure    (spectrum forced)
Layer 7:  dim=16, block diagonalization                   (blocks forced)
Layer 8:  eigenvalues: 2, 0, 3, 3, 1, 1, 1               (numbers forced)
Layer 9:  spectral split: 1 unstable, 2 stable, 13 center (partition forced)
Layer 10: charges, Lambda=6/16, gap=1, hbar*=c*=1         (closure forced)
```

Total depth: 10 layers from bottom to final numbers. Zero free parameters at any layer.
