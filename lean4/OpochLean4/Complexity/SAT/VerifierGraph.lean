/-
  OpochLean4/Complexity/SAT/VerifierGraph.lean

  The verifier state graph for SAT.
  Partial assignment verifier: reads bits one by one,
  tracks residual clause state.
  Dependencies: Defs
  Assumptions: None.
-/

import OpochLean4.Complexity.Core.Defs

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Verifier states
-- ═══════════════════════════════════════════════════════════════

/-- The clause status after a partial assignment:
    each clause is either already satisfied, still open, or impossible. -/
inductive ClauseStatus where
  | satisfied   -- at least one literal is true
  | open_       -- no literal yet true, but some unassigned
  | impossible  -- all literals false (no unassigned remain that could help)
deriving DecidableEq, Repr

/-- The verifier state: status of each clause after reading
    the first k assignment bits. -/
structure VerifierState (φ : CNF) where
  /-- How many variables assigned so far. -/
  depth : Nat
  /-- Status of each clause. -/
  clauseStatus : Fin φ.length → ClauseStatus

/-- Initial verifier state: all clauses open. -/
def initState (φ : CNF) : VerifierState φ where
  depth := 0
  clauseStatus := fun _ => .open_

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Verifier transitions
-- ═══════════════════════════════════════════════════════════════

/-- Update a clause's status when variable v is assigned value b. -/
def updateClauseStatus (c : Clause) (cs : ClauseStatus) (v : Nat) (b : Bool) :
    ClauseStatus :=
  match cs with
  | .satisfied => .satisfied  -- already done
  | .impossible => .impossible  -- already failed
  | .open_ =>
    -- Check if any literal in c is satisfied by v := b
    if c.any (fun l => l.var == v && evalLit l (fun i => if i == v then b else false)) then
      .satisfied
    else
      cs  -- still open

/-- Advance the verifier by one bit assignment. -/
def stepVerifier (φ : CNF) (vs : VerifierState φ) (b : Bool) :
    VerifierState φ where
  depth := vs.depth + 1
  clauseStatus := fun i =>
    updateClauseStatus (φ[i]) (vs.clauseStatus i) vs.depth b

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Verifier acceptance
-- ═══════════════════════════════════════════════════════════════

/-- The verifier accepts if all clauses are satisfied. -/
def allClausesSatisfied (φ : CNF) (vs : VerifierState φ) : Bool :=
  decide (∀ i : Fin φ.length, vs.clauseStatus i = .satisfied)

/-- Run the verifier on a sequence of bits from a state. -/
def runVerifier (φ : CNF) (vs : VerifierState φ) : List Bool → VerifierState φ
  | [] => vs
  | b :: rest => runVerifier φ (stepVerifier φ vs b) rest

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Verifier graph structure
-- ═══════════════════════════════════════════════════════════════

/-- The verifier graph is a layered DAG:
    - Layer k = all verifier states after k bits assigned
    - Edges = bit-0 and bit-1 transitions
    - Source = initState
    - Accept = allClausesSatisfied

    An accepting path exists iff the formula is satisfiable. -/
def hasAcceptingPath (φ : CNF) : Prop :=
  ∃ bits : List Bool, allClausesSatisfied φ (runVerifier φ (initState φ) bits) = true
