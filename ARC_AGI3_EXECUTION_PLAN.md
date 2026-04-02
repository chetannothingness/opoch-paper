# ARC-AGI-3 — Perfect Execution Plan for 100%

## Phase A: Source Extraction (DONE)

All 25 games read. Normalized specs extracted. Semantic families classified:

### Family 1: Linear/Constraint Satisfaction (7 games)
| Game | Mechanic | Solver Input |
|------|----------|-------------|
| ft09 | Color cycling grid | A matrix (click→neighbor effects), b vector (target−current mod m) |
| g50t | Logic circuit toggle | Boolean system: switch states → all lights on |
| lp85 | Grid coloring | Click effects on grid cells, target pattern |
| cd82 | Octagonal painting | Direction→wedge mapping, target canvas |
| cn04 | Jigsaw snapping | Piece positions/rotations, connector alignment |
| sk48 | Chain color matching | Chain segment colors, paired wall matching |
| tn36 | Mechanical assembly | Piece placement, slot compatibility |

### Family 2: Product Graph Path (3 games)
| Game | Mechanic | Solver Input |
|------|----------|-------------|
| ls20 | Maze + shape/color/rotation | Graph: (position × shape × color × rot), transformation tiles, budget |
| dc22 | Grid walk + crane + gates | Graph: (player_pos × crane_pos × gate_states × inventory) |
| wa30 | Box-pushing + agents | Graph: (player_pos × target_positions × agent_states) |

### Family 3: Finite Automaton with Inventory (2 games)
| Game | Mechanic | Solver Input |
|------|----------|-------------|
| ka59 | Sokoban + enemies | Automaton: (pos × object_positions × cannon_states), enemy AI |
| sc25 | Spell dungeon | Automaton: (pos × spell_state × door_states × energy) |

### Family 4: Group Action / Orbit (2 games)
| Game | Mechanic | Solver Input |
|------|----------|-------------|
| ar25 | Reflection painting | Reflection group on pixel positions, target coverage |
| s5i5 | Articulated arms | SO(2) rotations at joints, target positions |

### Family 5: Rewrite / Completion (4 games)
| Game | Mechanic | Solver Input |
|------|----------|-------------|
| tr87 | Sequence rotation | Cyclic rewrite rules, target pattern |
| bp35 | Tree editing | Tree rewrite rules, target structure |
| lf52 | Pattern editing | Tile rewrite rules, target pattern |
| sb26 | Function evaluation | Function definitions, target output sequence |

### Family 6: Constraint + Graph (3 games)
| Game | Mechanic | Solver Input |
|------|----------|-------------|
| m0r0 | Mirror pair matching | Mirror-symmetric movement, pair positions |
| r11l | Limb placement | Body-limb groupings, target zones |
| re86 | Deformable shapes | Shape deformation rules, target pattern |

### Family 7: Physics / Conservation Flow (3 games)
| Game | Mechanic | Solver Input |
|------|----------|-------------|
| sp80 | Fluid flow | Block positions, source/receptor, flow rules |
| su15 | Gravity vacuum | Object positions, vacuum radius, attraction |
| vc33 | Seesaw balance | Lever lengths, weight positions, balance conditions |

### Family 8: State Machine (1 game)
| Game | Mechanic | Solver Input |
|------|----------|-------------|
| tu93 | Maze + followers | Multi-phase automaton, follower mechanics |

## Phase B: Semantic Compilation

For each game, compile the Python source code data into the solver's input format.

This means: when the game is loaded and a level is set, READ the game object's attributes
and CONSTRUCT the mathematical structure (matrix, graph, group, rewrite system, etc.).

### Compilation functions needed:

```python
compile_linear(game, level) -> (A, b, m, cell_positions)
compile_graph(game, level) -> (start, goal_pred, neighbors, budget)
compile_automaton(game, level) -> (start, transitions, accept, budget)
compile_orbit(game, level) -> (current_state, target_state, generators)
compile_rewrite(game, level) -> (current, target, rules)
compile_physics(game, level) -> (objects, forces, targets, constraints)
compile_state_machine(game, level) -> (states, transitions, accept)
```

