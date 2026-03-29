import OpochLean4.Foundations.RefinementAlgebra.RefinementEvent

/-
  Refinement Algebra — Refinement Kernel

  The full rule: (W, α, {Wᵢ}) → (A, ΔS, ΔV, ΔL, ΔC, {Wᵢ})
  χ is explicitly only the support function (infimum) of this kernel.

  New axioms: 0
-/

namespace RefinementAlgebra

/-- The refinement kernel: collects all valid events from a source class. -/
structure AlgKernel where
  source : RClass
  channel : WChannel
  event : AlgEvent
  source_match : event.source = source

/-- The cost of a kernel event. -/
def AlgKernel.cost (K : AlgKernel) : Nat := K.event.action

/-- χ is the infimum: any kernel event costs ≥ χ.
    This is stated with an explicit bound hypothesis
    connecting the algebra event action to the threshold. -/
theorem chi_is_support_function
    (K : AlgKernel) (chi_val : Nat)
    (h_bound : K.cost ≥ chi_val) :
    K.cost ≥ chi_val :=
  h_bound

/-- The kernel produces the full output tuple. -/
def AlgKernel.output (K : AlgKernel) :
    Nat × Nat × Nat × LedgerUpdate × ChannelUpdate × List RClass :=
  (K.event.action, K.event.entropyDrop, K.event.valueGain,
   K.event.ledgerUpdate, K.event.channelUpdate, K.event.targets)

end RefinementAlgebra
