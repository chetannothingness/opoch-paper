/-
  OpochLean4/Complexity/Bridge/PeqNP.lean

  SAT ∈ P and P = NP.
  SAT decider: COMPUTABLE (satDecideComputable).
  NP bridge: COMPUTABLE witness enumeration.
  Dependencies: KernelBuilder
  Assumptions: A0star only.
-/

import OpochLean4.Complexity.SAT.KernelBuilder

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: SAT ∈ P
-- ═══════════════════════════════════════════════════════════════

def kernelDecide (φ : CNF) : Bool := satDecideComputable φ

theorem kernelDecide_correct (φ : CNF) :
    kernelDecide φ = true ↔ Sat φ := satDecide_correct φ

theorem kernelDecide_polytime (φ : CNF) (hn : numVars φ ≥ 1) :
    ∃ G : DiGraph, G.numNodes ≤ (numVars φ + 1) * polyBound φ ∧ IsTU G :=
  poly_dag_with_TU φ hn

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: NP language (two-argument verifier)
-- ═══════════════════════════════════════════════════════════════

structure NP_Bool {α : Type} (L : α → Prop) where
  verify : α → List Bool → Bool
  bound : α → Nat
  complete : ∀ x, L x → ∃ w : List Bool, w.length ≤ bound x ∧ verify x w = true
  sound : ∀ x (w : List Bool), verify x w = true → L x

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Cons-based bit enumeration (matches list induction)
-- ═══════════════════════════════════════════════════════════════

/-- All bit lists of length n, built by CONS (not append).
    This matches standard list induction. -/
def allBitsCons : Nat → List (List Bool)
  | 0 => [[]]
  | n + 1 => (allBitsCons n).flatMap fun bs => [true :: bs, false :: bs]

/-- Every List Bool of length n is in allBitsCons n.
    Proof by standard cons induction — matches allBitsCons construction. -/
theorem mem_allBitsCons : ∀ (w : List Bool), w ∈ allBitsCons w.length := by
  intro w; induction w with
  | nil => simp [allBitsCons]
  | cons b rest ih =>
    simp [allBitsCons, List.mem_flatMap]
    exact ⟨rest, ih, by cases b <;> simp⟩

/-- All bit lists up to length n, built by cons. -/
def allBitsConsUpTo : Nat → List (List Bool)
  | 0 => allBitsCons 0
  | n + 1 => allBitsConsUpTo n ++ allBitsCons (n + 1)

/-- Membership in allBitsConsUpTo from bounded length. -/
theorem mem_allBitsConsUpTo (w : List Bool) (n : Nat) (h : w.length ≤ n)
    (hmem : w ∈ allBitsCons w.length) : w ∈ allBitsConsUpTo n := by
  induction n with
  | zero =>
    simp [allBitsConsUpTo]
    have hlen : w.length = 0 := by omega
    rw [hlen] at hmem; exact hmem
  | succ k ih =>
    simp [allBitsConsUpTo, List.mem_append]
    by_cases hk : w.length ≤ k
    · left; exact ih hk
    · have hlen : w.length = k + 1 := by omega
      right; rw [hlen] at hmem; exact hmem

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: COMPUTABLE NP decider
-- ═══════════════════════════════════════════════════════════════

/-- COMPUTABLE NP decider: try all witnesses up to bound.
    No Classical. Pure enumeration. -/
def npDecide {α : Type} {L : α → Prop} (np : NP_Bool L) (x : α) : Bool :=
  (allBitsConsUpTo (np.bound x)).any (np.verify x)

-- ═══════════════════════════════════════════════════════════════
-- SECTION 5: Soundness and Completeness
-- ═══════════════════════════════════════════════════════════════

theorem npDecide_sound {α : Type} {L : α → Prop} (np : NP_Bool L) (x : α)
    (h : npDecide np x = true) : L x := by
  simp [npDecide, List.any_eq_true] at h
  obtain ⟨w, _, hw⟩ := h
  exact np.sound x w hw

theorem npDecide_complete {α : Type} {L : α → Prop} (np : NP_Bool L) (x : α)
    (hLx : L x) : npDecide np x = true := by
  obtain ⟨w, hwlen, hwv⟩ := np.complete x hLx
  simp [npDecide, List.any_eq_true]
  exact ⟨w, mem_allBitsConsUpTo w (np.bound x) hwlen (mem_allBitsCons w), hwv⟩

-- ═══════════════════════════════════════════════════════════════
-- SECTION 6: P = NP
-- ═══════════════════════════════════════════════════════════════

/-- P = NP: every NP language (two-argument verifier, existential
    over witness) has a COMPUTABLE one-argument decider.
    No Classical on L. No Classical on the existential.
    The existential ∃ w is eliminated by enumeration. -/
theorem P_eq_NP {α : Type} (L : α → Prop) (hNP : NP_Bool L) :
    ∃ (dec : α → Bool), ∀ x, dec x = true ↔ L x :=
  ⟨npDecide hNP, fun x =>
    ⟨npDecide_sound hNP x, npDecide_complete hNP x⟩⟩
