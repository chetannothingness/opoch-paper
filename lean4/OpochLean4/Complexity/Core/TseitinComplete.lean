import OpochLean4.Complexity.Core.Tseitin

/-
  Tseitin Completeness: g.eval σ = true → Sat(tseitin g)

  5 lemmas → main theorem. Zero sorry target.
  Dependencies: Tseitin
  New axioms: 0
-/

namespace Complexity

-- ════════════════════════════════════════════════════════════════
-- Variable update
-- ════════════════════════════════════════════════════════════════

def upd (σ : Nat → Bool) (v : Nat) (b : Bool) (i : Nat) : Bool :=
  if i = v then b else σ i

theorem upd_at (σ : Nat → Bool) (v : Nat) (b : Bool) : upd σ v b v = b := by simp [upd]
theorem upd_ne (σ : Nat → Bool) (v : Nat) (b : Bool) (i : Nat) (h : i ≠ v) : upd σ v b i = σ i := by simp [upd, h]

-- ════════════════════════════════════════════════════════════════
-- Lemma 0: nextVar monotonicity
-- ════════════════════════════════════════════════════════════════

theorem nv_mono (g : Gate) (s : TsState) :
    s.nextVar ≤ (tsEncode g s).2.nextVar := by
  induction g generalizing s with
  | input _ => exact Nat.le_refl _
  | const b => cases b <;> simp [tsEncode] <;> omega
  | not g ih => simp only [tsEncode]; have := ih s; omega
  | and g₁ g₂ ih₁ ih₂ => simp only [tsEncode]; have := ih₁ s; have := ih₂ (tsEncode g₁ s).2; omega
  | or g₁ g₂ ih₁ ih₂ => simp only [tsEncode]; have := ih₁ s; have := ih₂ (tsEncode g₁ s).2; omega

-- ════════════════════════════════════════════════════════════════
-- Lemma 1: output var bound (with maxVar precondition)
-- ════════════════════════════════════════════════════════════════

theorem outvar_bound (g : Gate) (s : TsState) (hmv : g.maxVar ≤ s.nextVar) :
    (tsEncode g s).1 < (tsEncode g s).2.nextVar := by
  induction g generalizing s with
  | input i => simp [tsEncode, Gate.maxVar] at *; omega
  | const b => cases b <;> simp [tsEncode] <;> omega
  | not g ih =>
    simp only [tsEncode, Gate.maxVar] at *; have := nv_mono g s; omega
  | and g₁ g₂ ih₁ ih₂ =>
    simp only [tsEncode, Gate.maxVar] at *
    have := nv_mono g₂ (tsEncode g₁ s).2; omega
  | or g₁ g₂ ih₁ ih₂ =>
    simp only [tsEncode, Gate.maxVar] at *
    have := nv_mono g₂ (tsEncode g₁ s).2; omega

-- ════════════════════════════════════════════════════════════════
-- Lemma 2: clause variable bound
-- ════════════════════════════════════════════════════════════════

def cvb (c : Clause) (n : Nat) : Prop := ∀ l ∈ c, l.var < n

theorem cvb_mono (c : Clause) (n m : Nat) (h : cvb c n) (hnm : n ≤ m) :
    cvb c m := fun l hl => Nat.lt_of_lt_of_le (h l hl) hnm

-- Check that specific clause types have bounded vars
private theorem cvb_posLit (v n : Nat) (h : v < n) : cvb [posLit v] n := by
  intro l hl; simp [List.mem_singleton] at hl; subst hl; simp [posLit]; exact h

private theorem cvb_negLit (v n : Nat) (h : v < n) : cvb [negLit v] n := by
  intro l hl; simp [List.mem_singleton] at hl; subst hl; simp [negLit]; exact h

private theorem cvb_notClauses (aux sub n : Nat) (ha : aux < n) (hs : sub < n) :
    ∀ c ∈ notClauses aux sub, cvb c n := by
  intro c hc
  simp [notClauses, List.mem_cons, List.mem_nil_iff] at hc
  rcases hc with rfl | rfl <;> intro l hl <;>
    simp [List.mem_cons, List.mem_nil_iff, negLit, posLit] at hl <;>
    rcases hl with rfl | rfl <;> simp [negLit, posLit] <;> omega

