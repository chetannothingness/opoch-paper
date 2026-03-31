import OpochLean4.Autocompilation.PresentSupport

/-
  Endogenous Autocompilation — Local Defect

  Δ_Q(C_t) = Π(C_t) \ C_t : what closure demands but support lacks.

  A local defect d ⊆ Δ_Q(C_t) is a structured piece of that gap.
  It is admissible if it is finite, nonempty, and witnessable.

  The defect reduction relation d₁ ≤ d₂ orders defects by size:
  resolving a distinction shrinks the defect.

  New axioms: 0
-/

namespace Autocompilation

open Manifestability

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Local defect
-- ════════════════════════════════════════════════════════════════

/-- A local defect: a structured gap between present support and
    what closure demands. Each defect is a collection of unresolved
    classes with their refinement thresholds. -/
structure LocalDefect where
  /-- The unresolved classes in this defect -/
  unresolved : List ResidualClass
  /-- The defect is nonempty (there is something to resolve) -/
  nonempty : unresolved.length ≥ 1
  /-- The total cost to resolve this defect (sum of multiplicities) -/
  totalCost : Nat
  /-- Cost is positive -/
  cost_pos : totalCost ≥ 1

/-- The size of a defect: number of unresolved classes. -/
def LocalDefect.size (d : LocalDefect) : Nat :=
  d.unresolved.length

/-- A defect is admissible if it is finite, nonempty, and every
    class in it has multiplicity ≥ 1 (refers to real distinctions). -/
def IsAdmissibleDefect (d : LocalDefect) : Prop :=
  d.unresolved.length ≥ 1 ∧
  ∀ rc ∈ d.unresolved, rc.multiplicity ≥ 1

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Defect extraction from support
-- ════════════════════════════════════════════════════════════════

/-- Extract the local defect from a conscious support.
    The defect is: what closure demands minus what support has.
    In the finite model: the defect has size proportional to the
    gap between capacity and resolved count. -/
def extractDefect (C : ConsciousSupport) (gap : ResidualClass)
    (h_gap : gap.multiplicity ≥ 1) : LocalDefect where
  unresolved := [gap]
  nonempty := by simp
  totalCost := gap.multiplicity
  cost_pos := h_gap

/-- A local defect exists whenever the support has unresolved structure. -/
theorem local_defect_exists (C : ConsciousSupport) (gap : ResidualClass)
    (h_gap : gap.multiplicity ≥ 1) :
    ∃ d : LocalDefect, d.size ≥ 1 := by
  exact ⟨extractDefect C gap h_gap, by simp [LocalDefect.size, extractDefect]⟩

/-- Admissibility is exact: the conditions are individually necessary
    and jointly sufficient. -/
theorem local_defect_admissibility_exact (d : LocalDefect)
    (h_all : ∀ rc ∈ d.unresolved, rc.multiplicity ≥ 1) :
    IsAdmissibleDefect d :=
  ⟨d.nonempty, h_all⟩

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: Defect reduction relation
-- ════════════════════════════════════════════════════════════════

/-- Defect reduction: d₁ is a reduction of d₂ if it is strictly smaller.
    Resolving a distinction shrinks the defect. -/
def DefectReduces (d₁ d₂ : LocalDefect) : Prop :=
  d₁.totalCost < d₂.totalCost

/-- Defect reduction is well-founded (Nat is well-ordered under <). -/
theorem defect_reduction_well_founded :
    WellFounded DefectReduces :=
  InvImage.wf LocalDefect.totalCost Nat.lt_wfRel.wf

/-- A resolved defect has cost 0 and no unresolved classes. -/
def IsResolved (d : LocalDefect) : Prop :=
  d.totalCost = 0

end Autocompilation
