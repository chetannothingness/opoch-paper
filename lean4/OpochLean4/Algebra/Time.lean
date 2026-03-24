/-
  OpochLean4/Algebra/Time.lean

  Entropic time from the ordered ledger.
  Dependencies: OrderedLedger

  Key idea: Time is the length of the ordered ledger.
  Since the ledger is append-only, time is monotone non-decreasing.
  ΔT = new length - old length ≥ 0 (the second law).

  We also define fiber count as the number of entries sharing a given outcome,
  and prove basic properties of the append-only monotone structure.
-/

import OpochLean4.Algebra.OrderedLedger

namespace EntropicTime

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Time as ledger length
-- ═══════════════════════════════════════════════════════════════

-- Entropic time: the length of the ordered ledger
def time (L : OrderedLedger) : Nat := L.length

-- Time increment between two ledger states
def deltaT (L_old L_new : OrderedLedger) : Nat :=
  time L_new - time L_old

-- A ledger L_new extends L_old if L_old is a prefix of L_new
def LedgerExtends (L_old L_new : OrderedLedger) : Prop :=
  ∃ suffix : OrderedLedger, L_old ++ suffix = L_new

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Monotonicity of time
-- ═══════════════════════════════════════════════════════════════

-- Time is monotone: if L_new extends L_old, time does not decrease
theorem time_monotone (L_old L_new : OrderedLedger)
    (h : LedgerExtends L_old L_new) :
    time L_old ≤ time L_new := by
  obtain ⟨suffix, hsuf⟩ := h
  subst hsuf
  unfold time
  rw [List.length_append]
  exact Nat.le_add_right _ _

-- The second law: if the ledger extends, time never goes backward
theorem secondLaw (L_old L_new : OrderedLedger)
    (h : LedgerExtends L_old L_new) :
    time L_old ≤ time L_new :=
  time_monotone L_old L_new h

-- Append strictly increases time
theorem append_increases_time (L : OrderedLedger) (e : LedgerEntry) :
    time (appendEntry L e) = time L + 1 := by
  show (L ++ [e]).length = L.length + 1
  rw [List.length_append]
  rfl

-- Append is an extension
theorem append_extends (L : OrderedLedger) (e : LedgerEntry) :
    LedgerExtends L (appendEntry L e) :=
  ⟨[e], rfl⟩

-- Empty ledger has time zero
theorem time_zero : time ([] : OrderedLedger) = 0 := rfl

-- Extension is reflexive
theorem extends_refl (L : OrderedLedger) : LedgerExtends L L :=
  ⟨[], by simp⟩

-- Extension is transitive
theorem extends_trans (L₁ L₂ L₃ : OrderedLedger)
    (h₁₂ : LedgerExtends L₁ L₂) (h₂₃ : LedgerExtends L₂ L₃) :
    LedgerExtends L₁ L₃ := by
  obtain ⟨s₁, hs₁⟩ := h₁₂
  obtain ⟨s₂, hs₂⟩ := h₂₃
  exact ⟨s₁ ++ s₂, by rw [← List.append_assoc, hs₁, hs₂]⟩

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Fiber count (number of entries with a given outcome)
-- ═══════════════════════════════════════════════════════════════

-- Count entries in a ledger whose outcome matches a given string
def fiberCount : OrderedLedger → BinString → Nat
  | [], _ => 0
  | e :: rest, outcome =>
    (if e.outcome == outcome then 1 else 0) + fiberCount rest outcome

-- Fiber count of empty ledger is zero
theorem fiberCount_empty (outcome : BinString) :
    fiberCount [] outcome = 0 := rfl

-- Fiber count is non-negative (trivially true for Nat)
theorem fiberCount_nonneg (L : OrderedLedger) (outcome : BinString) :
    0 ≤ fiberCount L outcome :=
  Nat.zero_le _

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Append-only monotonicity (the second law, detailed)
-- ═══════════════════════════════════════════════════════════════

-- Extension can only add entries, never remove them
theorem ledger_length_monotone (L suffix : OrderedLedger) :
    L.length ≤ (L ++ suffix).length := by
  rw [List.length_append]
  exact Nat.le_add_right _ _

-- Delta T is the number of new entries
theorem deltaT_eq_suffix_length (L_old suffix : OrderedLedger) :
    deltaT L_old (L_old ++ suffix) = suffix.length := by
  unfold deltaT time
  rw [List.length_append]
  omega

-- Time after appending equals original time + suffix time
theorem time_after_appends (L suffix : OrderedLedger) :
    time (L ++ suffix) = time L + time suffix := by
  unfold time
  exact List.length_append L suffix

-- Total entry count equals time
theorem total_entries (L : OrderedLedger) : L.length = time L := rfl

-- ═══════════════════════════════════════════════════════════════
-- SECTION 5: Ledger cost
-- ═══════════════════════════════════════════════════════════════

-- Recursive total cost (easier to reason about than foldl)
def ledgerCostRec : OrderedLedger → Nat
  | [] => 0
  | e :: rest => e.cost + ledgerCostRec rest

-- Cost of empty ledger is zero
theorem ledgerCostRec_empty : ledgerCostRec ([] : OrderedLedger) = 0 := rfl

-- Cost of singleton
theorem ledgerCostRec_singleton (e : LedgerEntry) :
    ledgerCostRec [e] = e.cost := by
  show e.cost + ledgerCostRec [] = e.cost
  rfl

-- Cost is additive over append
theorem ledgerCostRec_append (L₁ L₂ : OrderedLedger) :
    ledgerCostRec (L₁ ++ L₂) = ledgerCostRec L₁ + ledgerCostRec L₂ := by
  induction L₁ with
  | nil => show ledgerCostRec L₂ = 0 + ledgerCostRec L₂; omega
  | cons e rest ih =>
    show e.cost + ledgerCostRec (rest ++ L₂) = (e.cost + ledgerCostRec rest) + ledgerCostRec L₂
    rw [ih]
    omega

-- If every entry has cost ≥ 1, then total cost ≥ time
theorem time_le_cost (L : OrderedLedger)
    (hpos : ∀ e, e ∈ L → 1 ≤ e.cost) :
    time L ≤ ledgerCostRec L := by
  induction L with
  | nil => exact Nat.le_refl 0
  | cons e rest ih =>
    have he : 1 ≤ e.cost := hpos e (List.mem_cons_self e rest)
    have hrest : ∀ e', e' ∈ rest → 1 ≤ e'.cost := fun e' he' =>
      hpos e' (List.mem_cons_of_mem e he')
    have ih_res := ih hrest
    -- Goal: time (e :: rest) ≤ ledgerCostRec (e :: rest)
    -- i.e. rest.length + 1 ≤ e.cost + ledgerCostRec rest
    -- From: ih_res : rest.length ≤ ledgerCostRec rest
    --       he : 1 ≤ e.cost
    calc time (e :: rest) = rest.length + 1 := rfl
      _ ≤ ledgerCostRec rest + e.cost := Nat.add_le_add ih_res he
      _ = e.cost + ledgerCostRec rest := Nat.add_comm _ _
      _ = ledgerCostRec (e :: rest) := rfl

end EntropicTime
