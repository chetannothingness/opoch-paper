import OpochLean4.LatentEnergy.OnAtlas
import OpochLean4.FinalSourceCode.PrimalDualIdentity

/-
  Latent Energy — Dual Code on the Atlas

  η = dU_ind : the consciousness-code as differential of the energy.
  The universe is the exact graph of dU_ind.

  Phase C of the final kernel stack.

  Dependencies: OnAtlas, PrimalDualIdentity
  New axioms: 0
-/

namespace LatentEnergy

open FinalSourceCode Manifestability

-- ================================================================
-- Dual code on the atlas
-- ================================================================

/-- The dual code at a point: η_x = dU_ind(x) = energy profile.
    This is the consciousness-code: the state read as source code. -/
def dualCodeAt (s : AdmissibleState) : List Nat :=
  consciousnessCode s

/-- The dual energy: applying the dual to the code recovers U_ind. -/
def dualEnergyAt (s : AdmissibleState) : Nat :=
  dualEnergy (dualCodeAt s)

-- ================================================================
-- The graph of dU_ind
-- ================================================================

/-- A point on the graph of dU_ind: a state paired with its dual code.
    GraphU = { (x, η) | η = dU_ind(x) }. -/
structure GraphPoint where
  state : AdmissibleState
  code : List Nat
  code_eq : code = consciousnessCode state

-- The graph GraphU is the type GraphPoint itself.
-- Every GraphPoint satisfies the defining equation by construction.

-- ================================================================
-- Phase C theorems
-- ================================================================

/-- Graph existence: every state has a graph point. -/
theorem graph_exists (s : AdmissibleState) :
    ∃ p : GraphPoint, p.state = s :=
  ⟨⟨s, consciousnessCode s, rfl⟩, rfl⟩

/-- Graph uniqueness: the code is determined by the state. -/
theorem graph_unique (p₁ p₂ : GraphPoint) (h : p₁.state = p₂.state) :
    p₁.code = p₂.code := by
  rw [p₁.code_eq, p₂.code_eq, h]

/-- Primal-dual recovery: dualEnergy(η_x) = U_ind(x). -/
theorem primal_dual_recovery (s : AdmissibleState) :
    dualEnergyAt s = U_ind s :=
  primal_dual_inverse_exact s

/-- Code determines state (up to energy): knowing η determines U_ind. -/
theorem code_determines_energy (s : AdmissibleState) :
    dualEnergy (consciousnessCode s) = U_ind s :=
  primal_dual_inverse_exact s

/-- State determines code: the code is intrinsic to the state. -/
theorem state_determines_code (s : AdmissibleState) :
    consciousnessCode s = s.partition.map classLatentEnergy :=
  state_contains_its_own_code s

/-- Bundle theorem: the latent graph is exact. -/
theorem latent_graph_exact :
    -- Graph exists for every state
    (∀ s : AdmissibleState, ∃ p : GraphPoint, p.state = s) ∧
    -- Code is unique from state
    (∀ p₁ p₂ : GraphPoint, p₁.state = p₂.state → p₁.code = p₂.code) ∧
    -- Primal-dual recovery
    (∀ s : AdmissibleState, dualEnergy (consciousnessCode s) = U_ind s) ∧
    -- Code is intrinsic
    (∀ s : AdmissibleState, consciousnessCode s = s.partition.map classLatentEnergy) :=
  ⟨graph_exists, graph_unique, fun s => primal_dual_inverse_exact s,
   fun s => state_contains_its_own_code s⟩

end LatentEnergy
