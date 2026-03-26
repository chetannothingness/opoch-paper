# Formalization Map

This file maps paper claims to Lean 4 modules and theorem names.
It mirrors Appendix E (Formalization and Artifacts) of the paper.

## Build

```bash
cd lean4 && lake build
# Expected: "Build completed successfully." (3884 modules)
```

## Counts

| Metric | Value |
|--------|-------|
| Lean files | 78 |
| Files | 140 |
| sorry | 0 |
| admit | 0 |
| Axioms | 1 (A0*, forward direction derived from nothingness) |
| Lean version | 4.14.0 |
| Mathlib version | v4.14.0 |

## Dependency Root

All 76 operational files trace back to `Manifest/Nothingness.lean`.
74 flow through `Manifest/Axioms.lean` (A0*).
2 disconnected: `Basic.lean` (utility), `MathlibBridge.lean` (independent mathlib verification).

## Map

### Foundation (Layer 0-1)

| Paper Claim | Lean Module | Key Theorems |
|-------------|------------|--------------|
| Nothingness conditions | Manifest/Nothingness | `N0_no_external_verifier`, `N0_clock_invariance` |
| N1-N5 necessity lemmas | Foundations/EndogenousMeaning | `N1_external_reduces_to_endogenous` through `N5_labels_require_witnesses`, `S0_whole_atemporal` |
| A0* (one axiom) | Manifest/Axioms | `A0star` |
| W1-W8 witness properties | Foundations/WitnessStructure | `W1_finite`, `W2_replayable`, `real_has_admissible` |

### Carrier, Encoding, Algebra (Steps 1-7)

| Paper Claim | Lean Module | Key Theorems |
|-------------|------------|--------------|
| Binary carrier forced | Foundations/FiniteCarrier | `unary_no_distinctions` |
| Self-delimiting syntax | Foundations/PrefixFree | `sd_injective` |
| Truth quotient | Algebra/TruthQuotient | `Q1_real_quotient_invariant` |
| Gauge group laws | Algebra/Gauge | `gauge_inverse`, `gaugeBij_comp_inv`, `gaugeBij_inv_comp` |
| Ordered ledger, Diamond Law | Algebra/OrderedLedger | `diamond_law`, `append_preserves` |

### Time, Entropy, Control (Steps 8-18)

| Paper Claim | Lean Module | Key Theorems |
|-------------|------------|--------------|
| Irreversible time | Algebra/Time | `time_monotone`, `append_increases_time` |
| Second law | Algebra/Entropy | `second_law`, `budget_exhaustion` |
| Bellman minimax | Control/Bellman | `budget_decreases`, `value_deterministic` |
| Regime partition | Control/RegimeSplit | `regimes_disjoint`, `regimes_exhaustive` |
| Pi-consistency | Control/PiConsistency | `gauge_is_piConsistent` |

### Execution (Steps 19-25)

| Paper Claim | Lean Module | Key Theorems |
|-------------|------------|--------------|
| Self-hosting | Execution/SelfHosting | `fixed_point`, `self_hosting_all_unique` |
| Closure-defect | Execution/ClosureDefect | `witness_step_monotone`, `residue_all_open` |
| Consciousness (C1-C4) | Execution/Consciousness | `c1_necessary` through `c4_necessary`, `minimal_cost_unique` |
| Trit field | Execution/TritField | `trit_exhaustive`, `trit_partition` |

### Geometry (Steps 26-33)

| Paper Claim | Lean Module | Key Theorems |
|-------------|------------|--------------|
| Conductance w = C/d^2 | Geometry/ConductanceLemma | `conductance_determined`, `conductance_unique`, `conductance_exponent_derived` |
| n = 3 spatial | Geometry/Dimensionality | `spatial_dimension_is_three`, `two_fails_matching`, `four_fails_matching`, `unique_spatial_dimension` |
| Dirichlet form | Geometry/DirichletForm | `dirichlet_axioms_hold` |
| Fisher metric | Geometry/FisherMetric | `spd_symm`, `spd_refl` |
| J^2 = -I | Geometry/KahlerProof | `j_squared_neg_id`, `j_preserves_metric` |
| Unique decomposition | Geometry/WitnessGenerator | `decomp_unique`, `kahler_2d`, `kahler_4d` |

