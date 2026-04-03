import Arc3Instant.Games.Common

/-
  ls20 — Navigation game with shape/color/rotation state matching

  Semantic family: Inventory/Automaton on finite grid

  State = (player_x, player_y, shape, color, rotation, goals_collected)
  Actions = {up, down, left, right} = {1, 2, 3, 4}
  Modifiers: shape changer (+1 mod 6), color changer (+1 mod 4), rotation changer (+1 mod 4)
  Win: visit all goals with matching (shape, color, rotation)

  Grid: 64×64 pixels, cells are 5×5
  Player colors: [12, 9, 14, 8]
  Shapes: 6 patterns (3×3)
  Rotations: [0°, 90°, 180°, 270°]

  NF_G: read grid → identify player/goals/modifiers → compute deficit → direction

  New axioms: 0
-/

namespace Arc3Instant.Ls20

-- ================================================================
-- ls20 concrete state
-- ================================================================

/-- The 4 player colors in order. -/
def playerColors : List Nat := [12, 9, 14, 8]

/-- The cell size in pixels. -/
def cellSize : Nat := 5

/-- Wall color. -/
def wallColor : Nat := 4

/-- Goal area color. -/
def goalColor : Nat := 5

/-- The ls20 semantic state. -/
structure Ls20State where
  /-- Player grid position (pixel coordinates). -/
  playerX : Nat
  playerY : Nat
  /-- Shape index (0-5). -/
  shape : Fin 6
  /-- Color index (0-3). -/
  color : Fin 4
  /-- Rotation index (0-3, representing 0°/90°/180°/270°). -/
  rotation : Fin 4
  /-- Number of goals remaining. -/
  goalsRemaining : Nat

/-- A goal requirement. -/
structure GoalReq where
  x : Nat
  y : Nat
  shape : Fin 6
  color : Fin 4
  rotation : Fin 4

/-- A modifier on the grid. -/
inductive ModifierType where
  | shapeChanger   -- cycles shape +1 mod 6
  | colorChanger   -- cycles color +1 mod 4
  | rotationChanger -- cycles rotation +1 mod 4

structure Modifier where
  x : Nat
  y : Nat
  kind : ModifierType

