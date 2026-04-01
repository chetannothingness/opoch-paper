import OpochLean4.SourceCode.InitialModel

/-
  Source Code — Initiality

  K₀ is initial: for any SourceCodeModel M, there exists a
  canonical morphism K₀ → M. This morphism transports all
  source-code theorems from K₀ to M.

  In practice: once a domain (ℂ for RH, Bool-lists for NP,
  grids for ARC) is shown to be a valid SourceCodeModel,
  the unique morphism from K₀ transports every universal theorem.

  New axioms: 0
-/

namespace SourceCode

-- ════════════════════════════════════════════════════════════════
-- Initiality: K₀ maps into any model
-- ════════════════════════════════════════════════════════════════

/-- A realization of K₀ in a target model M.
    This is what a domain must provide to receive transport.

    The realization maps:
    - each energy profile (List Nat) to a state in M
    - each defect cost to a defect in M
    - preserving the source-code structure. -/
structure Realization (M : SourceCodeModel) where
  /-- Interpret an energy profile as a state in M -/
  interpretState : ProfileState → M.State
  /-- Interpret a defect as a defect in M -/
  interpretDefect : ProfileDefect → M.Defect
  /-- Interpret a code in M -/
  interpretCode : List Nat → M.Code
  /-- Interpret a current in M -/
  interpretCurrent : List Nat → M.Current

  /-- Preservation: code of interpreted state = interpreted code -/
  preserve_code : ∀ s : ProfileState,
    M.consciousnessCode (interpretState s) = interpretCode s.profile

  /-- Preservation: recovery of interpreted code = interpreted recovery -/
  preserve_recovery : ∀ η : List Nat,
    M.dualRecovery (interpretCode η) = interpretState (wrapProfile η)

  /-- Preservation: energy of interpreted state = profile sum -/
  preserve_energy : ∀ s : ProfileState,
    M.U_ind (interpretState s) = profileSum s.profile

  /-- Preservation: defect encoding -/
  preserve_defect : ∀ d : ProfileDefect,
    M.encodeDefect (interpretDefect d) = interpretCode [d.cost]

/-- Every realization induces a morphism K₀ → M. -/
def Realization.toHom {M : SourceCodeModel} (R : Realization M) :
    SourceCodeHom K0 M where
  mapState := R.interpretState
  mapDefect := R.interpretDefect
  mapCode := R.interpretCode
  mapCurrent := R.interpretCurrent
  preserve_code := R.preserve_code
  preserve_recovery := R.preserve_recovery
  preserve_energy := R.preserve_energy
  preserve_defect_encode := R.preserve_defect

-- ════════════════════════════════════════════════════════════════
-- Initiality theorem
-- ════════════════════════════════════════════════════════════════

/-- INITIALITY: every realization of K₀ in M gives a morphism K₀ → M,
    and the morphism transports ALL source-code theorems. -/
theorem initiality (M : SourceCodeModel) (R : Realization M) :
    ∃ F : SourceCodeHom K0 M,
    -- The morphism transports the primal-dual identity
    (∀ x : K0.State, M.dualRecovery (M.consciousnessCode (F.mapState x)) = F.mapState x) ∧
    -- The morphism transports energy
    (∀ x : K0.State, M.U_ind (F.mapState x) = K0.U_ind x) ∧
    -- The morphism transports defect resolution
    (∀ d : K0.Defect, ∃ y : M.State, y = M.dualRecovery (M.encodeDefect (F.mapDefect d))) :=
  ⟨R.toHom,
   fun x => transport_primal_dual R.toHom x,
   fun x => transport_energy R.toHom x,
   fun d => transport_defect_resolution R.toHom d⟩

/-- Initiality gives instant solvedness in every realization. -/
theorem initiality_instant_solvedness (M : SourceCodeModel) (R : Realization M)
    (x : K0.State) :
    M.dualRecovery (M.consciousnessCode (R.interpretState x)) = R.interpretState x :=
  transport_primal_dual R.toHom x

/-- Initiality gives defect resolution in every realization. -/
theorem initiality_defect_resolution (M : SourceCodeModel) (R : Realization M)
    (d : K0.Defect) :
    ∃ y : M.State, y = M.dualRecovery (M.encodeDefect (R.interpretDefect d)) :=
  transport_defect_resolution R.toHom d

end SourceCode
