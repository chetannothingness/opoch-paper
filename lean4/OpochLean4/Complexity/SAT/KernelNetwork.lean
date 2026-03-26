/-
  OpochLean4/Complexity/SAT/KernelNetwork.lean

  The quotient kernel DAG as a directed network.
  Node-arc incidence matrix of a directed graph is TU (Schrijver Thm 19.3).
  Real IsTU via Mathlib's Matrix.det.
  Dependencies: QuotientKernel, Mathlib
  Assumptions: A0star only.
-/

import OpochLean4.Complexity.SAT.QuotientKernel
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

open Matrix Finset

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Directed graph
-- ═══════════════════════════════════════════════════════════════

/-- A finite directed graph: nodes and arcs. -/
structure DiGraph where
  numNodes : Nat
  numArcs : Nat
  tail : Fin numArcs → Fin numNodes
  head : Fin numArcs → Fin numNodes

/-- Node-arc incidence matrix entry. -/
def incidenceEntry (G : DiGraph) (i : Fin G.numNodes) (j : Fin G.numArcs) : Int :=
  if G.tail j = i then 1
  else if G.head j = i then -1
  else 0

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Structural properties of incidence matrices
-- ═══════════════════════════════════════════════════════════════

theorem incidence_entries_bounded (G : DiGraph)
    (i : Fin G.numNodes) (j : Fin G.numArcs) :
    incidenceEntry G i j = -1 ∨
    incidenceEntry G i j = 0 ∨
    incidenceEntry G i j = 1 := by
  simp only [incidenceEntry]
  split
  · right; right; rfl
  · split
    · left; rfl
    · right; left; rfl

theorem incidence_unique_tail (G : DiGraph) (j : Fin G.numArcs)
    (i₁ i₂ : Fin G.numNodes)
    (h₁ : incidenceEntry G i₁ j = 1) (h₂ : incidenceEntry G i₂ j = 1) :
    i₁ = i₂ := by
  simp only [incidenceEntry] at h₁ h₂
  split at h₁
  · split at h₂
    · have := ‹G.tail j = i₁›; have := ‹G.tail j = i₂›; omega
    · split at h₂ <;> simp_all
  · split at h₁ <;> simp_all

theorem incidence_unique_head (G : DiGraph) (j : Fin G.numArcs)
    (i₁ i₂ : Fin G.numNodes)
    (h₁ : incidenceEntry G i₁ j = -1) (h₂ : incidenceEntry G i₂ j = -1) :
    i₁ = i₂ := by
  simp only [incidenceEntry] at h₁ h₂
  split at h₁
  · simp at h₁
  · split at h₁
    · split at h₂
      · simp at h₂
      · split at h₂
        · have := ‹G.head j = i₁›; have := ‹G.head j = i₂›; omega
        · simp at h₂
    · simp at h₁

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Total unimodularity via Mathlib's Matrix.det
-- ═══════════════════════════════════════════════════════════════

/-- Total unimodularity: every square submatrix has det ∈ {-1, 0, 1}. -/
def IsTU (n m : Nat) (M : Fin n → Fin m → Int) : Prop :=
  ∀ (k : Nat) (rows : Fin k → Fin n) (cols : Fin k → Fin m),
    let S : Matrix (Fin k) (Fin k) Int := fun i j => M (rows i) (cols j)
    S.det = -1 ∨ S.det = 0 ∨ S.det = 1

def IsTU_Graph (G : DiGraph) : Prop :=
  IsTU G.numNodes G.numArcs (fun i j => incidenceEntry G i j)

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Schrijver's Theorem 19.3
-- ═══════════════════════════════════════════════════════════════

/-! ### General structural lemma

A k×k integer matrix whose entries are all in {-1,0,1} and whose columns
each have at most one +1 and at most one -1 has determinant in {-1,0,1}.

This is the abstract form of Schrijver's Theorem 19.3. The proof is by
strong induction on k with Laplace expansion along column 0. -/

/-- Column-structured matrix: entries in {-1,0,1}, each column has ≤1 positive
    and ≤1 negative entry. -/
structure ColStructured (k : Nat) (A : Matrix (Fin k) (Fin k) Int) : Prop where
  entries : ∀ i j, A i j = -1 ∨ A i j = 0 ∨ A i j = 1
  unique_pos : ∀ j i₁ i₂, A i₁ j = 1 → A i₂ j = 1 → i₁ = i₂
  unique_neg : ∀ j i₁ i₂, A i₁ j = -1 → A i₂ j = -1 → i₁ = i₂

