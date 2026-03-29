import OpochLean4.Foundations.RefinementAlgebra.RefinementKernel

/-
  Refinement Algebra — Sequential Composition (Tree Grafting)

  If e₁ : W → (W₁,...,Wⱼ,...,Wᵣ) and e₂ : Wⱼ → (U₁,...,Uₘ),
  then e₂ ∘ⱼ e₁ : W → (W₁,...,U₁,...,Uₘ,...,Wᵣ).

  This is operadic tree grafting: e₂ replaces child j of e₁.
  Action is additive: A(e₂ ∘ⱼ e₁) = A(e₁) + A(e₂).

  New axioms: 0
-/

namespace RefinementAlgebra

/-- Tree-grafting sequential composition.
    e₂ refines child at index j of e₁'s targets. -/
structure TreeGraft where
  /-- First event -/
  first : AlgEvent
  /-- Second event (refines a child of first) -/
  second : AlgEvent
  /-- Index of child being refined -/
  childIndex : Nat
  /-- Child index is valid -/
  childValid : childIndex < first.targets.length
  /-- Second event's source matches the child -/
  source_matches : second.source = first.targets[childIndex]

/-- The targets after tree grafting: replace child j with second's targets. -/
def TreeGraft.graftedTargets (tg : TreeGraft) : List RClass :=
  (tg.first.targets.take tg.childIndex) ++
  tg.second.targets ++
  (tg.first.targets.drop (tg.childIndex + 1))

/-- Total action of a tree graft: ADDITIVE.
    A(e₂ ∘ⱼ e₁) = A(e₁) + A(e₂).
    Forced by append-only ledger: both witnesses are recorded. -/
def TreeGraft.totalAction (tg : TreeGraft) : Nat :=
  tg.first.action + tg.second.action

/-- Sequential action additivity (tree-grafting form). -/
theorem sequential_action_additivity_tree (tg : TreeGraft) :
    tg.totalAction = tg.first.action + tg.second.action :=
  rfl

/-- Total entropy drop telescopes. -/
def TreeGraft.totalEntropyDrop (tg : TreeGraft) : Nat :=
  tg.first.entropyDrop + tg.second.entropyDrop

/-- Entropy telescoping: total ΔS = Σ local ΔS. -/
theorem history_entropy_telescopes (tg : TreeGraft) :
    tg.totalEntropyDrop = tg.first.entropyDrop + tg.second.entropyDrop :=
  rfl

/-- Sequential composition is well-defined:
    the grafted result has valid targets. -/
theorem sequential_composition_well_defined (tg : TreeGraft) :
    tg.graftedTargets.length ≥ 1 := by
  simp [TreeGraft.graftedTargets, List.length_append]
  have := tg.second.targets_nonempty
  omega

/-- A refinement tree: recursive sequential composition. -/
inductive RefinementTree where
  | leaf : RClass → RefinementTree
  | node : AlgEvent → List RefinementTree → RefinementTree

-- Total action of a refinement tree (mutual recursion with list helper).
mutual
  def RefinementTree.totalAction : RefinementTree → Nat
    | .leaf _ => 0
    | .node e children => e.action + sumTreeActions children

  def sumTreeActions : List RefinementTree → Nat
    | [] => 0
    | t :: ts => t.totalAction + sumTreeActions ts
end

/-- Tree action is non-negative. -/
theorem tree_action_nonneg (t : RefinementTree) :
    t.totalAction ≥ 0 :=
  Nat.zero_le _

end RefinementAlgebra
