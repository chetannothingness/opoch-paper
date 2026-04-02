import Arc3Instant.Certificates.StateCert
import Arc3Instant.Action.ActionReadout

/-
  ARC-AGI-3 -- Action Certificate

  A certificate that an action was correctly read from a current.
  Soundness: the action is legal and matches the current readout.

  New axioms: 0
-/

namespace Arc3Instant

/-- A certificate for action readout. -/
structure ActionCertificate where
  current : ArcCurrent
  legalSet : LegalActionSet
  action : Action
  consistent : action = selectLegalAction current legalSet
  legal : IsLegalAction action legalSet

/-- The action certificate is sound. -/
theorem action_certificate_sound (cert : ActionCertificate) :
    cert.action = selectLegalAction cert.current cert.legalSet /\
    IsLegalAction cert.action cert.legalSet :=
  ⟨cert.consistent, cert.legal⟩

/-- An action certificate can always be produced. -/
theorem action_certificate_exists (J : ArcCurrent) (L : LegalActionSet) :
    exists cert : ActionCertificate,
      cert.current = J /\ cert.legalSet = L /\
      cert.action = selectLegalAction J L /\
      IsLegalAction cert.action L :=
  ⟨⟨J, L, selectLegalAction J L, rfl, arc_action_is_legal J L⟩,
   rfl, rfl, rfl, arc_action_is_legal J L⟩

end Arc3Instant
