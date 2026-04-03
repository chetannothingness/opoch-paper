import OpochLean4.Realizations.ARC3.ActionReadout

/-
  ARC-AGI-3 Realization -- Coordinate Readout

  (x*, y*) = C(J_t)

  For ACTION6: the coordinates are NOT searched.
  They are READ from the current J_t.

  The docs do not expose active ACTION6 coordinates.
  The theorem must therefore derive them from the current.
  No coordinate search is allowed.

  New axioms: 0
-/

namespace ARC3

-- ================================================================
-- Coordinate readout
-- ================================================================

/-- Read out ACTION6 coordinates from the current.
    The coordinates are determined by the tension structure:
    the point of maximum tension IS the coordinate. -/
def coordinateReadout (J : ArcCurrent) : Option CoordPayload :=
  J.preferredCoord

/-- Full coordinate readout from dual code. -/
def coordinateFromDual (η : ArcDualCode) : Option CoordPayload :=
  coordinateReadout (currentFromDual η)

-- ================================================================
-- Coordinate theorems
-- ================================================================

/-- Coordinate readout exists. -/
theorem arc_coordinate_readout_exists (J : ArcCurrent) :
    ∃ c : Option CoordPayload, c = coordinateReadout J :=
  ⟨coordinateReadout J, rfl⟩

/-- Coordinate readout is unique: same current = same coordinates. -/
theorem arc_coordinate_readout_unique (J : ArcCurrent) :
    ∀ c₁ c₂ : Option CoordPayload,
      c₁ = coordinateReadout J → c₂ = coordinateReadout J →
      c₁ = c₂ := by
  intro c₁ c₂ h1 h2; rw [h1, h2]

/-- When coordinates exist, they are the ones selected by the current. -/
theorem arc_coordinate_readout_is_legal (J : ArcCurrent) :
    coordinateReadout J = J.preferredCoord :=
  rfl

/-- Coordinate readout is exact: no enumeration, no search.
    The coordinates are a direct function of the dual code. -/
theorem arc_coordinate_readout_exact (η : ArcDualCode) :
    coordinateFromDual η = (currentFromDual η).preferredCoord :=
  rfl

end ARC3
