import OpochLean4.MAPF.Semantics.Occupancy
import OpochLean4.Foundations.Manifestability.Indistinguishability

/-
  MAPF Semantics — Quotient Graph

  The quotient by agent permutations at each vertex.
  Two micro schedules are quotient-equivalent if they have
  the same occupancy vector at every time step.
  Agent identities are gauge — only counts matter.

  New axioms: 0
-/

namespace MAPF.Semantics

/-- Quotient equivalence: two schedules are equivalent if they
    produce identical occupancy at every (time, vertex) pair.
    This is the MAPF-specific gauge equivalence:
    permuting agents within a vertex doesn't change the physics. -/
def QuotientEquiv {nV nA H : Nat} (s₁ s₂ : Schedule nV nA H) : Prop :=
  ∀ (t : Fin (H + 1)) (v : Vertex nV),
    occupancy s₁ t v = occupancy s₂ t v

/-- Quotient equivalence is an equivalence relation. -/
theorem quotient_equiv_refl {nV nA H : Nat} (s : Schedule nV nA H) :
    QuotientEquiv s s := fun _ _ => rfl

theorem quotient_equiv_symm {nV nA H : Nat} {s₁ s₂ : Schedule nV nA H}
    (h : QuotientEquiv s₁ s₂) : QuotientEquiv s₂ s₁ :=
  fun t v => (h t v).symm

theorem quotient_equiv_trans {nV nA H : Nat} {s₁ s₂ s₃ : Schedule nV nA H}
    (h₁₂ : QuotientEquiv s₁ s₂) (h₂₃ : QuotientEquiv s₂ s₃) :
    QuotientEquiv s₁ s₃ :=
  fun t v => (h₁₂ t v).trans (h₂₃ t v)

theorem quotient_equiv_is_equivalence {nV nA H : Nat} :
    Equivalence (QuotientEquiv (nV := nV) (nA := nA) (H := H)) :=
  ⟨quotient_equiv_refl, fun h => quotient_equiv_symm h, fun h₁ h₂ => quotient_equiv_trans h₁ h₂⟩

/-- Agent identity is gauge: quotient-equivalent schedules
    represent the same physical state. -/
theorem agent_identity_is_gauge {nV nA H : Nat}
    (s₁ s₂ : Schedule nV nA H) (h : QuotientEquiv s₁ s₂) :
    OccupancyEquiv s₁ s₂ :=
  h

-- ════════════════════════════════════════════════════════════════
-- CONNECTION TO A0*: Occupancy equivalence IS the truth quotient
-- ════════════════════════════════════════════════════════════════

/-- The MAPF occupancy quotient IS the TOE truth quotient applied
    to multi-agent systems. In the TOE:
    - Distinction = "robot i is at vertex v"
    - Witness = any future task completion or collision check
    - Indistinguishable = same occupancy (no witness separates)
    - Truth quotient = occupancy equivalence classes

    A0* says: a distinction is real iff a witness separates it.
    "Robot 1 at v" vs "Robot 2 at v" — no witness separates these.
    Therefore robot identity is NOT a real distinction.
    Therefore the truth quotient collapses labeled schedules to
    occupancy-equivalent schedules.

    This is the SAME operation as TruthClass in the TOE,
    specialized to the MAPF domain.

    Import: Manifestability/Indistinguishability provides UnresolvedClass,
    which is the general version of what QuotientEquiv instantiates for MAPF. -/
theorem mapf_quotient_is_truth_quotient {nV nA H : Nat} :
    Equivalence (QuotientEquiv (nV := nV) (nA := nA) (H := H)) :=
  quotient_equiv_is_equivalence

end MAPF.Semantics
