/-
  OpochLean4/Algebra/ObservableOpens.lean (Step 7)

  Observable open sets on truth classes, and erasers.
  An observable open is a predicate on TruthClass induced by a witness:
  the set of truth classes where that witness separates.
  An eraser merges truth classes that a given witness cannot distinguish.

  Dependencies: TruthQuotient
  Assumptions: A0star only.
-/

import OpochLean4.Algebra.TruthQuotient

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Observable opens
-- ═══════════════════════════════════════════════════════════════

-- An observable open set on Distinction is the set of distinctions
-- where a given witness separates. It is induced by a specific witness.
def ObservableOpen (w : Witness) (δ : Distinction) : Prop :=
  Separates w δ

-- An observable open is quotient-invariant: if δ₁ ~ δ₂,
-- then w separates δ₁ iff w separates δ₂ (by definition of Indistinguishable)
theorem observableOpen_invariant (w : Witness) :
    QuotientInvariant (ObservableOpen w) := by
  intro δ₁ δ₂ hindist
  exact hindist w

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Erasers
-- ═══════════════════════════════════════════════════════════════

-- The eraser associated with a witness w:
-- Two distinctions are erased-equivalent under w if w cannot tell them apart.
-- That is, w separates both or neither.
def ErasedEquiv (w : Witness) (δ₁ δ₂ : Distinction) : Prop :=
  (Separates w δ₁ ↔ Separates w δ₂)

-- ErasedEquiv is reflexive
theorem erasedEquiv_refl (w : Witness) (δ : Distinction) :
    ErasedEquiv w δ δ :=
  Iff.rfl

-- ErasedEquiv is symmetric
theorem erasedEquiv_symm (w : Witness) (δ₁ δ₂ : Distinction)
    (h : ErasedEquiv w δ₁ δ₂) : ErasedEquiv w δ₂ δ₁ :=
  h.symm

-- ErasedEquiv is transitive
theorem erasedEquiv_trans (w : Witness) (δ₁ δ₂ δ₃ : Distinction)
    (h₁₂ : ErasedEquiv w δ₁ δ₂) (h₂₃ : ErasedEquiv w δ₂ δ₃) :
    ErasedEquiv w δ₁ δ₃ :=
  h₁₂.trans h₂₃

-- ErasedEquiv is an equivalence relation
theorem erasedEquiv_equivalence (w : Witness) :
    Equivalence (ErasedEquiv w) :=
  ⟨erasedEquiv_refl w, erasedEquiv_symm w _ _, erasedEquiv_trans w _ _ _⟩

-- An eraser is a function that maps distinctions to a canonical representative
-- of their erased-equivalence class. We model this as an idempotent function
-- that preserves ErasedEquiv.
structure Eraser where
  witness : Witness
  erase : Distinction → Distinction
  -- The eraser maps each distinction to something erased-equivalent
  erases : ∀ δ, ErasedEquiv witness δ (erase δ)
  -- The eraser is idempotent: erase ∘ erase = erase
  idempotent : ∀ δ, erase (erase δ) = erase δ

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Erasers are idempotent
-- ═══════════════════════════════════════════════════════════════

-- Erasers are idempotent (applying twice = applying once)
theorem eraser_idempotent (E : Eraser) (δ : Distinction) :
    E.erase (E.erase δ) = E.erase δ :=
  E.idempotent δ

-- Applying an eraser three times equals applying it once
theorem eraser_triple (E : Eraser) (δ : Distinction) :
    E.erase (E.erase (E.erase δ)) = E.erase δ := by
  rw [E.idempotent (E.erase δ), E.idempotent δ]

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Observable opens are closed under finite intersection
-- ═══════════════════════════════════════════════════════════════

-- The intersection of two observable opens: δ is in the intersection iff
-- both witnesses separate δ
def ObservableOpenInter (w₁ w₂ : Witness) (δ : Distinction) : Prop :=
  ObservableOpen w₁ δ ∧ ObservableOpen w₂ δ

-- The intersection is also quotient-invariant (closed under finite intersection)
theorem observableOpenInter_invariant (w₁ w₂ : Witness) :
    QuotientInvariant (ObservableOpenInter w₁ w₂) := by
  intro δ₁ δ₂ hindist
  constructor
  · intro ⟨h₁, h₂⟩
    exact ⟨(hindist w₁).mp h₁, (hindist w₂).mp h₂⟩
  · intro ⟨h₁, h₂⟩
    exact ⟨(hindist w₁).mpr h₁, (hindist w₂).mpr h₂⟩

-- Finite intersection of a list of observable opens
def ObservableOpenFiniteInter (ws : List Witness) (δ : Distinction) : Prop :=
  ∀ w, w ∈ ws → ObservableOpen w δ

-- Finite intersection is quotient-invariant
theorem observableOpenFiniteInter_invariant (ws : List Witness) :
    QuotientInvariant (ObservableOpenFiniteInter ws) := by
  intro δ₁ δ₂ hindist
  constructor
  · intro h w hw
    exact (hindist w).mp (h w hw)
  · intro h w hw
    exact (hindist w).mpr (h w hw)

-- Empty intersection is the full set
theorem observableOpenFiniteInter_nil (δ : Distinction) :
    ObservableOpenFiniteInter [] δ := by
  intro _ hm
  exact absurd hm (List.not_mem_nil _)

-- Cons extends intersection
theorem observableOpenFiniteInter_cons (w : Witness) (ws : List Witness) (δ : Distinction) :
    ObservableOpenFiniteInter (w :: ws) δ ↔
    ObservableOpen w δ ∧ ObservableOpenFiniteInter ws δ := by
  constructor
  · intro h
    exact ⟨h w (List.mem_cons_self w ws),
           fun w' hw' => h w' (List.mem_cons_of_mem w hw')⟩
  · intro ⟨hw, hws⟩ w' hw'
    cases hw' with
    | head => exact hw
    | tail _ hmem => exact hws w' hmem
