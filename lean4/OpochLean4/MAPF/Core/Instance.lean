/-
  MAPF Core — Instance

  General finite MAPF instance: finite motion graph, finite agents,
  start positions, goal assignments. This is the foundation for
  the exact reduction to the residual kernel.

  Not restricted to grids. Not restricted to unit costs.
  General finite graph with arbitrary connectivity.

  New axioms: 0
-/

namespace MAPF

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Finite Graph
-- ════════════════════════════════════════════════════════════════

/-- A finite graph with nV vertices and an adjacency relation.
    Vertices are Fin nV. Adjacency is decidable. -/
structure FiniteGraph (nV : Nat) where
  /-- Adjacency: vertex u is connected to vertex v -/
  adj : Fin nV → Fin nV → Bool
  /-- Self-loops: every vertex is adjacent to itself (wait action) -/
  self_adj : ∀ v, adj v v = true
  /-- Symmetry: if u→v then v→u (undirected graph) -/
  symm : ∀ u v, adj u v = adj v u

/-- A vertex in the graph. -/
abbrev Vertex (nV : Nat) := Fin nV

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: MAPF Instance
-- ════════════════════════════════════════════════════════════════

/-- A finite MAPF instance. Parameterized by:
    - nV: number of vertices
    - nA: number of agents
    - nT: number of tasks -/
structure FiniteMAPFInstance (nV nA nT : Nat) where
  /-- The motion graph -/
  graph : FiniteGraph nV
  /-- Start position of each agent -/
  start : Fin nA → Vertex nV
  /-- Goal assignment: task i has a destination vertex -/
  taskGoal : Fin nT → Vertex nV
  /-- Task source: task i has a source vertex (for pickup-delivery) -/
  taskSource : Fin nT → Vertex nV
  /-- Agents are distinct: no two agents start at the same vertex -/
  starts_distinct : ∀ i j, i ≠ j → start i ≠ start j
  /-- At least one agent and one task -/
  agents_pos : nA ≥ 1
  tasks_pos : nT ≥ 1

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: Schedule (micro execution)
-- ════════════════════════════════════════════════════════════════

/-- A micro schedule: the position of each agent at each time step.
    Schedule a t = position of agent a at time t. -/
def Schedule (nV nA H : Nat) := Fin nA → Fin (H + 1) → Vertex nV

/-- A schedule is valid if each agent's movement respects adjacency. -/
def ScheduleValid {nV nA H : Nat} (G : FiniteGraph nV) (sched : Schedule nV nA H) : Prop :=
  ∀ (a : Fin nA) (t : Fin H),
    G.adj (sched a t.castSucc) (sched a t.succ) = true

/-- A schedule starts correctly if each agent begins at its start position. -/
def ScheduleStartsCorrect {nV nA H : Nat}
    (inst : FiniteMAPFInstance nV nA nT) (sched : Schedule nV nA H) : Prop :=
  ∀ a : Fin nA, sched a ⟨0, Nat.zero_lt_succ H⟩ = inst.start a

-- ════════════════════════════════════════════════════════════════
-- SECTION 4: Conflicts
-- ════════════════════════════════════════════════════════════════

/-- Vertex conflict: two agents at the same vertex at the same time. -/
def HasVertexConflict {nV nA H : Nat} (sched : Schedule nV nA H) : Prop :=
  ∃ (a₁ a₂ : Fin nA) (t : Fin (H + 1)),
    a₁ ≠ a₂ ∧ sched a₁ t = sched a₂ t

/-- Edge/swap conflict: two agents swap positions in one time step. -/
def HasSwapConflict {nV nA H : Nat} (sched : Schedule nV nA H) : Prop :=
  ∃ (a₁ a₂ : Fin nA) (t : Fin H),
    a₁ ≠ a₂ ∧
    sched a₁ t.castSucc = sched a₂ t.succ ∧
    sched a₁ t.succ = sched a₂ t.castSucc

/-- A schedule is conflict-free if it has no vertex or swap conflicts. -/
def ConflictFree {nV nA H : Nat} (sched : Schedule nV nA H) : Prop :=
  ¬HasVertexConflict sched ∧ ¬HasSwapConflict sched

/-- A legal schedule: valid movements, correct starts, conflict-free. -/
structure LegalSchedule {nV nA nT H : Nat}
    (inst : FiniteMAPFInstance nV nA nT) where
  sched : Schedule nV nA H
  valid : ScheduleValid inst.graph sched
  starts : ScheduleStartsCorrect inst sched
  no_conflicts : ConflictFree sched

-- ════════════════════════════════════════════════════════════════
-- SECTION 5: Basic properties
-- ════════════════════════════════════════════════════════════════

/-- A single-agent schedule on a connected graph is always conflict-free. -/
theorem single_agent_no_vertex_conflict {nV H : Nat}
    (sched : Schedule nV 1 H) :
    ¬HasVertexConflict sched := by
  intro ⟨a₁, a₂, _, hne, _⟩
  exact absurd (Fin.ext_iff.mpr (by omega)) hne

/-- The identity schedule (everyone stays at start) is valid if self-loops exist. -/
def staySchedule {nV nA H : Nat} (starts : Fin nA → Vertex nV) : Schedule nV nA H :=
  fun a _ => starts a

theorem staySchedule_valid {nV nA H : Nat} (G : FiniteGraph nV) (starts : Fin nA → Vertex nV) :
    ScheduleValid G (staySchedule (H := H) starts) :=
  fun a _ => G.self_adj (starts a)

end MAPF
