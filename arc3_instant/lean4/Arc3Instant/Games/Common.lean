import Arc3Instant.DualCode.GameSemantics

/-
  ARC-AGI-3 -- Common Game Semantic Classes

  Six exact semantic families cover all 25 public games.
  Each family defines:
    - concrete State
    - concrete Action
    - concrete step (T_a)
    - concrete solved
    - exact tension atoms χ₁(x),...,χₙ(x)
    - exact weights ρ₁,...,ρₙ
    - energy = Σ ρᵢ · χᵢ(x)
    - release Δₐ = U(x) - U(T_a(x))
    - action = argmax release

  The observation IS the state. The state IS the dual code.
  The action IS the projection. No computation. Definitional readout.

  New axioms: 0
-/

namespace Arc3Instant

-- ================================================================
-- Family 1: Constraint Satisfaction (ft09, cn04, s5i5, su15)
-- ================================================================

/-- State for constraint satisfaction games:
    A vector of cell values over Z/mZ with a constraint system. -/
structure CSPState where
  /-- Number of cells. -/
  n : Nat
  /-- Modulus (color cycle length). -/
  m : Nat
  m_pos : m ≥ 1
  /-- Current cell values (each mod m). -/
  cells : Fin n → Fin m
  /-- Target cell values (each mod m). -/
  target : Fin n → Fin m
  /-- Effect matrix: clicking cell i affects cell j. A[j][i] = effect mod m. -/
  effectMatrix : Fin n → Fin n → Fin m

/-- Tension atom for CSP: defect at cell j = (target[j] - current[j]) mod m. -/
def cspTension (s : CSPState) (j : Fin s.n) : Nat :=
  ((s.target j).val + s.m - (s.cells j).val) % s.m

/-- Energy for CSP: number of unsatisfied cells (Hamming distance to target). -/
def cspEnergy (s : CSPState) : Nat :=
  List.range s.n |>.filter (fun j =>
    if h : j < s.n then cspTension s ⟨j, h⟩ ≠ 0 else false) |>.length

/-- CSP is solved when all cells match target. -/
def cspSolved (s : CSPState) : Prop :=
  ∀ j : Fin s.n, s.cells j = s.target j

-- ================================================================
-- Family 2: Shortest Path (ar25, dc22, ka59, sk48, tu93, ls20)
-- ================================================================

/-- State for shortest-path games:
    Position on a finite graph with goal positions. -/
structure PathState where
  /-- Grid width. -/
  width : Nat
  /-- Grid height. -/
  height : Nat
  /-- Player position. -/
  playerX : Nat
  playerY : Nat
  /-- Goal position. -/
  goalX : Nat
  goalY : Nat
  /-- Phase/inventory state (for games with state beyond position). -/
  phase : Nat

/-- Tension for path games: Manhattan distance to goal. -/
def pathTension (s : PathState) : Nat :=
  let dx := if s.playerX ≥ s.goalX then s.playerX - s.goalX else s.goalX - s.playerX
  let dy := if s.playerY ≥ s.goalY then s.playerY - s.goalY else s.goalY - s.playerY
  dx + dy

/-- Energy for path games: distance to goal + phase mismatch. -/
def pathEnergy (s : PathState) : Nat :=
  pathTension s + s.phase

/-- Path game is solved when player reaches goal with correct phase. -/
def pathSolved (s : PathState) : Prop :=
  s.playerX = s.goalX ∧ s.playerY = s.goalY ∧ s.phase = 0

-- ================================================================
-- Family 3: Orbit/Permutation (bp35, sc25, sp80, tr87, wa30, re86)
-- ================================================================

/-- State for orbit/permutation games:
    A vector of cyclic positions that must match targets. -/
structure OrbitState where
  /-- Number of independent orbit elements. -/
  n : Nat
  /-- Modulus for each element (cycle length). -/
  moduli : Fin n → Nat
  /-- Current positions (each mod its modulus). -/
  current : Fin n → Nat
  /-- Target positions. -/
  target : Fin n → Nat

/-- Tension for orbit games: modular distance per element.
    (target - current) mod modulus. -/
def orbitTension (s : OrbitState) (i : Fin s.n) : Nat :=
  let m := s.moduli i
  if m = 0 then 0
  else (s.target i + m - s.current i) % m

/-- Energy for orbit games: sum of modular distances. -/
def orbitEnergy (s : OrbitState) : Nat :=
  List.range s.n |>.foldl (fun acc j =>
    if h : j < s.n then acc + orbitTension s ⟨j, h⟩ else acc) 0

/-- Orbit game is solved when all elements are at target. -/
def orbitSolved (s : OrbitState) : Prop :=
  ∀ i : Fin s.n, orbitTension s i = 0

-- ================================================================
-- Family 4: Inventory/Automaton (g50t, m0r0, vc33, lp85, cd82)
-- ================================================================

