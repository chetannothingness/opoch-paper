import OpochLean4.Foundations.RefinementAlgebra.ResidualClass

/-
  Refinement Algebra — Extended Refinement Event

  A primitive event e : W ↝ (W₁,...,Wᵣ) with ALL fields:
  channel, action, entropy drop, value gain, ledger update,
  channel/back-reaction update.

  This is the generator of the refinement multicategory.

  New axioms: 0
-/

namespace RefinementAlgebra

open Manifestability

/-- Ledger update: what gets appended to the ordered ledger. -/
structure LedgerUpdate where
  /-- Witness record hash -/
  witnessRecord : Nat
  /-- Cost recorded -/
  costRecorded : Nat

/-- Channel update: back-reaction on the witness channel. -/
structure ChannelUpdate where
  /-- Channel that was used -/
  channelUsed : Nat
  /-- Capacity consumed -/
  capacityConsumed : Nat

/-- Extended refinement event with ALL operational fields.
    This is the generator of the refinement multicategory. -/
structure AlgEvent where
  /-- Source class -/
  source : RClass
  /-- Target classes (multi-output: one-to-many) -/
  targets : List RClass
  /-- Channel through which refinement occurs -/
  channel : WChannel
  /-- Action cost A(e) -/
  action : Nat
  /-- Entropy drop ΔS(e) -/
  entropyDrop : Nat
  /-- Value gain ΔV(e) -/
  valueGain : Nat
  /-- Ledger update ΔL(e) -/
  ledgerUpdate : LedgerUpdate
  /-- Channel back-reaction ΔC(e) -/
  channelUpdate : ChannelUpdate
  /-- Targets are nonempty -/
  targets_nonempty : targets.length ≥ 1
  /-- Multiplicity conserved -/
  multiplicity_conserved :
    source.multiplicity = (targets.map (·.multiplicity)).foldl (· + ·) 0

/-- Number of children. -/
def AlgEvent.arity (e : AlgEvent) : Nat := e.targets.length

/-- Action is non-negative. -/
theorem event_action_nonneg (e : AlgEvent) : e.action ≥ 0 :=
  Nat.zero_le _

end RefinementAlgebra
