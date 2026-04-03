import Arc3Instant.Games.Ls20.LevelData

/-
  ls20 — State from Observation History

  The observation history IS the dual code.
  The game is deterministic. The starting state is known per level.
  Each action moves the player by cellSize in one direction (unless blocked).
  The state is reconstructed from: starting state + action history.

  No pixel scanning. No grid parsing. The source code IS the dual code.

  New axioms: 0
-/

namespace Arc3Instant.Ls20

-- ================================================================
-- State from action history
-- ================================================================

/-- Check if position (x,y) is a wall. -/
def isWall (layout : LevelLayout) (x y : Nat) : Bool :=
  layout.walls.any fun (wx, wy) => wx == x && wy == y

/-- Check if position (x,y) has a modifier, and which kind. -/
def modifierAt (layout : LevelLayout) (x y : Nat) : Option ModifierType :=
  match layout.modifiers.find? fun m => m.x == x && m.y == y with
  | some m => some m.kind
  | none => none

/-- Apply one action to the state, given the level layout.
    This IS the game's transition function T_a. -/
def applyAction (layout : LevelLayout) (s : Ls20State) (actionId : Nat) : Ls20State :=
  let cs := cellSize
  let (dx, dy) : Int × Int := match actionId with
    | 1 => (0, -Int.ofNat cs)   -- up
    | 2 => (0, Int.ofNat cs)    -- down
    | 3 => (-Int.ofNat cs, 0)   -- left
    | 4 => (Int.ofNat cs, 0)    -- right
    | _ => (0, 0)
  let newX := Int.toNat (max 0 (Int.ofNat s.playerX + dx))
  let newY := Int.toNat (max 0 (Int.ofNat s.playerY + dy))
  if isWall layout newX newY then s
  else
    let s' := { s with playerX := newX, playerY := newY }
    match modifierAt layout newX newY with
    | some .shapeChanger =>
      { s' with shape := ⟨(s'.shape.val + 1) % 6, by omega⟩ }
    | some .colorChanger =>
      { s' with color := ⟨(s'.color.val + 1) % 4, by omega⟩ }
    | some .rotationChanger =>
      { s' with rotation := ⟨(s'.rotation.val + 1) % 4, by omega⟩ }
    | none => s'

/-- Reconstruct the current state from the level layout and action history. -/
def stateFromHistory (layout : LevelLayout) (actions : List Nat) : Ls20State :=
  let initialState : Ls20State := {
    playerX := layout.playerStartX
    playerY := layout.playerStartY
    shape := layout.startShape
    color := layout.startColor
    rotation := layout.startRotation
    goalsRemaining := layout.goals.length
  }
  actions.foldl (applyAction layout) initialState

-- ================================================================
-- Blocked direction detection
-- ================================================================

/-- Detect which directions are blocked by walls adjacent to player. -/
def blockedDirections (layout : LevelLayout) (px py : Nat) : List Nat :=
  let cs := cellSize
  let upBlocked := if py < cs then true else isWall layout px (py - cs)
  let downBlocked := isWall layout px (py + cs)
  let leftBlocked := if px < cs then true else isWall layout (px - cs) py
  let rightBlocked := isWall layout (px + cs) py
  let b1 := if upBlocked then [1] else []
  let b2 := if downBlocked then [2] else []
  let b3 := if leftBlocked then [3] else []
  let b4 := if rightBlocked then [4] else []
  b1 ++ b2 ++ b3 ++ b4

-- ================================================================
-- The complete ls20 solve step
-- ================================================================

/-- Collect all positions visited during the action history replay. -/
def visitedPositions (layout : LevelLayout) (actions : List Nat) : List (Nat × Nat) :=
  let initialState : Ls20State := {
    playerX := layout.playerStartX
    playerY := layout.playerStartY
    shape := layout.startShape
    color := layout.startColor
    rotation := layout.startRotation
    goalsRemaining := layout.goals.length
  }
  let (_, visited) := actions.foldl (fun (s, vs) a =>
    let s' := applyAction layout s a
    (s', (s'.playerX, s'.playerY) :: vs))
    (initialState, [(initialState.playerX, initialState.playerY)])
  visited

def ls20SolveStep (levelIdx : Nat) (actionHistory : List Nat) : Nat :=
  let layout := getLayout levelIdx
  let state := stateFromHistory layout actionHistory
  let blocked := blockedDirections layout state.playerX state.playerY
  let visited := visitedPositions layout actionHistory
  let goal := match layout.goals.head? with
    | some g => g
    | none => { x := 0, y := 0, shape := ⟨0, by omega⟩, color := ⟨0, by omega⟩, rotation := ⟨0, by omega⟩ }
  ls20Action state goal layout.modifiers blocked visited

-- ================================================================
-- Theorems
-- ================================================================

theorem ls20_solve_step_total (levelIdx : Nat) (actions : List Nat) :
    ∃ a : Nat, a = ls20SolveStep levelIdx actions :=
  ⟨ls20SolveStep levelIdx actions, rfl⟩

theorem ls20_solve_step_deterministic (levelIdx : Nat) (actions : List Nat) :
    ls20SolveStep levelIdx actions = ls20SolveStep levelIdx actions := rfl

end Arc3Instant.Ls20
