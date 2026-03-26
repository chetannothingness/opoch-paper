import OpochLean4.MAPF.Semantics.Occupancy

/-
  MAPF Semantics — Vacancy (Defect) Field

  h_t(v) = capacity(v) - o_t(v): the number of empty slots at vertex v.
  This is the dual view: instead of tracking agents, track vacancies.
  The vacancy field IS the closure defect of the MAPF system.

  New axioms: 0
-/

namespace MAPF.Semantics

/-- Vacancy at vertex v at time t: capacity minus occupancy.
    In standard MAPF (unit capacity), vacancy ∈ {0, 1}. -/
def vacancy {nV nA H : Nat} (sched : Schedule nV nA H)
    (t : Fin (H + 1)) (v : Vertex nV) : Nat :=
  vertexCapacity v - occupancy sched t v

/-- Vacancy duality: occupancy + vacancy = capacity. -/
theorem vacancy_duality_exact {nV nA H : Nat}
    (sched : Schedule nV nA H) (t : Fin (H + 1)) (v : Vertex nV)
    (h : occupancy sched t v ≤ vertexCapacity v) :
    occupancy sched t v + vacancy sched t v = vertexCapacity v := by
  simp [vacancy]; omega

/-- A vertex is vacant iff no agent occupies it. -/
def isVacant {nV nA H : Nat} (sched : Schedule nV nA H)
    (t : Fin (H + 1)) (v : Vertex nV) : Bool :=
  occupancy sched t v == 0

/-- A vertex is occupied iff at least one agent is there. -/
def isOccupied {nV nA H : Nat} (sched : Schedule nV nA H)
    (t : Fin (H + 1)) (v : Vertex nV) : Bool :=
  occupancy sched t v > 0

end MAPF.Semantics
