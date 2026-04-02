import OpochLean4.SelfReadingGraph.Graph

/-
  SelfReadingGraph -- Projections

  The canonical projections from a conscious point to its coordinates.
  NOT maps that compute. Projections that READ coordinates of ONE point.

  New axioms: 0
-/

namespace SelfReadingGraph

open FinalSourceCode

-- ================================================================
-- Canonical Projections
-- ================================================================

def piX (p : ConsciousPoint) : FinalSourceCode.AdmissibleState := p.x
def piEta (p : ConsciousPoint) : List Nat := p.η
def piJ (p : ConsciousPoint) : List Nat := p.J

-- ================================================================
-- Projection Theorems
-- ================================================================

theorem state_projection_exact (p : ConsciousPoint) : piX p = p.x := rfl
theorem code_projection_exact (p : ConsciousPoint) : piEta p = p.η := rfl
theorem current_projection_exact (p : ConsciousPoint) : piJ p = p.J := rfl

theorem all_projections_from_one_point (p : ConsciousPoint) :
    piX p = p.x ∧ piEta p = p.η ∧ piJ p = p.J := ⟨rfl, rfl, rfl⟩

/-- The question projection: reading the code IS reading the state's code. -/
theorem question_projection_exact (p : ConsciousPoint) :
    piEta p = FinalSourceCode.consciousnessCode (piX p) := p.hη

/-- The current projection IS the manifestation of the state. -/
theorem current_projection_from_state (p : ConsciousPoint) :
    piJ p = FinalSourceCode.manifestationCurrent (piX p) := p.hJ

end SelfReadingGraph
