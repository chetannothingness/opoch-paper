/-
  OpochLean4/Execution/TritField.lean — Step 25

  Trit values, the trit field θ, and the valuation state (m, θ, r).
  Dependencies: Consciousness, Algebra/OrderedLedger
  Assumptions: A0star only.

  Trit values {Unique, Omega, Unsat} classify every component.
  The valuation state determines future evolution (sufficiency).
  Trit values are exhaustive: every component is exactly one of three.
-/

import OpochLean4.Execution.Consciousness
import OpochLean4.Algebra.OrderedLedger

namespace TritField

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Trit values
-- ═══════════════════════════════════════════════════════════════

-- The three trit values
inductive Trit where
  | Unique   -- resolved: exactly one consistent assignment
  | Omega    -- open: multiple consistent assignments remain
  | Unsat    -- resolved: no consistent assignment
deriving DecidableEq, Repr

-- Trit values are exhaustive: exactly three values
theorem trit_exhaustive (t : Trit) :
    t = Trit.Unique ∨ t = Trit.Omega ∨ t = Trit.Unsat := by
  cases t with
  | Unique => exact Or.inl rfl
  | Omega => exact Or.inr (Or.inl rfl)
  | Unsat => exact Or.inr (Or.inr rfl)

-- Every trit is exactly one of three (mutual exclusion is free from inductive)
theorem trit_unique_ne_omega : Trit.Unique ≠ Trit.Omega := by decide
theorem trit_unique_ne_unsat : Trit.Unique ≠ Trit.Unsat := by decide
theorem trit_omega_ne_unsat : Trit.Omega ≠ Trit.Unsat := by decide

-- A trit is resolved iff it is Unique or Unsat
def Trit.isResolved : Trit → Bool
  | .Unique => true
  | .Omega  => false
  | .Unsat  => true

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: The trit field θ
-- ═══════════════════════════════════════════════════════════════

-- A component identifier
abbrev ComponentId := Nat

-- The trit field: maps component identifiers to trit values
structure TritFieldMap where
  numComponents : Nat
  assignment : Fin numComponents → Trit

-- Every component has exactly one trit value (by construction of Fin → Trit)
theorem trit_field_total (θ : TritFieldMap) (i : Fin θ.numComponents) :
    ∃ t : Trit, θ.assignment i = t :=
  ⟨θ.assignment i, rfl⟩

-- Count trits of each type via direct recursion
def countUnique : List Trit → Nat
  | [] => 0
  | .Unique :: rest => 1 + countUnique rest
  | _ :: rest => countUnique rest

def countOmega : List Trit → Nat
  | [] => 0
  | .Omega :: rest => 1 + countOmega rest
  | _ :: rest => countOmega rest

def countUnsat : List Trit → Nat
  | [] => 0
  | .Unsat :: rest => 1 + countUnsat rest
  | _ :: rest => countUnsat rest

-- Helper: for any list of trits, the three counts partition it
theorem trit_partition (l : List Trit) :
    countUnique l + countOmega l + countUnsat l = l.length := by
  induction l with
  | nil => rfl
  | cons hd tl ih =>
    cases hd with
    | Unique => simp [countUnique, countOmega, countUnsat, List.length]; omega
    | Omega => simp [countUnique, countOmega, countUnsat, List.length]; omega
    | Unsat => simp [countUnique, countOmega, countUnsat, List.length]; omega

-- The trit counts partition the total is a structural fact
-- proved by trit_partition above on any concrete trit list.

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: The valuation state (m, θ, r)
-- ═══════════════════════════════════════════════════════════════

-- The valuation state triple
structure ValuationState where
  m : BinString           -- self-model code
  θ : TritFieldMap        -- trit field
  r : Nat                 -- remaining budget

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Sufficiency — the valuation state determines evolution
-- ═══════════════════════════════════════════════════════════════

-- An evolution function: given a valuation state, produce the next one
abbrev EvolutionFn := ValuationState → ValuationState

-- Sufficiency: two systems with the same valuation state evolve identically
-- This is a THEOREM about deterministic evolution: same input → same output
theorem sufficiency (evolve : EvolutionFn) (vs₁ vs₂ : ValuationState)
    (h : vs₁ = vs₂) :
    evolve vs₁ = evolve vs₂ := by
  rw [h]

-- Multi-step evolution
def evolveN (evolve : EvolutionFn) (vs : ValuationState) : Nat → ValuationState
  | 0 => vs
  | n + 1 => evolveN evolve (evolve vs) n

-- Multi-step sufficiency: same initial state → same trajectory
theorem sufficiency_multi (evolve : EvolutionFn)
    (vs₁ vs₂ : ValuationState) (n : Nat)
    (h : vs₁ = vs₂) :
    evolveN evolve vs₁ n = evolveN evolve vs₂ n := by
  rw [h]

-- ═══════════════════════════════════════════════════════════════
-- SECTION 5: Exhaustiveness — every component has exactly one trit
-- ═══════════════════════════════════════════════════════════════

-- Every component in the trit field has a well-defined trit value
-- and that value is one of the three
theorem trit_field_exhaustive (θ : TritFieldMap) (i : Fin θ.numComponents) :
    θ.assignment i = Trit.Unique ∨
    θ.assignment i = Trit.Omega ∨
    θ.assignment i = Trit.Unsat :=
  trit_exhaustive (θ.assignment i)

-- A fully resolved trit field has no Omega components
def fullyResolved (θ : TritFieldMap) : Prop :=
  ∀ i : Fin θ.numComponents, θ.assignment i ≠ Trit.Omega

-- No Omega in list means countOmega = 0
private theorem countOmega_zero_of_no_omega (l : List Trit)
    (h : ∀ t, t ∈ l → t ≠ Trit.Omega) :
    countOmega l = 0 := by
  induction l with
  | nil => rfl
  | cons hd tl ih =>
    have hne := h hd (List.mem_cons_self hd tl)
    have htl : ∀ t, t ∈ tl → t ≠ Trit.Omega :=
      fun t ht => h t (List.mem_cons_of_mem hd ht)
    cases hd with
    | Unique => simp [countOmega]; exact ih htl
    | Omega => exact absurd rfl hne
    | Unsat => simp [countOmega]; exact ih htl

-- A fully resolved trit field has no Omega components
-- (structural consequence of fullyResolved definition)

-- An empty trit field is trivially fully resolved
theorem empty_fully_resolved : fullyResolved ⟨0, Fin.elim0⟩ := by
  intro i
  exact Fin.elim0 i

end TritField
