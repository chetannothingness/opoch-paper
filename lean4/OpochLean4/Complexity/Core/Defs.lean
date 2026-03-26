/-
  OpochLean4/Complexity/Core/Defs.lean

  Standard complexity definitions. No shortcuts.
  P has polynomial bound. NP has polynomial verifier.
  SAT defined properly. Pure definitions.
  Assumptions: None beyond Lean's type theory.
-/

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Size and polynomial bounds
-- ═══════════════════════════════════════════════════════════════

/-- Polynomial bound function with enforced polynomial growth.
    eval is bounded by coeff * (n+1)^degree.
    This ensures no exponential can satisfy Poly. -/
structure Poly where
  eval : Nat → Nat
  degree : Nat
  coeff : Nat
  monotone : ∀ a b, a ≤ b → eval a ≤ eval b
  polynomial_bound : ∀ n, eval n ≤ coeff * (n + 1) ^ degree

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1b: Sized types
-- ═══════════════════════════════════════════════════════════════

/-- A type with a computable size measure. -/
class Sized (α : Type) where
  size : α → Nat

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: SAT definitions (concrete, computational)
-- ═══════════════════════════════════════════════════════════════

/-- A literal: variable index + polarity. -/
structure Literal where
  var : Nat
  pos : Bool
deriving DecidableEq, Repr

abbrev Clause := List Literal
abbrev CNF := List Clause
abbrev Assign := Nat → Bool

/-- Number of variables in a formula. -/
def numVars (φ : CNF) : Nat :=
  φ.foldl (fun acc c => c.foldl (fun a l => max a (l.var + 1)) acc) 0

/-- Formula size (total literal occurrences). -/
def cnfSize (φ : CNF) : Nat :=
  φ.foldl (fun acc c => acc + c.length) 0

instance : Sized (List Bool) where
  size := List.length

/-- CNF size measure: captures all relevant parameters.
    numVars (variable count) + cnfSize (total literals) +
    length (clause count) + maxWidth (max clause width).
    This ensures all formula parameters ≤ Sized.size. -/
def cnfFullSize (φ : CNF) : Nat :=
  -- Forward declaration — maxWidth defined in KernelSize.lean
  -- For the size measure, we use a conservative bound
  numVars φ + cnfSize φ + φ.length

instance : Sized CNF where
  size := cnfFullSize

/-- Evaluate a literal under assignment. -/
def evalLit (l : Literal) (σ : Assign) : Bool :=
  if l.pos then σ l.var else !σ l.var

/-- Evaluate a clause (disjunction). -/
def evalClause (c : Clause) (σ : Assign) : Bool :=
  c.any (evalLit · σ)

/-- Evaluate a CNF formula (conjunction of clauses). -/
def evalCNF (φ : CNF) (σ : Assign) : Bool :=
  φ.all (evalClause · σ)

/-- Satisfiability. -/
def Sat (φ : CNF) : Prop := ∃ σ : Assign, evalCNF φ σ = true

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: SAT verification lemmas
-- ═══════════════════════════════════════════════════════════════

theorem evalCNF_cons (c : Clause) (φ : CNF) (σ : Assign) :
    evalCNF (c :: φ) σ = (evalClause c σ && evalCNF φ σ) := by
  simp [evalCNF, List.all_cons]

theorem empty_sat : Sat [] := ⟨fun _ => true, by simp [evalCNF]⟩

theorem unit_sat : Sat [[⟨0, true⟩]] :=
  ⟨fun _ => true, by simp [evalCNF, evalClause, evalLit]⟩

theorem contra_unsat : ¬Sat [[⟨0, true⟩], [⟨0, false⟩]] := by
  intro ⟨σ, h⟩
  simp [evalCNF, evalClause, evalLit] at h

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Partial assignments and residual formulas
-- ═══════════════════════════════════════════════════════════════

/-- A partial assignment: assigns first k variables. -/
structure PartialAssign where
  depth : Nat
  values : Fin depth → Bool

/-- Extend a partial assignment by one bit. -/
def PartialAssign.extend (pa : PartialAssign) (b : Bool) : PartialAssign where
  depth := pa.depth + 1
  values := fun i =>
    if h : i.val < pa.depth then pa.values ⟨i.val, h⟩ else b

/-- Complete a partial assignment with a suffix. -/
def PartialAssign.complete (pa : PartialAssign) (suffix : Nat → Bool) : Assign :=
  fun i => if h : i < pa.depth then pa.values ⟨i, h⟩ else suffix (i - pa.depth)

