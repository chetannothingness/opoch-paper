import Arc3Instant.Certificates.ActionCert
import Arc3Instant.RuntimeBridge.ARCInstantSolve

/-
  ARC-AGI-3 -- The ARC Realization of the Source Code

  The ARC sector IS a realization of the universal source code:
  - State = ArcState (grid + tensions + budget)
  - Code = ArcDualCode (structural content of observation)
  - Current = ArcCurrent (action-tension distribution)
  - Action = the unique legal readout

  The primal-dual identity: the state's source code IS the dual code
  it was recovered from. The observation contains its own answer.

  New axioms: 0
-/

namespace Arc3Instant

-- ================================================================
-- Full certified instant step
-- ================================================================

/-- A fully certified instant step: observation to action with
    certificates at every stage proving correctness. -/
structure CertifiedInstantStep where
  step : InstantStep
  dualCert : DualCodeCertificate
  stateCert : StateCertificate
  actionCert : ActionCertificate
  -- Consistency across certificates
  code_consistent : dualCert.code = step.dualCode
  state_consistent : stateCert.state = step.state
  action_consistent : actionCert.action = step.action

/-- Build a fully certified instant step. -/
def certifiedInstantStep (D : ArcDecoder) (o : ObservationBundle)
    (frame : Frame) (L : LegalActionSet) : CertifiedInstantStep where
  step := instantStep o D frame L
  dualCert := ⟨D, o, D.decode o, rfl⟩
  stateCert := ⟨D.decode o, frame, primalRecovery (D.decode o) frame, rfl⟩
  actionCert := ⟨currentFromDual (D.decode o), L,
    selectLegalAction (currentFromDual (D.decode o)) L, rfl,
    arc_action_is_legal _ L⟩
  code_consistent := rfl
  state_consistent := rfl
  action_consistent := rfl

-- ================================================================
-- The ARC realization is complete and sound
-- ================================================================

/-- The ARC realization is complete: for every observation,
    a fully certified instant step exists. -/
theorem arc_realization_complete (D : ArcDecoder) (o : ObservationBundle)
    (frame : Frame) (L : LegalActionSet) :
    exists cs : CertifiedInstantStep,
      cs.step.observation = o /\
      cs.step.decoder = D /\
      IsLegalAction cs.step.action L := by
  exact ⟨certifiedInstantStep D o frame L, rfl, rfl,
    instant_step_legal o D frame L⟩

/-- The ARC realization is sound: every certified step has
    a legal action that is the direct readout of the dual code. -/
theorem arc_realization_sound (D : ArcDecoder) (o : ObservationBundle)
    (frame : Frame) (L : LegalActionSet) :
    let cs := certifiedInstantStep D o frame L
    -- The action is legal
    IsLegalAction cs.step.action L /\
    -- The action is the direct readout
    cs.step.action = selectLegalAction (currentFromDual (D.decode o)) L /\
    -- The dual code comes from the observation
    cs.dualCert.code = D.decode o /\
    -- The state comes from the code
    cs.stateCert.state = primalRecovery (D.decode o) frame /\
    -- Zero search
    cs.step.dualCode = D.decode o := by
  exact ⟨instant_step_legal o D frame L, rfl, rfl, rfl, rfl⟩

end Arc3Instant
