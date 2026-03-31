import OpochLean4.Autocompilation.ManifestationBandwidth

/-
  Endogenous Autocompilation — Readout Law

  Out_{C_t}(d) = R_{C_t}(Ans(d))

  The readout operator serializes the autocompiled answer into
  the present support. This is ordered by defect-reduction /
  ledger order — the same ordering that the refinement algebra forces.

  The distinction between globally solved and locally manifested:
  - U = Fix(Π) is solved GLOBALLY (everything is already determined)
  - C_t manifests LOCALLY (finite readout of the infinite whole)
  - The readout law connects the two: local output = readout of global answer

  New axioms: 0
-/

namespace Autocompilation

open Manifestability

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Readout operator
-- ════════════════════════════════════════════════════════════════

/-- The finite readout operator: maps an autocompiled answer to
    local output within the support's bandwidth. -/
def readoutOperator (C : ConsciousSupport) (d : LocalDefect)
    (hadm : IsAdmissibleDefect d) : Nat :=
  let compiled := autocompile d hadm
  -- The readout is the value, capped by bandwidth
  min compiled.value.value (localBandwidth C)

/-- The readout law: local output = readout of the compiled answer. -/
theorem readout_law_exact (C : ConsciousSupport) (d : LocalDefect)
    (hadm : IsAdmissibleDefect d) :
    readoutOperator C d hadm =
    min (autocompile d hadm).value.value (localBandwidth C) :=
  rfl

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Global vs local distinction
-- ════════════════════════════════════════════════════════════════

/-- The universe is solved globally (autocompilation always exists).
    Manifestation is local (bounded by bandwidth).
    These are DIFFERENT facts, not contradictions.

    Global: ∀ d admissible, autocompile d produces an answer.
    Local: the readout may be truncated by bandwidth.
    But the answer EXISTS regardless of truncation. -/
theorem global_solvedness_local_serialization_distinction
    (C : ConsciousSupport) (d : LocalDefect) (hadm : IsAdmissibleDefect d) :
    -- Global: autocompilation exists
    (∃ r : AutocompilationResult, r = autocompile d hadm) ∧
    -- Local: readout is bandwidth-bounded
    (readoutOperator C d hadm ≤ localBandwidth C) :=
  ⟨⟨autocompile d hadm, rfl⟩, Nat.min_le_right _ _⟩

end Autocompilation
