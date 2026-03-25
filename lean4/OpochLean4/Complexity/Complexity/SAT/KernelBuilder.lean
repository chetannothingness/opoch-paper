/-
  OpochLean4/Complexity/SAT/KernelBuilder.lean

  COMPUTABLE SAT decision. Pure computation, zero gaps.
  Dependencies: LPSolver, KernelSize
  Assumptions: None.
-/

import OpochLean4.Complexity.SAT.LPSolver
import OpochLean4.Complexity.SAT.KernelSize

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: List helpers
-- ═══════════════════════════════════════════════════════════════

private theorem list_any_congr {α : Type} (l : List α) (f g : α → Bool)
    (h : ∀ x ∈ l, f x = g x) : l.any f = l.any g := by
  induction l with
  | nil => simp
  | cons hd tl ih =>
    simp [List.any_cons]
    rw [h hd (List.mem_cons_self _ _),
        ih (fun x hx => h x (List.mem_cons_of_mem _ hx))]

private theorem list_all_congr {α : Type} (l : List α) (f g : α → Bool)
    (h : ∀ x ∈ l, f x = g x) : l.all f = l.all g := by
  induction l with
  | nil => simp
  | cons hd tl ih =>
    simp [List.all_cons]
    rw [h hd (List.mem_cons_self _ _),
        ih (fun x hx => h x (List.mem_cons_of_mem _ hx))]

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Variable independence of evalCNF
-- ═══════════════════════════════════════════════════════════════

theorem evalLit_agree (l : Literal) (σ₁ σ₂ : Assign)
    (h : σ₁ l.var = σ₂ l.var) : evalLit l σ₁ = evalLit l σ₂ := by
  simp [evalLit, h]

theorem evalClause_agree (c : Clause) (σ₁ σ₂ : Assign)
    (h : ∀ l ∈ c, σ₁ l.var = σ₂ l.var) :
    evalClause c σ₁ = evalClause c σ₂ :=
  list_any_congr c _ _ (fun l hl => evalLit_agree l σ₁ σ₂ (h l hl))

theorem evalCNF_agree (φ : CNF) (σ₁ σ₂ : Assign)
    (h : ∀ c ∈ φ, ∀ l ∈ c, σ₁ l.var = σ₂ l.var) :
    evalCNF φ σ₁ = evalCNF φ σ₂ :=
  list_all_congr φ _ _ (fun c hc => evalClause_agree c σ₁ σ₂ (h c hc))

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Variable bound
-- ═══════════════════════════════════════════════════════════════

private def listMax : List Nat → Nat
  | [] => 0
  | hd :: tl => max hd (listMax tl)

private theorem listMax_ge (l : List Nat) (x : Nat) (h : x ∈ l) :
    listMax l ≥ x := by
  induction l with
  | nil => exact absurd h (List.not_mem_nil _)
  | cons hd tl ih =>
    cases h with
    | head => simp [listMax]; omega
    | tail _ htl => simp [listMax]; have := ih htl; omega

def varBound (φ : CNF) : Nat :=
  listMax ((φ.bind id).map (·.var)) + 1

theorem var_lt_varBound (φ : CNF) (c : Clause) (hc : c ∈ φ)
    (l : Literal) (hl : l ∈ c) : l.var < varBound φ := by
  have : l.var ∈ (φ.bind id).map (·.var) :=
    List.mem_map_of_mem _ (List.mem_bind.mpr ⟨c, hc, hl⟩)
  have hge := listMax_ge _ _ this; simp only [varBound]; omega

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Bits ↔ assignment (using getD to avoid Fin issues)
-- ═══════════════════════════════════════════════════════════════

/-- Convert bits to assignment using getD (no Fin, no dependent types). -/
def bitsToAssign (bits : List Bool) : Assign :=
  fun i => bits.getD i false

def checkSat (φ : CNF) (bits : List Bool) : Bool :=
  evalCNF φ (bitsToAssign bits)

/-- Build bit list from assignment. -/
def assignToBits (σ : Assign) : Nat → List Bool
  | 0 => []
  | n + 1 => assignToBits σ n ++ [σ n]

theorem assignToBits_length (σ : Assign) : ∀ n,
    (assignToBits σ n).length = n := by
  intro n; induction n with
  | zero => simp [assignToBits]
  | succ k ih => simp [assignToBits, ih]

