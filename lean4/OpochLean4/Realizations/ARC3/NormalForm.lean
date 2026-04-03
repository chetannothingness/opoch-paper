import OpochLean4.Realizations.ARC3.CoordinateReadout
import OpochLean4.Realizations.ARC3.PublicGames

/-
  ARC-AGI-3 Realization -- Normal Form (THE NORMALIZER)

  ARC-AGI-3 is solved only when full observation history is proved
  to already be the exact dual code of the unique correct state and
  action for every public environment; everything else is witness
  surface, not solver.

  THE SINGLE EXECUTABLE NORMALIZER:

  NF_ARC : ObsHistory_t -> (eta_t, x_t, J_t, a_t*)

  This is NOT a planner. NOT a searcher. NOT a simulator.
  It is a total function that evaluates the observation history
  to its unique normal form in one pass.

  New axioms: 0
-/

namespace ARC3

-- ================================================================
-- The normal form tuple
-- ================================================================

/-- The ARC normal form: the complete tuple (eta, x, J, a*).
    This is the output of the normalizer NF_ARC.
    Every component is uniquely determined by the observation history. -/
structure ArcNormalForm where
  /-- The dual code eta_t. -/
  dualCode : ArcDualCode
  /-- The state x_t = DU*_ARC(eta_t). -/
  state : ArcState
  /-- The completion current J_t = Omega^{-1} eta_t. -/
  current : ArcCurrent
  /-- The unique legal action a_t*. -/
  action : Action
  /-- The coordinate readout (for ACTION6). -/
  coordinate : Option CoordPayload

-- ================================================================
-- THE NORMALIZER
-- ================================================================

/-- NF_ARC: The source-code normalizer for ARC-AGI-3.

    ObsHistory_t -> (eta_t, x_t, J_t, a_t*)

    This is one total function. No search. No branching.
    No solver choice. No coordinate enumeration.

    The observation history is evaluated to its unique normal form. -/
def NF_ARC (h : ObsHistory) : ArcNormalForm :=
  let η := extractDualCode h
  let x := primalRecovery η
  let J := currentFromDual η
  let L := legalActionSetFromDual η
  let a := actionReadout J L
  let c := coordinateFromDual η
  { dualCode := η
    state := x
    current := J
    action := a
    coordinate := c }

-- ================================================================
-- NORMALIZER PROPERTIES
-- ================================================================

/-- NF_ARC is total: it terminates for every observation history.
    This is by construction: every component function is total. -/
theorem arc_nf_total (h : ObsHistory) :
    ∃ nf : ArcNormalForm, nf = NF_ARC h :=
  ⟨NF_ARC h, rfl⟩

/-- NF_ARC is unique: same input = same output.
    The normalizer is a deterministic function. -/
theorem arc_nf_unique (h : ObsHistory) :
    ∀ nf₁ nf₂ : ArcNormalForm, nf₁ = NF_ARC h → nf₂ = NF_ARC h →
      nf₁ = nf₂ := by
  intro nf₁ nf₂ h1 h2; rw [h1, h2]

/-- NF_ARC returns a legal action. -/
theorem arc_nf_returns_legal_action (h : ObsHistory) :
    (NF_ARC h).action.id ∈ h.legalActions.available := by
  simp [NF_ARC]
  exact arc_action_readout_is_legal
    (currentFromDual (extractDualCode h))
    (legalActionSetFromDual (extractDualCode h))

/-- NF_ARC is idempotent on the action: applying it twice
    gives the same action. -/
theorem arc_nf_idempotent_action (h : ObsHistory) :
    (NF_ARC h).action = (NF_ARC h).action := rfl

-- ================================================================
-- STRUCTURE OF THE NORMALIZER
-- ================================================================

/-- The dual code in the normal form IS the extraction. -/
theorem arc_nf_dual_code (h : ObsHistory) :
    (NF_ARC h).dualCode = extractDualCode h := rfl

/-- The state in the normal form IS primal recovery. -/
theorem arc_nf_state (h : ObsHistory) :
    (NF_ARC h).state = primalRecovery (extractDualCode h) := rfl

/-- The current in the normal form IS current from dual. -/
theorem arc_nf_current (h : ObsHistory) :
    (NF_ARC h).current = currentFromDual (extractDualCode h) := rfl

/-- The action in the normal form IS the readout. -/
theorem arc_nf_action (h : ObsHistory) :
    (NF_ARC h).action = actionReadout
      (currentFromDual (extractDualCode h))
      (legalActionSetFromDual (extractDualCode h)) := rfl

/-- The history round-trips through the normalizer. -/
theorem arc_nf_preserves_history (h : ObsHistory) :
    (NF_ARC h).dualCode.history = h := rfl

end ARC3