private theorem cvb_andClauses (aux left right n : Nat)
    (ha : aux < n) (hl : left < n) (hr : right < n) :
    ∀ c ∈ andClauses aux left right, cvb c n := by
  intro c hc
  simp [andClauses, List.mem_cons, List.mem_nil_iff] at hc
  rcases hc with rfl | rfl | rfl <;> intro l hlm <;>
    simp [List.mem_cons, List.mem_nil_iff, negLit, posLit] at hlm <;>
    (try rcases hlm with rfl | rfl | rfl) <;> (try rcases hlm with rfl | rfl) <;>
    simp [negLit, posLit] <;> omega

private theorem cvb_orClauses (aux left right n : Nat)
    (ha : aux < n) (hl : left < n) (hr : right < n) :
    ∀ c ∈ orClauses aux left right, cvb c n := by
  intro c hc
  simp [orClauses, List.mem_cons, List.mem_nil_iff] at hc
  rcases hc with rfl | rfl | rfl <;> intro l hlm <;>
    simp [List.mem_cons, List.mem_nil_iff, negLit, posLit] at hlm <;>
    (try rcases hlm with rfl | rfl | rfl) <;> (try rcases hlm with rfl | rfl) <;>
    simp [negLit, posLit] <;> omega

-- ════════════════════════════════════════════════════════════════
-- Lemma 3: tsEncode clauses have bounded vars
-- ════════════════════════════════════════════════════════════════

theorem enc_cvb (g : Gate) (s : TsState) (hmv : g.maxVar ≤ s.nextVar)
    (hpre : ∀ c ∈ s.clauses, cvb c s.nextVar) :
    ∀ c ∈ (tsEncode g s).2.clauses, cvb c (tsEncode g s).2.nextVar := by
  induction g generalizing s with
  | input _ =>
    simp [tsEncode]; intro c hc
    exact cvb_mono c s.nextVar s.nextVar (hpre c hc) (Nat.le_refl _)
  | const b =>
    cases b <;> simp only [tsEncode] <;> intro c hc <;>
      simp [List.mem_append, List.mem_cons, List.mem_nil_iff] at hc <;>
      rcases hc with hc | rfl
    · exact cvb_mono c s.nextVar (s.nextVar + 1) (hpre c hc) (by omega)
    · exact cvb_negLit s.nextVar (s.nextVar + 1) (by omega)
    · exact cvb_mono c s.nextVar (s.nextVar + 1) (hpre c hc) (by omega)
    · exact cvb_posLit s.nextVar (s.nextVar + 1) (by omega)
  | not g ih =>
    have hmv_g : g.maxVar ≤ s.nextVar := by simp [Gate.maxVar] at hmv; exact hmv
    have h_nv_g := nv_mono g s
    have h_ov_g := outvar_bound g s hmv_g
    have h_inner_nv : (tsEncode g s).2.nextVar ≥ s.nextVar := h_nv_g
    have h_outer_nv : (tsEncode (.not g) s).2.nextVar = (tsEncode g s).2.nextVar + 1 := by
      simp [tsEncode]
    intro c hc
    rcases List.mem_append.mp hc with hc | hc
    · have hcvb_inner := ih s hmv_g hpre c hc
      rw [h_outer_nv]; exact cvb_mono c _ _ hcvb_inner (Nat.le_succ _)
    · rw [h_outer_nv]
      exact cvb_notClauses _ _ _ (Nat.lt_succ_of_le (Nat.le_refl _)) (Nat.lt_succ_of_lt h_ov_g) c hc
  | and g₁ g₂ ih₁ ih₂ =>
    have hmv₁ : g₁.maxVar ≤ s.nextVar := by simp [Gate.maxVar] at hmv; omega
    have hmv₂ : g₂.maxVar ≤ s.nextVar := by simp [Gate.maxVar] at hmv; omega
    have h_nv₁ := nv_mono g₁ s
    have h_nv₂ := nv_mono g₂ (tsEncode g₁ s).2
    have h_ov₁ := outvar_bound g₁ s hmv₁
    have hmv₂' : g₂.maxVar ≤ (tsEncode g₁ s).2.nextVar := by omega
    have h_ov₂ := outvar_bound g₂ (tsEncode g₁ s).2 hmv₂'
    have h_outer_nv : (tsEncode (.and g₁ g₂) s).2.nextVar =
        (tsEncode g₂ (tsEncode g₁ s).2).2.nextVar + 1 := by simp [tsEncode]
    intro c hc
    rcases List.mem_append.mp hc with hc | hc
    · have h₁ := ih₁ s hmv₁ hpre
      have hpre₂ : ∀ c ∈ (tsEncode g₁ s).2.clauses,
          cvb c (tsEncode g₁ s).2.nextVar := h₁
      have h₂ := ih₂ (tsEncode g₁ s).2 hmv₂' hpre₂ c hc
      rw [h_outer_nv]; exact cvb_mono c _ _ h₂ (Nat.le_succ _)
    · rw [h_outer_nv]
      exact cvb_andClauses _ _ _ _
        (Nat.lt_succ_of_le (Nat.le_refl _))
        (by omega)
        (Nat.lt_succ_of_lt h_ov₂) c hc
  | or g₁ g₂ ih₁ ih₂ =>
    have hmv₁ : g₁.maxVar ≤ s.nextVar := by simp [Gate.maxVar] at hmv; omega
    have hmv₂ : g₂.maxVar ≤ s.nextVar := by simp [Gate.maxVar] at hmv; omega
    have h_nv₁ := nv_mono g₁ s
    have h_nv₂ := nv_mono g₂ (tsEncode g₁ s).2
    have h_ov₁ := outvar_bound g₁ s hmv₁
    have hmv₂' : g₂.maxVar ≤ (tsEncode g₁ s).2.nextVar := by omega
    have h_ov₂ := outvar_bound g₂ (tsEncode g₁ s).2 hmv₂'
    have h_outer_nv : (tsEncode (.or g₁ g₂) s).2.nextVar =
        (tsEncode g₂ (tsEncode g₁ s).2).2.nextVar + 1 := by simp [tsEncode]
    intro c hc
    rcases List.mem_append.mp hc with hc | hc
    · have h₁ := ih₁ s hmv₁ hpre
      have h₂ := ih₂ (tsEncode g₁ s).2 hmv₂' h₁ c hc
      rw [h_outer_nv]; exact cvb_mono c _ _ h₂ (Nat.le_succ _)
    · rw [h_outer_nv]
      exact cvb_orClauses _ _ _ _
        (Nat.lt_succ_of_le (Nat.le_refl _))
        (by omega)
        (Nat.lt_succ_of_lt h_ov₂) c hc

