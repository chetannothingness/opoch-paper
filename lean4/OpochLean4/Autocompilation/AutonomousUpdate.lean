import OpochLean4.Autocompilation.NextRefinement

/-
  Endogenous Autocompilation — Autonomous Update

  C_{t+1} = C_t union witness(e*_d): the autonomous update that adds
  one resolved class to the present support.

  The defect strictly shrinks: d_{t+1}.totalCost < d_t.totalCost.

  New axioms: 0
-/

namespace Autocompilation

open Manifestability

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Autonomous update
-- ════════════════════════════════════════════════════════════════

/-- The autonomous update: add the resolved class from the canonical
    next step to the present support. -/
def autonomousUpdate (C : ConsciousSupport) (d : LocalDefect)
    (hadm : IsAdmissibleDefect d)
    (h_cap : C.resolved.length + 1 ≤ C.capacity) :
    ConsciousSupport where
  resolved := C.resolved ++ [(canonicalNextStep d hadm).resolvedClass]
  capacity := C.capacity
  capacity_pos := C.capacity_pos
  within_capacity := by
    simp [List.length_append]
    exact h_cap

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Defect reduction
-- ════════════════════════════════════════════════════════════════

/-- Reduce a defect by one step: subtract the action cost from total cost.
    The unresolved list is preserved (cost tracks progress);
    the well-founded relation is on totalCost alone. -/
def reduceDefect (d : LocalDefect) (step : NextStep)
    (_h : step.actionCost ≤ d.totalCost)
    (h2 : d.totalCost - step.actionCost ≥ 1) : LocalDefect where
  unresolved := d.unresolved
  nonempty := d.nonempty
  totalCost := d.totalCost - step.actionCost
  cost_pos := h2

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: Theorems
-- ════════════════════════════════════════════════════════════════

/-- The autonomous update adds exactly one resolved class. -/
theorem autonomous_update_exact (C : ConsciousSupport) (d : LocalDefect)
    (hadm : IsAdmissibleDefect d)
    (h_cap : C.resolved.length + 1 ≤ C.capacity) :
    (autonomousUpdate C d hadm h_cap).resolved.length =
    C.resolved.length + 1 := by
  simp [autonomousUpdate, List.length_append]

/-- The local defect strictly reduces under auto-update:
    the reduced defect has strictly smaller total cost. -/
theorem local_defect_strictly_reduces_under_autoupdate
    (d : LocalDefect) (step : NextStep)
    (h : step.actionCost ≤ d.totalCost)
    (h2 : d.totalCost - step.actionCost ≥ 1) :
    DefectReduces (reduceDefect d step h h2) d := by
  simp [DefectReduces, reduceDefect]
  have := step.cost_pos
  omega

end Autocompilation
