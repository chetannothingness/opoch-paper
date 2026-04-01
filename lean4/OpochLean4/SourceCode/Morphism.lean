import OpochLean4.SourceCode.Model

/-
  Source Code — Morphism

  A morphism between source-code models preserves all structure:
  latent energy, consciousness-code, dual recovery, current law.

  Morphisms are the arrows in the category of source-code models.
  The initial model maps uniquely into every other model.
  Transport is pushforward along morphisms.

  New axioms: 0
-/

namespace SourceCode

-- ════════════════════════════════════════════════════════════════
-- Morphisms between models
-- ════════════════════════════════════════════════════════════════

/-- A morphism between source-code models.
    Preserves: states, codes, energy, primal-dual identity.
    This is what makes transport work. -/
structure SourceCodeHom (M N : SourceCodeModel) where
  /-- Map on states -/
  mapState : M.State → N.State
  /-- Map on defects -/
  mapDefect : M.Defect → N.Defect
  /-- Map on codes -/
  mapCode : M.Code → N.Code
  /-- Map on currents -/
  mapCurrent : M.Current → N.Current

  /-- Preserves consciousness-code:
      η_N(F(x)) = F_code(η_M(x)) -/
  preserve_code : ∀ x : M.State,
    N.consciousnessCode (mapState x) = mapCode (M.consciousnessCode x)

  /-- Preserves dual recovery:
      r_N(F_code(η)) = F(r_M(η)) -/
  preserve_recovery : ∀ c : M.Code,
    N.dualRecovery (mapCode c) = mapState (M.dualRecovery c)

  /-- Preserves energy:
      U_ind_N(F(x)) = U_ind_M(x) -/
  preserve_energy : ∀ x : M.State,
    N.U_ind (mapState x) = M.U_ind x

  /-- Preserves defect encoding -/
  preserve_defect_encode : ∀ d : M.Defect,
    N.encodeDefect (mapDefect d) = mapCode (M.encodeDefect d)

-- ════════════════════════════════════════════════════════════════
-- Derived properties of morphisms
-- ════════════════════════════════════════════════════════════════

variable {M N : SourceCodeModel}

/-- A morphism transports the primal-dual identity. -/
theorem transport_primal_dual (F : SourceCodeHom M N) (x : M.State) :
    N.dualRecovery (N.consciousnessCode (F.mapState x)) = F.mapState x := by
  rw [F.preserve_code, F.preserve_recovery]
  congr 1
  exact M.primal_dual x

/-- A morphism transports instant solvedness. -/
theorem transport_instant_solvedness (F : SourceCodeHom M N) (x : M.State) :
    N.dualRecovery (N.consciousnessCode (F.mapState x)) = F.mapState x :=
  transport_primal_dual F x

/-- A morphism transports energy conservation. -/
theorem transport_energy (F : SourceCodeHom M N) (x : M.State) :
    N.U_ind (F.mapState x) = M.U_ind x :=
  F.preserve_energy x

/-- A morphism transports defect resolution. -/
theorem transport_defect_resolution (F : SourceCodeHom M N) (d : M.Defect) :
    ∃ x : N.State, x = N.dualRecovery (N.encodeDefect (F.mapDefect d)) := by
  rw [F.preserve_defect_encode]
  rw [F.preserve_recovery]
  exact ⟨_, rfl⟩

-- ════════════════════════════════════════════════════════════════
-- Identity and composition
-- ════════════════════════════════════════════════════════════════

/-- The identity morphism. -/
def SourceCodeHom.id (M : SourceCodeModel) : SourceCodeHom M M where
  mapState := _root_.id
  mapDefect := _root_.id
  mapCode := _root_.id
  mapCurrent := _root_.id
  preserve_code := fun _ => rfl
  preserve_recovery := fun _ => rfl
  preserve_energy := fun _ => rfl
  preserve_defect_encode := fun _ => rfl

/-- Composition of morphisms. -/
def SourceCodeHom.comp {L M N : SourceCodeModel}
    (G : SourceCodeHom M N) (F : SourceCodeHom L M) : SourceCodeHom L N where
  mapState := G.mapState ∘ F.mapState
  mapDefect := G.mapDefect ∘ F.mapDefect
  mapCode := G.mapCode ∘ F.mapCode
  mapCurrent := G.mapCurrent ∘ F.mapCurrent
  preserve_code := fun x => by
    simp [Function.comp]
    rw [G.preserve_code, F.preserve_code]
  preserve_recovery := fun c => by
    simp [Function.comp]
    rw [G.preserve_recovery, F.preserve_recovery]
  preserve_energy := fun x => by
    simp [Function.comp]
    rw [G.preserve_energy, F.preserve_energy]
  preserve_defect_encode := fun d => by
    simp [Function.comp]
    rw [G.preserve_defect_encode, F.preserve_defect_encode]

end SourceCode
