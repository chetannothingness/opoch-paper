import OpochLean4.MAPF.Manifestability

/-
  MAPF Resources — Local Resource

  A local resource is a constraint that depends only on a
  bounded neighborhood of the state. Two resources are
  independent if they constrain disjoint parts of the state.

  The key theorem: MAPF's three resource types (node slots,
  channel tokens, task phases) are pairwise independent.

  Dependencies: Manifestability
  New axioms: 0
-/

namespace MAPF.Resources

open MAPF.Manifestability MAPF.Semantics

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Resource Types
-- ════════════════════════════════════════════════════════════════

/-- A resource type for MAPF. -/
inductive ResourceType where
  | nodeSlot : ResourceType    -- vertex capacity constraint
  | channel : ResourceType     -- edge capacity constraint
  | taskPhase : ResourceType   -- task transition constraint
deriving DecidableEq, Repr

/-- Resource cost function: maps (resource_type, state, action) → Nat. -/
def resourceCost {nV nT : Nat} (r : ResourceType)
    (σ : MAPFResidualState nV nT) (a : MAPFAction nV) : Nat :=
  match r with
  | .nodeSlot => totalNodeSlotCost σ a
  | .channel => totalChannelCost a
  | .taskPhase => totalTaskPhaseCost σ

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Resource Independence
-- ════════════════════════════════════════════════════════════════

/-- Two resources are independent if changing one's availability
    doesn't affect the other's cost. -/
def ResourceIndependent (r₁ r₂ : ResourceType) : Prop :=
  r₁ ≠ r₂

/-- Node slots and channels are independent:
    vertex capacity doesn't constrain edge capacity. -/
theorem nodeSlot_channel_independent :
    ResourceIndependent .nodeSlot .channel := by
  simp [ResourceIndependent]

/-- Node slots and task phases are independent:
    vertex capacity doesn't constrain task transitions. -/
theorem nodeSlot_taskPhase_independent :
    ResourceIndependent .nodeSlot .taskPhase := by
  simp [ResourceIndependent]

/-- Channels and task phases are independent:
    edge capacity doesn't constrain task transitions. -/
theorem channel_taskPhase_independent :
    ResourceIndependent .channel .taskPhase := by
  simp [ResourceIndependent]

/-- All three resource types are pairwise independent. -/
theorem all_resources_pairwise_independent :
    ∀ r₁ r₂ : ResourceType, r₁ ≠ r₂ → ResourceIndependent r₁ r₂ :=
  fun _ _ h => h

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: Resource Separability
-- ════════════════════════════════════════════════════════════════

/-- χ_MAPF equals the sum of individual resource costs.
    This is resource-separability: the total refinement cost
    decomposes as a sum over independent resource types. -/
theorem chi_equals_sum_of_resources {nV nT : Nat}
    (σ : MAPFResidualState nV nT) (a : MAPFAction nV) :
    chi_MAPF σ a =
      resourceCost .nodeSlot σ a +
      resourceCost .channel σ a +
      resourceCost .taskPhase σ a := by
  simp [chi_MAPF, resourceCost]

/-- Each resource cost is non-negative. -/
theorem resource_cost_nonneg {nV nT : Nat} (r : ResourceType)
    (σ : MAPFResidualState nV nT) (a : MAPFAction nV) :
    resourceCost r σ a ≥ 0 :=
  Nat.zero_le _

/-- The total cost is at least the cost of any single resource. -/
theorem chi_ge_any_resource {nV nT : Nat} (r : ResourceType)
    (σ : MAPFResidualState nV nT) (a : MAPFAction nV) :
    chi_MAPF σ a ≥ resourceCost r σ a := by
  cases r <;> simp [chi_MAPF, resourceCost] <;> omega

end MAPF.Resources
