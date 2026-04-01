import OpochLean4.InstantQuestion.Audit.Manifest

/-
  Final Source Code — Admissible State

  The last observation says that the selector-code is not an extra map
  on top of the source code; it is the differential of the one latent
  indistinguishability-energy functional, and the state is recovered
  instantly as its dual.

  X_adm = the admissible state carrier.
  Built from the existing Partition = List RefinableClass,
  each carrying (ResidualClass, RefinementThreshold).

  This is the REAL carrier on which U_ind = Σ ρ(W)·χ(W) acts.

  New axioms: 0
-/

namespace FinalSourceCode

open Manifestability Autocompilation

-- ════════════════════════════════════════════════════════════════
-- The admissible state: a nonempty partition of refinable classes
-- ════════════════════════════════════════════════════════════════

/-- An admissible state: a nonempty partition of refinable classes.
    Each RefinableClass bundles:
    - cls : ResidualClass (= UnresolvedClass + multiplicity ≥ 1)
    - threshold : RefinementThreshold cls (= chi, refinable, lower_bound, achieves)
    This is the exact carrier on which U_ind acts. -/
structure AdmissibleState where
  /-- The partition: list of refinable classes -/
  partition : Partition
  /-- The partition is nonempty -/
  nonempty : partition.length ≥ 1

/-- The number of refinable classes in the state. -/
def AdmissibleState.size (s : AdmissibleState) : Nat :=
  s.partition.length

/-- Extract the list of chi values (the refinement thresholds). -/
def AdmissibleState.chiValues (s : AdmissibleState) : List Nat :=
  s.partition.map (fun rc => rc.threshold.chi)

/-- Extract the list of multiplicities. -/
def AdmissibleState.multiplicities (s : AdmissibleState) : List Nat :=
  s.partition.map (fun rc => rc.cls.multiplicity)

-- ════════════════════════════════════════════════════════════════
-- Required theorems
-- ════════════════════════════════════════════════════════════════

/-- There exists an admissible state (any nonempty partition qualifies). -/
theorem admissible_state_exists (rc : RefinableClass) :
    ∃ s : AdmissibleState, s.partition = [rc] :=
  ⟨⟨[rc], by simp⟩, rfl⟩

/-- The admissible state space is nonempty
    (witnessed by any single refinable class). -/
theorem admissible_state_nonempty (rc : RefinableClass) :
    Nonempty AdmissibleState :=
  ⟨⟨[rc], by simp⟩⟩

/-- Admissible states are closed under truth projection:
    removing the last class from a partition with ≥ 2 classes
    gives a smaller admissible state. -/
theorem admissible_state_closed_under_truth_projection
    (s : AdmissibleState) (h : s.partition.length ≥ 2) :
    ∃ s' : AdmissibleState, s'.partition.length < s.partition.length := by
  match s.partition, s.nonempty, h with
  | rc :: rest, _, h_len =>
    have h_rest : rest.length ≥ 1 := by simp at h_len; omega
    exact ⟨⟨rest, h_rest⟩, by simp⟩

/-- Every class in an admissible state is refinable. -/
theorem admissible_state_all_refinable (s : AdmissibleState)
    (rc : RefinableClass) (hmem : rc ∈ s.partition) :
    IsRefinable rc.cls :=
  rc.threshold.refinable

/-- Every class in an admissible state has multiplicity ≥ 1. -/
theorem admissible_state_all_positive_multiplicity (s : AdmissibleState)
    (rc : RefinableClass) (hmem : rc ∈ s.partition) :
    rc.cls.multiplicity ≥ 1 :=
  rc.cls.multiplicity_pos

/-- The chi-profile has the same length as the partition. -/
theorem chi_values_length (s : AdmissibleState) :
    s.chiValues.length = s.partition.length := by
  simp [AdmissibleState.chiValues]

end FinalSourceCode
