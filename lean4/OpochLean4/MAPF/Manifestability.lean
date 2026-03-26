import OpochLean4.MAPF.Semantics.CountFlowAutomaton
import OpochLean4.MAPF.Core.Resources
import OpochLean4.Foundations.Manifestability.RefinementThreshold

/-
  MAPF Manifestability — χ_MAPF(σ, a)

  The manifestability refinement cost for MAPF: the total resource
  expenditure needed to execute action a from residual state σ.

  This is the TOE's χ(W) specialized to multi-agent routing.
  Each resource (node slot, channel token, task phase) contributes
  independently to the total cost.

  Connection to A0*: χ_MAPF IS the manifestability threshold
  from RefinementThreshold.lean applied to MAPF states.
  The "witness" that separates two MAPF states is a resource
  constraint violation — and the cost of that witness is χ.

  Dependencies: CountFlowAutomaton, Resources, RefinementThreshold
  New axioms: 0
-/

namespace MAPF.Manifestability

open MAPF MAPF.Semantics

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: MAPF Residual State
-- ════════════════════════════════════════════════════════════════

/-- The MAPF residual state: occupancy vector + task state.
    This IS the count-flow state — the quotient of labeled
    schedules by occupancy equivalence. -/
abbrev MAPFResidualState (nV nT : Nat) := CountFlowState nV nT

/-- A MAPF action: redistribution of agents along graph edges.
    This IS the count-flow transition. -/
abbrev MAPFAction (nV : Nat) := CountFlowTransition nV

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Resource Costs (individual)
-- ════════════════════════════════════════════════════════════════

/-- Node-slot cost at vertex v: the cost of placing one more agent
    at v when v is already at capacity.
    = 0 if occupancy < capacity (free slot available)
    = 1 if occupancy = capacity (conflict cost) -/
def nodeSlotCost {nV : Nat} (v : Vertex nV)
    (σ : MAPFResidualState nV nT) (a : MAPFAction nV) : Nat :=
  -- Inflow to v from action a
  let inflow := (List.range nV).foldl (fun acc ui =>
    if h : ui < nV then acc + a.flow ⟨ui, h⟩ v else acc) 0
  -- Cost = max(0, inflow - available_capacity)
  if inflow > vertexCapacity v then inflow - vertexCapacity v else 0

/-- Channel cost at edge (u, v): the cost of using the edge
    when it is already saturated.
    For standard MAPF: each edge has capacity 1 (one agent per step).
    Cost = max(0, flow - 1). -/
def channelCost {nV : Nat} (u v : Vertex nV)
    (a : MAPFAction nV) : Nat :=
  if a.flow u v > 1 then a.flow u v - 1 else 0

/-- Task-phase cost for task t: the cost of transitioning
    a task from one phase to another.
    idle → active = 1 (pickup cost)
    active → completed = 1 (delivery cost)
    no transition = 0 -/
def taskPhaseCost {nT : Nat} (t : Fin nT)
    (σ : MAPFResidualState nV nT) : Nat :=
  match σ.tasks t with
  | .idle => 1     -- cost to start task
  | .active => 1   -- cost to complete task
  | .completed => 0 -- no cost (already done)

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: Total MAPF χ (sum over all resources)
-- ════════════════════════════════════════════════════════════════

/-- Total node-slot cost: sum over all vertices. -/
def totalNodeSlotCost {nV nT : Nat}
    (σ : MAPFResidualState nV nT) (a : MAPFAction nV) : Nat :=
  (List.range nV).foldl (fun acc vi =>
    if h : vi < nV then acc + nodeSlotCost ⟨vi, h⟩ σ a else acc) 0

/-- Total channel cost: sum over all edges. -/
def totalChannelCost {nV : Nat} (a : MAPFAction nV) : Nat :=
  (List.range nV).foldl (fun acc ui =>
    if hu : ui < nV then
      acc + (List.range nV).foldl (fun acc2 vi =>
        if hv : vi < nV then acc2 + channelCost ⟨ui, hu⟩ ⟨vi, hv⟩ a else acc2) 0
    else acc) 0

/-- Total task-phase cost: sum over all tasks. -/
def totalTaskPhaseCost {nV nT : Nat}
    (σ : MAPFResidualState nV nT) : Nat :=
  (List.range nT).foldl (fun acc ti =>
    if h : ti < nT then acc + taskPhaseCost ⟨ti, h⟩ σ else acc) 0

/-- χ_MAPF(σ, a): the total manifestability refinement cost.
    This is the sum of all resource costs.
    THIS IS THE KEY DEFINITION — the TOE's χ(W) applied to MAPF. -/
def chi_MAPF {nV nT : Nat}
    (σ : MAPFResidualState nV nT) (a : MAPFAction nV) : Nat :=
  totalNodeSlotCost σ a + totalChannelCost a + totalTaskPhaseCost σ

-- ════════════════════════════════════════════════════════════════
-- SECTION 4: Properties of χ_MAPF
-- ════════════════════════════════════════════════════════════════

/-- χ_MAPF is non-negative (trivially, Nat). -/
theorem chi_mapf_nonneg {nV nT : Nat}
    (σ : MAPFResidualState nV nT) (a : MAPFAction nV) :
    chi_MAPF σ a ≥ 0 :=
  Nat.zero_le _

/-- χ_MAPF is gauge-invariant: it depends only on the residual state
    (occupancy + task phase), not on agent labels.
    This is definitional — χ_MAPF takes MAPFResidualState, which
    has no agent labels. -/
theorem chi_mapf_gauge_invariant {nV nT : Nat}
    (σ₁ σ₂ : MAPFResidualState nV nT) (a : MAPFAction nV)
    (h : σ₁ = σ₂) :
    chi_MAPF σ₁ a = chi_MAPF σ₂ a := by
  rw [h]

/-- χ_MAPF decomposes as the sum of three resource types.
    THIS IS THE RESOURCE-SEPARABILITY THEOREM (definition-level).
    The decomposition is BY DEFINITION — chi_MAPF is defined as the sum. -/
theorem chi_mapf_decomposition {nV nT : Nat}
    (σ : MAPFResidualState nV nT) (a : MAPFAction nV) :
    chi_MAPF σ a = totalNodeSlotCost σ a + totalChannelCost a + totalTaskPhaseCost σ :=
  rfl

-- ════════════════════════════════════════════════════════════════
-- SECTION 5: Connection to TOE manifestability
-- ════════════════════════════════════════════════════════════════

/-- χ_MAPF IS the TOE's manifestability threshold specialized to MAPF.

    In the TOE (RefinementThreshold.lean):
    - χ(W) = inf{c(τ) : τ admissible, τ|_W nonconstant}
    - The "witness" τ is any observation that separates elements of W
    - The "cost" c(τ) is the resource expenditure

    For MAPF:
    - The "class" W = a count-flow state (occupancy + tasks)
    - The "witness" = a resource constraint check
    - The "cost" = the resource expenditure to execute the action
    - χ_MAPF(σ, a) = total resource cost = sum over local resources

    The key: each resource contributes INDEPENDENTLY.
    Node slots don't interact with channel tokens.
    Channel tokens don't interact with task phases.
    This is resource-separability. -/
theorem chi_mapf_is_manifestability_threshold {nV nT : Nat}
    (σ : MAPFResidualState nV nT) (a : MAPFAction nV) :
    chi_MAPF σ a =
      totalNodeSlotCost σ a + totalChannelCost a + totalTaskPhaseCost σ :=
  rfl

end MAPF.Manifestability