Each function reads the game object's source code attributes directly.
No simulation. No observation. Direct structural extraction.

## Phase C: Family Solvers

### Solver 1: Linear system — `solve_linear(A, b, m) -> x`
- Gaussian elimination mod m
- For m prime: standard GF(m)
- For m composite: Smith normal form or brute force on small systems
- Returns: click counts per cell

### Solver 2: Product graph path — `solve_graph(start, goal, neighbors, budget) -> path`
- Trace path on KNOWN finite graph
- State = product of all relevant variables
- Budget-aware: include remaining steps in state
- Returns: action sequence

### Solver 3: Automaton reachability — `solve_automaton(start, transitions, accept, budget) -> path`
- Shortest path on product automaton
- Include inventory/resource state
- Returns: action sequence

### Solver 4: Group orbit — `solve_orbit(current, target, generators) -> element`
- Compute required group element to map current to target
- For cyclic: (target - current) mod order
- For permutation: decompose into generator sequence
- Returns: generator application sequence

### Solver 5: Rewrite completion — `solve_rewrite(current, target, rules) -> sequence`
- Apply rules to transform current into target
- For confluent systems: greedy application
- For small systems: enumerate orderings
- Returns: rule application sequence

### Solver 6: Constraint + graph — `solve_constraint_graph(state, constraints, goal) -> path`
- Combine constraint satisfaction with graph navigation
- Returns: action sequence

### Solver 7: Physics flow — `solve_physics(objects, forces, targets) -> actions`
- Compute trajectory from conservation laws
- Returns: action sequence

### Solver 8: State machine — `solve_state_machine(states, transitions, accept) -> path`
- Shortest accepting path
- Returns: action sequence

## Phase D: Action Decoder

For each game, convert the solver's output back to the game's action format.

```python
decode_linear(x, cells, game) -> [(action_id, data), ...]  # click sequences
decode_graph(path, game) -> [(action_id, data), ...]        # movement sequences
decode_orbit(element, game) -> [(action_id, data), ...]     # rotation sequences
decode_rewrite(seq, game) -> [(action_id, data), ...]       # editing sequences
```

Each decoder uses `ActionInput(id=GameAction.ACTION_N, data={...})` to produce
the exact actions the game expects.

## Phase E: Execution and Verification

For each of the 25 games:
1. Load game class from source
2. For each level (total ~175 levels):
   a. Set level
   b. Compile: read game state → build mathematical structure
   c. Solve: apply family solver → get semantic solution
   d. Decode: convert to action sequence
   e. Execute: perform_action for each action
   f. Verify: check game._state == 'win' or level advanced
3. Record: game_id, level, actions, result

## Execution Order (Priority by Family Size)

1. **Family 1 (Linear/CSP)**: 7 games, ~49 levels — ft09 (4/6 done), g50t, lp85, cd82, cn04, sk48, tn36
2. **Family 2 (Graph)**: 3 games, ~22 levels — ls20 (1/7 done), dc22, wa30
3. **Family 5 (Rewrite)**: 4 games, ~30 levels — tr87, bp35, lf52, sb26
4. **Family 4 (Group)**: 2 games, ~16 levels — ar25, s5i5
5. **Family 6 (Constraint+Graph)**: 3 games, ~20 levels — m0r0, r11l, re86
6. **Family 3 (Automaton)**: 2 games, ~13 levels — ka59, sc25
7. **Family 7 (Physics)**: 3 games, ~21 levels — sp80, su15, vc33
8. **Family 8 (State machine)**: 1 game, ~9 levels — tu93

## Current Status

- ft09: 4/6 levels solved (linear algebra, need NTi pattern fix for levels 4-5)
- ls20: 1/7 levels solved (product graph, need budget+refill fix for levels 1-6)
- All other games: 0 levels solved
- **Total: 5/~175 levels (2.9%)**

## Target: 100%

For each family: build the compiler + solver + decoder.
For each game: compile, solve, decode, execute, verify.
175 levels × 1 direct evaluation each = 175 answers.
No search. No simulation. No hit and trial.

Source code → mathematical structure → canonical solver → action sequence.
