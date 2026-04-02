import Arc3Instant.Current.CurrentFromDual

/-
  ARC-AGI-3 -- Dual Code Certificate

  A certificate that a dual code was correctly read from an observation.
  The certificate records: which decoder was used, what observation
  was decoded, and what dual code was produced.

  Soundness: the certificate is sound iff the dual code matches
  what the decoder would produce on the same observation.

  New axioms: 0
-/

namespace Arc3Instant

/-- A certificate for a dual code reading. -/
structure DualCodeCertificate where
  decoder : ArcDecoder
  observation : ObservationBundle
  code : ArcDualCode
  consistent : code = decoder.decode observation

/-- The dual code certificate is sound: the recorded code
    matches the decoder's output on the recorded observation. -/
theorem dual_code_certificate_sound (cert : DualCodeCertificate) :
    cert.code = cert.decoder.decode cert.observation :=
  cert.consistent

/-- A certificate can always be produced from a decoder and observation. -/
theorem dual_code_certificate_exists (D : ArcDecoder) (o : ObservationBundle) :
    exists cert : DualCodeCertificate,
      cert.decoder = D /\ cert.observation = o /\ cert.code = D.decode o :=
  ⟨⟨D, o, D.decode o, rfl⟩, rfl, rfl, rfl⟩

end Arc3Instant
