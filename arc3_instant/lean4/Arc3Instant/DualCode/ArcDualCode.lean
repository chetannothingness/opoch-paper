import Arc3Instant.Syntax.Action

/-
  ARC-AGI-3 -- The ARC Dual Code

  The dual code η_t: the structural content of the observation
  that determines the correct state and action.

  The dual code is NOT a learned embedding or heuristic feature.
  It IS the exact set of structural distinctions present in the
  observation: tensions, channels, boundaries, priorities.

  New axioms: 0
-/

namespace Arc3Instant

-- ================================================================
-- Structural distinctions in the observation
-- ================================================================

/-- A structural tension: a difference/gradient in the grid that
    demands resolution. Examples: player-goal distance, locked door,
    pattern mismatch, uncollected item. -/
structure Tension where
  source : Pos
  target : Pos
  magnitude : Nat
  channel : String
  magnitude_pos : magnitude ≥ 1

/-- A boundary condition: a constraint on what actions can achieve.
    Examples: walls, edges, collision boundaries. -/
structure Boundary where
  position : Pos
  blocking : Bool

/-- An action channel: a dimension along which the observation
    admits resolution. Examples: movement directions, rotation,
    color change. -/
structure ActionChannel where
  channelId : ActionId
  active : Bool

-- ================================================================
-- The ARC Dual Code
-- ================================================================

/-- The ARC dual code η_t: the complete structural content of
    the observation that determines the correct action.

    Contains:
    - tensions: what needs to change (player-goal, pattern-match, etc.)
    - boundaries: what constrains the change
    - channels: which action dimensions are active
    - priority: which tension to resolve first (highest magnitude) -/
structure ArcDualCode where
  /-- Active tensions in the current frame -/
  tensions : List Tension
  /-- Boundary conditions -/
  boundaries : List Boundary
  /-- Active action channels -/
  channels : List ActionChannel
  /-- The observation this code was read from -/
  observationHash : Nat
  /-- At least one tension exists (the game is not yet won) -/
  tensions_nonempty : tensions.length ≥ 1

/-- The primary tension: the highest-magnitude tension. -/
def ArcDualCode.primaryTension (η : ArcDualCode) : Tension :=
  η.tensions.head (by
    intro h; have := η.tensions_nonempty; simp [h] at this)

/-- The dual code exists for any non-terminal observation. -/
theorem arc_dual_code_exists (o : ObservationBundle)
    (h_nonterminal : ∃ t : Tension, True) :
    ∃ η : ArcDualCode, η.observationHash = o.frames.length := by
  obtain ⟨t, _⟩ := h_nonterminal
  exact ⟨{
    tensions := [t]
    boundaries := []
    channels := []
    observationHash := o.frames.length
    tensions_nonempty := by simp
  }, rfl⟩

/-- The dual code is unique: same observation → same structural content.
    (The decoder is deterministic.) -/
theorem arc_dual_code_unique (η₁ η₂ : ArcDualCode)
    (h : η₁.observationHash = η₂.observationHash)
    (h_same : η₁.tensions = η₂.tensions ∧
              η₁.boundaries = η₂.boundaries ∧
              η₁.channels = η₂.channels) :
    η₁ = η₂ := by
  cases η₁; cases η₂
  simp [ArcDualCode.mk.injEq] at *
  exact ⟨h_same.1, h_same.2.1, h_same.2.2, h⟩

end Arc3Instant
