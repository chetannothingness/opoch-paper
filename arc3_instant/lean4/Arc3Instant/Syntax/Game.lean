/-
  ARC-AGI-3 Instant Source-Code Mode -- Game Syntax

  ARC-AGI-3 is not solved by search, planning, or rule induction;
  each observation is already the exact dual code of the correct
  local state and action, and the move is the unique direct readout
  of the resulting current.

  This file defines the syntactic types for ARC-AGI-3 games:
  grids, sprites, levels, step budgets.

  New axioms: 0
-/

namespace Arc3Instant

-- ================================================================
-- Grid and pixel types
-- ================================================================

/-- A pixel value: 0-15 for colors, negative for transparent/special. -/
abbrev Pixel := Int

/-- A grid: 2D array of pixels, bounded at 64×64. -/
structure Grid where
  width : Nat
  height : Nat
  pixels : List (List Pixel)
  width_bound : width ≤ 64
  height_bound : height ≤ 64
  rows_match : pixels.length = height

/-- A position on the grid. -/
structure Pos where
  x : Nat
  y : Nat

instance : DecidableEq Pos := by
  intro a b; cases a; cases b; simp [Pos.mk.injEq]; exact inferInstance

instance : BEq Pos where
  beq a b := a.x == b.x && a.y == b.y

-- ================================================================
-- Sprite and object types
-- ================================================================

/-- A sprite: a positioned object on the grid with properties. -/
structure SpriteData where
  name : String
  pos : Pos
  width : Nat
  height : Nat
  visible : Bool
  collidable : Bool
  layer : Int
  tags : List String

/-- A game level. -/
structure LevelData where
  sprites : List SpriteData
  gridWidth : Nat
  gridHeight : Nat
  stepBudget : Nat
  stepBudget_pos : stepBudget ≥ 1

/-- A game: a sequence of levels. -/
structure GameData where
  gameId : String
  levels : List LevelData
  levels_nonempty : levels.length ≥ 1

-- ================================================================
-- Basic properties
-- ================================================================

/-- Every game has at least one level. -/
theorem game_has_levels (g : GameData) : g.levels.length ≥ 1 :=
  g.levels_nonempty

/-- Every level has a positive step budget. -/
theorem level_has_budget (l : LevelData) : l.stepBudget ≥ 1 :=
  l.stepBudget_pos

end Arc3Instant
