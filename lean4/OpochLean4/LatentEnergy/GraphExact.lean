import OpochLean4.LatentEnergy.DualCode
import OpochLean4.FinalSourceCode.CurrentLaw

/-
  Latent Energy — Graph Exact (Phase C bundle)

  Strengthens the dual code graph with the current law.

  Dependencies: DualCode, CurrentLaw
  New axioms: 0
-/

namespace LatentEnergy

open FinalSourceCode Manifestability

/-- The manifestation current at a state: J_x = Ω⁻¹η_x.
    At this level, J = η (current = code). -/
def currentAt (s : AdmissibleState) : List Nat :=
  manifestationCurrent s

/-- Current equals code: J_x = η_x. -/
theorem current_equals_code (s : AdmissibleState) :
    currentAt s = consciousnessCode s := rfl

/-- The full chain: state → code → dual energy → current. -/
theorem full_chain_exact (s : AdmissibleState) :
    -- Code is derivative of energy
    consciousnessCode s = s.partition.map classLatentEnergy ∧
    -- Dual recovers energy
    dualEnergy (consciousnessCode s) = U_ind s ∧
    -- Current is code
    manifestationCurrent s = consciousnessCode s :=
  ⟨state_contains_its_own_code s, primal_dual_inverse_exact s, rfl⟩

end LatentEnergy