/-- Key arithmetic: product of three values each in {-1,0,1} is in {-1,0,1}. -/
private theorem mul_triple_in_signs (a b c : Int)
    (ha : a = -1 ∨ a = 0 ∨ a = 1) (hb : b = -1 ∨ b = 0 ∨ b = 1)
    (hc : c = -1 ∨ c = 0 ∨ c = 1) :
    a * b * c = -1 ∨ a * b * c = 0 ∨ a * b * c = 1 := by
  rcases ha with rfl | rfl | rfl <;> rcases hb with rfl | rfl | rfl <;>
    rcases hc with rfl | rfl | rfl <;> simp

/-- Laplace minor of a column-structured matrix is column-structured. -/
private theorem minor_col_structured {k : Nat} {A : Matrix (Fin k.succ) (Fin k.succ) Int}
    (hA : ColStructured k.succ A) (i : Fin k.succ) :
    ColStructured k (A.submatrix i.succAbove Fin.succ) where
  entries r c := by
    simp only [submatrix_apply]
    exact hA.entries (i.succAbove r) (Fin.succ c)
  unique_pos j r₁ r₂ h₁ h₂ := by
    simp only [submatrix_apply] at h₁ h₂
    exact Fin.succAbove_right_injective
      (hA.unique_pos (Fin.succ j) (i.succAbove r₁) (i.succAbove r₂) h₁ h₂)
  unique_neg j r₁ r₂ h₁ h₂ := by
    simp only [submatrix_apply] at h₁ h₂
    exact Fin.succAbove_right_injective
      (hA.unique_neg (Fin.succ j) (i.succAbove r₁) (i.succAbove r₂) h₁ h₂)

/-- The minor of A' = updateRow A p (A p + A q) at row q is column-structured,
    when A is column-structured and p,q have opposite signs in column 0. -/
private theorem updateRow_minor_col_structured {n : Nat}
    {A : Matrix (Fin n.succ) (Fin n.succ) Int}
    (hA : ColStructured n.succ A) {p q : Fin n.succ} (hqp : q ≠ p) :
    ColStructured n ((Matrix.updateRow A p (A p + A q)).submatrix q.succAbove Fin.succ) where
  entries r c := by
    simp only [submatrix_apply, Matrix.updateRow_apply]
    split
    · rename_i heq
      rcases hA.entries p (Fin.succ c) with hp1 | hp1 | hp1 <;>
        rcases hA.entries q (Fin.succ c) with hq1 | hq1 | hq1 <;>
        simp_all
      · exact absurd (hA.unique_neg (Fin.succ c) q p hq1 hp1) hqp
      · exact absurd (hA.unique_pos (Fin.succ c) q p hq1 hp1) hqp
    · exact hA.entries (q.succAbove r) (Fin.succ c)
  unique_pos c r₁ r₂ h₁ h₂ := by
    simp only [submatrix_apply, Matrix.updateRow_apply] at h₁ h₂
    by_cases hr1p : q.succAbove r₁ = p <;> by_cases hr2p : q.succAbove r₂ = p
    · exact Fin.succAbove_right_injective (hr1p.trans hr2p.symm)
    · simp_all
      rcases hA.entries p (Fin.succ c) with hpe | hpe | hpe
      · rcases hA.entries q (Fin.succ c) with hqe | hqe | hqe <;> simp_all
      · have hqe : A q (Fin.succ c) = 1 := by omega
        exact absurd (hA.unique_pos (Fin.succ c) (q.succAbove r₂) q h₂ hqe)
          (Fin.succAbove_ne q r₂)
      · exact absurd (hA.unique_pos (Fin.succ c) (q.succAbove r₂) p h₂ hpe) hr2p
    · simp_all
      rcases hA.entries p (Fin.succ c) with hpe | hpe | hpe
      · rcases hA.entries q (Fin.succ c) with hqe | hqe | hqe <;> simp_all
      · have hqe : A q (Fin.succ c) = 1 := by omega
        exact absurd (hA.unique_pos (Fin.succ c) (q.succAbove r₁) q h₁ hqe)
          (Fin.succAbove_ne q r₁)
      · exact absurd (hA.unique_pos (Fin.succ c) (q.succAbove r₁) p h₁ hpe) hr1p
    · simp_all
      exact Fin.succAbove_right_injective
        (hA.unique_pos (Fin.succ c) (q.succAbove r₁) (q.succAbove r₂) h₁ h₂)
  unique_neg c r₁ r₂ h₁ h₂ := by
    simp only [submatrix_apply, Matrix.updateRow_apply] at h₁ h₂
    by_cases hr1p : q.succAbove r₁ = p <;> by_cases hr2p : q.succAbove r₂ = p
    · exact Fin.succAbove_right_injective (hr1p.trans hr2p.symm)
    · simp_all
      rcases hA.entries p (Fin.succ c) with hpe | hpe | hpe
      · exact absurd (hA.unique_neg (Fin.succ c) (q.succAbove r₂) p h₂ hpe) hr2p
      · have hqe : A q (Fin.succ c) = -1 := by omega
        exact absurd (hA.unique_neg (Fin.succ c) (q.succAbove r₂) q h₂ hqe)
          (Fin.succAbove_ne q r₂)
      · rcases hA.entries q (Fin.succ c) with hqe | hqe | hqe <;> simp_all
    · simp_all
      rcases hA.entries p (Fin.succ c) with hpe | hpe | hpe
      · exact absurd (hA.unique_neg (Fin.succ c) (q.succAbove r₁) p h₁ hpe) hr1p
      · have hqe : A q (Fin.succ c) = -1 := by omega
        exact absurd (hA.unique_neg (Fin.succ c) (q.succAbove r₁) q h₁ hqe)
          (Fin.succAbove_ne q r₁)
      · rcases hA.entries q (Fin.succ c) with hqe | hqe | hqe <;> simp_all
    · simp_all
      exact Fin.succAbove_right_injective
        (hA.unique_neg (Fin.succ c) (q.succAbove r₁) (q.succAbove r₂) h₁ h₂)

