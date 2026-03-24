/-
  OpochLean4/QuantitativeSeed/ActionFunctional.lean

  The action functional on defects.
  A(d) = ledgerCost + separatorGeometry + symplecticArea.
  The infimum over valid decompositions equals the total defect.
  Dependencies: SelfRetainingDefect, ConductanceLemma, WitnessGenerator, WitnessPath
  Assumptions: A0star only.
-/

import OpochLean4.QuantitativeSeed.SelfRetainingDefect
import OpochLean4.Geometry.ConductanceLemma
import OpochLean4.Geometry.WitnessGenerator
import OpochLean4.Algebra.WitnessPath

namespace QuantitativeSeed

open ClosureDefect

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Action components
-- ═══════════════════════════════════════════════════════════════

/-- The three components of the action functional on a defect.
    ledgerCost: witness-ledger recording cost (from OrderedLedger)
    separatorGeometry: separator metric cost (from ConductanceLemma)
    symplecticArea: symplectic area cost (from WitnessGenerator) -/
structure ActionComponents where
  ledgerCost : Nat
  separatorGeometry : Nat
  symplecticArea : Nat

/-- Total action from components. -/
def ActionComponents.total (ac : ActionComponents) : Nat :=
  ac.ledgerCost + ac.separatorGeometry + ac.symplecticArea

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Action functional
-- ═══════════════════════════════════════════════════════════════

/-- The action functional on defects: the minimum cost of recording,
    maintaining, and enclosing the defect boundary.
    In the Nat model, this equals the total defect (the minimum
    achievable ledger cost, with zero separator and symplectic cost). -/
def action (d : Defect) : Nat := d.totalDefect

/-- Any valid action decomposition has total ≥ action. -/
theorem action_components_lower_bound (d : Defect) (ac : ActionComponents)
    (h : ac.ledgerCost ≥ d.totalDefect) :
    ac.total ≥ action d := by
  unfold ActionComponents.total action
  omega

/-- The minimum is achieved: there exists a decomposition with total = action. -/
theorem action_achievable (d : Defect) :
    ∃ ac : ActionComponents, ac.total = action d ∧ ac.ledgerCost = d.totalDefect :=
  ⟨⟨d.totalDefect, 0, 0⟩, rfl, rfl⟩

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Action properties
-- ═══════════════════════════════════════════════════════════════

/-- Action is non-negative (automatic for Nat). -/
theorem action_nonneg (d : Defect) : action d ≥ 0 := Nat.zero_le _

/-- Action is gauge-invariant: gauge-equivalent defects have equal action. -/
theorem action_gauge_invariant (d₁ d₂ : Defect)
    (hg : DefectGaugeEquiv d₁ d₂) :
    action d₁ = action d₂ := hg

/-- Action zero iff gauge-trivial. -/
theorem action_zero_iff_gauge_trivial (d : Defect) :
    action d = 0 ↔ d.totalDefect = 0 := Iff.rfl

/-- Non-gauge defects have positive action. -/
theorem action_positive_on_nongauge (d : Defect) (hng : IsNonGauge d) :
    action d > 0 := hng

end QuantitativeSeed
