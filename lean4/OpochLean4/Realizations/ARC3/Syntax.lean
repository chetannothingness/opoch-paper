import OpochLean4.FinalSourceCode.AdmissibleState

/-
  ARC-AGI-3 Realization -- Concrete Syntax

  ARC-AGI-3 is instantly solvable only when full observation history
  is proved to be the exact dual code of the correct state and action
  for every public environment; everything else is a witness surface,
  not the solver.

  Concrete types for the ARC-AGI-3 benchmark:
  - Frames: 1-N JSON observation bundles per step
  - Grids: bounded 64x64, cell values 0-15
  - Actions: explicit per game (1-7), ACTION6 coordinate-based
  - Games: 25 public environments, deterministic, stateful

  New axioms: 0
-/

namespace ARC3

-- ================================================================
-- Grid and cell types
-- ================================================================

/-- Cell value: 0-15 (4-bit). -/
abbrev CellValue := Fin 16

/-- Grid position within 64x64 bounds. -/
structure GridPos where
  x : Fin 64
  y : Fin 64
deriving DecidableEq

/-- A grid frame: bounded 64x64 with cell values 0-15. -/
structure Frame where
  width : Nat
  height : Nat
  hwidth : width ≤ 64
  hheight : height ≤ 64
  cells : Fin height → Fin width → CellValue

-- ================================================================
-- Action types
-- ================================================================

/-- Action identifier (1-7). -/
abbrev ActionId := Fin 7

/-- Coordinate payload for ACTION6. -/
structure CoordPayload where
  x : Nat
  y : Nat

/-- An action: identifier + optional coordinate payload. -/
structure Action where
  id : ActionId
  coord : Option CoordPayload

/-- The legal action set at a given step. -/
structure LegalActionSet where
  available : List ActionId
  nonempty : available.length ≥ 1

-- ================================================================
-- Game and score types
-- ================================================================

/-- Game identifier (one of 25 public games). -/
structure GameId where
  name : String

/-- Terminal status. -/
inductive TerminalStatus
  | playing : TerminalStatus
  | win : TerminalStatus
  | lose : TerminalStatus

/-- Score metadata. -/
structure ScoreMeta where
  levelIndex : Nat
  totalLevels : Nat
  stepsRemaining : Nat
  terminal : TerminalStatus

-- ================================================================
-- Observation bundle (single step)
-- ================================================================

/-- A single observation bundle: everything the environment
    surfaces at one timestep. -/
structure ObservationBundle where
  frames : List Frame
  hframes : frames.length ≥ 1
  legalActions : LegalActionSet
  score : ScoreMeta

-- ================================================================
-- Basic properties
-- ================================================================

/-- Frames are finite and bounded. -/
theorem frame_finite (f : Frame) : f.width * f.height ≤ 64 * 64 :=
  Nat.mul_le_mul f.hwidth f.hheight

/-- Cell values are bounded. -/
theorem cell_bounded (v : CellValue) : v.val < 16 := v.isLt

/-- Action set is always nonempty. -/
theorem action_set_nonempty (L : LegalActionSet) : L.available.length ≥ 1 :=
  L.nonempty

end ARC3
