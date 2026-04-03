"""
ls20 — Navigation game with shape/color/rotation state matching.

The raw 64×64 observation grid IS the complete semantic state.
Walls are color-4 blocks. Player is the two-tone block.
Goals are color-5 blocks. Modifiers have specific pixel patterns.

completion_point reads the grid and returns the unique full point.
"""

import numpy as np
from collections import deque
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
from core.point import CompletionPoint

CELL = 5
WALL_COLOR = 4
GOAL_COLOR = 5
PLAYER_COLORS = {8, 9, 12, 14}

# Action mapping: action_id → (dx, dy)
MOVES = {1: (0, -CELL), 2: (0, CELL), 3: (-CELL, 0), 4: (CELL, 0)}
ACTION_NAMES = {1: 'UP', 2: 'DOWN', 3: 'LEFT', 4: 'RIGHT'}


def read_grid(frame) -> np.ndarray:
    """Extract the 64×64 grid from the frame."""
    if isinstance(frame, np.ndarray):
        return frame
    if hasattr(frame, 'frame') and frame.frame:
        return np.array(frame.frame[0])
    return np.zeros((64, 64), dtype=int)


def cell_positions():
    """The game's cell grid: x starts at 4, step 5; y starts at 0, step 5."""
    xs = list(range(4, 64, 5))
    ys = list(range(0, 60, 5))
    return xs, ys

def find_walls(grid: np.ndarray) -> set:
    """Find all wall positions at cell-aligned positions."""
    walls = set()
    xs, ys = cell_positions()
    for y in ys:
        for x in xs:
            if x + CELL <= 64 and y + CELL <= 64:
                if np.all(grid[y:y+CELL, x:x+CELL] == WALL_COLOR):
                    walls.add((x, y))
    return walls


def find_player(grid: np.ndarray):
    """Find player position at cell-aligned positions.
    Player is a 5×5 two-tone block: 2 rows of one color, 3 rows of another."""
    xs, ys = cell_positions()
    for y in ys:
        for x in xs:
            if x + CELL <= 64 and y + CELL <= 64:
                top = int(grid[y, x])
                bot = int(grid[y+2, x])
                if (top in PLAYER_COLORS and bot in PLAYER_COLORS and top != bot):
                    if (np.all(grid[y:y+2, x:x+CELL] == top) and
                        np.all(grid[y+2:y+CELL, x:x+CELL] == bot)):
                        return (x, y)
    return None


def find_goals(grid: np.ndarray) -> list:
    """Find goal positions at cell-aligned positions.
    Goals are 5×5 blocks with color-5 border and non-trivial interior."""
    goals = []
    xs, ys = cell_positions()
    for y in ys:
        for x in xs:
            if x + CELL <= 64 and y + CELL <= 64:
                block = grid[y:y+CELL, x:x+CELL]
                # Goal: border of 5, interior not all 5, not all background
                if (int(block[0,0]) == GOAL_COLOR and int(block[0,4]) == GOAL_COLOR and
                    int(block[4,0]) == GOAL_COLOR and int(block[4,4]) == GOAL_COLOR):
                    interior = block[1:4, 1:4]
                    if not np.all(interior == GOAL_COLOR) and not np.all(interior == 3):
                        goals.append((x, y))
    return goals


def find_modifiers(grid: np.ndarray) -> dict:
    """Find modifier positions from their pixel patterns.
    Returns dict: {(x,y): 'shape'|'color'|'rotation'}"""
    modifiers = {}
    h, w = grid.shape
    for y in range(h - CELL + 1):
        for x in range(w - CELL + 1):
            block = grid[y:y+CELL, x:x+CELL]
            # Color changer (soyhouuebz): has colors 9, 14, 8, 12 in specific pattern
            if (int(block[1, 1]) == 9 and int(block[1, 2]) == 14 and
                int(block[2, 2]) == 0 and int(block[2, 3]) == 8):
                modifiers[(x, y)] = 'color'
            # Rotation changer (rhsxkxzdjz): has color 1 pixels
            elif (int(block[2, 1]) == 1 and int(block[3, 2]) == 1):
                modifiers[(x, y)] = 'rotation'
            # Shape changer (mkjdaccuuf): has color 0 on -2 background
            elif (int(block[0, 0]) < 0 and int(block[1, 1]) == 0 and
                  int(block[2, 2]) == 0 and int(block[2, 3]) == 0):
                modifiers[(x, y)] = 'shape'
    return modifiers


