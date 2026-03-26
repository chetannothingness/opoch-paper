# MAPF Exact Solver — Complete Plan

## The Target Theorem

```
theorem finite_mapf_exact_polytime
  (I : FiniteMAPFInstance) (H : Nat) :
  ∃ K : ResidualKernel,
    ExactReduction I H K ∧
    ExactObjectivePreservation I H K ∧
    PolynomialTimeExactOptimizer K ∧
    ExactLiftToMicroSchedule I H K

theorem finite_mapf_solved
  (I : FiniteMAPFInstance) (H : Nat) :
  ∃ sched, PolynomialTime sched ∧ IsOptimalMAPFSchedule I H (sched I H)
```

If these compile with zero sorry, MAPF is solved mathematically.

---

## Phase 1: Core Definitions

### Files
```
MAPF/Core/
  Instance.lean      — FiniteMAPFInstance (graph, agents, starts, goals)
  ActionModel.lean   — finite action alphabet (wait, move N/S/E/W, rotate)
  Resources.lean     — resource/conflict model (vertex, edge, swap conflicts)
  TaskModel.lean     — finite task automaton (pickup, delivery, service)
  Objective.lean     — completed task count, makespan, sum-of-costs
  Horizon.lean       — finite horizon H, valid time steps
```

### What each file must define

**Instance.lean:**
- `FiniteGraph`: finite set of vertices + edges
- `FiniteMAPFInstance`: graph G, num_agents, start positions, goal assignments
- `valid_position`: agent at a graph vertex
- `Schedule`: Fin num_agents → Fin H → vertex (position of each agent at each time)
- `conflict_free`: no two agents at same vertex/edge at same time

**ActionModel.lean:**
- `Action`: enumerated type (wait, move to neighbor)
- `action_valid`: action from vertex v leads to vertex v'
- `action_cost`: cost of each action (default 1)

**Resources.lean:**
- `VertexConflict`: two agents at same vertex at same time
- `EdgeConflict`: two agents traverse same edge in opposite directions
- `SwapConflict`: two agents swap positions
- `ConflictFree`: schedule has no conflicts of any type

**TaskModel.lean:**
- `Task`: source vertex → destination vertex
- `TaskAutomaton`: states (idle, carrying, delivered), transitions
- `task_completed`: agent reached goal with correct item

**Objective.lean:**
- `completed_tasks`: count of tasks completed by horizon H
- `makespan`: time of last completion
- `sum_of_costs`: total movement cost
- `MAPFDecision(I, H, B)`: at least B completions by horizon H?
- `OPT_MAPF(I, H)`: maximum completions achievable

**Horizon.lean:**
- `FiniteHorizon`: H ∈ Nat, all schedules have length H
- `time_step`: Fin H

### Gate: All definitions compile. Zero sorry.

---

## Phase 2: Semantic Collapse (Micro → Count-Flow)

### The Key Insight
Individual agent identities don't matter for the objective. What matters is:
- How many agents are at each vertex at each time (occupancy)
- How many vacancies exist at each vertex (defect)
- How flow moves through the graph (count-flow)

Two micro schedules that produce the same count-flow have the same objective.

### Files
```
MAPF/Semantics/
  Occupancy.lean           — o_t(v) = number of agents at vertex v at time t
  VacancyField.lean        — h_t(v) = capacity(v) - o_t(v) (defect field)
  DefectContinuity.lean    — conservation: Σ_v o_t(v) = num_agents for all t
  QuotientGraph.lean       — quotient by agent permutations at each vertex
  CountFlowAutomaton.lean  — finite automaton on count vectors
  Projection.lean          — micro schedule → count-flow (exact projection)
  Lifting.lean             — count-flow → micro schedule (exact lift modulo gauge)
```

### Key Theorems

**vacancy_duality_exact:**
```
∀ schedule, occupancy schedule t v + vacancy schedule t v = capacity v
```

**defect_continuity_exact:**
```
∀ t, Σ_v occupancy schedule t v = num_agents
∀ t, Σ_v vacancy schedule t v = total_capacity - num_agents
```

