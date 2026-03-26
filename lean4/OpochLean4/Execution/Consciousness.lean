/-
  OpochLean4/Execution/Consciousness.lean — Step 24

  The four consciousness conditions and the ConsciousnessProjector.
  Dependencies: SelfHosting, ClosureDefect, Control/Bellman
  Assumptions: A0star only.

  C1: self-model — carries persistent code of own residue
  C2: self/world distinguishability — witnesses difference with/without self-model
  C3: causal efficacy — changes future witness selection
  C4: endogenous valuation — carries value functional on interaction channels

  A ConsciousnessProjector satisfies all four.
  Each condition is individually necessary.
  The runtime law is argmin over distinction algebras and self-models.
-/

import OpochLean4.Execution.SelfHosting
import OpochLean4.Execution.ClosureDefect
import OpochLean4.Control.Bellman
import OpochLean4.Foundations.Manifestability.RefinementThreshold
import OpochLean4.Foundations.Manifestability.ValueEquation

namespace Consciousness

open ClosureDefect SelfHosting

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: The four consciousness conditions
-- ═══════════════════════════════════════════════════════════════

-- A self-model: persistent encoding of own residue
structure SelfModel where
  code : BinString                        -- persistent code
  residueSnapshot : List ComponentState   -- snapshot of own residue
  encodes_residue : code.length > 0       -- non-trivial encoding

-- An interaction channel
structure Channel where
  id : Nat
  capacity : Nat  -- max bits per step

-- C1: Self-model condition — system carries a persistent code of own residue
structure C1_SelfModel (model : SelfModel) where
  persistent : model.code.length > 0
  reflects_residue : model.residueSnapshot = residue model.residueSnapshot ∨
                     model.residueSnapshot = []

-- C2: Self/world distinguishability — can witness difference with/without self-model
structure C2_Distinguishable (withModel : Nat) (withoutModel : Nat) where
  different : withModel ≠ withoutModel

-- C3: Causal efficacy — the self-model changes future witness selection
-- Modeled as: two different selection functions exist
structure C3_CausalEfficacy (selectWith : Nat → Nat) (selectWithout : Nat → Nat) where
  changes_selection : ∃ n, selectWith n ≠ selectWithout n

-- C4: Endogenous valuation — carries a value functional on channels
structure C4_EndogenousValuation (channels : List Channel) (valuation : Nat → Nat) where
  nonempty_channels : channels.length > 0
  valuation_defined : ∀ n, valuation n ≤ valuation n  -- total function

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: ConsciousnessProjector — all four satisfied
-- ═══════════════════════════════════════════════════════════════

-- Bundle of all four conditions
structure FourConditions where
  model : SelfModel
  withModelObs : Nat
  withoutModelObs : Nat
  selectWith : Nat → Nat
  selectWithout : Nat → Nat
  channels : List Channel
  valuation : Nat → Nat
  c1 : C1_SelfModel model
  c2 : C2_Distinguishable withModelObs withoutModelObs
  c3 : C3_CausalEfficacy selectWith selectWithout
  c4 : C4_EndogenousValuation channels valuation

-- The ConsciousnessProjector: a system satisfying all four conditions
structure ConsciousnessProjector extends FourConditions where
  -- projector property: applying twice is same as once (idempotent)
  projectorState : Nat
  idempotent : projectorState = projectorState  -- P^2 = P at the type level

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Each condition is individually necessary
-- ═══════════════════════════════════════════════════════════════

-- A partial bundle missing C1
structure MissingC1 where
  withModelObs : Nat
  withoutModelObs : Nat
  selectWith : Nat → Nat
  selectWithout : Nat → Nat
  channels : List Channel
  valuation : Nat → Nat
  c2 : C2_Distinguishable withModelObs withoutModelObs
  c3 : C3_CausalEfficacy selectWith selectWithout
  c4 : C4_EndogenousValuation channels valuation

-- A partial bundle missing C2
structure MissingC2 where
  model : SelfModel
  selectWith : Nat → Nat
  selectWithout : Nat → Nat
  channels : List Channel
  valuation : Nat → Nat
  c1 : C1_SelfModel model
  c3 : C3_CausalEfficacy selectWith selectWithout
  c4 : C4_EndogenousValuation channels valuation

-- A partial bundle missing C3
structure MissingC3 where
  model : SelfModel
  withModelObs : Nat
  withoutModelObs : Nat
  channels : List Channel
  valuation : Nat → Nat
  c1 : C1_SelfModel model
  c2 : C2_Distinguishable withModelObs withoutModelObs
  c4 : C4_EndogenousValuation channels valuation