-- ════════════════════════════════════════════════════════════════
-- Lemma 4: upd at fresh var doesn't affect bounded clauses
-- ════════════════════════════════════════════════════════════════

theorem eC_upd_fresh (c : Clause) (σ : Nat → Bool) (v : Nat) (b : Bool)
    (hcvb : cvb c v) : eC c (upd σ v b) = eC c σ := by
  simp only [eC]
  induction c with
  | nil => rfl
  | cons l rest ih =>
    simp only [List.any_cons]
    have hlt : l.var < v := hcvb l (List.mem_cons_self _ _)
    have hrest : cvb rest v := fun l' hl' => hcvb l' (List.mem_cons_of_mem _ hl')
    rw [ih hrest]
    congr 1
    simp only [eLit, upd, show l.var ≠ v by omega, ite_false]

-- ════════════════════════════════════════════════════════════════
-- Semantic extension
-- ════════════════════════════════════════════════════════════════

def mkExt (σ_input : Nat → Bool) : Gate → TsState → (Nat → Bool) → (Nat → Bool)
  | .input _, _, base => base
  | .const true, s, base => upd base s.nextVar true
  | .const false, s, base => upd base s.nextVar false
  | .not g, s, base =>
    let base' := mkExt σ_input g s base
    upd base' (tsEncode g s).2.nextVar (!(g.eval σ_input))
  | .and g₁ g₂, s, base =>
    let base' := mkExt σ_input g₁ s base
    let base'' := mkExt σ_input g₂ (tsEncode g₁ s).2 base'
    upd base'' (tsEncode g₂ (tsEncode g₁ s).2).2.nextVar (g₁.eval σ_input && g₂.eval σ_input)
  | .or g₁ g₂, s, base =>
    let base' := mkExt σ_input g₁ s base
    let base'' := mkExt σ_input g₂ (tsEncode g₁ s).2 base'
    upd base'' (tsEncode g₂ (tsEncode g₁ s).2).2.nextVar (g₁.eval σ_input || g₂.eval σ_input)

