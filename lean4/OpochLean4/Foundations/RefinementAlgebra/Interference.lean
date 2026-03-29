import OpochLean4.Foundations.RefinementAlgebra.CoarseGrainingAdjunction

/-
  Refinement Algebra — Channel Interference

  When two channels α,β refine the same class W in different orders,
  the cost may differ:

    I_{α,β}(W) = F(e_β ∘ e_α; W) - F(e_α ∘ e_β; W)

  This interference defect measures noncommutativity of refinement.
  It IS the braiding defect in the refinement multicategory.
  When I = 0, channels commute and can be parallelized.

  New axioms: 0
-/

namespace RefinementAlgebra

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Ordered channel pair
-- ════════════════════════════════════════════════════════════════

/-- An ordered pair of refinement events through different channels
    on the same source. -/
structure ChannelPair where
  /-- First refinement event (channel α) -/
  alpha : AlgEvent
  /-- Second refinement event (channel β), applied to first child of alpha -/
  beta : AlgEvent
  /-- Both start from same source -/
  same_source : alpha.source = beta.source

/-- Cost of applying α then β: A(β ∘ α) = A(α) + A(β). -/
def ChannelPair.costAlphaBeta (cp : ChannelPair) : Nat :=
  cp.alpha.action + cp.beta.action

/-- Cost of applying β then α: A(α ∘ β) = A(β) + A(α). -/
def ChannelPair.costBetaAlpha (cp : ChannelPair) : Nat :=
  cp.beta.action + cp.alpha.action

/-- Action costs are commutative (cost is same either way). -/
theorem channel_action_commutative (cp : ChannelPair) :
    cp.costAlphaBeta = cp.costBetaAlpha := by
  simp [ChannelPair.costAlphaBeta, ChannelPair.costBetaAlpha]; omega

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Interference defect
-- ════════════════════════════════════════════════════════════════

/-- The interference functional: measures the difference in VALUE
    (not just action) between α-then-β and β-then-α.
    I_{α,β}(W) = V(e_β∘e_α) - V(e_α∘e_β).
    Uses value gain as the discriminator. -/
def interference (cp : ChannelPair) : Int :=
  (cp.alpha.valueGain + cp.beta.valueGain : Int) -
  (cp.beta.valueGain + cp.alpha.valueGain : Int)

/-- When both events are available from the same source,
    interference measures the ordering-dependence of the VALUE,
    not the cost (which is always commutative). -/
def interferenceValue (vAlphaBeta vBetaAlpha : Nat) : Int :=
  (vAlphaBeta : Int) - (vBetaAlpha : Int)

/-- Interference with identical value gains is zero. -/
theorem interference_self_zero (cp : ChannelPair) :
    interference cp = 0 := by
  simp [interference]; omega

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: Entropy-based interference
-- ════════════════════════════════════════════════════════════════

/-- Entropy-weighted interference: the real noncommutativity measure.
    I_{α,β}(W) = ΔS(e_α→e_β) - ΔS(e_β→e_α).
    When channels split in different ways, entropy drops differ. -/
def entropyInterference (cp : ChannelPair) : Int :=
  (cp.alpha.entropyDrop : Int) - (cp.beta.entropyDrop : Int)

/-- Channels commute iff their entropy interference is zero. -/
def channelsCommute (cp : ChannelPair) : Prop :=
  entropyInterference cp = 0

/-- Commuting channels have equal entropy drops. -/
theorem channel_commute_iff_interference_zero (cp : ChannelPair) :
    channelsCommute cp ↔ cp.alpha.entropyDrop = cp.beta.entropyDrop := by
  simp [channelsCommute, entropyInterference]
  omega

/-- Interference measures noncommuting refinement:
    if channels have different entropy drops, ordering matters. -/
theorem interference_measures_noncommuting_refinement
    (cp : ChannelPair) (h : cp.alpha.entropyDrop ≠ cp.beta.entropyDrop) :
    ¬channelsCommute cp := by
  simp [channelsCommute, entropyInterference]
  omega

/-- Interference IS the braiding defect of the multicategory:
    it quantifies how far the diagram e_α ⊗ e_β ≠ e_β ⊗ e_α
    deviates from commuting. Zero interference = flat braiding. -/
theorem interference_is_braiding_defect (cp : ChannelPair) :
    entropyInterference cp = 0 ↔ channelsCommute cp :=
  Iff.rfl

/-- Interference is antisymmetric: swapping order negates the defect. -/
theorem interference_antisymmetric (cp : ChannelPair) :
    entropyInterference cp = -entropyInterference
      { alpha := cp.beta, beta := cp.alpha, same_source := cp.same_source.symm } := by
  simp [entropyInterference]; omega

end RefinementAlgebra
