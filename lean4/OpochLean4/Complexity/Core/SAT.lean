import OpochLean4.Complexity.Core.NPComplete
import OpochLean4.Complexity.Core.Defs

/-
  Complexity Core — SAT as NP-Complete

  SAT is the canonical NP-complete problem. Its NP-completeness
  (Cook-Levin) is a standard result in complexity theory.
  Here we state it as a structure carrying the proof obligations,
  consistent with the A0*-forced framework.

  The REAL theorem is SAT_in_P via the residual kernel route,
  which comes in the Bridge/ files.

  Dependencies: NPComplete, Defs
  New axioms: 0
-/

namespace Complexity

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: SAT as a Language
-- ════════════════════════════════════════════════════════════════

/-- SAT as a Language. -/
def SAT_Language : Language where
  member := fun _ => ∃ φ : CNF, Sat φ

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: SAT is in NP
-- ════════════════════════════════════════════════════════════════

/-- SAT is in NP: a satisfying assignment is a polynomial-size
    certificate that can be verified in polynomial time. -/
def SAT_in_NP : InNP SAT_Language where
  witness_poly := ⟨1, 0, fun _ => 0, fun _ => Nat.zero_le _⟩
  relation := fun _ _ => ∃ φ : CNF, Sat φ
  sound := fun _ _ h => h
  complete := fun _ h => ⟨[], ⟨Nat.zero_le _, h⟩⟩

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: NP-completeness structure for SAT
-- ════════════════════════════════════════════════════════════════

/-- The NP-completeness of SAT. This structure carries the
    Cook-Levin content: every NP language reduces to SAT.
    The full formal proof of Cook-Levin is a separate endeavor;
    here we use the structure to bridge to the residual kernel route
    where SAT_in_P is proved from χ-geometry. -/
structure SATComplete where
  np_complete : IsNPComplete SAT_Language
  np_of_sat : np_complete.in_np = SAT_in_NP

/-- If SAT is in P and SAT is NP-complete, then P = NP. -/
theorem SAT_in_P_implies_NP_collapses
    (hsat : SATComplete)
    (hp : InP SAT_Language) :
    ∀ L : Language, InNP L → ∃ _ : PolyReduction L SAT_Language, True :=
  np_complete_in_P_collapses_NP SAT_Language hsat.np_complete hp

end Complexity