-- ════════════════════════════════════════════════════════════════
-- Lemma: mkExt preserves variables below s.nextVar
-- ════════════════════════════════════════════════════════════════

theorem mkExt_preserves (σ : Nat → Bool) (g : Gate) (s : TsState) (base : Nat → Bool)
    (i : Nat) (hi : i < s.nextVar) :
    mkExt σ g s base i = base i := by
  induction g generalizing s base with
  | input _ => rfl
  | const b =>
    cases b <;> simp only [mkExt, upd, show i ≠ s.nextVar by omega, ite_false]
  | not g ih =>
    simp only [mkExt]
    have h_nv := nv_mono g s
    rw [upd_ne _ _ _ _ (by omega)]
    exact ih s base hi
  | and g₁ g₂ ih₁ ih₂ =>
    simp only [mkExt]
    have h_nv₁ := nv_mono g₁ s
    have h_nv₂ := nv_mono g₂ (tsEncode g₁ s).2
    rw [upd_ne _ _ _ _ (by omega)]
    rw [ih₂ (tsEncode g₁ s).2 _ (by omega)]
    exact ih₁ s base hi
  | or g₁ g₂ ih₁ ih₂ =>
    simp only [mkExt]
    have h_nv₁ := nv_mono g₁ s
    have h_nv₂ := nv_mono g₂ (tsEncode g₁ s).2
    rw [upd_ne _ _ _ _ (by omega)]
    rw [ih₂ (tsEncode g₁ s).2 _ (by omega)]
    exact ih₁ s base hi

-- ════════════════════════════════════════════════════════════════
-- Lemma: eC on mkExt = eC on base when clause vars < s.nextVar
-- ════════════════════════════════════════════════════════════════

theorem eC_mkExt_base (σ : Nat → Bool) (g : Gate) (s : TsState) (base : Nat → Bool)
    (c : Clause) (hcvb : cvb c s.nextVar) :
    eC c (mkExt σ g s base) = eC c base := by
  simp only [eC]
  induction c with
  | nil => rfl
  | cons l rest ih =>
    simp only [List.any_cons]
    have hlt : l.var < s.nextVar := hcvb l (List.mem_cons_self _ _)
    have hrest : cvb rest s.nextVar := fun l' hl' => hcvb l' (List.mem_cons_of_mem _ hl')
    rw [ih hrest]
    congr 1
    simp only [eLit]
    rw [mkExt_preserves σ g s base l.var hlt]

-- ════════════════════════════════════════════════════════════════
-- Lemma 5a: mkExt maps output to correct value
-- ════════════════════════════════════════════════════════════════

theorem mkExt_outvar (σ : Nat → Bool) (g : Gate) (s : TsState) (base : Nat → Bool)
    (hmv : g.maxVar ≤ s.nextVar)
    (hbase : ∀ i, i < g.maxVar → base i = σ i) :
    mkExt σ g s base (tsEncode g s).1 = g.eval σ := by
  induction g generalizing s base with
  | input i =>
    simp [mkExt, tsEncode, Gate.eval, Gate.maxVar] at *
    exact hbase i (by omega)
  | const b => cases b <;> simp [mkExt, tsEncode, Gate.eval, upd]
  | not g ih =>
    simp only [mkExt, tsEncode, Gate.eval, Gate.maxVar] at *
    simp [upd]
  | and g₁ g₂ ih₁ ih₂ =>
    simp only [mkExt, tsEncode, Gate.eval, Gate.maxVar] at *
    simp [upd]
  | or g₁ g₂ ih₁ ih₂ =>
    simp only [mkExt, tsEncode, Gate.eval, Gate.maxVar] at *
    simp [upd]

-- ════════════════════════════════════════════════════════════════
-- Lemma 5b: mkExt satisfies all encoding clauses
-- ════════════════════════════════════════════════════════════════

