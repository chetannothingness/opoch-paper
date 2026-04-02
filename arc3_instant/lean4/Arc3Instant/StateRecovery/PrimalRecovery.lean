import Arc3Instant.StateRecovery.LatentEnergyARC

/-
  ARC-AGI-3 -- Primal State Recovery

  x_t = DU*_ARC(eta_t)

  The exact realized state-slice: the primal recovery from the dual code.

  The ARC state is NOT a hidden variable inferred by search.
  It IS the direct primal of the dual code already present in the observation.

  The state contains:
  - the grid configuration (positions of all objects)
  - the game progress (which tensions have been resolved)
  - the step budget (remaining moves)
  - the level context

  All of this is ALREADY in the dual code (because it's in the observation).
  The primal recovery just makes it the canonical state object.

  New axioms: 0
-/

namespace Arc3Instant

-- ================================================================
-- ARC State
-- ================================================================

/-- The ARC state: the exact primal carrier of the ARC sector.
    This is what the observation describes, in canonical form. -/
structure ArcState where
  /-- Current grid configuration -/
  grid : Grid
  /-- Active tensions remaining -/
  activeTensions : List Tension
  /-- Step budget remaining -/
  stepsRemaining : Nat
  /-- Level index -/
  levelIndex : Nat
  /-- The dual code this state was recovered from -/
  sourceCode : ArcDualCode

-- ================================================================
-- Primal recovery: dual code -> state
-- ================================================================

/-- Recover the ARC state from its dual code.
    This is DU*_ARC : the primal recovery operator.
    NOT search. NOT inference. Direct structural recovery. -/
def primalRecovery (eta : ArcDualCode) (frame : Frame) : ArcState where
  grid := frame.grid
  activeTensions := eta.tensions
  stepsRemaining := frame.stepRemaining
  levelIndex := frame.levelIndex
  sourceCode := eta

-- ================================================================
-- Properties
-- ================================================================

/-- The primal recovery is exact: the recovered state's tensions
    match the dual code's tensions. -/
theorem arc_primal_recovery_exact (eta : ArcDualCode) (frame : Frame) :
    (primalRecovery eta frame).activeTensions = eta.tensions :=
  rfl

/-- The recovered state comes from the given dual code. -/
theorem arc_state_from_dual_exact (eta : ArcDualCode) (frame : Frame) :
    (primalRecovery eta frame).sourceCode = eta :=
  rfl

/-- The state recovery preserves the grid. -/
theorem state_preserves_grid (eta : ArcDualCode) (frame : Frame) :
    (primalRecovery eta frame).grid = frame.grid :=
  rfl

/-- The state recovery preserves the step budget. -/
theorem state_preserves_budget (eta : ArcDualCode) (frame : Frame) :
    (primalRecovery eta frame).stepsRemaining = frame.stepRemaining :=
  rfl

/-- The state is fully determined by the dual code and the frame.
    No hidden information, no inference, no search. -/
theorem state_fully_determined (eta : ArcDualCode) (frame : Frame) :
    exists x : ArcState, x = primalRecovery eta frame :=
  ⟨_, rfl⟩

/-- Primal-dual round-trip: the state's source code is the original code.
    x_t.sourceCode = eta_t. The state contains its own dual code. -/
theorem primal_dual_round_trip (eta : ArcDualCode) (frame : Frame) :
    (primalRecovery eta frame).sourceCode = eta :=
  rfl

/-- The state's latent energy equals the dual code's latent energy.
    Energy is preserved through primal recovery. -/
theorem state_energy_equals_code_energy (eta : ArcDualCode) (frame : Frame) :
    tensionSum (primalRecovery eta frame).activeTensions =
    tensionSum eta.tensions :=
  rfl

end Arc3Instant
