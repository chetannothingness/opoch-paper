import OpochLean4.Foundations.Manifestability.ValueEquation

/-
  Manifestability Block — Local Remodelling Law

  W★ = argmin F — the exact local update law.
  Reality selects the refinement that minimizes the manifestability
  functional. This is "nothingness observing itself" in operational form.

  Dependencies: ValueEquation
  New axioms: 0
-/

namespace Manifestability

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Optimal refinement
-- ════════════════════════════════════════════════════════════════

/-- A candidate refinement: an event with its functional value. -/
structure CandidateRefinement where
  event : RefinementEvent
  functional : ManifestabilityFunctional
  functional_matches : functional.event = event

/-- A refinement is optimal among candidates if no other has lower cost. -/
def IsOptimal (c : CandidateRefinement)
    (candidates : List CandidateRefinement) : Prop :=
  c ∈ candidates ∧
  ∀ c' ∈ candidates, c.functional.value ≤ c'.functional.value

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Local Remodelling Law
-- ════════════════════════════════════════════════════════════════

/-- The local remodelling law: given a nonempty list of candidate
    refinements, an optimal one exists.
    This is W★ = argmin F — the exact operational law.
    Proof: induction on the list, tracking the minimum. -/
theorem local_remodelling_law_exact
    (candidates : List CandidateRefinement)
    (hne : candidates ≠ []) :
    ∃ c ∈ candidates, IsOptimal c candidates := by
  induction candidates with
  | nil => exact absurd rfl hne
  | cons head tail ih =>
    by_cases ht : tail = []
    · -- Singleton: head is trivially optimal
      subst ht
      exact ⟨head, List.mem_cons_self _ _,
        ⟨List.mem_cons_self _ _, fun c' hc' => by
          cases List.mem_singleton.mp hc'
          exact Nat.le_refl _⟩⟩
    · -- Nonempty tail: get its minimum, compare with head
      obtain ⟨c_tail, hm_tail, hopt_tail⟩ := ih ht
      obtain ⟨_, hmin_tail⟩ := hopt_tail
      by_cases h : head.functional.value ≤ c_tail.functional.value
      · -- Head beats tail minimum → head is global minimum
        exact ⟨head, List.mem_cons_self _ _,
          ⟨List.mem_cons_self _ _, fun c' hc' => by
            rcases List.mem_cons.mp hc' with rfl | hc''
            · exact Nat.le_refl _
            · exact Nat.le_trans h (hmin_tail c' hc'')⟩⟩
      · -- Tail minimum beats head → tail minimum is global minimum
        have hlt : c_tail.functional.value < head.functional.value :=
          Nat.lt_of_not_le h
        exact ⟨c_tail, List.mem_cons_of_mem _ hm_tail,
          ⟨List.mem_cons_of_mem _ hm_tail, fun c' hc' => by
            rcases List.mem_cons.mp hc' with rfl | hc''
            · exact Nat.le_of_lt hlt
            · exact hmin_tail c' hc''⟩⟩

/-- Binary case: among two candidates, the lower-cost one is preferred. -/
theorem local_remodelling_binary
    (c₁ c₂ : CandidateRefinement)
    (h : c₁.functional.value ≤ c₂.functional.value) :
    IsOptimal c₁ [c₁, c₂] :=
  ⟨List.mem_cons_self _ _, fun c' hc' => by
    rcases List.mem_cons.mp hc' with rfl | hc''
    · exact Nat.le_refl _
    · rcases List.mem_cons.mp hc'' with rfl | hc'''
      · exact h
      · exact absurd hc''' (List.not_mem_nil _)⟩

end Manifestability