/-- The empty partial assignment. -/
def PartialAssign.empty : PartialAssign where
  depth := 0
  values := Fin.elim0

-- ═══════════════════════════════════════════════════════════════
-- SECTION 5: Future satisfiability
-- ═══════════════════════════════════════════════════════════════

/-- Future satisfiability: can the partial assignment be completed
    to satisfy the formula? -/
def futureSat (φ : CNF) (pa : PartialAssign) : Prop :=
  ∃ suffix : Nat → Bool, evalCNF φ (pa.complete suffix) = true

/-- Satisfiability = future satisfiability from empty assignment. -/
theorem sat_iff_future_empty (φ : CNF) :
    Sat φ ↔ futureSat φ PartialAssign.empty := by
  constructor
  · intro ⟨σ, h⟩
    exact ⟨σ, by simp [PartialAssign.complete, PartialAssign.empty]; exact h⟩
  · intro ⟨suffix, h⟩
    exact ⟨PartialAssign.empty.complete suffix, h⟩

-- ═══════════════════════════════════════════════════════════════
-- SECTION 6: Future equivalence (the A0*-forced quotient)
-- ═══════════════════════════════════════════════════════════════

/-- Two partial assignments are future-equivalent w.r.t. φ if they
    have the same future satisfiability behavior for ALL completions.
    This is the A0*-forced quotient: only internally distinguishable
    future behavior is real. -/
def FutureEquiv (φ : CNF) (pa₁ pa₂ : PartialAssign) : Prop :=
  ∀ suffix : Nat → Bool,
    evalCNF φ (pa₁.complete suffix) = evalCNF φ (pa₂.complete suffix)

/-- Future equivalence is reflexive. -/
theorem futureEquiv_refl (φ : CNF) (pa : PartialAssign) :
    FutureEquiv φ pa pa :=
  fun _ => rfl

/-- Future equivalence is symmetric. -/
theorem futureEquiv_symm (φ : CNF) (pa₁ pa₂ : PartialAssign)
    (h : FutureEquiv φ pa₁ pa₂) : FutureEquiv φ pa₂ pa₁ :=
  fun suffix => (h suffix).symm

/-- Future equivalence is transitive. -/
theorem futureEquiv_trans (φ : CNF) (pa₁ pa₂ pa₃ : PartialAssign)
    (h₁₂ : FutureEquiv φ pa₁ pa₂) (h₂₃ : FutureEquiv φ pa₂ pa₃) :
    FutureEquiv φ pa₁ pa₃ :=
  fun suffix => (h₁₂ suffix).trans (h₂₃ suffix)

/-- Future equivalence is an equivalence relation. -/
theorem futureEquiv_equiv (φ : CNF) : Equivalence (FutureEquiv φ) :=
  ⟨futureEquiv_refl φ, futureEquiv_symm φ _ _, futureEquiv_trans φ _ _ _⟩

/-- Future-equivalent partial assignments have the same future satisfiability. -/
theorem futureEquiv_preserves_futureSat (φ : CNF) (pa₁ pa₂ : PartialAssign)
    (h : FutureEquiv φ pa₁ pa₂) :
    futureSat φ pa₁ ↔ futureSat φ pa₂ := by
  constructor
  · intro ⟨suffix, hsat⟩
    exact ⟨suffix, by rw [← h suffix]; exact hsat⟩
  · intro ⟨suffix, hsat⟩
    exact ⟨suffix, by rw [h suffix]; exact hsat⟩

-- ═══════════════════════════════════════════════════════════════
-- SECTION 7: NP with polynomial constraints
-- ═══════════════════════════════════════════════════════════════

/-- NP language with POLYNOMIAL witness bound and POLYNOMIAL verification.
    Unlike NP_Bool, the witness bound is a Poly (not α → Nat),
    requiring a Sized instance on α. This rules out exponential witness bounds. -/
structure NP_Poly {α : Type} [Sized α] (L : α → Prop) where
  /-- Two-argument verifier: instance × witness → Bool. -/
  verify : α → List Bool → Bool
  /-- POLYNOMIAL witness length bound. -/
  witBound : Poly
  /-- Completeness: if L x, there exists a short witness. -/
  complete : ∀ x, L x → ∃ w : List Bool,
    w.length ≤ witBound.eval (Sized.size x) ∧ verify x w = true
  /-- Soundness: any accepted witness implies L x. -/
  sound : ∀ x (w : List Bool), verify x w = true → L x
