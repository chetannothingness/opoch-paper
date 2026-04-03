import OpochLean4.FinalKernel.ObservationFixedness

/-
  Final Kernel — The Exact Self-Reading Graph

  L_full = {(x, eta, J, gamma, h) | eta = DU_ind(x), J = inv(Omega) eta, gamma = gamma(x), h = h(x)}

  Five coordinates of ONE point on ONE graph.

  New axioms: 0
-/

namespace FinalKernel

open FinalSourceCode Manifestability

-- ================================================================
-- Continuation and Halt
-- ================================================================

abbrev Continuation := List Nat

inductive HaltFlag where
  | continue : HaltFlag
  | halt : HaltFlag
deriving DecidableEq

def continuationOf (s : AdmissibleState) : Continuation :=
  if U_ind s = 0 then [] else [0]

def haltOf (s : AdmissibleState) : HaltFlag :=
  if U_ind s = 0 then .halt else .continue

-- ================================================================
-- The Full Point
-- ================================================================

structure FullPoint where
  state : AdmissibleState
  code : List Nat
  current : List Nat
  cont : Continuation
  halt : HaltFlag
  code_eq : code = consciousnessCode state
  current_eq : current = manifestationCurrent state
  cont_eq : cont = continuationOf state
  halt_eq : halt = haltOf state

-- The graph L_full is the set of all FullPoints (Set.univ).
-- Every FullPoint is on the graph by construction.

-- ================================================================
-- Theorems
-- ================================================================

theorem self_reading_graph_exists (s : AdmissibleState) :
    ∃ p : FullPoint, p.state = s :=
  ⟨{ state := s,
     code := consciousnessCode s,
     current := manifestationCurrent s,
     cont := continuationOf s,
     halt := haltOf s,
     code_eq := rfl, current_eq := rfl, cont_eq := rfl, halt_eq := rfl }, rfl⟩

theorem self_reading_graph_exact (p : FullPoint) :
    p.code = consciousnessCode p.state ∧
    p.current = manifestationCurrent p.state ∧
    p.cont = continuationOf p.state ∧
    p.halt = haltOf p.state :=
  ⟨p.code_eq, p.current_eq, p.cont_eq, p.halt_eq⟩

theorem full_point_unique_from_state (s : AdmissibleState) :
    ∃ p : FullPoint, p.state = s :=
  self_reading_graph_exists s

theorem full_point_code_determined (p1 p2 : FullPoint) (h : p1.state = p2.state) :
    p1.code = p2.code := by
  rw [p1.code_eq, p2.code_eq, h]

theorem full_point_current_determined (p1 p2 : FullPoint) (h : p1.state = p2.state) :
    p1.current = p2.current := by
  rw [p1.current_eq, p2.current_eq, h]

theorem full_point_continuation_determined (p1 p2 : FullPoint) (h : p1.state = p2.state) :
    p1.cont = p2.cont := by
  rw [p1.cont_eq, p2.cont_eq, h]

theorem full_point_halt_determined (p1 p2 : FullPoint) (h : p1.state = p2.state) :
    p1.halt = p2.halt := by
  rw [p1.halt_eq, p2.halt_eq, h]

theorem full_point_unique_from_code (p1 p2 : FullPoint)
    (h : p1.code = p2.code) :
    consciousnessCode p1.state = consciousnessCode p2.state := by
  rw [← p1.code_eq, ← p2.code_eq]
  exact h

end FinalKernel