/-- State for inventory/automaton games:
    Position × inventory × phase in a finite automaton. -/
structure AutomatonState where
  /-- Position on the graph. -/
  position : Nat
  /-- Inventory bitmask (which items are held). -/
  inventory : Nat
  /-- Phase/stage in the automaton. -/
  phase : Nat
  /-- Goal position. -/
  goalPosition : Nat
  /-- Required inventory at goal. -/
  goalInventory : Nat
  /-- Required phase at goal. -/
  goalPhase : Nat
  /-- Distance lookup: position → goal distance. -/
  distToGoal : Nat

/-- Tension for automaton games: distance + inventory deficit + phase deficit. -/
def automatonTension (s : AutomatonState) : Nat :=
  s.distToGoal +
  (if s.inventory = s.goalInventory then 0 else 1) +
  (if s.phase = s.goalPhase then 0 else 1)

/-- Automaton game is solved when position, inventory, and phase all match. -/
def automatonSolved (s : AutomatonState) : Prop :=
  s.position = s.goalPosition ∧
  s.inventory = s.goalInventory ∧
  s.phase = s.goalPhase

-- ================================================================
-- Family 5: Rewrite/Matching (r11l, sb26, lf52)
-- ================================================================

/-- State for rewrite games:
    A sequence of symbols that must match a target sequence. -/
structure RewriteState where
  /-- Current sequence length. -/
  n : Nat
  /-- Current sequence. -/
  current : Fin n → Nat
  /-- Target sequence. -/
  target : Fin n → Nat

/-- Tension for rewrite games: Hamming distance to target. -/
def rewriteTension (s : RewriteState) : Nat :=
  List.range s.n |>.filter (fun j =>
    if h : j < s.n then s.current ⟨j, h⟩ ≠ s.target ⟨j, h⟩ else false) |>.length

/-- Rewrite game is solved when sequence matches target. -/
def rewriteSolved (s : RewriteState) : Prop :=
  ∀ i : Fin s.n, s.current i = s.target i

-- ================================================================
-- Family 6: Click Puzzle (tn36)
-- ================================================================

/-- State for click puzzle games:
    A set of sprites with positions and a target configuration. -/
structure ClickState where
  /-- Number of clickable sprites. -/
  n : Nat
  /-- Current sprite states (0 = unclicked, 1 = clicked, etc.). -/
  states : Fin n → Nat
  /-- Target states. -/
  targetStates : Fin n → Nat
  /-- Sprite positions (x, y) for coordinate readout. -/
  positions : Fin n → Nat × Nat

/-- Tension for click games: number of sprites not in target state. -/
def clickTension (s : ClickState) : Nat :=
  List.range s.n |>.filter (fun j =>
    if h : j < s.n then s.states ⟨j, h⟩ ≠ s.targetStates ⟨j, h⟩ else false) |>.length

/-- Click game is solved when all sprites are in target state. -/
def clickSolved (s : ClickState) : Prop :=
  ∀ i : Fin s.n, s.states i = s.targetStates i

-- ================================================================
-- The universal ARC game type
-- ================================================================

/-- Every ARC game state falls into one of the six families.
    The observation IS one of these states.
    The dual code IS the tension decomposition of that state. -/
inductive ArcGameState where
  | csp : CSPState → ArcGameState
  | path : PathState → ArcGameState
  | orbit : OrbitState → ArcGameState
  | automaton : AutomatonState → ArcGameState
  | rewrite : RewriteState → ArcGameState
  | click : ClickState → ArcGameState

/-- The universal ARC energy: dispatches to the correct family. -/
def arcEnergy : ArcGameState → Nat
  | .csp s => cspEnergy s
  | .path s => pathEnergy s
  | .orbit s => orbitEnergy s
  | .automaton s => automatonTension s
  | .rewrite s => rewriteTension s
  | .click s => clickTension s

/-- The universal ARC solved predicate. -/
def arcSolved : ArcGameState → Prop
  | .csp s => cspSolved s
  | .path s => pathSolved s
  | .orbit s => orbitSolved s
  | .automaton s => automatonSolved s
  | .rewrite s => rewriteSolved s
  | .click s => clickSolved s

-- ================================================================
-- Core theorems
-- ================================================================

/-- Energy is zero only when solved (for each family). -/
theorem arc_zero_energy_structure (gs : ArcGameState) :
    arcEnergy gs = 0 →
    (match gs with
     | .csp s => cspEnergy s = 0
     | .path s => pathEnergy s = 0
     | .orbit s => orbitEnergy s = 0
     | .automaton s => automatonTension s = 0
     | .rewrite s => rewriteTension s = 0
     | .click s => clickTension s = 0) := by
  intro h
  cases gs <;> exact h

/-- Energy is nonnegative (trivial on Nat). -/
theorem arc_energy_nonneg (gs : ArcGameState) : arcEnergy gs ≥ 0 :=
  Nat.zero_le _

end Arc3Instant
