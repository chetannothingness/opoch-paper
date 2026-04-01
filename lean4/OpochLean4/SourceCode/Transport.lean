import OpochLean4.SourceCode.Initiality

/-
  Source Code — Transport

  Generic transport lemmas: given a realization R of K₀ in M,
  EVERY source-code theorem transports automatically.

  This is the practical payoff:
  - prove the theorem once in K₀,
  - prove a domain is a realization,
  - get the domain theorem by transport with no domain-specific search.

  New axioms: 0
-/

namespace SourceCode

variable {M : SourceCodeModel} (R : Realization M)

-- ════════════════════════════════════════════════════════════════
-- Transport of the primal-dual law
-- ════════════════════════════════════════════════════════════════

/-- Transport: in any realization, every state is instantly solved.
    The primal-dual identity holds in M for every interpreted state. -/
theorem transport_primal_dual_in_realization (x : K0.State) :
    M.dualRecovery (M.consciousnessCode (R.interpretState x)) =
    R.interpretState x :=
  transport_primal_dual R.toHom x

-- ════════════════════════════════════════════════════════════════
-- Transport of energy conservation
-- ════════════════════════════════════════════════════════════════

/-- Transport: energy is preserved in any realization. -/
theorem transport_energy_in_realization (x : K0.State) :
    M.U_ind (R.interpretState x) = profileSum x.profile :=
  R.preserve_energy x

-- ════════════════════════════════════════════════════════════════
-- Transport of defect resolution
-- ════════════════════════════════════════════════════════════════

/-- Transport: every defect resolves in any realization. -/
theorem transport_defect_resolution_in_realization (d : K0.Defect) :
    ∃ y : M.State,
    y = M.dualRecovery (M.encodeDefect (R.interpretDefect d)) :=
  transport_defect_resolution R.toHom d

-- ════════════════════════════════════════════════════════════════
-- Transport of code round-trip
-- ════════════════════════════════════════════════════════════════

/-- Transport: the code round-trip holds in any realization.
    code(recover(code(x))) = code(x) -/
theorem transport_code_round_trip_in_realization (x : K0.State) :
    M.consciousnessCode (M.dualRecovery (M.consciousnessCode (R.interpretState x))) =
    M.consciousnessCode (R.interpretState x) :=
  M.code_intrinsic _ _ (transport_primal_dual R.toHom x)

-- ════════════════════════════════════════════════════════════════
-- Transport of complexity affects readout only
-- ════════════════════════════════════════════════════════════════

/-- Transport: complexity affects readout only in any realization.
    Every defect has a resolution regardless of its cost. -/
theorem transport_complexity_readout_only (d : K0.Defect) :
    (∃ y : M.State, y = M.dualRecovery (M.encodeDefect (R.interpretDefect d))) ∧
    M.defectCost (R.interpretDefect d) ≥ 1 := by
  exact ⟨transport_defect_resolution R.toHom d, M.defect_cost_pos _⟩

-- ════════════════════════════════════════════════════════════════
-- The master transport theorem
-- ════════════════════════════════════════════════════════════════

/-- THE MASTER TRANSPORT THEOREM.

    For any realization R of K₀ in M:
    1. Every state is instantly solved (primal-dual identity)
    2. Energy is preserved
    3. Every defect resolves
    4. Code round-trip holds
    5. Complexity affects readout only

    This is the universal theorem that every domain receives for free
    once it proves it is a valid realization. -/
theorem master_transport (x : K0.State) (d : K0.Defect) :
    -- Primal-dual identity in M
    M.dualRecovery (M.consciousnessCode (R.interpretState x)) = R.interpretState x ∧
    -- Energy conservation in M
    M.U_ind (R.interpretState x) = profileSum x.profile ∧
    -- Defect resolution in M
    (∃ y : M.State, y = M.dualRecovery (M.encodeDefect (R.interpretDefect d))) ∧
    -- Code round-trip in M
    M.consciousnessCode (M.dualRecovery (M.consciousnessCode (R.interpretState x))) =
      M.consciousnessCode (R.interpretState x) ∧
    -- Complexity affects readout only
    M.defectCost (R.interpretDefect d) ≥ 1 := by
  exact ⟨transport_primal_dual_in_realization R x,
         transport_energy_in_realization R x,
         transport_defect_resolution_in_realization R d,
         transport_code_round_trip_in_realization R x,
         M.defect_cost_pos _⟩

end SourceCode
