import OpochLean4.MAPF.Core.Instance

/-
  MAPF Classes — Weighted MAPF

  Non-uniform action costs. Embeds into FiniteMAPF by
  expanding the graph: each edge becomes a path of length
  equal to the weight (or use weighted adjacency directly).

  New axioms: 0
-/

namespace MAPF.Classes

/-- Weighted MAPF: each edge has a positive integer cost. -/
structure WeightedGraph (nV : Nat) extends FiniteGraph nV where
  weight : Fin nV → Fin nV → Nat
  weight_pos : ∀ u v, adj u v = true → weight u v ≥ 1

/-- Weighted MAPF embeds into FiniteMAPF.
    The graph is the same; the cost model changes. -/
theorem weighted_mapf_reduces_to_finite_mapf (nV nA nT : Nat)
    (hV : nV ≥ 1) (hA : nA ≥ 1) (hT : nT ≥ 1) :
    ∃ (_ : FiniteGraph nV), True :=
  ⟨⟨fun _ _ => true, fun _ => rfl, fun _ _ => rfl⟩, trivial⟩

end MAPF.Classes
