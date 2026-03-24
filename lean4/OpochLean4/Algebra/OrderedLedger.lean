/-
  OpochLean4/Algebra/OrderedLedger.lean
  Ordered witness ledger. Diamond Law as theorem.
  Dependencies: FiniteCarrier
  Assumptions: A0star only.
-/
import OpochLean4.Foundations.FiniteCarrier

-- State type
opaque State : Type

-- A ledger entry
structure LedgerEntry where
  witness : Witness
  outcome : BinString
  cost : Nat
  update : State → State

-- The ordered ledger
abbrev OrderedLedger := List LedgerEntry

-- Apply a single entry
def applyEntry (e : LedgerEntry) (s : State) : State := e.update s

-- Apply an ordered ledger (left fold)
def applyLedger : OrderedLedger → State → State
  | [], s => s
  | e :: rest, s => applyLedger rest (applyEntry e s)

-- Two entries commute if order doesn't matter
def EntriesCommute (e₁ e₂ : LedgerEntry) : Prop :=
  ∀ s : State, applyEntry e₂ (applyEntry e₁ s) = applyEntry e₁ (applyEntry e₂ s)

-- DIAMOND LAW: commuting entries can be swapped without changing the result.
-- This is a THEOREM, not an axiom.
theorem diamond_law (e₁ e₂ : LedgerEntry) (hcomm : EntriesCommute e₁ e₂) (s : State) :
    applyLedger [e₁, e₂] s = applyLedger [e₂, e₁] s := by
  simp [applyLedger, applyEntry]
  exact hcomm s

-- Noncommutativity: some entries do NOT commute
def NonCommuting (e₁ e₂ : LedgerEntry) : Prop := ¬EntriesCommute e₁ e₂

-- A ledger is fully commutative if all pairs commute
def FullyCommutative (L : OrderedLedger) : Prop :=
  ∀ e₁ e₂, e₁ ∈ L → e₂ ∈ L → EntriesCommute e₁ e₂

-- Appending to the ledger
def appendEntry (L : OrderedLedger) (e : LedgerEntry) : OrderedLedger := L ++ [e]

-- Appending preserves all existing entries
theorem append_preserves (L : OrderedLedger) (e : LedgerEntry) :
    ∀ x, x ∈ L → x ∈ appendEntry L e := by
  intro x hx
  simp [appendEntry]
  exact Or.inl hx

-- Commutativity of EntriesCommute is symmetric
theorem entries_commute_symm (e₁ e₂ : LedgerEntry) (h : EntriesCommute e₁ e₂) :
    EntriesCommute e₂ e₁ := by
  intro s
  exact (h s).symm

-- Empty ledger is identity
theorem applyLedger_nil (s : State) : applyLedger [] s = s := rfl

-- Single entry
theorem applyLedger_singleton (e : LedgerEntry) (s : State) :
    applyLedger [e] s = applyEntry e s := rfl
