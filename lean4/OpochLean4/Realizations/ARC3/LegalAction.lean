import OpochLean4.Realizations.ARC3.Current

/-
  ARC-AGI-3 Realization -- Legal Action Surface

  The official legal action surface:
  - Actions vary per game (1-7)
  - Action set can change after each step
  - ACTION6 exposes availability but not active coordinates

  The legal action set is part of the observation bundle,
  so it is already contained in the dual code.

  New axioms: 0
-/

namespace ARC3

-- ================================================================
-- Legal action surface
-- ================================================================

/-- Extract the exact legal action set from an observation history. -/
def legalActionSetFromHistory (h : ObsHistory) : LegalActionSet :=
  h.legalActions

/-- Extract from dual code. -/
def legalActionSetFromDual (η : ArcDualCode) : LegalActionSet :=
  η.history.legalActions

-- ================================================================
-- Theorems
-- ================================================================

/-- The legal action set is exactly determined by the observation. -/
theorem arc_legal_action_set_exact (h : ObsHistory) :
    legalActionSetFromHistory h = h.current.legalActions :=
  rfl

/-- The legal action set from dual code matches the runtime surface. -/
theorem arc_action_surface_matches_runtime (η : ArcDualCode) :
    legalActionSetFromDual η = η.history.current.legalActions :=
  rfl

/-- The legal action set is always nonempty. -/
theorem arc_legal_actions_nonempty (η : ArcDualCode) :
    (legalActionSetFromDual η).available.length ≥ 1 :=
  η.history.legalActions.nonempty

/-- Dual code extraction preserves the legal action set. -/
theorem arc_dual_preserves_legal_actions (h : ObsHistory) :
    legalActionSetFromDual (extractDualCode h) = legalActionSetFromHistory h :=
  rfl

end ARC3
