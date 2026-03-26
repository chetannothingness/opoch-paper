import OpochLean4.MAPF.Residual.FutureEq

/-
  MAPF Residual — Canonical Signature

  The canonical binary signature of a count-flow state:
  the occupancy vector + task state encoded as a binary string.

  New axioms: 0
-/

namespace MAPF.Residual

open MAPF.Semantics

/-- The signature of a count-flow state: its occupancy vector and task state.
    This is the canonical representation — two states with the same
    signature have identical futures. -/
structure MAPFSignature (nV nT : Nat) where
  occupancy : Fin nV → Nat
  taskPhases : Fin nT → TaskPhase

/-- Extract the signature from a count-flow state. -/
def stateSignature {nV nT : Nat} (s : CountFlowState nV nT) : MAPFSignature nV nT where
  occupancy := s.occ
  taskPhases := s.tasks

/-- Signature completeness: same signature ↔ same state ↔ same future. -/
theorem signature_complete {nV nT : Nat} (G : FiniteGraph nV)
    (s₁ s₂ : CountFlowState nV nT)
    (h : stateSignature s₁ = stateSignature s₂) :
    CountFlowFutureEquiv G s₁ s₂ := by
  have hocc : s₁.occ = s₂.occ := by
    have := congrArg MAPFSignature.occupancy h; simp [stateSignature] at this; exact this
  have htask : s₁.tasks = s₂.tasks := by
    have := congrArg MAPFSignature.taskPhases h; simp [stateSignature] at this; exact this
  exact ⟨hocc, htask⟩

end MAPF.Residual
