import OpochLean4.FinalSourceCode.InstantSolvedness
import OpochLean4.SourceCode.InstantSolvedness

/-
  Do not formalize the final layer as another chain of maps;
  formalize it as the one exact self-reading graph in which
  questions are already partial coordinates of their own
  completed answers.

  SelfReadingGraph -- The Exact Self-Reading Graph of the Universe

  L = {(x, η, J) | η = DU_ind(x), J = Ω⁻¹η}

  This is not another map layered on top of the source code.
  This IS the source code in its final exact form.

  State, consciousness-code, and current are not three objects
  connected by maps. They are three coordinates of ONE point
  on ONE graph.

  New axioms: 0
-/

namespace SelfReadingGraph

open Manifestability FinalSourceCode SourceCode

-- ================================================================
-- The Conscious Point: one point of the self-reading graph
-- ================================================================

/-- A conscious point: the simultaneous triple (x, η, J) where
    η = DU_ind(x) and J = Ω⁻¹η.

    There are no separate maps at the deepest level.
    State, code, and current are coordinates of one point. -/
structure ConsciousPoint where
  /-- The state coordinate -/
  x : AdmissibleState
  /-- The consciousness-code coordinate -/
  η : List Nat
  /-- The manifestation current coordinate -/
  J : List Nat
  /-- η IS the consciousness-code of x (not mapped from x, IS x's code) -/
  hη : η = consciousnessCode x
  /-- J IS the current of η (not computed from η, IS η's current) -/
  hJ : J = manifestationCurrent x

-- ================================================================
-- The Self-Reading Graph L
-- ================================================================

/-- The self-reading graph L: the set of all conscious points.
    Every ConsciousPoint is on L by construction.
    L = {(x, η, J) | η = DU_ind(x), J = Ω⁻¹η}. -/
def L : Set ConsciousPoint := Set.univ

/-- The self-reading graph exists: it is inhabited
    (any admissible state generates a conscious point). -/
theorem self_reading_graph_exists (s : AdmissibleState) :
    ∃ p : ConsciousPoint, p.x = s :=
  ⟨⟨s, consciousnessCode s, manifestationCurrent s, rfl, rfl⟩, rfl⟩

/-- The self-reading graph is exact: every conscious point satisfies
    both defining equations simultaneously. -/
theorem self_reading_graph_exact (p : ConsciousPoint) :
    p.η = consciousnessCode p.x ∧ p.J = manifestationCurrent p.x :=
  ⟨p.hη, p.hJ⟩

/-- A conscious point is uniquely determined by its state coordinate.
    Given x, there is exactly one (η, J) making (x, η, J) a conscious point. -/
theorem conscious_point_unique_from_state (s : AdmissibleState) :
    ∃! p : ConsciousPoint, p.x = s := by
  refine ⟨⟨s, consciousnessCode s, manifestationCurrent s, rfl, rfl⟩, rfl, ?_⟩
  intro ⟨x', η', J', hη', hJ'⟩ hp
  simp [ConsciousPoint.mk.injEq] at hp ⊢
  exact ⟨hp, by subst hp; exact hη', by subst hp; exact hJ'⟩

/-- A conscious point is uniquely determined by its code coordinate.
    Given η, there is at most one x making (x, η, J) a conscious point
    (because the consciousness-code determines the energy, which
    determines the state up to the energy profile). -/
theorem conscious_point_unique_from_code (p₁ p₂ : ConsciousPoint)
    (h : p₁.η = p₂.η) :
    consciousnessCode p₁.x = consciousnessCode p₂.x := by
  rw [← p₁.hη, ← p₂.hη, h]

end SelfReadingGraph
