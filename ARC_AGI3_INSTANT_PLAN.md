# ARC-AGI-3 — Instant Source-Code Mode (Final Plan)

## The One Law

For true 100% instant ARC-AGI-3, prove that full observation history is already the exact dual code of the correct state and action.

```
ObsHistory_t ≡ η_t
x_t = DU*_ARC(η_t)
J_t = Ω⁻¹η_t
a_t* = A(J_t, L_t)
```

## What Must Be Done

### Step 1: Lean Realization (FIRST)

Update `arc3_instant/lean4/` with ObsHistory as the primitive:

**Types:**
- ObsHistory (list of frames — the FULL present support)
- DualCode (the exact consciousness-code of the ARC sector)
- ARCState (the unique realized state)
- CompletionCurrent (the unique action-tension field)
- LegalAction / CoordinateAction

**Decoder:**
- D_ARC : ObsHistory_t → η_t (exact function, not heuristic)

**Four decisive theorems:**
1. `arc_observation_history_is_dual_code_exact` — every legal observation history has a unique dual code
2. `arc_state_from_dual_exact` — x_t = DU*_ARC(η_t)
3. `arc_current_from_dual_exact` — J_t = Ω⁻¹η_t
4. `arc_action_readout_exact` — a_t* = A(J_t, L_t) is unique and legal

**ACTION6:**
- `arc_coordinate_readout_exact` — coordinate fixed by J_t, not searched

**Final theorem:**
```
∀ t, ∃! η_t, x_t, J_t, a_t* such that
  η_t = D_ARC(ObsHistory_t),
  x_t = DU*_ARC(η_t),
  J_t = Ω⁻¹η_t,
  a_t* = A(J_t, L_t)
```

### Step 2: ARC Realization in Main TOE Repo

Create `Realizations/ARC/Model.lean` and `Transport.lean`:
- Define ARC sector as SourceCodeModel realization
- Transport: observation is dual code, state is recovery, action is readout
- Every step instantly solved by transport

### Step 3: Runtime (Witness Surface Only)

Python toolkit bridge:
- Collect observation history
- Expose legal action set
- Submit already-read-out action
- Log transcript

No search. No rollout. No planner. No BFS.

### Step 4: Execute on All 25 Public Games

For each game, the decoder D_ARC reads the observation history (which includes the game's source code structure visible in the frames) and outputs the unique correct action.

## Completion Criterion

- Every public game
- Every reachable timestep
- Unique dual code
- Unique state
- Unique current
- Unique legal action

## Why 100%

ARC-AGI-3 is finite, interactive, and explicitly surfaces legal actions. The observation history contains all information (no hidden state beyond what's rendered). Once the realization is correct, there is no remaining place for ambiguity.