/-- getD on append: if i < prefix length, get from prefix. -/
private theorem getD_append_left {α : Type} (l₁ l₂ : List α) (i : Nat) (d : α)
    (h : i < l₁.length) : (l₁ ++ l₂).getD i d = l₁.getD i d := by
  simp only [List.getD]
  rw [List.get?_append (h)]

private theorem getD_append_at {α : Type} (l₁ : List α) (x : α) (d : α) :
    (l₁ ++ [x]).getD l₁.length d = x := by
  simp only [List.getD]
  rw [List.get?_append_right (by omega)]
  simp

/-- Key lemma: bitsToAssign (assignToBits σ n) agrees with σ on i < n. -/
theorem bitsToAssign_agree (σ : Assign) : ∀ (n i : Nat), i < n →
    bitsToAssign (assignToBits σ n) i = σ i := by
  intro n; induction n with
  | zero => intro i hi; omega
  | succ k ih =>
    intro i hi
    simp only [bitsToAssign, assignToBits]
    by_cases hik : i < k
    · -- i < k: element is in the prefix assignToBits σ k
      rw [getD_append_left _ _ _ _ (by rw [assignToBits_length]; exact hik)]
      exact ih i hik
    · -- i = k
      have hieq : i = k := by omega
      subst hieq
      -- Goal: (assignToBits σ i ++ [σ i]).getD i false = σ i
      -- assignToBits σ i has length i
      have hlen := assignToBits_length σ i
      -- getD on (prefix ++ [x]) at index prefix.length gives x
      show (assignToBits σ i ++ [σ i]).getD i false = σ i
      have : (assignToBits σ i ++ [σ i]).get? i = some (σ i) := by
        rw [List.get?_append_right (by omega)]
        simp [hlen]
      -- getD at index = length of prefix gives the appended element
      change (assignToBits σ i ++ [σ i]).getD i false = σ i
      -- Prove directly: get? at index = prefix.length in (prefix ++ [x]) = some x
      have hget : (assignToBits σ i ++ [σ i]).get? i = some (σ i) := by
        rw [List.get?_append_right (by omega)]
        simp [hlen]
      -- getD with some = the value
      show ((assignToBits σ i ++ [σ i]).get? i).getD false = σ i
      rw [hget]; rfl

-- ═══════════════════════════════════════════════════════════════
-- SECTION 5: Exhaustive enumeration
-- ═══════════════════════════════════════════════════════════════

def allBits : Nat → List (List Bool)
  | 0 => [[]]
  | n + 1 => (allBits n).bind fun bs => [bs ++ [true], bs ++ [false]]

theorem assignToBits_mem (σ : Assign) : ∀ n,
    assignToBits σ n ∈ allBits n := by
  intro n; induction n with
  | zero => simp [assignToBits, allBits]
  | succ k ih =>
    simp [allBits, List.mem_bind]
    refine ⟨assignToBits σ k, ih, ?_⟩
    simp only [assignToBits]; cases σ k <;> simp

def satDecideComputable (φ : CNF) : Bool :=
  (allBits (varBound φ)).any (checkSat φ)

-- ═══════════════════════════════════════════════════════════════
-- SECTION 6: Soundness and Completeness — ZERO SORRY
-- ═══════════════════════════════════════════════════════════════

theorem satDecide_sound (φ : CNF) (h : satDecideComputable φ = true) :
    Sat φ := by
  simp [satDecideComputable, List.any_eq_true] at h
  obtain ⟨bits, _, hcheck⟩ := h
  exact ⟨bitsToAssign bits, hcheck⟩

theorem satDecide_complete (φ : CNF) (h : Sat φ) :
    satDecideComputable φ = true := by
  obtain ⟨σ, hsat⟩ := h
  simp [satDecideComputable, List.any_eq_true]
  refine ⟨assignToBits σ (varBound φ), assignToBits_mem σ _, ?_⟩
  simp only [checkSat]
  rw [evalCNF_agree φ _ σ (fun c hc l hl =>
    bitsToAssign_agree σ (varBound φ) l.var (var_lt_varBound φ c hc l hl))]
  exact hsat

/-- The SAT decider is correct. Pure computation, zero gaps. -/
theorem satDecide_correct (φ : CNF) :
    satDecideComputable φ = true ↔ Sat φ :=
  ⟨satDecide_sound φ, satDecide_complete φ⟩
