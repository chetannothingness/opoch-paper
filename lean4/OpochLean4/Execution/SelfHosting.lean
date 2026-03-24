/-
  OpochLean4/Execution/SelfHosting.lean — Step 19

  Self-hosting: a system that can verify its own derivation steps.
  Dependencies: Control/Bellman, Algebra/OrderedLedger
  Assumptions: A0star only.

  A self-hosting system encodes each derivation step as a problem tuple,
  verifies it, and produces a receipt. If all steps verify, the system
  is a fixed point: Υ(S) = S.
-/

import OpochLean4.Control.Bellman
import OpochLean4.Algebra.OrderedLedger

namespace SelfHosting

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Verification receipts
-- ═══════════════════════════════════════════════════════════════

-- A verification result for a single derivation step
inductive VerifResult where
  | unique   -- step verified: produces a unique outcome
  | failed   -- step did not verify
deriving DecidableEq, Repr

-- A verification receipt: a step together with its result
structure VerifReceipt where
  stepIndex : Nat
  result : VerifResult

-- A receipt witnesses UNIQUE when its result is unique
def VerifReceipt.isUnique (r : VerifReceipt) : Bool :=
  match r.result with
  | .unique => true
  | .failed => false

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Derivation encoding
-- ═══════════════════════════════════════════════════════════════

-- A derivation step encoded as a problem tuple
structure DerivationStep where
  input : BinString       -- the input encoding
  output : BinString      -- the expected output
  costBound : Nat         -- budget for this step

-- A derivation is a list of steps
abbrev Derivation := List DerivationStep

-- Each derivation step can be encoded as a binary string (problem tuple)
def encodeStep (step : DerivationStep) : BinString :=
  step.input ++ step.output

-- Every derivation step has an encoding
theorem step_encodable (step : DerivationStep) :
    ∃ bs : BinString, bs = encodeStep step :=
  ⟨encodeStep step, rfl⟩

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Verification of a derivation
-- ═══════════════════════════════════════════════════════════════

-- A verifier is a function that checks a derivation step
abbrev Verifier := DerivationStep → VerifResult

-- Apply a verifier to produce receipts for all steps
def verify (v : Verifier) : Derivation → List VerifReceipt
  | [] => []
  | step :: rest =>
    { stepIndex := rest.length, result := v step } :: verify v rest

-- All steps verified means every receipt is unique
def allVerified (receipts : List VerifReceipt) : Prop :=
  ∀ r, r ∈ receipts → r.result = VerifResult.unique

-- allVerified of empty list is trivially true
theorem allVerified_nil : allVerified [] := by
  intro r hr
  exact absurd hr (List.not_mem_nil r)

-- allVerified of cons requires head and tail
theorem allVerified_cons (r : VerifReceipt) (rs : List VerifReceipt)
    (hr : r.result = VerifResult.unique) (hrs : allVerified rs) :
    allVerified (r :: rs) := by
  intro x hx
  cases hx with
  | head => exact hr
  | tail _ htail => exact hrs x htail

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Self-hosting system as fixed point
-- ═══════════════════════════════════════════════════════════════

-- A self-hosting system: a verifier that can verify its own derivation
structure SelfHostingSystem where
  verifier : Verifier
  derivation : Derivation
  receipts : List VerifReceipt
  receipts_eq : receipts = verify verifier derivation
  all_unique : allVerified receipts

-- The fixed-point property: applying the verifier to the derivation
-- produces the same receipts (Υ(S) = S)
theorem fixed_point (sys : SelfHostingSystem) :
    verify sys.verifier sys.derivation = sys.receipts :=
  sys.receipts_eq.symm

-- Verification is deterministic: running the verifier twice gives the same result
theorem verify_deterministic (v : Verifier) (d : Derivation) :
    verify v d = verify v d := rfl

-- In a self-hosting system, every step produces UNIQUE
theorem self_hosting_all_unique (sys : SelfHostingSystem)
    (r : VerifReceipt) (hr : r ∈ sys.receipts) :
    r.result = VerifResult.unique :=
  sys.all_unique r hr

-- ═══════════════════════════════════════════════════════════════
-- SECTION 5: Concrete model — a list of bools all true
-- ═══════════════════════════════════════════════════════════════

-- A concrete verification trace: list of booleans
def allTrue : List Bool → Prop
  | [] => True
  | b :: rest => b = true ∧ allTrue rest

-- allTrue is decidable
def decideAllTrue : (bs : List Bool) → Decidable (allTrue bs)
  | [] => isTrue trivial
  | b :: rest =>
    match b, decideAllTrue rest with
    | true, isTrue h => isTrue ⟨rfl, h⟩
    | true, isFalse h => isFalse (fun ⟨_, hr⟩ => h hr)
    | false, _ => isFalse (fun ⟨hb, _⟩ => Bool.noConfusion hb)

-- A trivial self-hosting system: empty derivation
def trivialSystem : SelfHostingSystem where
  verifier := fun _ => VerifResult.unique
  derivation := []
  receipts := []
  receipts_eq := rfl
  all_unique := allVerified_nil

-- The trivial system is a fixed point
theorem trivial_is_fixed_point :
    verify trivialSystem.verifier trivialSystem.derivation = trivialSystem.receipts :=
  fixed_point trivialSystem

end SelfHosting
