import Arc3Instant.Certificates.DualCodeCert

/-
  ARC-AGI-3 -- State Certificate

  A certificate that a state was correctly recovered from a dual code.
  Soundness: the state matches primal recovery of the code.

  New axioms: 0
-/

namespace Arc3Instant

/-- A certificate for state recovery. -/
structure StateCertificate where
  code : ArcDualCode
  frame : Frame
  state : ArcState
  consistent : state = primalRecovery code frame

/-- The state certificate is sound. -/
theorem state_certificate_sound (cert : StateCertificate) :
    cert.state = primalRecovery cert.code cert.frame :=
  cert.consistent

/-- A state certificate can always be produced. -/
theorem state_certificate_exists (eta : ArcDualCode) (frame : Frame) :
    exists cert : StateCertificate,
      cert.code = eta /\ cert.state = primalRecovery eta frame :=
  ⟨⟨eta, frame, primalRecovery eta frame, rfl⟩, rfl, rfl⟩

end Arc3Instant