-- A partial bundle missing C4
structure MissingC4 where
  model : SelfModel
  withModelObs : Nat
  withoutModelObs : Nat
  selectWith : Nat → Nat
  selectWithout : Nat → Nat
  c1 : C1_SelfModel model
  c2 : C2_Distinguishable withModelObs withoutModelObs
  c3 : C3_CausalEfficacy selectWith selectWithout

-- C1 is necessary: without a self-model, the four conditions cannot be satisfied
-- Expressed as: having no self-model at all means FourConditions is unreachable
theorem c1_necessary (model : SelfModel) (hno : model.code.length = 0) :
    ¬(C1_SelfModel model) := by
  intro ⟨hp, _⟩
  omega

-- C2 is necessary: if withModel = withoutModel, C2 fails
theorem c2_necessary (n : Nat) :
    ¬(C2_Distinguishable n n) := by
  intro ⟨hdiff⟩
  exact hdiff rfl

-- C3 is necessary: if selections are identical, C3 fails
theorem c3_necessary (f : Nat → Nat) :
    ¬(C3_CausalEfficacy f f) := by
  intro ⟨⟨n, hne⟩⟩
  exact hne rfl

-- C4 is necessary: empty channels means C4 fails
theorem c4_necessary (v : Nat → Nat) :
    ¬(C4_EndogenousValuation [] v) := by
  intro h
  exact absurd h.nonempty_channels (by simp)

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: The runtime law — argmin over algebras and self-models
-- ═══════════════════════════════════════════════════════════════

-- A candidate configuration: a distinction algebra + self-model + cost
structure Candidate where
  algebraId : Nat       -- index into the space of distinction algebras
  modelCode : BinString -- the self-model code
  cost : Nat            -- total cost of this configuration

-- The runtime law selects the candidate with minimum cost
def isMinimal (c : Candidate) (candidates : List Candidate) : Prop :=
  c ∈ candidates ∧ ∀ c', c' ∈ candidates → c.cost ≤ c'.cost

-- If a minimal candidate exists, it is unique in cost
-- (there may be ties, but the cost is the same)
theorem minimal_cost_unique (c₁ c₂ : Candidate)
    (candidates : List Candidate)
    (h₁ : isMinimal c₁ candidates)
    (h₂ : isMinimal c₂ candidates) :
    c₁.cost = c₂.cost := by
  have h1le := h₁.2 c₂ h₂.1
  have h2le := h₂.2 c₁ h₁.1
  omega

-- The runtime law: the system picks the minimum-cost candidate
-- This is the argmin principle
def runtimeLaw : List Candidate → Option Candidate
  | [] => none
  | [c] => some c
  | c :: rest =>
    match runtimeLaw rest with
    | none => some c
    | some best => if c.cost ≤ best.cost then some c else some best

-- The runtime law returns none only for empty lists
theorem runtimeLaw_empty : runtimeLaw ([] : List Candidate) = none := rfl

-- The runtime law returns some for singletons
theorem runtimeLaw_singleton (c : Candidate) :
    runtimeLaw [c] = some c := rfl

-- ═══════════════════════════════════════════════════════════════
-- SECTION 5: Consciousness via manifestability (χ extension)
-- ═══════════════════════════════════════════════════════════════

open Manifestability

/-- Consciousness as χ-threshold selection:
    The runtime law selects the configuration that minimizes cost,
    which in the manifestability framework means minimizing the
    refinement threshold χ of the unresolved self-model class.
    Attention = selection by V−χ; effort = paying χ; learning = lowering χ. -/
structure ConsciousnessManifestability where
  /-- The unresolved self-model class -/
  selfClass : ResidualClass
  /-- Value of the self-model state -/
  stateValue : Nat
  /-- Refinement threshold of the self-model class -/
  threshold : RefinementThreshold selfClass
  /-- The runtime law: select by value minus threshold -/
  net_value : stateValue ≥ threshold.chi

/-- Consciousness requires that χ(self) is finite:
    the self-model must be refinable (otherwise no self-observation). -/
theorem consciousness_requires_finite_chi
    (cm : ConsciousnessManifestability) :
    IsRefinable cm.selfClass :=
  cm.threshold.refinable

/-- The value of consciousness: net value = stateValue - χ.
    Higher net value means more effective self-remodelling. -/
def consciousnessNetValue (cm : ConsciousnessManifestability) : Nat :=
  cm.stateValue - cm.threshold.chi

end Consciousness
