import OpochLean4.Riemann.Defect.CriticalDefect

/-
  Layer A — Concrete Mathlib Side

  Define the concrete RH defect type entirely in Mathlib terms.
  No TOE types here. Pure complex analysis objects.

  New axioms: 0
-/

namespace Riemann.Bridge

open Complex

-- ════════════════════════════════════════════════════════════════
-- Concrete zero orbit type
-- ════════════════════════════════════════════════════════════════

/-- A nontrivial zero of ξ as a concrete Mathlib object. -/
structure NontrivialZeroData where
  ρ : ℂ
  is_zero : Riemann.xi ρ = 0
  ne_zero : ρ ≠ 0
  ne_one : ρ ≠ 1

/-- A zero orbit: a collection of related zeros under symmetry. -/
structure ZeroOrbit where
  members : List ℂ
  nonempty : members.length ≥ 1
  all_zeros : ∀ z ∈ members, Riemann.xi z = 0

/-- An orbit is critical: all members have Re = 1/2. -/
def CriticalOrbit (O : ZeroOrbit) : Prop :=
  ∀ z ∈ O.members, z.re = 1/2

/-- An orbit is off-line: at least one member has Re ≠ 1/2. -/
def OffLineOrbit (O : ZeroOrbit) : Prop :=
  ∃ z ∈ O.members, z.re ≠ 1/2

/-- An RH defect: a zero orbit that is off-line. -/
structure RHDefect where
  orbit : ZeroOrbit
  offLine : OffLineOrbit orbit

/-- Build a zero orbit from a single nontrivial zero. -/
def orbitOf (z : NontrivialZeroData) : ZeroOrbit where
  members := [z.ρ]
  nonempty := by simp
  all_zeros := by simp [z.is_zero]

/-- The zero is in its own orbit. -/
theorem orbit_contains_self (z : NontrivialZeroData) :
    z.ρ ∈ (orbitOf z).members := by simp [orbitOf]

/-- If a zero is off-line, its orbit is off-line. -/
theorem offLine_of_re_ne (z : NontrivialZeroData) (h : z.ρ.re ≠ 1/2) :
    OffLineOrbit (orbitOf z) :=
  ⟨z.ρ, orbit_contains_self z, h⟩

end Riemann.Bridge
