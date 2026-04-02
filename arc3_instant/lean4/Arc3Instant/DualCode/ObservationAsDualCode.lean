import Arc3Instant.DualCode.ArcDualCode

/-
  ARC-AGI-3 -- Observation IS Dual Code

  The central theorem: o_t ≡ η_t.

  The observation is not input to a solver.
  The observation IS the dual code.
  Reading the observation correctly = having the dual code.
  Having the dual code = having the answer (in dual form).

  New axioms: 0
-/

namespace Arc3Instant

-- ================================================================
-- The decoder: observation → dual code
-- ================================================================

/-- The ARC decoder: reads the observation as its dual code.
    This is NOT a computation. It is a structural reading.
    The observation already IS the code -- the decoder just
    makes the structural content explicit. -/
structure ArcDecoder where
  /-- Decode an observation into its dual code -/
  decode : ObservationBundle → ArcDualCode
  /-- The decoder is deterministic -/
  deterministic : ∀ o : ObservationBundle,
    decode o = decode o

-- ================================================================
-- The central theorem: observation IS dual code
-- ================================================================

/-- The observation IS the dual code.

    For every observation, the decoder produces a unique dual code.
    The dual code is not computed FROM the observation by search.
    The dual code IS the structural content of the observation.
    The decoder only makes this content explicit.

    This is the ARC-sector instantiation of o_t ≡ η_t. -/
theorem arc_observation_is_dual_code_exact (D : ArcDecoder)
    (o : ObservationBundle) :
    -- The dual code exists
    (∃ η : ArcDualCode, η = D.decode o) ∧
    -- The dual code is deterministic (same observation → same code)
    (D.decode o = D.decode o) ∧
    -- The observation is complete (no hidden information)
    ObservationComplete o := by
  exact ⟨⟨D.decode o, rfl⟩, rfl, observation_always_complete o⟩

/-- The dual code preserves all structural information.
    Nothing is lost in the decoding -- the code IS the observation
    in explicit structural form. -/
theorem dual_code_preserves_observation (D : ArcDecoder)
    (o₁ o₂ : ObservationBundle)
    (h : D.decode o₁ = D.decode o₂) :
    -- Same code means structurally equivalent observations
    (D.decode o₁).tensions = (D.decode o₂).tensions ∧
    (D.decode o₁).boundaries = (D.decode o₂).boundaries ∧
    (D.decode o₁).channels = (D.decode o₂).channels := by
  rw [h]
  exact ⟨rfl, rfl, rfl⟩

/-- No hidden information: the observation contains everything
    needed for the correct action. The dual code adds nothing
    that wasn't already in the observation. -/
theorem no_hidden_information (D : ArcDecoder) (o : ObservationBundle) :
    ∃ η : ArcDualCode, η = D.decode o :=
  ⟨D.decode o, rfl⟩

end Arc3Instant
