import OpochLean4.SourceCode.Morphism

/-
  Source Code — Initial Model K₀

  The canonical initial source-code model.

  K₀ is the pure source code. State = nonempty list of Nat (energy profile).
  U_ind = sum. Code = the profile itself. Dual recovery = wrap profile as state.
  Primal-dual identity holds by construction.

  Every other model receives theorems from K₀ via morphisms (transport).

  New axioms: 0
-/

namespace SourceCode

-- ════════════════════════════════════════════════════════════════
-- Carrier types for K₀
-- ════════════════════════════════════════════════════════════════

/-- A state in the initial model: a nonempty energy profile. -/
structure ProfileState where
  profile : List Nat
  nonempty : profile.length ≥ 1

@[ext]
theorem ProfileState.ext {a b : ProfileState} (h : a.profile = b.profile) : a = b := by
  cases a; cases b; simp_all

/-- A defect in the initial model: a positive cost. -/
structure ProfileDefect where
  cost : Nat
  cost_pos : cost ≥ 1

/-- Sum of a list of Nat (the energy). -/
def profileSum : List Nat → Nat
  | [] => 0
  | n :: rest => n + profileSum rest

-- ════════════════════════════════════════════════════════════════
-- The Initial Model K₀
-- ════════════════════════════════════════════════════════════════

/-- Wrap a nonempty code (List Nat) as a ProfileState. -/
def wrapProfile (η : List Nat) : ProfileState where
  profile := if η.length ≥ 1 then η else [0]
  nonempty := by
    split <;> simp_all <;> omega

/-- K₀: the canonical initial source-code model.

    The state IS its energy profile.
    The code IS the profile.
    The dual recovery wraps the code back as state.
    The primal-dual identity is: unwrap then wrap = id. -/
def K0 : SourceCodeModel where
  State := ProfileState
  Defect := ProfileDefect
  Code := List Nat
  Current := List Nat

  U_ind := fun s => profileSum s.profile
  consciousnessCode := fun s => s.profile
  dualRecovery := wrapProfile
  current := fun η => η
  encodeDefect := fun d => [d.cost]
  defectCost := fun d => d.cost
  defect_cost_pos := fun d => d.cost_pos

  primal_dual := fun x => by
    apply ProfileState.ext
    simp only [wrapProfile]
    have := x.nonempty
    split
    · rfl
    · omega
  code_determines_energy := fun x => by
    simp only [wrapProfile]
    split
    · rfl
    · have := x.nonempty; omega
  defect_resolves := fun d => ⟨_, rfl⟩
  code_intrinsic := fun _ _ h => by subst h; rfl

-- ════════════════════════════════════════════════════════════════
-- Properties of K₀
-- ════════════════════════════════════════════════════════════════

/-- K₀ satisfies the primal-dual identity. -/
theorem K0_primal_dual (x : K0.State) :
    K0.dualRecovery (K0.consciousnessCode x) = x :=
  every_state_instantly_solved x

/-- K₀ resolves every defect. -/
theorem K0_defect_resolves (d : K0.Defect) :
    ∃ x : K0.State, x = K0.dualRecovery (K0.encodeDefect d) :=
  every_defect_resolves d

/-- Profile sum is additive (used for transport). -/
theorem profileSum_append (l₁ l₂ : List Nat) :
    profileSum (l₁ ++ l₂) = profileSum l₁ + profileSum l₂ := by
  induction l₁ with
  | nil => simp [profileSum]
  | cons n rest ih => simp [profileSum, ih]; omega

end SourceCode
