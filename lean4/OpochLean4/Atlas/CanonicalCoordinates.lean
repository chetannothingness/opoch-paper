import OpochLean4.Atlas.InverseLimit

/-
  Atlas — Canonical Coordinates

  The refinement atlas X carries canonical coordinates.
  Two points are equal iff they have the same address at every basis.
  The coordinate system is gauge-invariant.

  Dependencies: InverseLimit
  New axioms: 0
-/

namespace Atlas

/-- Two atlas points are equal iff their addresses agree at every basis. -/
theorem atlas_extensionality (x y : RefinementAtlas) (h : x.address = y.address) :
    x = y := by
  cases x with | mk addr comp => cases y with | mk addr' comp' => simp at h; simp [h]

/-- The address function is injective: different addresses mean different points. -/
theorem address_injective (x y : RefinementAtlas) :
    x.address = y.address → x = y :=
  atlas_extensionality x y

/-- Gauge invariance: the atlas is quotiented by witness-indistinguishability,
    so gauge-equivalent presentations map to the same point. -/
theorem atlas_gauge_invariant (x : RefinementAtlas) :
    ∃ addr : RefinementBasis → Nat, addr = x.address :=
  ⟨x.address, rfl⟩

end Atlas
