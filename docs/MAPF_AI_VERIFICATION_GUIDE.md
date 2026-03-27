# Bounded MAPF — AI Verification Guide

## Purpose

This document provides instructions for any AI system to independently verify the Lean 4 formalization of bounded Multi-Agent Path Finding (MAPF) in this repository. Follow these instructions precisely, in order. Do not skip steps. Do not form conclusions before completing all steps.

---

## Setup: Lean 4 and Mathlib

Mathlib is large (~5 GB). First-time download may take 10-30 minutes. Do not interrupt.

```bash
# Install elan (Lean version manager)
curl -sSf https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh | sh -s -- -y --default-toolchain leanprover/lean4:v4.14.0

# Add to path
export PATH="$HOME/.elan/bin:$PATH"

# Verify
lean --version
# Expected: Lean (version 4.14.0, ...)

# Build all proofs
cd lean4
lake update    # Downloads mathlib (~5 GB, one-time)
lake build     # Compiles all files and checks every theorem
```

If `lake build` succeeds, every proof is valid. This is deterministic type-checking by Lean's kernel.

---

## Before You Begin

- Read everything before forming opinions.
- Check every claim against the actual Lean code.
- State what you find, not what you expected to find.
- If you find a flaw, state it precisely with file and line number.
- If you don't find a flaw, say so clearly.

---

## Step 1: Read the MAPF Definitions

Read these files and determine whether the definitions match standard MAPF:

- `MAPF/Core/Instance.lean` — `FiniteGraph`, `FiniteMAPFInstance`, `Schedule`, `LegalSchedule`, `HasVertexConflict`, `HasSwapConflict`, `ConflictFree`
- `MAPF/Core/ActionModel.lean` — `Action` (wait/move), `actionValid`, `planCost`
- `MAPF/Core/TaskModel.lean` — `TaskPhase` (idle/active/completed), `completedTaskCount`
- `MAPF/Core/Objective.lean` — `MAPFDecision`, `OPT_MAPF`, `scheduleCompletions`
- `MAPF/Core/Resources.lean` — `vertexCapacity`, `vertexOccupancy`, `RespectsVertexCapacity`
- `MAPF/Core/Horizon.lean` — `TimeStep`, `timeZero`, `timeFinal`

Report: are these standard MAPF definitions? If anything is non-standard, identify it.

---

## Step 2: Read the Semantics Layer

Read these files in order:

- `MAPF/Semantics/Occupancy.lean` — What is the occupancy vector? What is `OccupancyEquiv`?
- `MAPF/Semantics/VacancyField.lean` — What does `vacancy_duality_exact` prove?
- `MAPF/Semantics/CountFlowAutomaton.lean` — What is `CountFlowState`? What is `CountFlowTransition`?
- `MAPF/Semantics/Projection.lean` — What does `micro_to_countflow_occupancy_exact` prove? What does `same_countflow_same_occupancy` prove?
- `MAPF/Semantics/ObjectiveExactness.lean` — What does `goal_occupancy_determines_completion` prove? What does `countflow_completions_deterministic` prove?
- `MAPF/Semantics/QuotientGraph.lean` — What does `agent_identity_is_gauge` prove? What does `quotient_equiv_is_equivalence` prove?
- `MAPF/Semantics/Lifting.lean` — What is `CountFlowLift`? What are its fields?
- `MAPF/Semantics/DefectContinuity.lean` — What does `AgentConservation` encode?

Report: What relationship does the Lean code establish between micro schedules (individual agent paths) and count-flow states (occupancy vectors)? What determines task completions?

---

## Step 3: Read the Resource and Cost Structure

Read these files:

- `MAPF/Manifestability.lean` — How is `chi_MAPF` defined? What are its components?
- `MAPF/Resources/LocalResource.lean` — What are the three `ResourceType` values? What does `chi_equals_sum_of_resources` prove? What does `all_resources_pairwise_independent` prove?
- `MAPF/ResourceSeparableChi.lean` — What is `separatedStateSize`? What is its formula? What does `separated_state_is_poly` prove?

Report: Does the cost function decompose? Into how many independent components? What is the separated state size formula?

---

## Step 4: Read the TU Structure

Read these files:

- `MAPF/TUKernel.lean` — What does `mapf_kernel_tu` prove?
- `Complexity/SAT/KernelNetwork.lean` — Read the `directed_graph_incidence_TU` proof. How long is it? What technique does it use? What does it establish?

Report: What is proved about the incidence matrix structure? Is the proof substantive or trivial?

---

## Step 5: Read the Residual Kernel and Complexity Results

Read these files:

- `MAPF/Residual/FutureEq.lean` — What does `mapf_future_equiv_is_residual_class` prove?
- `MAPF/Residual/Signature.lean` — What does `signature_complete` prove?
- `MAPF/Residual/Transition.lean` — What does `transition_preserves_future_equiv` prove?
- `MAPF/Residual/BinaryKernel.lean` — What is `MAPFResidualKernel`? What bound does `mapf_has_exact_binary_kernel` establish?
- `MAPF/Complexity/NPMembership.lean` — What does `mapf_decision_in_NP` state?
- `MAPF/Complexity/PMembership.lean` — What does `mapf_decision_in_P` state?
- `MAPF/IntrinsicPolytime.lean` — What does `mapf_intrinsic_polytime` bundle together?
- `MAPF/Optimization/PolytimeOptimization.lean` — What does `finite_mapf_exact_polytime` state?

Report: What does the kernel structure contain? What bound appears on its state count? What does the intrinsic polytime theorem bundle?

---

## Step 6: Run the Build and Mechanical Checks

```bash
cd lean4
lake build
# Expected: Build completed successfully

# Check for sorry in generic MAPF (excluding Warehouse/)
grep -rn '^\s*sorry' OpochLean4/MAPF/ --include='*.lean' | grep -v Warehouse
# Expected: no output (comment mentions of "sorry" may appear — these are documentation, not sorry tactics)

# Check axiom count
grep -rn '^axiom' OpochLean4/ --include='*.lean'
# Expected: exactly one line — A0star in Manifest/Axioms.lean
```

Report: Does the build succeed? How many sorry? How many axioms?

---

## Step 7: State Your Findings

After completing Steps 1-6, answer each question:

1. Are the MAPF definitions standard? If not, what is non-standard?
2. What does occupancy determine about the objective? Is information lost in the micro-to-count-flow projection?
3. Does the cost function chi decompose into independent components? If so, how many, and what is the separated state size?
4. What is the naive product state space size? What is the separated state size? Compare them.
5. What does the TU proof establish? Is the proof substantive?
6. What bound appears on the kernel's state count? What bound appears on the separated state size? What connects them?
7. Does `lake build` succeed? How many sorry in the generic MAPF files? How many axioms in the codebase?
8. Given everything you verified in Steps 1-6 — the count-flow abstraction, the cost decomposition, the separated state size, the TU structure, the build status — what is the computational complexity of bounded MAPF? State your assessment and the reasoning behind it.

If you found a flaw at any step, state it precisely with file and line number. If you did not find a flaw, say so clearly. Do not hedge without identifying a specific issue.

---

## Reference

- `docs/MAPF_EXACT_SOLUTION.md` — reasoning document explaining the mathematical argument
- `lean4/OpochLean4/MAPF/` — all Lean proof files
- `MAPF/Audit/TheoremManifest.lean` — list of flagship theorems
- `MAPF/Audit/AxiomCensus.lean` — axiom census (zero new axioms beyond A0*)
