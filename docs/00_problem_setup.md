# Warehouse Large — Problem Setup
Instance: warehouse_large, LoRR 2024 Main Round Evaluation
Source: `/lorr-benchmark-archive/2024 Competition/Main Round Evaluation Instances/warehouse.domain/`
Verified: 2025-02-16 via static scan against actual instance files.

## 1. Map Layout (500 x 140 = 70,000 cells)

┌───────────────────────────────────┬────────┬────────┬──────────┐
│            Cell Type              │ Symbol │ Count  │ % of Map │
├───────────────────────────────────┼────────┼────────┼──────────┤
│ Passable corridor / open floor    │ .      │ 12,985 │ 18.5%    │
├───────────────────────────────────┼────────┼────────┼──────────┤
│ Obstacle (wall / pillar)          │ @      │ 31,414 │ 44.9%    │
├───────────────────────────────────┼────────┼────────┼──────────┤
│ Endpoint (pickup/dropoff station) │ E      │    352 │  0.5%    │
├───────────────────────────────────┼────────┼────────┼──────────┤
│ Shelf (storage, traversable)      │ S      │ 25,249 │ 36.1%    │
├───────────────────────────────────┼────────┼────────┼──────────┤
│ Total passable (. + E + S)        │        │ 38,586 │ 55.1%    │
└───────────────────────────────────┴────────┴────────┴──────────┘

Passability rule (from C++ Start Kit Grid.cpp:60-63):
Only `@` and `T` are obstacles. All other characters (`.`, `S`, `E`) are traversable.

### 1.1 Vertical zones (row bands)

```
rows   0-2:   E-strip top       (E cells at row 1, flanked by `.` rows 0, 2)
rows   3-6:   Top highway        (4 pure-`.` rows, 492-500 passable each, no shelves)
rows  7-130:  Shelf zone         (42 internal corridors + 41 shelf basins)
rows 131-136: Bottom highway     (6 pure-`.` rows, 492-500 passable each, no shelves)
rows 137-139: E-strip bottom    (E cells at row 138, flanked by `.` rows 137, 139)
```

### 1.2 Shelf zone structure (rows 7-130)

The shelf zone repeats a 3-row pattern:

```
row  7: .SSS.SSS.SSS.SSS.SSS...  (shelf-corridor: 134 `.` + 363 `S` = 497 passable)
row  8: S@@@S@@@S@@@S@@@S@@@S...  (basin wall:     12 `.` + 122 `S` = 134 passable, only at aisle cols)
row  9: S@@@S@@@S@@@S@@@S@@@S...  (basin wall:     14 `.` + 122 `S` = 137 passable, only at aisle cols)
row 10: .SSS.SSS.SSS.SSS.SSS...  (shelf-corridor: 137 `.` + 363 `S` = 500 passable)
row 11: S@@@S@@@S@@@S@@@S@@@S...  (basin wall)
row 12: S@@@S@@@S@@@S@@@S@@@S...  (basin wall)
row 13: .SSS.SSS.SSS.SSS.SSS...  (shelf-corridor)
...repeats...
row 130: .SSS.SSS.SSS.SSS.SSS... (last shelf-corridor)
```

**Internal corridors**: Rows 7, 10, 13, 16, ..., 130 (every 3rd row). Total: **42** rows.
Each is ~497-500 cells wide (fully traversable — the S cells are passable).
These are the east-west arteries through the shelf zone. Robots traverse shelf faces (S cells) en route.

**Shelf basins**: The 2-row gaps between consecutive internal corridors. Total: **41** basins.
Each basin is 2 rows of `S@@@S` pattern: shelf walls with passable shelf faces only at aisle columns.
Each basin contains 244 S cells (shelf faces accessible from vertical aisles).

### 1.3 Vertical aisles

