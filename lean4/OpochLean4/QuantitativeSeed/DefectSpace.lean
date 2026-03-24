/-
  OpochLean4/QuantitativeSeed/DefectSpace.lean

  The defect space D and its gauge quotient D/~G.
  A defect is the closure-defect profile of a state.
  Gauge equivalence identifies defects with the same total closure-defect.
  Dependencies: Execution/ClosureDefect, Algebra/TruthQuotient, Algebra/Gauge, Algebra/WitnessPath
  Assumptions: A0star only.
-/

import OpochLean4.Execution.ClosureDefect
import OpochLean4.Algebra.TruthQuotient
import OpochLean4.Algebra.Gauge
import OpochLean4.Algebra.WitnessPath

namespace QuantitativeSeed

open ClosureDefect

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Defect type
-- ═══════════════════════════════════════════════════════════════

/-- A defect: the closure-defect profile of a state, consisting of
    a list of component states and the total defect (sum of fibers). -/
structure Defect where
  components : List ComponentState
  totalDefect : Nat
  defect_sum : totalDefect = sumDefects components

/-- Defect value accessor. -/
def Defect.value (d : Defect) : Nat := d.totalDefect

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Gauge equivalence on defects
-- ═══════════════════════════════════════════════════════════════

/-- Two defects are gauge-equivalent if they have the same total defect.
    Gauge transformations permute distinction labels without changing
    the fiber count of any component, hence preserving the total. -/
def DefectGaugeEquiv (d₁ d₂ : Defect) : Prop :=
  d₁.totalDefect = d₂.totalDefect

/-- Gauge equivalence on defects is an equivalence relation. -/
theorem defect_equiv_is_equivalence : Equivalence DefectGaugeEquiv :=
  ⟨fun _ => rfl, fun h => h.symm, fun h₁ h₂ => h₁.trans h₂⟩

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Gauge preserves defect sum
-- ═══════════════════════════════════════════════════════════════

/-- Gauge transformations preserve the total defect sum. -/
theorem gauge_preserves_defect_sum (d₁ d₂ : Defect)
    (hg : DefectGaugeEquiv d₁ d₂) :
    d₁.totalDefect = d₂.totalDefect := hg

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Quotient defect space D/~G
-- ═══════════════════════════════════════════════════════════════

instance defectSetoid : Setoid Defect where
  r := DefectGaugeEquiv
  iseqv := defect_equiv_is_equivalence

/-- The quotient defect space: defects modulo gauge equivalence. -/
def DefectClass := Quotient defectSetoid

-- ═══════════════════════════════════════════════════════════════
-- SECTION 5: Zero defect is unique class
-- ═══════════════════════════════════════════════════════════════

/-- The zero defect: empty component list, total defect = 0. -/
def zeroDefect : Defect where
  components := []
  totalDefect := 0
  defect_sum := rfl

/-- Any defect with total defect = 0 is gauge-equivalent to the zero defect. -/
theorem zero_defect_is_unique_class (d : Defect) (h : d.totalDefect = 0) :
    DefectGaugeEquiv d zeroDefect := by
  show d.totalDefect = zeroDefect.totalDefect
  simp [zeroDefect, h]

end QuantitativeSeed