### Operator Algebra

| Paper Claim | Lean Module | Key Theorems |
|-------------|------------|--------------|
| C*-algebra | OperatorAlgebra/WitnessStarAlgebra | `cstar_norm`, `wit_star_star`, `unit_unique_from_laws` |
| Mathlib bridge | OperatorAlgebra/MathlibBridge | `born_probability_nonneg`, `triangle_ineq_complex`, `star_involutive_complex` |
| Born rule | OperatorAlgebra/BornRule | `born_additivity`, `born_normalization` |
| C*-ring confirmed | OperatorAlgebra/CstarProof | `cstar_identity_matches_mathlib` |

### Physics

| Paper Claim | Lean Module | Key Theorems |
|-------------|------------|--------------|
| Split law | Physics/SplitLaw | `split_unique`, `hamiltonian_is_bijective`, `dissipative_monotone` |
| Gauge group derived | Physics/SplitLaw | `kahler_forces_rank_ge_1`, `spin_rank_from_dimension`, `anomaly_forces_rank_3`, `gauge_dimension_derived` |
| Falsifiable predictions | Physics/Predictions | `P1_inverse_square_flux`, `P2_order_matters`, `P3_dimensionality_forced` |

### Quantitative Seed

| Paper Claim | Lean Module | Key Theorems |
|-------------|------------|--------------|
| Seed existence | QSeed/SeedExistence | `exists_action_minimizer`, `seedDefect_action` |
| Seed uniqueness | QSeed/SeedExistence | `seed_unique_up_to_gauge` |
| Renormalization fixed point | QSeed/Renormalization | `seed_is_fixed_point` |
| Self-retaining stability | QSeed/SelfRetainingDefect | `self_retaining_stable` |
| Observable decomposition | QSeed/QuantitativeClosure | `dimensionless_observable_decomposition` |
| All physics from seed | QSeed/PhysicsRealizationFromSeed | `all_physics_from_seed` |

### Numerical Extraction (20 files)

| Paper Claim | Lean Module | Key Theorems |
|-------------|------------|--------------|
| Physical dim = 16 | NE/PhysicalDefect | `physical_dim_is_sixteen` |
| Physical seed exists | NE/AdmissibleDefect | `physical_seed_exists`, `physical_seed_unique` |
| Block-diagonal L* | NE/BlockDiagonal | `physicalLstar_block_diagonal`, `block_offsets_sum` |
| Temporal eigenvalue = 2 | NE/BlockEigenvalues | `temporalEigenPair` (native_decide) |
| Spatial eigenvalues 0,3,3 | NE/BlockEigenvalues | `spatialConstantEigenPair`, `spatialNonconstantEigenPair` (native_decide) |
| Gauge eigenvalue = 1 | NE/BlockEigenvalues | `u1EigenPair`, `su2EigenPair`, `su3EigenPair` (native_decide) |
| Spectral split 1+13+2=16 | NE/PhysicalSpectralSplit | `time_from_unstable_direction`, `forces_from_center_sector`, `space_from_stable_modes` |
| Lambda = 6/16 | NE/CosmologicalConstant | `vacuum_curvature_invariant`, `lambda_positive` |
| Charges Z x Z2 x Z3 | NE/ChargeQuantization | `u1_integer_charge_lattice`, `su2_center_Z2`, `su3_triality_Z3` |
| hbar* = c* = 1 | NE/Normalization | `seed_unit_normalization`, `normalization_does_not_add_content` |
| All entries classified | NE/ParameterAudit | `all_entries_classified`, `no_hidden_choices`, `no_empirical_inputs` |