**131 vertical aisle columns** running the full height of the shelf zone (rows 7-130).
Every cell in an aisle column is passable (it's either `.` or `S` on corridor rows, and `S` on basin rows).
Spacing: predominantly every 4 columns (121 intervals of 4, plus 9 intervals of 1 at the perimeter buffer).
First 15 columns: 3, 4, 5, 6, 7, 11, 15, 19, 23, 27, 31, 35, 39, 43, 47.

Aisles are **1 cell wide**. A robot occupying an aisle cell blocks all traffic through that cell.
Bidirectional traffic in aisles causes head-on deadlock — one-way lane assignment eliminates this.

### 1.4 Endpoint layout

352 E cells arranged on the perimeter in 4 strips:
┌────────┬──────────────────────┬───────┬──────────────────────────┐
│ Strip  │       Location       │ Count │         Spacing          │
├────────┼──────────────────────┼───────┼──────────────────────────┤
│ Top    │ row 1, cols 7-494    │ 140   │ alternating 3 and 4 cols │
├────────┼──────────────────────┼───────┼──────────────────────────┤
│ Bottom │ row 138, cols 5-492  │ 140   │ alternating 3 and 4 cols │
├────────┼──────────────────────┼───────┼──────────────────────────┤
│ Left   │ col 1, rows 5-128   │  36   │ alternating 3 and 4 rows │
├────────┼──────────────────────┼───────┼──────────────────────────┤
│ Right  │ col 498, rows 11-134 │  36   │ alternating 3 and 4 rows │
└────────┴──────────────────────┴───────┴──────────────────────────┘

All 352 E cells have degree 3 (3 passable neighbors, 1 wall behind). No dead-ends.

## 2. Robots

┌────────────────────┬──────────────────────────────────────────────┐
│     Parameter      │                    Value                     │
├────────────────────┼──────────────────────────────────────────────┤
│ Team size          │ 10,000                                       │
├────────────────────┼──────────────────────────────────────────────┤
│ Starting positions │ Pre-assigned in warehouse_large_10000.agents │
├────────────────────┼──────────────────────────────────────────────┤
│ Agent format       │ One cell index (integer) per line.           │
│                    │ cell_index = row * 500 + col.                │
│                    │ Starting orientation is not in the file      │
│                    │ (assigned by simulator, typically East=0).   │
└────────────────────┴──────────────────────────────────────────────┘

Agent starting cell types:
- S cells (shelf faces): 6,572 (65.7%)
- `.` cells (corridor/floor): 3,346 (33.5%)
- E cells (endpoints): 82 (0.8%)

10,000 robots on 38,586 passable cells = **25.9% density** (roughly 1 in 4 passable cells occupied).

## 3. Simulation Parameters

┌─────────────────────────┬─────────────────────────────────────────────────────┐
│        Parameter        │                       Value                         │
├─────────────────────────┼─────────────────────────────────────────────────────┤
│ Simulation length       │ T = 5,000 ticks                                    │
├─────────────────────────┼─────────────────────────────────────────────────────┤
│ Planning time per tick  │ 1 second wall-clock (soft deadline; miss → all-W)   │
├─────────────────────────┼─────────────────────────────────────────────────────┤
│ Preprocessing time      │ 30 minutes (one-time before simulation)             │
├─────────────────────────┼─────────────────────────────────────────────────────┤
│ Total wall-clock budget │ ~83 minutes (30 min preprocess + 5000 × 1s ticks)   │
└─────────────────────────┴─────────────────────────────────────────────────────┘

## 4. Task Model

Config from `WAREHOUSE.json`:
```json
{
    "mapFile": "maps/warehouse_large.map",
    "agentFile": "agents/warehouse_large_10000.agents",
    "teamSize": 10000,
    "taskFile": "tasks/warehouse_large.tasks",
    "numTasksReveal": 1.5,
    "version": "2024 LoRR"
}
```

### 4.1 Pool mechanics

- Pool target = floor(1.5 × 10,000) = **15,000 tasks visible** at any time
- 100,000 task templates pre-generated in `warehouse_large.tasks`
- Each task = `(start_cell, end_cell)` — a 2-location errand
- Robot visits start_cell first, then end_cell. Score increments on reaching end_cell.
- When a robot completes a task, it is removed from pool and the next template is revealed.
- Completion is immediate upon entering end_cell — no dwell time required.

### 4.2 Task type distribution — ACTUAL DATA

**All 100,000 tasks are E→S (100.0%).** Zero S→E, zero E→E, zero S→S.

This was verified by classifying every task in the actual `warehouse_large.tasks` file:
```
E->S: 100,000 (100.0%)
```

The tasks were generated by `warehouse_task_generator.py` in **Amazon/2024 mode** (`generate_amazon_warehouse_tasks()`), which:
1. Selects first waypoint uniformly from E cells (352 options)
2. Selects second waypoint from S cells using distance-bucket bias (closer shelves more likely)

Source: `/lorr-benchmark-archive/2024 Competition/Problem Generator/script/warehouse_task_generator.py`

NOTE: The generator also has a **random mode** (`random_generate()` with `task_type_rl=[0.5, 0.5]`) that produces a 25/25/25/25 split of E→S, S→E, E→E, S→S. This is NOT what the competition instance uses.

### 4.3 Task cycle implication

Since all tasks are E→S, the robot lifecycle is:
```
current_pos → E_j (first waypoint) → S_j (second waypoint, score++) → E_{j+1} → S_{j+1} → ...
```

Each task cycle has two legs:
- **Leg 1 (repositioning):** Travel from current position (typically an S cell after the last completion) to the task's E cell.
- **Leg 2 (fulfillment):** Travel from the E cell to the task's S cell.

The scheduler controls which task is assigned. A good scheduler minimizes Leg 1 by picking tasks whose E cell is near the robot.

### 4.4 Distance statistics (oriented BFS, actual 100K E→S tasks)

Computed via forward oriented BFS from all 352 unique start cells (= all E cells).
State = (cell, orientation), transitions = FW/CR/CCR each cost 1 tick. 0 unreachable tasks.

```
d0 (E→S, empty-map oriented BFS distance):
  min  =   8
  p10  =  88
  p25  = 140
  p50  = 231  (median)
  p75  = 354
  p90  = 447
  p95  = 487
  p99  = 542
  max  = 612
  mean = 250.6
```

Throughput bound (zero-congestion, E→S leg only):
  5000 ticks × 10,000 robots / 231 median = 216,450 tasks (upper bound if Leg 1 = 0).
  With Leg 1 overhead, this drops significantly.

## 5. Scoring

- Score = total tasks completed across all 5,000 ticks.
- No partial credit — a task counts only when the robot reaches end_cell.
- SOTA score: **S_sota = 154,834** tasks (Team No Man's Sky, LoRR 2024).

## 6. Action Model

Robots have 4-cardinal orientation (East=0, South=1, West=2, North=3).

┌────────┬──────────────────────────────────────────────────────────┐
│ Action │                       Effect                            │
├────────┼──────────────────────────────────────────────────────────┤
│ FW     │ Move 1 cell in facing direction (if target is passable) │
├────────┼──────────────────────────────────────────────────────────┤
│ CR     │ Rotate 90° clockwise (no movement)                      │
├────────┼──────────────────────────────────────────────────────────┤
│ CCR    │ Rotate 90° counter-clockwise (no movement)              │
├────────┼──────────────────────────────────────────────────────────┤
│ W      │ Wait (no movement, no rotation)                         │
└────────┴──────────────────────────────────────────────────────────┘

Turning cost: A robot facing East that needs to go North spends 1 tick on CCR, then FW. A 180° turn costs 2 ticks (CR, CR or CCR, CCR).

## 7. Conflict Predicate

The `valid_actions()` check is a single boolean over the entire joint action vector:

┌────────────────────┬───────────────────────────────────────────────┬────────────────────────────────────┐
│       Check        │                   Predicate                   │          What it catches           │
├────────────────────┼───────────────────────────────────────────────┼────────────────────────────────────┤
│ Per-robot legality │ FW target must be in-bounds and passable      │ Wall collision, out-of-bounds      │
├────────────────────┼───────────────────────────────────────────────┼────────────────────────────────────┤
│ Vertex conflict    │ new_loc[i] == new_loc[j] for any i<j          │ Two robots at same cell after move │
├────────────────────┼───────────────────────────────────────────────┼────────────────────────────────────┤
│ Swap conflict      │ old[i]==new[j] AND old[j]==new[i] for any i<j │ Head-on edge crossing              │
└────────────────────┴───────────────────────────────────────────────┴────────────────────────────────────┘

Key behaviors:
- **Following allowed:** A→B and B→C in same tick is valid. Robots can chain-follow.
- **Global rejection:** If ANY check fails, the ENTIRE action vector becomes all-W, planner_errors += 1. Schedule is unaffected.
- **Rotate never conflicts in practice:** CR/CCR keep new_loc = old_loc. Two robots can't start at the same cell.

## 8. Task Assignment Semantics

┌──────────────┬──────────────┬───────────────────┬─────────────────┐
│    State     │ idx_next_loc │   Can reassign?   │ Can drop to -1? │
├──────────────┼──────────────┼───────────────────┼─────────────────┤
│ Unstarted    │ 0            │ Yes, freely       │ Yes             │
├──────────────┼──────────────┼───────────────────┼─────────────────┤
│ Opened (WIP) │ > 0          │ No — LOCKED       │ No — LOCKED     │
├──────────────┼──────────────┼───────────────────┼─────────────────┤
│ Finished     │ >= len       │ Removed from pool │ Auto-freed      │
└──────────────┴──────────────┴───────────────────┴─────────────────┘

- Once idx_next_loc > 0 (robot has visited the first waypoint), the robot is strictly locked to that task.
- Lock violation → schedule rejected entirely, previous schedule retained, schedule_errors += 1.
- A different robot cannot pick up an opened task (cross-agent check).
- Partial progress persists — idx_next_loc never resets.

## 9. Simulator Tick Order

Global validate-then-apply, per tick:
```
1. apply_schedule(proposed_schedule)
   → if invalid: keep previous, schedule_errors++
2. valid_actions(all_actions_jointly)
   → if ANY conflict: entire vector → all-W, planner_errors++
3. step_move(action_used)
4. step_tasks()      ← completion check (immediate on entering end_cell)
5. step_reveal()     ← refill task pool to 15,000
6. tick++
```

## 10. Corridor Graph H — Structural Constants

### 10.1 Summary

┌────────────────────────────────────────┬────────┬──────────────────────────────────────────┐
│                Element                 │ Count  │                Description               │
├────────────────────────────────────────┼────────┼──────────────────────────────────────────┤
│ Internal horizontal corridors          │     42 │ Rows 7,10,13,...,130 (every 3 rows)      │
│                                        │        │ ~500 passable cells each (`.` + `S`)     │
├────────────────────────────────────────┼────────┼──────────────────────────────────────────┤
│ Top highway rows                       │      4 │ Rows 3, 4, 5, 6 (pure `.`, no shelves)  │
├────────────────────────────────────────┼────────┼──────────────────────────────────────────┤
│ Bottom highway rows                    │      6 │ Rows 131-136 (pure `.`, no shelves)      │
├────────────────────────────────────────┼────────┼──────────────────────────────────────────┤
│ Vertical aisle columns                 │    131 │ Every 4 cols (+ 9 at perimeter buffer)   │
├────────────────────────────────────────┼────────┼──────────────────────────────────────────┤
│ Shelf basins                           │     41 │ 2 wall-rows between consecutive corridors│
│                                        │        │ 244 S cells per basin                    │
├────────────────────────────────────────┼────────┼──────────────────────────────────────────┤
│ Mouths (basin wall cells on aisles)    │ 10,742 │ 262 per basin (131 up + 131 down)        │
├────────────────────────────────────────┼────────┼──────────────────────────────────────────┤
│ Intersections (internal corr × aisle)  │  5,502 │ 42 corridors × 131 aisles                │
├────────────────────────────────────────┼────────┼──────────────────────────────────────────┤
│ Total intersections (all corr × aisle) │  6,808 │ (42 + 10 highway) × 131 aisles           │
└────────────────────────────────────────┴────────┴──────────────────────────────────────────┘

### 10.2 Min-cut capacities

Path from shelf interior to E strip passes through three cut stages:

Shelf → Top E strip:
┌───────────────────────────────┬──────────────────────────────────────────┬────────────────────┐
│              Cut              │                 Capacity                 │       Width        │
├───────────────────────────────┼──────────────────────────────────────────┼────────────────────┤
│ A: Basin mouths → corridor    │ 262 per basin (131 up + 131 down)        │ 5,371 total upward │
├───────────────────────────────┼──────────────────────────────────────────┼────────────────────┤
│ B: Top corridor → buffer zone │ 497 (passable cols from row 7 to row 6)  │                    │
├───────────────────────────────┼──────────────────────────────────────────┼────────────────────┤
│ C: Buffer → E strip (row 1)   │ 140 (all 140 E cells have passable path) │ BOTTLENECK         │
└───────────────────────────────┴──────────────────────────────────────────┴────────────────────┘

Shelf → Bottom E strip: Symmetric. Cut C = 140.
Shelf → Left E strip (col 1): 36 E cells. BOTTLENECK = 36.
Shelf → Right E strip (col 498): 36 E cells. BOTTLENECK = 36.

### 10.3 E-cell throughput bound (corrected for 100% E→S)

Since all tasks are E→S, each task requires exactly 1 E-cell visit (the robot visits the E cell as the first waypoint). Additionally, after completing the S cell, the robot must return to an E cell for the next task — this is repositioning, not part of the task, but still consumes E-cell capacity.

Effective E-cell traversals per task cycle: ~2 (arrive at E for task, depart E toward S; plus arrive at E for next task).
Max E throughput: 352 cells × 1 robot/tick = 352 robot-visits/tick.
Max tasks/tick from E capacity: 352 / 2 ≈ 176 tasks/tick.
Max tasks over 5000 ticks: ~880,000 — not binding at S_sota = 154,834.

### 10.4 Mouth aggregate capacity

Each E→S task cycle requires the robot to:
- Enter a basin through 1 mouth (going to the S cell)
- Exit the basin through 1 mouth (repositioning to next E cell)
Minimum mouth traversals per task cycle: 2.

Total directional mouth capacity: 10,742 mouths × 1 robot/tick = 10,742/tick.
Max tasks/tick from mouths: 10,742 / 2 ≈ 5,371 — not binding.

The true binding constraint at SOTA throughput (~31 tasks/tick) is **congestion inflation** from 10,000 robots at 26% density, not raw structural capacity.

### 10.5 Service rates at bottleneck types

┌─────────────────────────┬─────────────┬──────────────────────────────────────┬──────────────────────────────┐
│     Bottleneck type     │    Count    │    Service rate (directed lanes)     │ Service rate (bidirectional) │
├─────────────────────────┼─────────────┼──────────────────────────────────────┼──────────────────────────────┤
│ Mouth edge              │ 10,742      │ 1 robot/tick per direction           │ 0.5 robot/tick (time-sliced) │
├─────────────────────────┼─────────────┼──────────────────────────────────────┼──────────────────────────────┤
│ Intersection (degree 4) │ ~5,467      │ 2 robots/tick (non-conflicting pair) │ 1 robot/tick (round-robin)   │
├─────────────────────────┼─────────────┼──────────────────────────────────────┼──────────────────────────────┤
│ Corridor segment        │ 1 cell wide │ 1 robot/tick per direction           │ 0.5 robot/tick               │
├─────────────────────────┼─────────────┼──────────────────────────────────────┼──────────────────────────────┤
│ E cell                  │ 352         │ 1 robot/tick (arrival or departure)  │ 1 robot/tick                 │
└─────────────────────────┴─────────────┴──────────────────────────────────────┴──────────────────────────────┘

## 11. Competition Machine

┌───────────┬────────────────────────────────────────────┐
│ Component │               Specification                │
├───────────┼────────────────────────────────────────────┤
│ CPU       │ AMD EPYC 7R32 (Zen2)                       │
├───────────┼────────────────────────────────────────────┤
│ Cores     │ 16 physical cores × 2 threads = 32 threads │
├───────────┼────────────────────────────────────────────┤
│ RAM       │ 128 GB                                     │
├───────────┼────────────────────────────────────────────┤
│ GPU       │ NVIDIA A10G (24 GB VRAM, Ampere)           │
├───────────┼────────────────────────────────────────────┤
│ Storage   │ ~27 GB free                                │
├───────────┼────────────────────────────────────────────┤
│ ISA       │ x86_64, AVX2, SSE4.2, AES-NI               │
├───────────┼────────────────────────────────────────────┤
│ Docker    │ pytorch/pytorch:2.4.1-cuda11.8-cudnn9-devel │
│           │ Ubuntu 22.04                                │
└───────────┴────────────────────────────────────────────┘

All 32 threads and GPU available. No internet during evaluation.
SOTA (NMS) uses 32 parallel PIBTS threads for motion planning (embarrassingly parallel).

## 12. Key Derived Constants

For the theorem (02_theorems.md):

```
N           = 10,000    (robots)
T           = 5,000     (ticks)
S_sota      = 154,834   (SOTA score)
C_target    = T*N / (S_sota + N) = 303.34 ticks per task cycle

d0_median   = 231       (E→S oriented BFS, empty map)
d0_mean     = 250.6
d0_max      = 612

Corridors   = 42 internal + 10 highway = 52 total
Aisles      = 131 vertical columns
Basins      = 41 (2 wall-rows each, 244 S cells each)
Mouths      = 10,742 (262 per basin)
Intersections = 5,502 (internal corridor × aisle)
E cells     = 352

Task type   = 100% E→S (Amazon/2024 generator mode)
Tasks       = 100,000 templates, 15,000 visible pool
```
