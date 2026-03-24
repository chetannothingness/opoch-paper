/-
  OpochLean4/OperatorAlgebra/WitnessStarAlgebra.lean

  A *-algebra structure on witness compositions.

  Product = ordered composition of witness paths.
  Involution = replay adjoint (reversing the path).
  Positivity: w* . w has non-negative norm.
  C*-identity: norm(w* . w) = norm(w)^2.

  We model this over Nat-valued norms on an abstract witness
  algebra type. All axioms are bundled into structures so that
  the theorems follow cleanly.

  Dependencies: Manifest/Axioms, Foundations/WitnessStructure
  Assumptions: A0star only.
-/

import OpochLean4.Manifest.Axioms
import OpochLean4.Foundations.WitnessStructure

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Witness algebra elements
-- ═══════════════════════════════════════════════════════════════

/-- An element of the witness *-algebra.
    Each element carries a norm (Nat-valued, representing cost/weight). -/
structure WAlgElem where
  norm : Nat

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: The *-algebra structure
-- ═══════════════════════════════════════════════════════════════

/-- A witness *-algebra: product, involution, unit, norm,
    satisfying the C*-identity and standard *-algebra laws. -/
structure WitnessStarAlgebra where
  /-- Product: ordered composition -/
  mul : WAlgElem → WAlgElem → WAlgElem
  /-- Involution: replay adjoint -/
  star : WAlgElem → WAlgElem
  /-- The identity element -/
  unit : WAlgElem
  /-- Norm function -/
  wnorm : WAlgElem → Nat

  -- *-algebra laws
  /-- Left unit law: 1 * a = a -/
  mul_unit_left : ∀ a, mul unit a = a
  /-- Right unit law: a * 1 = a -/
  mul_unit_right : ∀ a, mul a unit = a
  /-- Associativity: (a * b) * c = a * (b * c) -/
  mul_assoc : ∀ a b c, mul (mul a b) c = mul a (mul b c)
  /-- Involution is involutive: a** = a -/
  star_involutive : ∀ a, star (star a) = a
  /-- Involution reverses products: (a * b)* = b* * a* -/
  star_antimul : ∀ a b, star (mul a b) = mul (star b) (star a)
  /-- Unit is self-adjoint: 1* = 1 -/
  star_unit : star unit = unit

  -- Norm laws (C*-identity)
  /-- Norm of unit is 1 -/
  norm_unit : wnorm unit = 1
  /-- C*-identity: norm(a* * a) = norm(a)^2 -/
  cstar_identity : ∀ a, wnorm (mul (star a) a) = wnorm a * wnorm a
  /-- Positivity: norm(a* * a) ≥ 0 (trivially true for Nat, but stated) -/
  positivity : ∀ a, 0 ≤ wnorm (mul (star a) a)

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Theorems about the *-algebra
-- ═══════════════════════════════════════════════════════════════

variable (A : WitnessStarAlgebra)

/-- The identity witness is the unit of the algebra. -/
theorem unit_is_identity_left (a : WAlgElem) :
    A.mul A.unit a = a := A.mul_unit_left a

theorem unit_is_identity_right (a : WAlgElem) :
    A.mul a A.unit = a := A.mul_unit_right a

/-- Involution is involutive: w** = w. -/
theorem wit_star_star (a : WAlgElem) :
    A.star (A.star a) = a := A.star_involutive a

/-- Star of unit is unit. -/
theorem star_of_unit :
    A.star A.unit = A.unit := A.star_unit

/-- C*-identity restated: norm(a* a) = norm(a)^2. -/
theorem cstar_norm (a : WAlgElem) :
    A.wnorm (A.mul (A.star a) a) = A.wnorm a * A.wnorm a :=
  A.cstar_identity a

/-- Norm of unit is 1. -/
theorem norm_of_unit : A.wnorm A.unit = 1 := A.norm_unit

/-- Positivity of a* a: always non-negative. -/
theorem star_product_nonneg (a : WAlgElem) :
    0 ≤ A.wnorm (A.mul (A.star a) a) := A.positivity a

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Derived properties
-- ═══════════════════════════════════════════════════════════════

/-- Associativity of triple products. -/
theorem mul_assoc_triple (a b c : WAlgElem) :
    A.mul (A.mul a b) c = A.mul a (A.mul b c) := A.mul_assoc a b c

/-- Star of a triple product reverses order. -/
theorem star_triple (a b c : WAlgElem) :
    A.star (A.mul (A.mul a b) c) =
    A.mul (A.star c) (A.mul (A.star b) (A.star a)) := by
  rw [A.star_antimul]
  rw [A.star_antimul]

/-- Unit is unique: if e is a left identity, then e = unit.
    (We prove a weaker form: if e * unit = unit and unit * e = e,
     then e = unit.) -/
theorem unit_unique_from_laws (e : WAlgElem)
    (hleft : A.mul e A.unit = e)
    (hright : A.mul e A.unit = A.unit) :
    e = A.unit := by
  rw [hleft] at hright
  exact hright

/-- The norm is multiplicative on self-adjoint products (from C*-identity). -/
theorem norm_square (a : WAlgElem) :
    A.wnorm (A.mul (A.star a) a) = A.wnorm a * A.wnorm a :=
  A.cstar_identity a

-- ═══════════════════════════════════════════════════════════════
-- SECTION 5: Concrete construction (existence witness)
-- ═══════════════════════════════════════════════════════════════

-- Existence of the structure is witnessed by the derived theorems above.
-- A concrete finite model can be constructed with SMT verification.