**countflow_automaton_exists:**
```
∀ I : FiniteMAPFInstance, ∃ A : CountFlowAutomaton,
  states A ≤ poly(|I|) ∧ transitions A are deterministic
```

**micro_to_countflow_exact:**
```
∀ schedule : MicroSchedule, ∃ cf : CountFlowExecution,
  project(schedule) = cf ∧ objectives_equal schedule cf
```

**countflow_to_micro_lift_exact:**
```
∀ cf : CountFlowExecution, conflict_free cf →
  ∃ schedule : MicroSchedule, project(schedule) = cf ∧ legal(schedule)
```

### Gate: All semantic collapse theorems compile. Zero sorry.

---

## Phase 3: Objective Exactness

### File
```
MAPF/Semantics/
  ObjectiveExactness.lean
```

### Key Theorem

**mapf_objective_exactness:**
```
∀ I H schedule,
  completed_tasks(schedule, I, H) =
  completion_transitions(project(schedule), I, H)
```

The benchmark score (completed tasks) equals the count-flow automaton's completion count. This is crucial — without it, the reduction doesn't preserve what matters.

### Gate: Objective exactness compiles. Zero sorry.

---

## Phase 4: Bridge to Residual Kernel

### Files
```
MAPF/Residual/
  FutureEq.lean        — future-equivalence on count-flow states
  Signature.lean       — canonical binary signature of count-flow state
  Transition.lean      — transitions respect future-equivalence
  BinaryKernel.lean    — binary residual kernel for MAPF
  CompilerBridge.lean  — invoke the universal compiler theorem
```

### Key Theorems

**mapf_future_equiv_is_residual_class:**
```
FutureEquiv on count-flow states IS an indistinguishability class
```

**mapf_has_exact_binary_kernel:**
```
∀ I : FiniteMAPFInstance, H : Nat,
  ∃ K : ResidualKernel,
    ExactReduction I H K ∧
    ExactLift I H K ∧
    PolynomialBound K
```

Derived from the universal compiler theorem + MAPF-specific structure.

### Gate: Kernel exists. Zero sorry.

---

## Phase 5: Complexity

### Files
```
MAPF/Complexity/
  NPMembership.lean    — MAPF decision ∈ NP
  PMembership.lean     — MAPF decision ∈ P
```

### Key Theorems

**mapf_decision_in_NP:**
```
MAPFDecision(I, H, B) is in NP
  — witness: a schedule; verification: check conflicts + count completions
```

**mapf_decision_in_P:**
```
MAPFDecision(I, H, B) is in P
  — via exact kernel bridge + residual kernel compiler
```

### Gate: NP and P membership compile. Zero sorry.

---

## Phase 6: Optimization + Schedule Reconstruction

### Files
```
MAPF/Optimization/
  ValueFromDecision.lean       — binary search on B gives OPT
  ScheduleReconstruction.lean  — kernel solution → legal micro schedule
  PolytimeOptimization.lean    — polynomial-time optimal schedule
```

### Key Theorems

**mapf_opt_value_polytime:**
```
∀ I H, OPT_MAPF(I, H) is polynomial-time computable
  — binary search over B ∈ [0, num_tasks], each query is polytime
```

**mapf_opt_schedule_polytime:**
```
∀ I H, ∃ sched,
  PolynomialTime(construction of sched) ∧
  IsOptimalMAPFSchedule I H sched
```

This uses:
1. Compute OPT value (binary search on P-time decision)
2. Reconstruct kernel solution (from decision procedure trace)
3. Lift to micro schedule (countflow_to_micro_lift_exact)

### Gate: Optimization + reconstruction compile. Zero sorry.

---

## Phase 7: Class Coverage

### Files
```
MAPF/Classes/
  GridMAPF.lean              — 4-connected grid embeds into FiniteMAPF
  OrientedMAPF.lean          — robots with orientation (N/S/E/W states)
  WeightedMAPF.lean          — non-uniform action costs
  PickupDeliveryMAPF.lean    — pickup-delivery tasks
  MultiGoalMAPF.lean         — multiple goals per agent
  LifelongMAPF.lean          — receding-horizon exact control
```

