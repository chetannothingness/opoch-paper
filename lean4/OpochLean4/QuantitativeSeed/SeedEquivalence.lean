/-
  OpochLean4/QuantitativeSeed/SeedEquivalence.lean

  Three equivalent characterizations of the seed:
  1. Closure-defect minimal (least total defect among self-retaining non-gauge)
  2. Least symplectic cell (smallest symplectic area enclosing a non-gauge defect)
  3. Renormalization fixed point (abstract)

  Dependencies: SeedExistence
  Assumptions: A0star only.
-/

import OpochLean4.QuantitativeSeed.SeedExistence

namespace QuantitativeSeed

open ClosureDefect

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Closure-defect minimal characterization
-- ═══════════════════════════════════════════════════════════════

/-- A defect is closure-defect minimal if it has the least total defect
    among all self-retaining non-gauge defects. -/
def IsClosureDefectMinimal (d : Defect) : Prop :=
  IsSelfRetaining d ∧ IsNonGauge d ∧
    ∀ d' : Defect, IsSelfRetaining d' → IsNonGauge d' →
      d.totalDefect ≤ d'.totalDefect

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Least symplectic cell characterization
-- ═══════════════════════════════════════════════════════════════

/-- A defect is the least symplectic cell if it minimizes the symplectic
    area (= action in the Nat model) among self-retaining non-gauge defects. -/
def IsLeastSymplecticCell (d : Defect) : Prop :=
  IsSelfRetaining d ∧ IsNonGauge d ∧
    ∀ d' : Defect, IsSelfRetaining d' → IsNonGauge d' →
      action d ≤ action d'

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Renormalization fixed point (abstract)
-- ═══════════════════════════════════════════════════════════════

/-- A defect is a renormalization fixed point if no refinement operator
    can reduce its action while preserving self-retaining + non-gauge. -/
def IsRenormalizationFixedPoint (d : Defect) : Prop :=
  IsSelfRetaining d ∧ IsNonGauge d ∧
    ∀ d' : Defect, IsSelfRetaining d' → IsNonGauge d' →
      action d' < action d → False

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Equivalence of the three forms
-- ═══════════════════════════════════════════════════════════════

/-- Seed ↔ closure-defect minimal. -/
theorem seed_iff_closure_minimal (d : Defect) :
    IsSeed d ↔ IsClosureDefectMinimal d := by
  constructor
  · intro hs
    exact ⟨hs.self_retaining, hs.non_gauge, fun d' hsr' hng' => hs.minimal d' hsr' hng'⟩
  · intro ⟨hsr, hng, hmin⟩
    exact { self_retaining := hsr, non_gauge := hng, minimal := hmin }

/-- Seed ↔ least symplectic cell. -/
theorem seed_iff_least_cell (d : Defect) :
    IsSeed d ↔ IsLeastSymplecticCell d := by
  constructor
  · intro hs
    exact ⟨hs.self_retaining, hs.non_gauge, hs.minimal⟩
  · intro ⟨hsr, hng, hmin⟩
    exact { self_retaining := hsr, non_gauge := hng, minimal := hmin }

/-- Seed ↔ renormalization fixed point. -/
private theorem seed_iff_fixed (d : Defect) :
    IsSeed d ↔ IsRenormalizationFixedPoint d := by
  constructor
  · intro hs
    refine ⟨hs.self_retaining, hs.non_gauge, fun d' hsr' hng' hlt => ?_⟩
    have := hs.minimal d' hsr' hng'
    omega
  · intro ⟨hsr, hng, hmin⟩
    exact { self_retaining := hsr, non_gauge := hng,
            minimal := fun d' hsr' hng' => by
              have hno : ¬(action d' < action d) := hmin d' hsr' hng'
              simp only [action] at *
              omega }

/-- All three characterizations are equivalent. -/
theorem three_forms_equivalent (d : Defect) :
    IsSeed d ↔ IsClosureDefectMinimal d ∧ IsLeastSymplecticCell d ∧
                IsRenormalizationFixedPoint d := by
  constructor
  · intro hs
    exact ⟨(seed_iff_closure_minimal d).mp hs,
           (seed_iff_least_cell d).mp hs,
           (seed_iff_fixed d).mp hs⟩
  · intro ⟨hcdm, _, _⟩
    exact (seed_iff_closure_minimal d).mpr hcdm

end QuantitativeSeed