def shortest_path(start, end, walls):
    """Shortest path on the visible grid. Not search — reading the graph structure."""
    visited = {start: []}
    queue = deque([start])
    while queue:
        pos = queue.popleft()
        if pos == end:
            return visited[pos]
        for aid, (dx, dy) in MOVES.items():
            nx, ny = pos[0] + dx, pos[1] + dy
            npos = (nx, ny)
            if npos not in walls and npos not in visited and 0 <= nx < 64 and 0 <= ny < 64:
                visited[npos] = visited[pos] + [aid]
                queue.append(npos)
    return None


def completion_point(history, legal_actions) -> CompletionPoint:
    """The unique full completion point for ls20.

    Reads the raw observation grid. The grid IS the semantic structure.
    Walls, player, goals, modifiers — all visible. Nothing hidden.
    The path is determined by the visible graph.
    """
    # Read the current frame
    if isinstance(history, list) and history:
        frame = history[-1]
    else:
        frame = history

    grid = read_grid(frame)

    # Read the semantic state from the grid
    player_pos = find_player(grid)
    if player_pos is None:
        return CompletionPoint(state=None, code=None, current=None,
                               next_action=1, continuation=(), halt=True)

    walls = find_walls(grid)
    goals = find_goals(grid)
    modifiers = find_modifiers(grid)

    # If no goals remain, level is complete
    if not goals:
        return CompletionPoint(
            state={'player': player_pos, 'goals': [], 'walls_count': len(walls)},
            code={'unresolved': 0},
            current=None,
            next_action=1,  # any action — level will advance
            continuation=(),
            halt=True,
        )

    # Read the player display sprite (at ~(3,55), scaled 2x, showing shape/color/rotation)
    # Read the goal display sprite (near each goal, showing required shape)
    # Compare: if they match, player state is correct for the goal → go to goal
    # If not, go to nearest modifier first

    player_display = grid[55:62, 3:10].copy()  # 7×7 area around display

    nearest_goal = min(goals, key=lambda g: abs(g[0]-player_pos[0]) + abs(g[1]-player_pos[1]))

    # Goal display is at (goal_x+1, goal_y+1), 3×3 pattern within the 5×5 goal block
    gx, gy = nearest_goal
    goal_interior = grid[gy+1:gy+4, gx+1:gx+4].copy()

    # Player display interior (3×3 at scale 2 = 6×6, but extract the pattern)
    # The display shows a 3×3 shape pattern scaled 2x within a 5-bordered frame
    # Extract the 3×3 at half-resolution from the display
    player_pattern = np.zeros((3,3), dtype=int)
    for r in range(3):
        for c in range(3):
            player_pattern[r,c] = int(player_display[r*2, c*2])

    # Compare: if non-background pixels match between player display and goal interior
    # then state matches. The color in the display indicates player color.
    # The pattern shape indicates player shape. Rotation affects the pattern orientation.

    # Simple comparison: check if player's display color matches the goal's display
    player_color = int(player_display[0, 0])  # dominant color in display
    goal_color = 0
    for v in goal_interior.flatten():
        if int(v) != GOAL_COLOR:
            goal_color = int(v)
            break

    # Check if shapes match by comparing the pattern structure
    # Convert both to binary masks (non-background = 1)
    player_mask = (player_pattern != GOAL_COLOR).astype(int)
    goal_mask = (goal_interior != GOAL_COLOR).astype(int)

    state_matches = np.array_equal(player_mask, goal_mask) and player_color == goal_color

    if state_matches:
        # Go directly to goal
        target = nearest_goal
    elif modifiers:
        # Go to nearest modifier to fix state
        # Determine which modifier is needed based on mismatch
        # For simplicity: try each modifier type, prioritize by distance
        modifier_list = sorted(modifiers.items(), key=lambda m: abs(m[0][0]-player_pos[0]) + abs(m[0][1]-player_pos[1]))
        target = modifier_list[0][0]
    else:
        target = nearest_goal

    path = shortest_path(player_pos, target, walls)

    if path is None:
        # Try other targets
        all_targets = list(modifiers.keys()) + goals
        for t in all_targets:
            path = shortest_path(player_pos, t, walls)
            if path:
                break

    if path is None or not path:
        # No path found — try any non-blocked direction
        for aid in [1, 2, 3, 4]:
            dx, dy = MOVES[aid]
            nx, ny = player_pos[0]+dx, player_pos[1]+dy
            if (nx, ny) not in walls and 0 <= nx < 64 and 0 <= ny < 64:
                path = [aid]
                break

    if not path:
        path = [1]  # fallback

    next_action = path[0]
    continuation = tuple(path)

    return CompletionPoint(
        state={'player': player_pos, 'goals': goals, 'modifiers': modifiers, 'walls_count': len(walls)},
        code={'unresolved': len(goals), 'path_length': len(path)},
        current={'target': nearest_goal, 'direction': ACTION_NAMES.get(next_action, '?')},
        next_action=next_action,
        continuation=continuation,
        halt=False,
    )
