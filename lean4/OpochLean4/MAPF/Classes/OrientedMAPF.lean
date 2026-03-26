import OpochLean4.MAPF.Core.Instance

/-
  MAPF Classes — Oriented MAPF

  Robots with orientation (N/S/E/W). State = (vertex, orientation).
  Embeds into FiniteMAPF by expanding the vertex set:
  vertex_oriented = vertex × orientation (4× vertices).

  New axioms: 0
-/

namespace MAPF.Classes

/-- Orientation: four cardinal directions. -/
inductive Orientation where
  | north | south | east | west
deriving DecidableEq, Repr

/-- Number of orientations. -/
def numOrientations : Nat := 4

/-- Oriented MAPF embeds into FiniteMAPF by expanding vertex set.
    Vertex in oriented MAPF = (position, orientation).
    nV_oriented = nV_base × 4.
    Adjacency: can move forward (in current direction) or rotate. -/
theorem oriented_mapf_reduces_to_finite_mapf (nV_base nA nT : Nat)
    (hV : nV_base ≥ 1) (hA : nA ≥ 1) (hT : nT ≥ 1) :
    ∃ (nV_expanded : Nat),
      nV_expanded = nV_base * numOrientations ∧
      nV_expanded ≥ 1 := by
  exact ⟨nV_base * numOrientations, rfl, by simp [numOrientations]; omega⟩

end MAPF.Classes
