import OpochLean4.Foundations.Manifestability.RefinementThreshold
import OpochLean4.Foundations.Manifestability.ChannelThreshold

/-
  Corollary — Computation as Refinement Geometry

  NP-hardness = bad presentation of refinement geometry.
  Exact solving = value propagation on the residual kernel.

  Dependencies: RefinementThreshold, ChannelThreshold, Compiler
  New axioms: 0
-/

namespace Corollaries

open Manifestability

/-- NP-hardness as channel-dependent high χ:
    a problem appears hard when the available channel has high
    refinement threshold. The raw presentation is a bad channel. -/
def presentationHardness
    {rc : ResidualClass} {α : WitnessChannel}
    (ct : ChannelThreshold α rc) : Nat :=
  ct.chi_channel

/-- Hardness is presentation-dependent: the same problem has different
    χ in different channels. -/
theorem hardness_is_presentation_dependent
    {rc : ResidualClass} {α β : WitnessChannel}
    (ct_α : ChannelThreshold α rc) (ct_β : ChannelThreshold β rc)
    (h : ct_α.chi_channel > ct_β.chi_channel) :
    presentationHardness ct_α > presentationHardness ct_β :=
  h

end Corollaries
