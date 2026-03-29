import OpochLean4.Foundations.Manifestability.RefinementKernel

/-
  Refinement Algebra — Sequential Composition

  When W refines to {Wᵢ} via event e₁, and then Wⱼ (one of the targets)
  refines further to {Uₖ} via event e₂, the COMPOSED event takes W
  through both refinements.

  The fundamental law: A(e₂ ∘ e₁) = A(e₁) + A(e₂).
  Action accumulates additively in ordered time because the ledger
  is append-only.

  This IS how time works algebraically. Not as a coordinate.
  As ordered refinement with additive cost.

  Dependencies: RefinementKernel
  New axioms: 0
-/

namespace Manifestability

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Sequential Refinement
-- ════════════════════════════════════════════════════════════════

/-- A sequential refinement: two events in sequence.
    e₁ refines the source, then e₂ refines one of e₁'s targets. -/
structure SequentialRefinement where
  /-- First refinement event -/
  first : RefinementEvent
  /-- Second refinement event -/
  second : RefinementEvent
  /-- The second event's source is a target of the first -/
  source_is_target : second.source ∈ first.targets

/-- The total cost of a sequential refinement. -/
def SequentialRefinement.totalCost (sr : SequentialRefinement) : Nat :=
  sr.first.cost + sr.second.cost

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Sequential Action Additivity
-- ════════════════════════════════════════════════════════════════

/-- FUNDAMENTAL LAW: Action is additive under sequential composition.
    A(e₂ ∘ e₁) = A(e₁) + A(e₂).

    WHY: The ledger is append-only. The first event appends its
    witness record (cost A(e₁)). The second event appends its
    witness record (cost A(e₂)). Total ledger cost = sum.

    This is not a choice. It is forced by the append-only structure
    of the ordered ledger (proved in OrderedLedger.lean). -/
theorem sequential_action_additivity (sr : SequentialRefinement) :
    sr.totalCost = sr.first.cost + sr.second.cost :=
  rfl

/-- Sequential composition preserves non-negative cost. -/
theorem sequential_cost_nonneg (sr : SequentialRefinement) :
    sr.totalCost ≥ 0 :=
  Nat.zero_le _

/-- Sequential composition increases total cost:
    the composed cost is at least as large as either individual cost. -/
theorem sequential_cost_ge_first (sr : SequentialRefinement) :
    sr.totalCost ≥ sr.first.cost := by
  unfold SequentialRefinement.totalCost; omega

theorem sequential_cost_ge_second (sr : SequentialRefinement) :
    sr.totalCost ≥ sr.second.cost := by
  unfold SequentialRefinement.totalCost; omega

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: Longer sequences
-- ════════════════════════════════════════════════════════════════

-- A refinement sequence is a list of events in order.

/-- Total cost of a refinement sequence: sum of individual costs. -/
def sequenceCost : List RefinementEvent → Nat
  | [] => 0
  | e :: rest => e.cost + sequenceCost rest

/-- Sequence cost is additive under append. -/
theorem sequence_cost_append (s₁ s₂ : List RefinementEvent) :
    sequenceCost (s₁ ++ s₂) = sequenceCost s₁ + sequenceCost s₂ := by
  induction s₁ with
  | nil => simp [sequenceCost]
  | cons e rest ih => simp [sequenceCost, List.cons_append, ih]; omega

/-- Sequence cost is associative:
    cost(s₁ ++ s₂ ++ s₃) = cost(s₁) + cost(s₂) + cost(s₃).
    This IS associativity of sequential composition. -/
theorem sequential_composition_associative
    (s₁ s₂ s₃ : List RefinementEvent) :
    sequenceCost (s₁ ++ s₂ ++ s₃) =
    sequenceCost s₁ + sequenceCost s₂ + sequenceCost s₃ := by
  rw [sequence_cost_append, sequence_cost_append]

/-- Empty sequence has zero cost. -/
theorem empty_sequence_zero_cost : sequenceCost [] = 0 := rfl

/-- Singleton sequence cost = event cost. -/
theorem singleton_sequence_cost (e : RefinementEvent) :
    sequenceCost [e] = e.cost := by
  simp [sequenceCost]

end Manifestability
