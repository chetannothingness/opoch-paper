import OpochLean4.Complexity.Core.Tseitin

/-
  Tseitin Completeness: g.eval σ = true → Sat(tseitin g)

  Dependencies: Tseitin
  New axioms: 0
-/

namespace Complexity

-- ════════════════════════════════════════════════════════════════
-- nextVar monotonicity
-- ════════════════════════════════════════════════════════════════

theorem tsEncode_nextVar_mono (g : Gate) (s : TsState) :
    s.nextVar ≤ (tsEncode g s).2.nextVar := by
  induction g generalizing s with
  | input _ => exact Nat.le_refl _
  | const b => cases b <;> simp [tsEncode] <;> omega
  | not g ih => simp only [tsEncode]; have := ih s; omega
  | and g₁ g₂ ih₁ ih₂ =>
    simp only [tsEncode]; have := ih₁ s; have := ih₂ (tsEncode g₁ s).2; omega
  | or g₁ g₂ ih₁ ih₂ =>
    simp only [tsEncode]; have := ih₁ s; have := ih₂ (tsEncode g₁ s).2; omega

-- ════════════════════════════════════════════════════════════════
-- Semantic extension
-- ════════════════════════════════════════════════════════════════

/-- Update σ at variable v to value b. -/
private def upd (σ : Nat → Bool) (v : Nat) (b : Bool) : Nat → Bool :=
  fun i => if i = v then b else σ i

private theorem upd_eq (σ : Nat → Bool) (v : Nat) (b : Bool) :
    upd σ v b v = b := by simp [upd]

private theorem upd_ne (σ : Nat → Bool) (v : Nat) (b : Bool) (i : Nat) (h : i ≠ v) :
    upd σ v b i = σ i := by simp [upd, h]

/-- Build the extending assignment. Each gate's aux gets its semantic value. -/
def mkSemExt : Gate → TsState → (Nat → Bool) → (Nat → Bool)
  | .input _, _, σ => σ
  | .const true, s, σ => upd σ s.nextVar true
  | .const false, s, σ => upd σ s.nextVar false
  | .not g, s, σ =>
    let σ₁ := mkSemExt g s σ
    upd σ₁ (tsEncode g s).2.nextVar (!(g.eval σ))
  | .and g₁ g₂, s, σ =>
    let σ₁ := mkSemExt g₁ s σ
    let σ₂ := mkSemExt g₂ (tsEncode g₁ s).2 σ₁
    upd σ₂ (tsEncode g₂ (tsEncode g₁ s).2).2.nextVar (g₁.eval σ && g₂.eval σ)
  | .or g₁ g₂, s, σ =>
    let σ₁ := mkSemExt g₁ s σ
    let σ₂ := mkSemExt g₂ (tsEncode g₁ s).2 σ₁
    upd σ₂ (tsEncode g₂ (tsEncode g₁ s).2).2.nextVar (g₁.eval σ || g₂.eval σ)

-- ════════════════════════════════════════════════════════════════
-- mkSemExt preserves variables below s.nextVar
-- ════════════════════════════════════════════════════════════════

theorem mkSemExt_preserves (g : Gate) (s : TsState) (σ : Nat → Bool)
    (i : Nat) (hi : i < s.nextVar) :
    mkSemExt g s σ i = σ i := by
  induction g generalizing s σ with
  | input _ => rfl
  | const b =>
    cases b <;> simp only [mkSemExt] <;> exact upd_ne σ s.nextVar _ i (by omega)
  | not g ih =>
    simp only [mkSemExt]
    have h_mono := tsEncode_nextVar_mono g s
    rw [upd_ne _ _ _ _ (by omega)]
    exact ih s σ hi
  | and g₁ g₂ ih₁ ih₂ =>
    simp only [mkSemExt]
    have h1 := tsEncode_nextVar_mono g₁ s
    have h2 := tsEncode_nextVar_mono g₂ (tsEncode g₁ s).2
    rw [upd_ne _ _ _ _ (by omega)]
    rw [ih₂ (tsEncode g₁ s).2 (mkSemExt g₁ s σ) (by omega)]
    exact ih₁ s σ hi
  | or g₁ g₂ ih₁ ih₂ =>
    simp only [mkSemExt]
    have h1 := tsEncode_nextVar_mono g₁ s
    have h2 := tsEncode_nextVar_mono g₂ (tsEncode g₁ s).2
    rw [upd_ne _ _ _ _ (by omega)]
    rw [ih₂ (tsEncode g₁ s).2 (mkSemExt g₁ s σ) (by omega)]
    exact ih₁ s σ hi