### Key Theorems

**oriented_mapf_reduces_to_finite_mapf:**
```
Every OrientedMAPFInstance embeds exactly into FiniteMAPFInstance
  — vertex = (position, orientation), edge = valid rotation/move
```

**pickup_delivery_mapf_reduces_to_finite_mapf:**
```
Every PickupDeliveryMAPFInstance embeds exactly into FiniteMAPFInstance
  — vertex = (position, task_state), transitions include pickup/delivery
```

**lifelong_mapf_as_receding_horizon_exact_control:**
```
Lifelong MAPF = repeated finite-horizon MAPF on the kernel state
  — each window is exactly solvable
  — receding horizon with exact overlap guarantees global feasibility
```

### Gate: All class embeddings compile. Zero sorry.

---

## Phase 8: Resource Constraints

### Files
```
MAPF/Resources/
  VertexConflict.lean         — no two agents at same vertex
  SwapConflict.lean           — no two agents swap positions
  OrientationSemantics.lean   — rotation costs and constraints
  WeightedActions.lean        — non-uniform move costs
  ServiceCells.lean           — cells requiring service time
  TaskPhaseSemantics.lean     — idle/carrying/delivered phases
```

### Key Theorem

**resource_constraints_exact:**
```
The count-flow automaton exactly encodes all resource constraints.
No constraint is lost in the projection. No constraint is added in the lift.
```

### Gate: Resource exactness compiles. Zero sorry.

---

## Phase 9: Audit

### Files
```
MAPF/Audit/
  TheoremManifest.lean   — list of all MAPF theorems
  AxiomCensus.lean       — A0star is still the sole axiom
  Replay.lean            — build hash, file count
```

---

## Phase 10: Flagship Theorems

The final theorems that appear in the README and paper:

```lean
theorem finite_mapf_exact_polytime
  (I : FiniteMAPFInstance) (H : Nat) :
  ∃ K : ResidualKernel,
    ExactReduction I H K ∧
    ExactObjectivePreservation I H K ∧
    PolynomialTimeExactOptimizer K ∧
    ExactLiftToMicroSchedule I H K

theorem finite_mapf_solved
  (I : FiniteMAPFInstance) (H : Nat) :
  ∃ sched, PolynomialTime sched ∧ IsOptimalMAPFSchedule I H (sched I H)
```

---

## Execution Order (Strict)

```
Phase 1 (Core)        → definitions compile
Phase 2 (Semantics)   → semantic collapse proved
Phase 3 (Objective)   → objective exactness proved
Phase 4 (Residual)    → kernel exists
Phase 5 (Complexity)  → NP and P membership
Phase 6 (Optimization)→ polytime optimal schedule
Phase 7 (Classes)     → all variants covered
Phase 8 (Resources)   → all constraints exact
Phase 9 (Audit)       → manifest, census, replay
Phase 10 (Flagship)   → finite_mapf_exact_polytime + finite_mapf_solved compile
```

No phase starts until the previous gate is green.
Zero sorry at every gate.
Every theorem traced to A0*.

---

## What This Achieves

When `finite_mapf_solved` compiles with zero sorry:

1. Every finite MAPF instance is optimally solvable in polynomial time
2. The solution is a legal micro schedule (not abstract)
3. The objective is exactly preserved (not approximated)
4. All resource constraints are exactly encoded (nothing lost)
5. All standard variants (oriented, weighted, PD, lifelong) are covered
6. The proof is machine-verified (Lean compilation)
7. No heuristics, no approximations, no timeouts

This is not a planner. This is a mathematical proof that MAPF is solved.

---

## File Count Estimate

```
Core:          6 files
Semantics:     7 files
Resources:     6 files
Residual:      5 files
Complexity:    2 files
Optimization:  3 files
Classes:       6 files
Audit:         3 files
Total:        38 files
```

Estimated theorems: ~80-100
Estimated lines: ~3000-4000