theorem mkExt_sat (σ : Nat → Bool) (g : Gate) (s : TsState) (base : Nat → Bool)
    (hmv : g.maxVar ≤ s.nextVar)
    (hbase : ∀ i, i < g.maxVar → base i = σ i)
    (hpre_sat : ∀ c ∈ s.clauses, eC c (mkExt σ g s base) = true)
    (hpre_cvb : ∀ c ∈ s.clauses, cvb c s.nextVar) :
    ∀ c ∈ (tsEncode g s).2.clauses, eC c (mkExt σ g s base) = true := by
  induction g generalizing s base with
  | input _ => exact hpre_sat
  | const b =>
    intro c hc
    cases b <;> simp only [tsEncode, mkExt, List.mem_append, List.mem_cons,
        List.mem_nil_iff, or_false] at hc ⊢ <;> rcases hc with hc | rfl
    · -- pre-existing clause: hpre_sat gives eC c (upd base nv false) = true
      -- eC_upd_fresh gives eC c (upd base nv false) = eC c base
      -- So eC c (upd base nv false) = true
      exact hpre_sat c hc
    · simp [eC, List.any_cons, List.any_nil, eLit, negLit, upd]
    · exact hpre_sat c hc
    · simp [eC, List.any_cons, List.any_nil, eLit, posLit, upd]
  | not g ih =>
    have hmv_g : g.maxVar ≤ s.nextVar := by simp [Gate.maxVar] at hmv; exact hmv
    have h_nv := nv_mono g s
    have h_ov := outvar_bound g s hmv_g
    -- σ₁ = mkExt σ g s base
    -- The full extension = upd σ₁ aux (!(g.eval σ))
    -- aux = (tsEncode g s).2.nextVar
    intro c hc
    simp only [mkExt]
    rcases List.mem_append.mp hc with hc | hc
    · -- Inner clause from g: upd doesn't affect it (aux is fresh)
      have h_enc_cvb := enc_cvb g s hmv_g hpre_cvb c hc
      rw [eC_upd_fresh c _ _ _ (cvb_mono c _ _ h_enc_cvb (Nat.le_refl _))]
      -- Now need: eC c (mkExt σ g s base) = true
      -- By IH
      have h_pre_mkext : ∀ c ∈ s.clauses, eC c (mkExt σ g s base) = true := by
        intro c' hc'
        -- hpre_sat gives eC c' (mkExt σ (.not g) s base) = true
        -- = eC c' (upd (mkExt σ g s base) aux val) = true
        -- By eC_upd_fresh (since c' has vars < s.nextVar ≤ aux):
        have := hpre_sat c' hc'
        simp only [mkExt] at this
        rwa [eC_upd_fresh c' _ _ _ (cvb_mono c' _ _ (hpre_cvb c' hc') h_nv)] at this
      exact ih s base hmv_g hbase h_pre_mkext hpre_cvb c hc
    · -- NOT clause: aux = !sub
      have h_outvar := mkExt_outvar σ g s base hmv_g hbase
      -- upd σ₁ aux (!(g.eval σ)) at aux = !(g.eval σ)
      -- σ₁(sub) = g.eval σ (by h_outvar)
      -- So upd σ₁ aux (!(g.eval σ)) has: aux = !(σ₁ sub)
      -- NOT clauses satisfied by not_enc_rev
      have h_aux_val : upd (mkExt σ g s base) (tsEncode g s).2.nextVar (!(g.eval σ))
          (tsEncode g s).2.nextVar = !(g.eval σ) := by simp [upd]
      have h_sub_val : upd (mkExt σ g s base) (tsEncode g s).2.nextVar (!(g.eval σ))
          (tsEncode g s).1 = g.eval σ := by
        simp [upd, show (tsEncode g s).1 ≠ (tsEncode g s).2.nextVar by omega]
        exact h_outvar
      -- aux = !(g.eval σ) = !(σ_ext sub)
      have h_rel : upd (mkExt σ g s base) (tsEncode g s).2.nextVar (!(g.eval σ))
          (tsEncode g s).2.nextVar =
          !(upd (mkExt σ g s base) (tsEncode g s).2.nextVar (!(g.eval σ)) (tsEncode g s).1) := by
        rw [h_aux_val, h_sub_val]
      exact not_enc_rev _ _ _ h_rel c hc
  | and g₁ g₂ ih₁ ih₂ =>
    have hmv₁ : g₁.maxVar ≤ s.nextVar := by simp [Gate.maxVar] at hmv; omega
    have hmv₂ : g₂.maxVar ≤ s.nextVar := by simp [Gate.maxVar] at hmv; omega
    have h_nv₁ := nv_mono g₁ s
    have h_nv₂ := nv_mono g₂ (tsEncode g₁ s).2
    have h_ov₁ := outvar_bound g₁ s hmv₁
    have hmv₂' : g₂.maxVar ≤ (tsEncode g₁ s).2.nextVar := by omega
    have h_ov₂ := outvar_bound g₂ (tsEncode g₁ s).2 hmv₂'
    -- Step 1: IH₁ — σ₁ satisfies g₁'s clauses
    have hbase₁ : ∀ i, i < g₁.maxVar → base i = σ i :=
      fun i hi => hbase i (by simp [Gate.maxVar] at hmv ⊢; omega)
    -- Convert hpre_sat from full extension to g₁ extension
    have hpre_sat₁ : ∀ c ∈ s.clauses, eC c (mkExt σ g₁ s base) = true := by
      intro c' hc'
      rw [eC_mkExt_base σ g₁ s base c' (hpre_cvb c' hc')]
      rw [← eC_mkExt_base σ (.and g₁ g₂) s base c' (hpre_cvb c' hc')]
      exact hpre_sat c' hc'
    have h_ih₁ := ih₁ s base hmv₁ hbase₁ hpre_sat₁ hpre_cvb
    -- h_ih₁ : ∀ c ∈ (tsEncode g₁ s).2.clauses, eC c (mkExt σ g₁ s base) = true
    -- Step 2: IH₂ — σ₂ satisfies g₂'s clauses
    -- Preconditions for IH₂:
    --   s₁ = (tsEncode g₁ s).2
    --   base₂ = mkExt σ g₁ s base (= σ₁)
    --   hpre_sat₂ = h_ih₁ (σ₁ satisfies s₁.clauses ✓)
    --   hpre_cvb₂ = enc_cvb g₁ s hmv₁ hpre_cvb (s₁.clauses have bounded vars ✓)
    --   hbase₂ = mkExt_preserves (σ₁ agrees with σ on inputs for g₂ ✓)
    have hbase₂ : ∀ i, i < g₂.maxVar → mkExt σ g₁ s base i = σ i := by
      intro i hi
      rw [mkExt_preserves σ g₁ s base i (by omega)]
      exact hbase i (by simp [Gate.maxVar] at hmv ⊢; omega)
    have hpre_cvb₂ := enc_cvb g₁ s hmv₁ hpre_cvb
    -- Convert h_ih₁ to satisfaction under mkExt g₂
    have hpre_sat₂ : ∀ c ∈ (tsEncode g₁ s).2.clauses,
        eC c (mkExt σ g₂ (tsEncode g₁ s).2 (mkExt σ g₁ s base)) = true := by
      intro c' hc'
      rw [eC_mkExt_base σ g₂ (tsEncode g₁ s).2 (mkExt σ g₁ s base) c' (hpre_cvb₂ c' hc')]
      exact h_ih₁ c' hc'
    have h_ih₂ := ih₂ (tsEncode g₁ s).2 (mkExt σ g₁ s base) hmv₂' hbase₂ hpre_sat₂ hpre_cvb₂
    -- h_ih₂ : ∀ c ∈ (tsEncode g₂ s₁).2.clauses, eC c σ₂ = true
    intro c hc
    simp only [mkExt]
    rcases List.mem_append.mp hc with hc | hc
    · -- Inner clause: upd at aux doesn't affect (aux is fresh)
      have h_cvb := enc_cvb g₂ (tsEncode g₁ s).2 hmv₂' hpre_cvb₂ c hc
      rw [eC_upd_fresh c _ _ _ (cvb_mono c _ _ h_cvb (Nat.le_refl _))]
      exact h_ih₂ c hc
    · -- AND clauses: and_enc_rev
      have h_outvar₁ := mkExt_outvar σ g₁ s base hmv₁ hbase₁
      have h_outvar₂ := mkExt_outvar σ g₂ (tsEncode g₁ s).2 (mkExt σ g₁ s base) hmv₂' hbase₂
      -- aux = g₁.eval && g₂.eval
      -- left = outvar₁: σ₂(left) = ? (may have been modified by mkExt g₂)
      -- We need σ₂(left) where σ₂ = mkExt σ g₂ s₁ σ₁
      -- left = (tsEncode g₁ s).1, which is < s₁.nextVar = (tsEncode g₁ s).2.nextVar
      -- By mkExt_preserves: mkExt σ g₂ s₁ σ₁ left = σ₁ left = g₁.eval σ
      have h_left_preserved : mkExt σ g₂ (tsEncode g₁ s).2 (mkExt σ g₁ s base) (tsEncode g₁ s).1
          = g₁.eval σ := by
        rw [mkExt_preserves σ g₂ (tsEncode g₁ s).2 _ _ h_ov₁, h_outvar₁]
      -- right = outvar₂ = (tsEncode g₂ s₁).1: σ₂(right) = g₂.eval σ (by h_outvar₂)
      -- upd σ₂ aux val at aux = val = g₁.eval && g₂.eval
      -- upd σ₂ aux val at left = σ₂ left = g₁.eval σ (by h_left_preserved, since left ≠ aux)
      -- upd σ₂ aux val at right = σ₂ right = g₂.eval σ (by h_outvar₂, since right ≠ aux)
      have h_rel : upd (mkExt σ g₂ (tsEncode g₁ s).2 (mkExt σ g₁ s base))
          (tsEncode g₂ (tsEncode g₁ s).2).2.nextVar (g₁.eval σ && g₂.eval σ)
          (tsEncode g₂ (tsEncode g₁ s).2).2.nextVar =
          (upd (mkExt σ g₂ (tsEncode g₁ s).2 (mkExt σ g₁ s base))
            (tsEncode g₂ (tsEncode g₁ s).2).2.nextVar (g₁.eval σ && g₂.eval σ)
            (tsEncode g₁ s).1 &&
           upd (mkExt σ g₂ (tsEncode g₁ s).2 (mkExt σ g₁ s base))
            (tsEncode g₂ (tsEncode g₁ s).2).2.nextVar (g₁.eval σ && g₂.eval σ)
            (tsEncode g₂ (tsEncode g₁ s).2).1) := by
        simp [upd, show (tsEncode g₁ s).1 ≠ (tsEncode g₂ (tsEncode g₁ s).2).2.nextVar by omega,
              show (tsEncode g₂ (tsEncode g₁ s).2).1 ≠ (tsEncode g₂ (tsEncode g₁ s).2).2.nextVar by omega]
        rw [h_left_preserved, h_outvar₂]
      exact and_enc_rev _ _ _ _ h_rel c hc
  | or g₁ g₂ ih₁ ih₂ =>
    have hmv₁ : g₁.maxVar ≤ s.nextVar := by simp [Gate.maxVar] at hmv; omega
    have hmv₂ : g₂.maxVar ≤ s.nextVar := by simp [Gate.maxVar] at hmv; omega
    have h_nv₁ := nv_mono g₁ s
    have h_nv₂ := nv_mono g₂ (tsEncode g₁ s).2
    have h_ov₁ := outvar_bound g₁ s hmv₁
    have hmv₂' : g₂.maxVar ≤ (tsEncode g₁ s).2.nextVar := by omega
    have h_ov₂ := outvar_bound g₂ (tsEncode g₁ s).2 hmv₂'
    have hbase₁ : ∀ i, i < g₁.maxVar → base i = σ i :=
      fun i hi => hbase i (by simp [Gate.maxVar] at hmv ⊢; omega)
    have hpre_sat₁ : ∀ c ∈ s.clauses, eC c (mkExt σ g₁ s base) = true := by
      intro c' hc'
      rw [eC_mkExt_base σ g₁ s base c' (hpre_cvb c' hc')]
      rw [← eC_mkExt_base σ (.or g₁ g₂) s base c' (hpre_cvb c' hc')]
      exact hpre_sat c' hc'
    have h_ih₁ := ih₁ s base hmv₁ hbase₁ hpre_sat₁ hpre_cvb
    have hbase₂ : ∀ i, i < g₂.maxVar → mkExt σ g₁ s base i = σ i := by
      intro i hi
      rw [mkExt_preserves σ g₁ s base i (by omega)]
      exact hbase i (by simp [Gate.maxVar] at hmv ⊢; omega)
    have hpre_cvb₂ := enc_cvb g₁ s hmv₁ hpre_cvb
    have hpre_sat₂ : ∀ c ∈ (tsEncode g₁ s).2.clauses,
        eC c (mkExt σ g₂ (tsEncode g₁ s).2 (mkExt σ g₁ s base)) = true := by
      intro c' hc'
      rw [eC_mkExt_base σ g₂ (tsEncode g₁ s).2 (mkExt σ g₁ s base) c' (hpre_cvb₂ c' hc')]
      exact h_ih₁ c' hc'
    have h_ih₂ := ih₂ (tsEncode g₁ s).2 (mkExt σ g₁ s base) hmv₂' hbase₂ hpre_sat₂ hpre_cvb₂
    intro c hc
    simp only [mkExt]
    rcases List.mem_append.mp hc with hc | hc
    · have h_cvb := enc_cvb g₂ (tsEncode g₁ s).2 hmv₂' hpre_cvb₂ c hc
      rw [eC_upd_fresh c _ _ _ (cvb_mono c _ _ h_cvb (Nat.le_refl _))]
      exact h_ih₂ c hc
    · have h_outvar₁ := mkExt_outvar σ g₁ s base hmv₁ hbase₁
      have h_outvar₂ := mkExt_outvar σ g₂ (tsEncode g₁ s).2 (mkExt σ g₁ s base) hmv₂' hbase₂
      have h_left_preserved : mkExt σ g₂ (tsEncode g₁ s).2 (mkExt σ g₁ s base) (tsEncode g₁ s).1
          = g₁.eval σ := by
        rw [mkExt_preserves σ g₂ (tsEncode g₁ s).2 _ _ h_ov₁, h_outvar₁]
      have h_rel : upd (mkExt σ g₂ (tsEncode g₁ s).2 (mkExt σ g₁ s base))
          (tsEncode g₂ (tsEncode g₁ s).2).2.nextVar (g₁.eval σ || g₂.eval σ)
          (tsEncode g₂ (tsEncode g₁ s).2).2.nextVar =
          (upd (mkExt σ g₂ (tsEncode g₁ s).2 (mkExt σ g₁ s base))
            (tsEncode g₂ (tsEncode g₁ s).2).2.nextVar (g₁.eval σ || g₂.eval σ)
            (tsEncode g₁ s).1 ||
           upd (mkExt σ g₂ (tsEncode g₁ s).2 (mkExt σ g₁ s base))
            (tsEncode g₂ (tsEncode g₁ s).2).2.nextVar (g₁.eval σ || g₂.eval σ)
            (tsEncode g₂ (tsEncode g₁ s).2).1) := by
        simp [upd, show (tsEncode g₁ s).1 ≠ (tsEncode g₂ (tsEncode g₁ s).2).2.nextVar by omega,
              show (tsEncode g₂ (tsEncode g₁ s).2).1 ≠ (tsEncode g₂ (tsEncode g₁ s).2).2.nextVar by omega]
        rw [h_left_preserved, h_outvar₂]
      exact or_enc_rev _ _ _ _ h_rel c hc

-- ════════════════════════════════════════════════════════════════
-- Main theorem
-- ════════════════════════════════════════════════════════════════

theorem tseitin_complete (g : Gate) (σ : Nat → Bool) (heval : g.eval σ = true) :
    Sat (tseitin g) := by
  let σ_ext := mkExt σ g ⟨g.maxVar, []⟩ σ
  refine ⟨σ_ext, ?_⟩
  simp only [tseitin, evalCNF, List.all_append, Bool.and_eq_true,
             List.all_cons, List.all_nil, Bool.true_and]
  constructor
  · -- Encoding clauses satisfied
    simp [List.all_eq_true]
    intro c hc
    have h_ec := mkExt_sat σ g ⟨g.maxVar, []⟩ σ (Nat.le_refl _)
      (fun _ _ => rfl) (fun c hc => absurd hc (List.not_mem_nil _))
      (fun c hc => absurd hc (List.not_mem_nil _)) c hc
    -- eC and evalClause are the same computation
    simp only [eC, eLit, evalClause, evalLit] at h_ec ⊢
    exact h_ec
  · -- Output clause satisfied
    constructor
    · simp [evalClause, List.any_cons, List.any_nil, evalLit, posLit]
      have h_out := mkExt_outvar σ g ⟨g.maxVar, []⟩ σ (Nat.le_refl _) (fun _ _ => rfl)
      change mkExt σ g ⟨g.maxVar, []⟩ σ (tsEncode g ⟨g.maxVar, []⟩).1 = true
      rw [h_out]; exact heval
    · trivial

end Complexity