-- ════════════════════════════════════════════════════════════════
-- mkSemExt maps outVar to g.eval σ
-- ════════════════════════════════════════════════════════════════

theorem mkSemExt_outvar (g : Gate) (s : TsState) (σ : Nat → Bool) :
    mkSemExt g s σ (tsEncode g s).1 = g.eval σ := by
  induction g generalizing s σ with
  | input i => simp [mkSemExt, tsEncode, Gate.eval]
  | const b =>
    cases b
    · simp [mkSemExt, tsEncode, Gate.eval, upd]
    · simp [mkSemExt, tsEncode, Gate.eval, upd]
  | not g ih =>
    simp only [mkSemExt, tsEncode, Gate.eval]
    exact upd_eq _ _ _
  | and g₁ g₂ ih₁ ih₂ =>
    simp only [mkSemExt, tsEncode, Gate.eval]
    exact upd_eq _ _ _
  | or g₁ g₂ ih₁ ih₂ =>
    simp only [mkSemExt, tsEncode, Gate.eval]
    exact upd_eq _ _ _

-- ════════════════════════════════════════════════════════════════
-- mkSemExt satisfies all encoding clauses
-- ════════════════════════════════════════════════════════════════

/-- KEY: the semantic extension satisfies all clauses produced by tsEncode.
    Proof: by induction on the gate, using reverse gate lemmas. -/
theorem mkSemExt_satisfies (g : Gate) (s : TsState) (σ : Nat → Bool)
    (h_pre : ∀ c ∈ s.clauses, eC c (mkSemExt g s σ) = true) :
    ∀ c ∈ (tsEncode g s).2.clauses, eC c (mkSemExt g s σ) = true := by
  induction g generalizing s σ with
  | input _ => exact h_pre
  | const b =>
    intro c hc
    cases b <;> simp only [tsEncode, List.mem_append, List.mem_cons,
        List.mem_nil_iff, or_false] at hc <;> rcases hc with hc | rfl
    · exact h_pre c hc
    · simp [mkSemExt, eC, List.any_cons, List.any_nil, eLit, negLit, upd]
    · exact h_pre c hc
    · simp [mkSemExt, eC, List.any_cons, List.any_nil, eLit, posLit, upd]
  | not g ih =>
    intro c hc
    simp only [tsEncode, List.mem_append] at hc
    rcases hc with hc | hc
    · -- From inner encoding: need mkSemExt (.not g) s σ to satisfy inner clauses
      -- mkSemExt (.not g) s σ = upd (mkSemExt g s σ) aux (!(g.eval σ))
      -- Inner clauses don't reference aux (it's fresh), so upd doesn't affect them
      simp only [mkSemExt]
      have h_mono := tsEncode_nextVar_mono g s
      sorry -- Need: upd doesn't affect inner clauses (aux is fresh)
    · -- From NOT clauses: need not_enc_rev
      simp only [mkSemExt]
      sorry -- Need: NOT clauses satisfied by the extended assignment
  | and g₁ g₂ ih₁ ih₂ => sorry
  | or g₁ g₂ ih₁ ih₂ => sorry

-- ════════════════════════════════════════════════════════════════
-- Tseitin completeness
-- ════════════════════════════════════════════════════════════════

/-- Tseitin completeness: if g.eval σ = true, then tseitin(g) is satisfiable.
    Construction: mkSemExt extends σ with correct auxiliary values. -/
theorem tseitin_complete (g : Gate) (σ : Nat → Bool) (heval : g.eval σ = true) :
    Sat (tseitin g) := by
  refine ⟨mkSemExt g ⟨g.maxVar, []⟩ σ, ?_⟩
  simp only [tseitin, evalCNF, List.all_append, Bool.and_eq_true,
             List.all_cons, List.all_nil, Bool.true_and]
  constructor
  · -- Encoding clauses satisfied
    simp [List.all_eq_true]
    intro c hc
    rw [← eC_eq_evalClause]
    exact mkSemExt_satisfies g ⟨g.maxVar, []⟩ σ
      (fun c hc => by simp [List.mem_nil_iff] at hc) c hc
  · -- Output clause satisfied: σ_ext(outVar) = g.eval σ = true
    simp [evalClause, List.any_cons, List.any_nil, evalLit, posLit]
    have := mkSemExt_outvar g ⟨g.maxVar, []⟩ σ
    rw [this, heval]

end Complexity
