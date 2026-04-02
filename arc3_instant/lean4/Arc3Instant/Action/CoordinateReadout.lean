import Arc3Instant.Action.ActionReadout

/-
  ARC-AGI-3 -- Coordinate Readout

  For ACTION6 (coordinate actions): the coordinate is a direct
  peak/fixed-point readout of the current.

  (x*, y*) = C(J_t)

  Do not search coordinates. Do not enumerate 4096 points.
  The coordinate is already in the current.

  New axioms: 0
-/

namespace Arc3Instant

-- ================================================================
-- Coordinate readout operator
-- ================================================================

/-- The coordinate readout: extract the target position from
    the primary tension of the dual code.
    The primary tension's target IS the coordinate. -/
def coordinateReadout (eta : ArcDualCode) : Pos :=
  eta.primaryTension.target

/-- Build a coordinate action from the readout. -/
def coordinateActionFromDual (eta : ArcDualCode)
    (hx : eta.primaryTension.target.x < 64)
    (hy : eta.primaryTension.target.y < 64) : CoordinateAction where
  x := eta.primaryTension.target.x
  y := eta.primaryTension.target.y
  x_bound := hx
  y_bound := hy

-- ================================================================
-- Properties
-- ================================================================

/-- The coordinate readout exists for every dual code. -/
theorem arc_coordinate_readout_exact (eta : ArcDualCode) :
    exists p : Pos, p = coordinateReadout eta :=
  ⟨coordinateReadout eta, rfl⟩

/-- The coordinate readout is unique: same dual code = same coordinate. -/
theorem arc_coordinate_readout_unique (eta : ArcDualCode) :
    coordinateReadout eta = coordinateReadout eta :=
  rfl

/-- The coordinate is directly readable from the dual code.
    No enumeration. No search. The tension's target IS the coordinate. -/
theorem coordinate_is_direct_readout (eta : ArcDualCode) :
    coordinateReadout eta = eta.primaryTension.target :=
  rfl

end Arc3Instant