-- ================================================================
-- Level layout (the game's source code formalized)
-- ================================================================

/-- Complete layout of one level: positions of all objects.
    This IS the game's source code for this level. -/
structure LevelLayout where
  playerStartX : Nat
  playerStartY : Nat
  startShape : Fin 6
  startColor : Fin 4
  startRotation : Fin 4
  goals : List GoalReq
  modifiers : List Modifier
  walls : List (Nat × Nat)

-- ================================================================
-- Deficit computation (exact)
-- ================================================================

/-- Shape deficit: how many shape changer hits needed. -/
def shapeDeficit (current target : Fin 6) : Nat :=
  (target.val + 6 - current.val) % 6

/-- Color deficit: how many color changer hits needed. -/
def colorDeficit (current target : Fin 4) : Nat :=
  (target.val + 4 - current.val) % 4

/-- Rotation deficit: how many rotation changer hits needed. -/
def rotationDeficit (current target : Fin 4) : Nat :=
  (target.val + 4 - current.val) % 4

/-- Manhattan distance between two positions. -/
def manhattan (x1 y1 x2 y2 : Nat) : Nat :=
  let dx := if x1 ≥ x2 then x1 - x2 else x2 - x1
  let dy := if y1 ≥ y2 then y1 - y2 else y2 - y1
  dx + dy

-- ================================================================
-- Tension and energy (exact)
-- ================================================================

/-- Total deficit for reaching one goal:
    shape_hits + color_hits + rotation_hits needed. -/
def goalDeficit (s : Ls20State) (g : GoalReq) : Nat :=
  shapeDeficit s.shape g.shape +
  colorDeficit s.color g.color +
  rotationDeficit s.rotation g.rotation

/-- Energy contribution from one goal:
    deficit + distance to reach it. -/
def goalEnergy (s : Ls20State) (g : GoalReq) : Nat :=
  goalDeficit s g + manhattan s.playerX s.playerY g.x g.y

-- ================================================================
-- Direction readout (exact — no search)
-- ================================================================

/-- Determine the next target position.
    If the player's state doesn't match the goal,
    find the nearest modifier that fixes a deficit.
    If state matches, move toward the goal. -/
def nextTarget (s : Ls20State) (goal : GoalReq) (modifiers : List Modifier) : Nat × Nat :=
  -- Check if state already matches goal
  if s.shape = goal.shape ∧ s.color = goal.color ∧ s.rotation = goal.rotation then
    -- Move toward goal
    (goal.x, goal.y)
  else
    -- Find which modifier to visit
    -- Priority: fix the first nonzero deficit
    let needed := if shapeDeficit s.shape goal.shape > 0 then some ModifierType.shapeChanger
      else if colorDeficit s.color goal.color > 0 then some ModifierType.colorChanger
      else if rotationDeficit s.rotation goal.rotation > 0 then some ModifierType.rotationChanger
      else none
    match needed with
    | none => (goal.x, goal.y)
    | some kind =>
      -- Find the modifier of this kind
      let candidates := modifiers.filter fun m => match kind, m.kind with
        | .shapeChanger, .shapeChanger => true
        | .colorChanger, .colorChanger => true
        | .rotationChanger, .rotationChanger => true
        | _, _ => false
      match candidates with
      | [] => (goal.x, goal.y)  -- no modifier found, go to goal anyway
      | m :: _ => (m.x, m.y)    -- go to the modifier

/-- Compute the direction: among open unvisited neighbors, pick closest to target.
    If all open neighbors are visited, pick closest to target anyway (allows backtracking).
    Visited positions come from the action history replay.
    This IS reading the corridor + history — no search. -/
def directionToTarget (px py tx ty : Nat) (blocked : List Nat) (visited : List (Nat × Nat)) : Nat :=
  let cs := cellSize
  -- For each direction: compute neighbor position, check if open and unvisited
  let up := if 1 ∉ blocked && py ≥ cs then some (px, py - cs) else none
  let down := if 2 ∉ blocked then some (px, py + cs) else none
  let left := if 3 ∉ blocked && px ≥ cs then some (px - cs, py) else none
  let right := if 4 ∉ blocked then some (px + cs, py) else none
  -- Score: manhattan distance, with penalty for visited
  let score := fun (pos : Option (Nat × Nat)) =>
    match pos with
    | none => 999999
    | some (nx, ny) =>
      let dist := manhattan nx ny tx ty
      let visitPenalty := if visited.any (fun (vx, vy) => vx == nx && vy == ny) then 10000 else 0
      dist + visitPenalty
  let upScore := score up
  let downScore := score down
  let leftScore := score left
  let rightScore := score right
  let minScore := min upScore (min downScore (min leftScore rightScore))
  if upScore == minScore then 1
  else if downScore == minScore then 2
  else if leftScore == minScore then 3
  else 4

/-- The complete ls20 normalizer: given state, goal, modifiers, blocked directions,
    and visited positions, return the unique action. -/
def ls20Action (s : Ls20State) (goal : GoalReq) (modifiers : List Modifier)
    (blocked : List Nat) (visited : List (Nat × Nat)) : Nat :=
  let (tx, ty) := nextTarget s goal modifiers
  directionToTarget s.playerX s.playerY tx ty blocked visited

-- ================================================================
-- Properties
-- ================================================================

/-- The normalizer is deterministic. -/
theorem ls20_action_deterministic (s : Ls20State) (g : GoalReq) (ms : List Modifier) (b : List Nat) (v : List (Nat × Nat)) :
    ls20Action s g ms b v = ls20Action s g ms b v := rfl

/-- The normalizer is total. -/
theorem ls20_action_total (s : Ls20State) (g : GoalReq) (ms : List Modifier) (b : List Nat) (v : List (Nat × Nat)) :
    ∃ a : Nat, a = ls20Action s g ms b v :=
  ⟨ls20Action s g ms b v, rfl⟩

/-- Zero deficit at matching state. -/
theorem goal_deficit_zero_of_match (s : Ls20State) (g : GoalReq)
    (hs : s.shape = g.shape) (hc : s.color = g.color) (hr : s.rotation = g.rotation) :
    goalDeficit s g = 0 := by
  unfold goalDeficit shapeDeficit colorDeficit rotationDeficit
  rw [hs, hc, hr]
  omega

/-- Zero distance at same position. -/
theorem manhattan_self (x y : Nat) : manhattan x y x y = 0 := by
  simp [manhattan]

end Arc3Instant.Ls20
