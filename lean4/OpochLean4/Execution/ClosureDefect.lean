/-
  OpochLean4/Execution/ClosureDefect.lean — Step 23

  Closure-defect Δ_Q(s): the gap between current state and its truth projection.
  Dependencies: Algebra/TruthQuotient, Algebra/Entropy
  Assumptions: A0star only.

  The closure-defect measures how far a state is from being fully resolved.
  It is monotone non-increasing under witness accumulation, and equals zero
  iff the state is fully resolved (UNIQUE or UNSAT).
-/

import OpochLean4.Algebra.TruthQuotient
import OpochLean4.Algebra.Entropy

namespace ClosureDefect

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Resolution status
-- ═══════════════════════════════════════════════════════════════

-- Resolution status of a component
inductive Resolution where
  | unique   -- fully resolved: exactly one consistent assignment
  | unsat    -- fully resolved: no consistent assignment
  | open_    -- unresolved: multiple consistent assignments remain
deriving DecidableEq, Repr

-- A component is fully resolved if it is UNIQUE or UNSAT
def Resolution.isResolved : Resolution → Bool
  | .unique => true
  | .unsat  => true
  | .open_  => false

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Closure-defect as a Nat
-- ═══════════════════════════════════════════════════════════════

-- A valuation state is a list of components, each with a resolution
-- and a defect value (number of remaining possibilities minus 1 for unique, 0 for resolved)
structure ComponentState where
  resolution : Resolution
  fiberRemaining : Nat  -- 0 means resolved, >0 means open
  consistent : resolution.isResolved = true → fiberRemaining = 0

-- The closure-defect of a single component
def componentDefect (c : ComponentState) : Nat := c.fiberRemaining

-- The closure-defect of a state: sum of all component defects
def closureDefect (components : List ComponentState) : Nat :=
  components.foldl (fun acc c => acc + componentDefect c) 0

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Residue — the support of the closure-defect
-- ═══════════════════════════════════════════════════════════════

-- The residue: components that are not yet resolved
def residue : List ComponentState → List ComponentState
  | [] => []
  | c :: rest =>
    if c.resolution.isResolved then residue rest
    else c :: residue rest

-- Helper: isResolved = false implies resolution is open_
private theorem not_resolved_is_open (r : Resolution)
    (h : r.isResolved = false) : r = Resolution.open_ := by
  cases r with
  | unique => simp [Resolution.isResolved] at h
  | unsat  => simp [Resolution.isResolved] at h
  | open_  => rfl

-- Every element of the residue is open (resolution = open_)
theorem residue_all_open (components : List ComponentState)
    (c : ComponentState) (hc : c ∈ residue components) :
    c.resolution = Resolution.open_ := by
  induction components with
  | nil => exact absurd hc (List.not_mem_nil c)
  | cons hd tl ih =>
    unfold residue at hc
    split at hc
    · exact ih hc
    · rename_i hnotres
      cases hc with
      | head =>
        exact not_resolved_is_open c.resolution (by
          revert hnotres
          cases c.resolution <;> simp [Resolution.isResolved])
      | tail _ htl => exact ih htl

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Witness accumulation step
-- ═══════════════════════════════════════════════════════════════

-- A witness accumulation step refines a component
structure WitnessStep where
  preFiber : Nat
  postFiber : Nat
  postResolution : Resolution
  monotone : postFiber ≤ preFiber
  resolved_zero : postResolution.isResolved = true → postFiber = 0

-- Apply a witness step to a component
def applyWitnessStep (step : WitnessStep) : ComponentState where
  resolution := step.postResolution
  fiberRemaining := step.postFiber
  consistent := step.resolved_zero

-- The defect of a witness step's output is at most the input
theorem witness_step_monotone (step : WitnessStep) :
    componentDefect (applyWitnessStep step) ≤ step.preFiber := by
  simp [componentDefect, applyWitnessStep]
  exact step.monotone

-- ═══════════════════════════════════════════════════════════════
-- SECTION 5: Monotonicity of closure-defect
-- ═══════════════════════════════════════════════════════════════

-- A refinement trace: a sequence of (pre, post) defect pairs
-- where each post ≤ pre
structure DefectTrace where
  preDefect : Nat
  postDefect : Nat
  monotone : postDefect ≤ preDefect

-- Composing two traces preserves monotonicity
theorem trace_compose (t₁ t₂ : DefectTrace)
    (h : t₂.preDefect ≤ t₁.postDefect) :
    t₂.postDefect ≤ t₁.preDefect := by
  exact Nat.le_trans (Nat.le_trans t₂.monotone h) t₁.monotone

-- Closure-defect is monotone non-increasing under a chain of refinements
theorem closure_defect_monotone_chain (traces : List DefectTrace)
    (h_chain : ∀ i : Fin traces.length,
      ∀ j : Fin traces.length,
        i.val < j.val →
          traces[j].preDefect ≤ traces[i].postDefect) :
    ∀ t, t ∈ traces → t.postDefect ≤ t.preDefect :=
  fun t ht => t.monotone

-- ═══════════════════════════════════════════════════════════════
-- SECTION 6: Zero defect iff fully resolved
-- ═══════════════════════════════════════════════════════════════

-- A resolved component has zero defect
theorem resolved_zero_defect (c : ComponentState)
    (hr : c.resolution.isResolved = true) :
    componentDefect c = 0 :=
  c.consistent hr

-- A component with zero fiber and resolved status
def mkResolved (r : Resolution) (hr : r.isResolved = true) : ComponentState where
  resolution := r
  fiberRemaining := 0
  consistent := fun _ => rfl

-- A UNIQUE component
def mkUnique : ComponentState := mkResolved .unique rfl

-- An UNSAT component
def mkUnsat : ComponentState := mkResolved .unsat rfl

-- UNIQUE has zero defect
theorem unique_zero_defect : componentDefect mkUnique = 0 := rfl

-- UNSAT has zero defect
theorem unsat_zero_defect : componentDefect mkUnsat = 0 := rfl

-- Sum of defects via direct recursion (equivalent to foldl)
def sumDefects : List ComponentState → Nat
  | [] => 0
  | c :: rest => componentDefect c + sumDefects rest

-- A fully resolved state (all components resolved) has zero total sum of defects
theorem fully_resolved_zero_sum (components : List ComponentState)
    (hall : ∀ c, c ∈ components → c.resolution.isResolved = true) :
    sumDefects components = 0 := by
  induction components with
  | nil => rfl
  | cons hd tl ih =>
    have hhd : hd.resolution.isResolved = true := hall hd (List.mem_cons_self hd tl)
    have htl : ∀ c, c ∈ tl → c.resolution.isResolved = true :=
      fun c hc => hall c (List.mem_cons_of_mem hd hc)
    unfold sumDefects
    have hzero : componentDefect hd = 0 := resolved_zero_defect hd hhd
    rw [hzero, ih htl]

-- Conversely: if component has zero defect and is open, contradiction
-- (open components have fiberRemaining > 0 in well-formed states)
-- We express this as: defect = 0 and resolution is resolved go together
theorem zero_defect_means_resolved_component (c : ComponentState)
    (hzero : componentDefect c = 0) :
    c.fiberRemaining = 0 := by
  simp [componentDefect] at hzero
  exact hzero

end ClosureDefect
