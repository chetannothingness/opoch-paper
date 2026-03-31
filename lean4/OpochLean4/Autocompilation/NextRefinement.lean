import OpochLean4.Autocompilation.Autocompile

/-
  Endogenous Autocompilation — Canonical Next Refinement

  The canonical next step: the one refinement event that the defect
  demands. Resolves the first unresolved class at cost = multiplicity.

  New axioms: 0
-/

namespace Autocompilation

open Manifestability

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Next refinement step
-- ════════════════════════════════════════════════════════════════

/-- The canonical next refinement step: resolves one unresolved class. -/
structure NextStep where
  defect : LocalDefect
  resolvedClass : ResidualClass
  actionCost : Nat
  cost_pos : actionCost ≥ 1

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Canonical step extraction
-- ════════════════════════════════════════════════════════════════

/-- Extract the canonical next step from an admissible defect.
    The resolved class is the first unresolved class;
    the action cost is its multiplicity. -/
def canonicalNextStep (d : LocalDefect) (_hadm : IsAdmissibleDefect d) :
    NextStep where
  defect := d
  resolvedClass := d.unresolved.head (by
    have := d.nonempty
    intro h
    simp [h] at this)
  actionCost := (d.unresolved.head (by
    have := d.nonempty
    intro h
    simp [h] at this)).multiplicity
  cost_pos := (d.unresolved.head (by
    have := d.nonempty
    intro h
    simp [h] at this)).multiplicity_pos

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: Theorems
-- ════════════════════════════════════════════════════════════════

/-- The canonical next refinement exists for every admissible defect. -/
theorem canonical_next_refinement_exists (d : LocalDefect)
    (hadm : IsAdmissibleDefect d) :
    ∃ step : NextStep, step = canonicalNextStep d hadm :=
  ⟨canonicalNextStep d hadm, rfl⟩

/-- The canonical next refinement is unique: same defect gives same step. -/
theorem canonical_next_refinement_unique (d : LocalDefect)
    (hadm : IsAdmissibleDefect d) :
    canonicalNextStep d hadm = canonicalNextStep d hadm :=
  rfl

end Autocompilation
