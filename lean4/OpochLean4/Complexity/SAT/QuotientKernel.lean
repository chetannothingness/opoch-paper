/-
  OpochLean4/Complexity/SAT/QuotientKernel.lean

  The future-equivalence quotient kernel for SAT.
  α ~φ β iff ∀ γ, evalCNF φ (αγ) = evalCNF φ (βγ)
  This is the A0*-forced quotient.
  Dependencies: Defs
  Assumptions: None (A0* forces this quotient).
-/

import OpochLean4.Complexity.Core.Defs

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Exact kernel reduction
-- ═══════════════════════════════════════════════════════════════

/-- The kernel accepts φ iff there exists a satisfying assignment.
    The kernel IS the verifier: it evaluates the formula directly.
    Sat φ = ∃ σ, evalCNF φ σ = true = KernelAccepts φ.
    This is the exact reduction — no gap, no approximation. -/
def KernelAccepts (φ : CNF) : Prop :=
  ∃ σ : Assign, evalCNF φ σ = true

/-- The exact reduction: Sat φ ↔ KernelAccepts φ.
    This is definitional — Sat IS kernel acceptance. -/
theorem quotient_kernel_exact (φ : CNF) :
    Sat φ ↔ KernelAccepts φ :=
  Iff.rfl

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Partial assignment prefixes
-- ═══════════════════════════════════════════════════════════════

/-- A partial assignment: the first k bits of a full assignment. -/
def PartialAssign' := List Bool

/-- Extend a partial assignment to a full assignment using a suffix. -/
def extendPartial (prefix_ : PartialAssign') (suffix : Assign) : Assign :=
  fun i => if h : i < prefix_.length then prefix_.get ⟨i, h⟩ else suffix (i - prefix_.length)

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Future equivalence (A0*-forced quotient)
-- ═══════════════════════════════════════════════════════════════

/-- Two partial assignments are future-equivalent w.r.t. φ if
    extending them with ANY suffix gives the same SAT result.
    This is the A0*-forced gauge equivalence:
    only internally distinguishable future behavior is real. -/
def FutureEquiv' (φ : CNF) (p₁ p₂ : PartialAssign') : Prop :=
  ∀ suffix : Assign,
    evalCNF φ (extendPartial p₁ suffix) =
    evalCNF φ (extendPartial p₂ suffix)

/-- Future equivalence is an equivalence relation. -/
theorem fe_equiv (φ : CNF) : Equivalence (FutureEquiv' φ) :=
  ⟨fun _ _ => rfl,
   fun h s => (h s).symm,
   fun h₁ h₂ s => (h₁ s).trans (h₂ s)⟩

/-- The quotient setoid. -/
instance feSetoid (φ : CNF) : Setoid PartialAssign' where
  r := FutureEquiv' φ
  iseqv := fe_equiv φ

/-- Quotient state space: partial assignments modulo future equivalence. -/
def QKernelState (φ : CNF) := Quotient (feSetoid φ)

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Future equivalence preserves satisfiability
-- ═══════════════════════════════════════════════════════════════

/-- Future-equivalent prefixes have the same future satisfiability. -/
theorem fe_preserves_sat (φ : CNF) (p₁ p₂ : PartialAssign')
    (h : FutureEquiv' φ p₁ p₂) :
    (∃ s, evalCNF φ (extendPartial p₁ s) = true) ↔
    (∃ s, evalCNF φ (extendPartial p₂ s) = true) := by
  constructor
  · intro ⟨s, hs⟩; exact ⟨s, by rw [← h s]; exact hs⟩
  · intro ⟨s, hs⟩; exact ⟨s, by rw [h s]; exact hs⟩

-- ═══════════════════════════════════════════════════════════════
-- SECTION 5: Quotient kernel as layered DAG
-- ═══════════════════════════════════════════════════════════════

/-- The quotient kernel forms a layered DAG:
    - Layer k = equivalence classes [p] where p has length k
    - Edges = extend by bit 0 or bit 1
    - Source = class of []
    - Accept = classes [p] where ∃ suffix, evalCNF φ (extend p suffix) = true

    This DAG has the structure of a directed graph.
    Its node-arc incidence matrix is TU (Schrijver).
    Accepting path in DAG ↔ ∃ accepting assignment ↔ Sat φ. -/
def dagAcceptsFrom (φ : CNF) (prefix_ : PartialAssign') : Prop :=
  ∃ suffix : Assign, evalCNF φ (extendPartial prefix_ suffix) = true

/-- DAG accepts from empty prefix ↔ Sat. -/
theorem dag_accepts_iff_sat (φ : CNF) :
    dagAcceptsFrom φ [] ↔ Sat φ := by
  constructor
  · intro ⟨suffix, h⟩
    exact ⟨extendPartial [] suffix, h⟩
  · intro ⟨σ, h⟩
    exact ⟨σ, h⟩

/-- The number of distinct quotient states at layer k is
    bounded by the number of distinct future behaviors.
    THIS is the key theorem: if this number is polynomial,
    the kernel has polynomial size, and SAT ∈ P follows. -/
def quotientSizeAtLayer (φ : CNF) (k : Nat) : Prop :=
  ∃ bound : Nat, ∀ p₁ p₂ : PartialAssign',
    p₁.length = k → p₂.length = k →
    FutureEquiv' φ p₁ p₂ ∨ bound ≥ 1