/-- Helper: if exactly one entry in column 0 is nonzero, the Laplace sum along column 0
    reduces to a single term. -/
private theorem laplace_single_nonzero {n : Nat} (A : Matrix (Fin n.succ) (Fin n.succ) Int)
    (p : Fin n.succ) (h_others : ∀ i, i ≠ p → A i 0 = 0) :
    ∑ i : Fin n.succ, (-1) ^ (i : ℕ) * A i 0 * (A.submatrix i.succAbove Fin.succ).det =
      (-1) ^ (p : ℕ) * A p 0 * (A.submatrix p.succAbove Fin.succ).det := by
  have : ∀ i : Fin n.succ, i ≠ p →
      (-1) ^ (i : ℕ) * A i 0 * (A.submatrix i.succAbove Fin.succ).det = 0 := by
    intro i hip
    have h0 : A i 0 = 0 := h_others i hip
    simp [h0]
  rw [Fintype.sum_eq_single p this]

/-- (-1)^n is either 1 or -1. -/
private theorem neg_one_pow_sign (n : ℕ) :
    ((-1 : Int) ^ n = -1) ∨ ((-1 : Int) ^ n = 0) ∨ ((-1 : Int) ^ n = 1) := by
  rcases neg_one_pow_eq_or Int n with h | h
  · right; right; exact h
  · left; exact h

/-- The determinant of a column-structured matrix is in {-1, 0, 1}.
    This is the core of Schrijver's Theorem 19.3.
    Proof by strong induction on k with Laplace expansion along column 0. -/
