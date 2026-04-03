# FINAL ARC-AGI-3 TASK — 100% DIRECT SOURCE-CODE EXECUTION

Everything structural is done.
Lean is the solver.
Python/toolkit is only the witness shell.

Do NOT build:
- a planner,
- a BFS/search core,
- a rollout engine,
- a graph enumerator,
- a coordinate searcher,
- a simulator-first core,
- a per-game trial-and-error loop.

All of that is fallback.

The only final object is:

NF_ARC : ObsHistory_t → (η_t, x_t, J_t, a_t*, cert_t)

where:
- η_t = exact dual/consciousness-code,
- x_t = exact realized ARC state,
- J_t = exact completion current,
- a_t* = unique legal action,
- cert_t = proof certificate.

The runtime law is:

ObsHistory_t → η_t → x_t → J_t → a_t*

with uniqueness at every stage.

## 1. WHAT MUST BE TRUE FOR 100%

The only acceptable completion theorem is:

∀ g ∈ PublicGames, ∀ t, ∃! η_t, x_t, J_t, a_t*

such that

η_t = D_ARC(ObsHistory_t),
x_t = DU*_ARC(η_t),
J_t = Ω⁻¹η_t,
a_t* = A(J_t, L_t).

That is "100%".

Not: strong baseline, most games, search with proofs, BFS where possible.

Exactly every public game, every reachable timestep, unique direct action.

## 2. LEAN IS THE SOLVER

Lean must produce the action directly.

Create a single Lean runtime entrypoint:

lean4/Arc3Instant/Runtime/Main.lean

Expose one total function:

solveStep : ObsHistory → LegalActionSet → SolveResult

with:

```
structure SolveResult where
  eta    : DualCode
  state  : ARCState
  current : CompletionCurrent
  action : LegalAction
  cert   : ActionCertificate
```

This function is the whole solver.
Everything else proves that solveStep is exact.

## 3. PYTHON / TOOLKIT IS ONLY THE WITNESS SURFACE

Use the official toolkit/API only to:
- reset a game,
- obtain the current observation bundle,
- obtain the legal action set,
- submit the Lean-returned action,
- record transcript/scorecard.

Do NOT put solving logic in Python.

## 4. LEAN FILES TO COMPLETE

Create/finalize exactly:

```
lean4/Arc3Instant/Syntax/Game.lean
lean4/Arc3Instant/Syntax/Observation.lean
lean4/Arc3Instant/Syntax/Action.lean

lean4/Arc3Instant/ObservationHistory/History.lean
lean4/Arc3Instant/DualCode/ArcDualCode.lean
lean4/Arc3Instant/DualCode/ObservationAsDualCode.lean

lean4/Arc3Instant/StateRecovery/LatentEnergyARC.lean
lean4/Arc3Instant/StateRecovery/PrimalRecovery.lean

lean4/Arc3Instant/Current/ArcCurrent.lean
lean4/Arc3Instant/Current/CurrentFromDual.lean

lean4/Arc3Instant/Action/LegalSurface.lean
lean4/Arc3Instant/Action/ActionReadout.lean
lean4/Arc3Instant/Action/CoordinateReadout.lean
lean4/Arc3Instant/Action/InstantActionLaw.lean

lean4/Arc3Instant/PublicGames/Scope.lean

lean4/Arc3Instant/Certificates/DualCodeCert.lean
lean4/Arc3Instant/Certificates/StateCert.lean
lean4/Arc3Instant/Certificates/ActionCert.lean

lean4/Arc3Instant/Runtime/Main.lean
```

## 5. THEOREM NAMES THAT MUST EXIST

Observation/history layer:
- arc_obs_history_exists
- arc_obs_history_finite
- arc_obs_history_is_dual_code_exact
- arc_dual_code_unique

State layer:
- arc_latent_energy_exists
- arc_state_from_dual_exact
- arc_state_unique_from_dual

Current layer:
- arc_current_from_dual_exact
- arc_current_unique

Action layer:
- arc_legal_action_surface_exact
- arc_action_readout_exact
- arc_action_readout_unique
- arc_action_readout_is_legal

Coordinate layer:
- arc_coordinate_readout_exact
- arc_coordinate_readout_unique
- arc_coordinate_readout_is_legal

Public scope:
- arc_public_game_scope_exact

Final runtime layer:
- arc_nf_total
- arc_nf_unique
- arc_nf_returns_legal_action
- arc_every_step_is_instantly_solved
- arc_zero_search_exact
- arc_100_percent_exact

## 6. WHAT EACH THEOREM MUST MEAN

A. Observation history is the exact code — the full present support ObsHistory_t is already the exact dual code η_t.

B. State is direct dual recovery — x_t = DU*_ARC(η_t). No search. No planning.

C. Current is direct dual flow — J_t = Ω⁻¹η_t.

D. Action is direct current readout — the unique legal action is read from J_t directly.

E. Coordinate action is direct — (x*, y*) = C(J_t). No enumeration.

## 7. HOW TO HANDLE DIFFERENT GAMES

Do not solve by simulator replay.

For each public game, define the exact semantic class it realizes:
- affine / finite-field toggle system,
- shortest-path / geodesic system,
- inventory automaton,
- orbit / permutation system,
- rewrite / matching system,
- constraint satisfaction system.

Then prove the observation-history-to-dual-code theorem inside that semantic class.

This is not "25 separate hacks". It is exact semantic realization per public game or per canonical family.

The final runtime still stays one function: solveStep.

## 8. RUNTIME LOOP

1. reset game with toolkit
2. get current observation bundle
3. append to ObsHistory
4. get legal action set
5. call Lean executable solveStep
6. receive (η_t, x_t, J_t, a_t*, cert_t)
7. submit a_t*
8. log transcript and certificate
9. repeat until terminal

No other logic is allowed.

## 9. BUILD / EXECUTION

Compile Lean once:
```
cd lean4
lake build Arc3Instant.Runtime.Main
```

Then Python calls the native Lean executable with JSON/stdin or file IPC.

## 10. PUBLIC-GAME COMPLETION CRITERION

Every public game id, every reachable timestep, exact Lean dual code, exact Lean state, exact Lean current, exact Lean legal action, verified by transcript/scorecard.

Nothing weaker counts.

## 11. BLOCK ORDER

BLOCK 1: Syntax/*, ObservationHistory/*, DualCode/*
BLOCK 2: StateRecovery/*, Current/*
BLOCK 3: Action/*, PublicGames/Scope.lean
BLOCK 4: Certificates/*, Runtime/Main.lean
BLOCK 5: Python witness shell, full public-game batch runner

Gate conditions:
- Do not move to BLOCK 2 until arc_obs_history_is_dual_code_exact and arc_dual_code_unique have compiled.
- Do not move to BLOCK 4 until arc_state_from_dual_exact, arc_current_from_dual_exact, arc_coordinate_readout_exact have compiled.
- Do not move to BLOCK 5 until arc_nf_total, arc_nf_unique, arc_nf_returns_legal_action have compiled.

## 12. THE ONE RULE TO KEEP FIXED

Lean is the only solver. The toolkit is only the witness surface. Every move must be direct readout from observation history, never search.
