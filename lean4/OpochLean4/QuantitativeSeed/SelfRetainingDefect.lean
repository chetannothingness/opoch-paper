/-
  OpochLean4/QuantitativeSeed/SelfRetainingDefect.lean

  Self-retaining defects: fixed points under witness accumulation
  that cannot be removed by gauge transformations.
  Dependencies: DefectSpace, Execution/SelfHosting
  Assumptions: A0star only.
-/

import OpochLean4.QuantitativeSeed.DefectSpace
import OpochLean4.Execution.SelfHosting

namespace QuantitativeSeed

open ClosureDefect

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Replayable defects
-- ═══════════════════════════════════════════════════════════════

/-- A defect is replayable if every open component has positive fiber
    (faithful encoding of unresolved state via A0* condition W2). -/
structure IsReplayable (d : Defect) where
  open_positive : ∀ c, c ∈ d.components →
    c.resolution = Resolution.open_ → c.fiberRemaining ≥ 1

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Self-retaining defects (fixed-point under witness accumulation)
-- ═══════════════════════════════════════════════════════════════

/-- A defect is self-retaining if:
    (1) It is replayable
    (2) Every open component has fiberRemaining = 1 (minimum nonzero)
    This makes it a fixed point: witness steps preserving open status
    cannot reduce the fiber below 1, and 1 is already the minimum. -/
structure IsSelfRetaining (d : Defect) where
  replayable : IsReplayable d
  at_minimum : ∀ c, c ∈ d.components →
    c.resolution = Resolution.open_ → c.fiberRemaining = 1

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Non-gauge defects
-- ═══════════════════════════════════════════════════════════════

/-- A defect is non-gauge if its total defect is positive
    (not removable by any gauge transformation). -/
def IsNonGauge (d : Defect) : Prop := d.totalDefect > 0

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Self-retaining stability
-- ═══════════════════════════════════════════════════════════════

/-- A self-retaining defect is stable: any witness step applied to
    an open component, if it preserves replayability (post-fiber ≥ 1),
    must leave the fiber unchanged at 1.
    Proof: monotone gives postFiber ≤ 1, replayability gives postFiber ≥ 1. -/
theorem self_retaining_stable (d : Defect) (hsr : IsSelfRetaining d)
    (c : ComponentState) (hc : c ∈ d.components)
    (hopen : c.resolution = Resolution.open_)
    (step : WitnessStep) (hpre : step.preFiber = c.fiberRemaining)
    (hpost_replay : step.postFiber ≥ 1) :
    step.postFiber = 1 := by
  have hat := hsr.at_minimum c hc hopen
  rw [hat] at hpre
  have hmono := step.monotone
  rw [hpre] at hmono
  -- hmono : step.postFiber ≤ 1, hpost_replay : step.postFiber ≥ 1
  omega

-- ═══════════════════════════════════════════════════════════════
-- SECTION 5: Non-gauge survives quotient
-- ═══════════════════════════════════════════════════════════════

/-- A non-gauge defect remains non-gauge in the quotient:
    all defects in the same gauge-equivalence class are also non-gauge. -/
theorem non_gauge_survives_quotient (d₁ d₂ : Defect)
    (hg : DefectGaugeEquiv d₁ d₂) (hng : IsNonGauge d₁) :
    IsNonGauge d₂ := by
  unfold IsNonGauge DefectGaugeEquiv at *
  omega

-- ═══════════════════════════════════════════════════════════════
-- SECTION 6: Self-retaining class is nonempty
-- ═══════════════════════════════════════════════════════════════

/-- An open component with minimum nonzero fiber (fiberRemaining = 1). -/
private def minOpenComponent : ComponentState where
  resolution := .open_
  fiberRemaining := 1
  consistent := by intro h; simp [Resolution.isResolved] at h

/-- A minimal self-retaining defect: one open component at fiber 1. -/
private def minimalSRDefect : Defect where
  components := [minOpenComponent]
  totalDefect := 1
  defect_sum := rfl

/-- The class of self-retaining non-gauge defects is nonempty.
    Witness: a single open component with fiberRemaining = 1. -/
theorem self_retaining_class_nonempty :
    ∃ d : Defect, IsSelfRetaining d ∧ IsNonGauge d :=
  ⟨minimalSRDefect,
    { replayable := ⟨fun c hc hopen => by
        cases hc with
        | head => decide
        | tail _ h => exact absurd h (List.not_mem_nil _)⟩
      at_minimum := fun c hc hopen => by
        cases hc with
        | head => decide
        | tail _ h => exact absurd h (List.not_mem_nil _) },
    by show (1 : Nat) > 0; omega⟩

end QuantitativeSeed