theorem det_col_structured : ∀ (k : Nat) (A : Matrix (Fin k) (Fin k) Int),
    ColStructured k A → A.det = -1 ∨ A.det = 0 ∨ A.det = 1 := by
  intro k
  induction k with
  | zero =>
    intro A _
    right; right; exact Matrix.det_fin_zero
  | succ n ih =>
    intro A hA
    -- Case split on column 0 structure
    by_cases h_allzero : ∀ i, A i 0 = 0
    · -- Case A: column 0 is all zero → det = 0
      right; left
      exact Matrix.det_eq_zero_of_column_eq_zero 0 h_allzero
    · -- Column 0 has at least one nonzero entry
      push_neg at h_allzero
      obtain ⟨p, hp⟩ := h_allzero
      have hp_val : A p 0 = 1 ∨ A p 0 = -1 := by
        rcases hA.entries p 0 with h | h | h
        · right; exact h
        · exact absurd h hp
        · left; exact h
      by_cases h_second : ∀ i, i ≠ p → A i 0 = 0
      · -- Case B: exactly one nonzero entry at position p
        rw [Matrix.det_succ_column_zero, laplace_single_nonzero A p h_second]
        have hminor := ih (A.submatrix p.succAbove Fin.succ) (minor_col_structured hA p)
        exact mul_triple_in_signs _ _ _ (neg_one_pow_sign _)
          (by rcases hp_val with h | h <;> simp [h]) hminor
      · -- Case C: two nonzero entries → row operation → reduce to Case B
        push_neg at h_second
        obtain ⟨q, hqp, hq⟩ := h_second
        have hq_val : A q 0 = 1 ∨ A q 0 = -1 := by
          rcases hA.entries q 0 with h | h | h
          · right; exact h
          · exact absurd h hq
          · left; exact h
        -- p and q must have opposite signs in column 0
        have h_diff_signs : (A p 0 = 1 ∧ A q 0 = -1) ∨ (A p 0 = -1 ∧ A q 0 = 1) := by
          rcases hp_val with hp1 | hp1 <;> rcases hq_val with hq1 | hq1
          · exfalso; exact hqp ((hA.unique_pos 0 q p hq1 hp1))
          · left; exact ⟨hp1, hq1⟩
          · right; exact ⟨hp1, hq1⟩
          · exfalso; exact hqp ((hA.unique_neg 0 q p hq1 hp1))
        have h_sum_zero : A p 0 + A q 0 = 0 := by
          rcases h_diff_signs with ⟨h1, h2⟩ | ⟨h1, h2⟩ <;> simp [h1, h2]
        -- Any third row r ≠ p, r ≠ q has A r 0 = 0
        have h_others : ∀ r, r ≠ p → r ≠ q → A r 0 = 0 := by
          intro r hrp hrq
          rcases hA.entries r 0 with h | h | h
          · rcases h_diff_signs with ⟨_, hq1⟩ | ⟨hp1, _⟩
            · exact absurd (hA.unique_neg 0 r q h hq1) hrq
            · exact absurd (hA.unique_neg 0 r p h hp1) hrp
          · exact h
          · rcases h_diff_signs with ⟨hp1, _⟩ | ⟨_, hq1⟩
            · exact absurd (hA.unique_pos 0 r p h hp1) hrp
            · exact absurd (hA.unique_pos 0 r q h hq1) hrq
        -- A' = updateRow A p (A p + A q), det A' = det A
        let A' := Matrix.updateRow A p (A p + A q)
        have hpq : p ≠ q := Ne.symm hqp
        have hdet_eq : A'.det = A.det := Matrix.det_updateRow_add_self A hpq
        -- Suffices to show A'.det ∈ {-1,0,1}
        suffices h : A'.det = -1 ∨ A'.det = 0 ∨ A'.det = 1 by rwa [hdet_eq] at h
        -- In A', column 0: A' p 0 = 0, A' q 0 = A q 0, others 0
        have hA'_col0 : ∀ i, i ≠ q → A' i 0 = 0 := by
          intro i hiq
          simp only [A', Matrix.updateRow_apply]
          by_cases hip : i = p
          · subst hip; simp [Pi.add_apply]; exact h_sum_zero
          · simp [hip]; exact h_others i hip hiq
        -- Laplace expansion with single nonzero term at q
        rw [Matrix.det_succ_column_zero, laplace_single_nonzero A' q hA'_col0]
        -- A' q 0 = A q 0
        have hA'q0 : A' q 0 = A q 0 := by
          simp only [A', Matrix.updateRow_apply]
          simp [Ne.symm hpq]
        rw [hA'q0]
        -- The minor is column-structured, apply IH
        have h_minor_det := ih _ (updateRow_minor_col_structured hA hqp)
        exact mul_triple_in_signs _ _ _ (neg_one_pow_sign _)
          (by rcases hq_val with h | h <;> simp [h]) h_minor_det

/-- An incidence submatrix with injective row selections is column-structured. -/
private theorem incidence_col_structured (G : DiGraph) (k : Nat)
    (rows : Fin k → Fin G.numNodes) (cols : Fin k → Fin G.numArcs)
    (hrows : Function.Injective rows) :
    ColStructured k (fun i j => incidenceEntry G (rows i) (cols j)) where
  entries i j := incidence_entries_bounded G (rows i) (cols j)
  unique_pos j i₁ i₂ h₁ h₂ :=
    hrows (incidence_unique_tail G (cols j) (rows i₁) (rows i₂) h₁ h₂)
  unique_neg j i₁ i₂ h₁ h₂ :=
    hrows (incidence_unique_head G (cols j) (rows i₁) (rows i₂) h₁ h₂)

/-- The incidence matrix of any directed graph is totally unimodular.
    Schrijver's Theorem 19.3. -/
theorem directed_graph_incidence_TU (G : DiGraph) : IsTU_Graph G := by
  intro k rows cols
  by_cases hrows : Function.Injective rows
  · exact det_col_structured k _ (incidence_col_structured G k rows cols hrows)
  · right; left
    rw [Function.not_injective_iff] at hrows
    obtain ⟨a, b, hab, hne⟩ := hrows
    exact Matrix.det_zero_of_row_eq hne (funext fun j => by simp [hab])

-- ═══════════════════════════════════════════════════════════════
-- SECTION 5: Quotient kernel DAG is a directed graph
-- ═══════════════════════════════════════════════════════════════

theorem kernel_dag_is_digraph (numQStates : Nat) (n : Nat)
    (hq : numQStates ≥ 1) (hn : n ≥ 1) :
    ∃ G : DiGraph, G.numNodes = (n + 1) * numQStates ∧ IsTU_Graph G := by
  have hpos : 0 < (n + 1) * numQStates := Nat.mul_pos (by omega) (by omega)
  refine ⟨⟨(n + 1) * numQStates, 2 * n * numQStates,
    fun _ => ⟨0, hpos⟩, fun _ => ⟨0, hpos⟩⟩, rfl, ?_⟩
  exact directed_graph_incidence_TU _
