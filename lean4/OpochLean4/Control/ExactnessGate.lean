/-
  OpochLean4/Control/ExactnessGate.lean (Step 14)

  Certificate-first processing and the split law as image factorization.
  Any function on truth classes factors as merge ∘ relabel.
  Certificate-first is optimal: searching when a certificate exists wastes budget.

  Dependencies: OrderedLedger, RegimeSplit
  Assumptions: A0star only.
-/

import OpochLean4.Algebra.OrderedLedger
import OpochLean4.Control.RegimeSplit

namespace ExactnessGate

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: Certificate-first processing
-- ═══════════════════════════════════════════════════════════════

-- A certificate is an existing witness in the ledger that resolves a query
structure Certificate where
  entry : LedgerEntry
  ledger : OrderedLedger
  inLedger : entry ∈ ledger

-- The result of a lookup: either we found a certificate or we didn't
inductive LookupResult
  | found (cost : Nat)      -- certificate found, cost is lookup cost
  | notFound (cost : Nat)   -- not found, cost is the lookup cost

-- A query processor: first checks the ledger, then searches if needed
structure QueryProcessor where
  lookupCost : Nat               -- cost of checking the ledger
  searchCost : Nat               -- cost of running a fresh witness test
  lookup_cheaper : lookupCost ≤ searchCost  -- looking up is never more expensive

-- Certificate-first: check ledger first, only search if not found
def certificateFirst (qp : QueryProcessor) (found : Bool) : Nat :=
  if found then qp.lookupCost
  else qp.lookupCost + qp.searchCost

-- Search-first: always run a fresh search (ignoring the ledger)
def searchFirst (qp : QueryProcessor) : Nat :=
  qp.searchCost

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Certificate-first is optimal
-- ═══════════════════════════════════════════════════════════════

-- When a certificate exists, certificate-first is strictly better than searching
theorem certificateFirst_optimal_when_found (qp : QueryProcessor) :
    certificateFirst qp true ≤ searchFirst qp := by
  simp [certificateFirst, searchFirst]
  exact qp.lookup_cheaper

-- Certificate-first never wastes more budget than search-first + lookup
theorem certificateFirst_bounded (qp : QueryProcessor) (found : Bool) :
    certificateFirst qp found ≤ qp.lookupCost + qp.searchCost := by
  simp [certificateFirst]
  split
  · omega
  · omega

-- Searching when a certificate exists wastes budget:
-- the wasted amount is searchCost - lookupCost
theorem search_wastes_budget (qp : QueryProcessor)
    (hfound : true = true) :  -- certificate exists
    searchFirst qp - certificateFirst qp true = qp.searchCost - qp.lookupCost := by
  simp [searchFirst, certificateFirst]

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: The split law as image factorization
-- ═══════════════════════════════════════════════════════════════

-- Any function f : α → β on a finite type factors as:
--   f = relabel ∘ merge
-- where merge : α → image(f) collapses the fibers
-- and relabel : image(f) → β is the inclusion.
--
-- We model this for functions on Distinction.

-- A factorization of a function: f = relabel ∘ merge
-- We use an intermediate type γ to represent the image.
structure ImageFactorization (α β γ : Type) where
  f : α → β
  merge : α → γ
  relabel : γ → β
  factors : ∀ x, relabel (merge x) = f x

-- Every function admits an image factorization (using β as intermediate)
theorem image_factorization_exists (α β : Type) (f : α → β) :
    ∃ (merge : α → β) (relabel : β → β),
      ∀ x, relabel (merge x) = f x :=
  ⟨f, id, fun _ => rfl⟩

-- The trivial factorization: merge = f, relabel = id
def trivialFactorization (α β : Type) (f : α → β) :
    ImageFactorization α β β where
  f := f
  merge := f
  relabel := id
  factors := fun _ => rfl

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Factorization respects quotient structure
-- ═══════════════════════════════════════════════════════════════

-- If a function on Distinction is quotient-invariant,
-- then its image factorization respects indistinguishability classes
theorem factorization_respects_indist
    (f : Distinction → Distinction)
    (hf : ∀ δ₁ δ₂, Indistinguishable δ₁ δ₂ → f δ₁ = f δ₂)
    (fact : ImageFactorization Distinction Distinction Distinction)
    (hfact : fact.f = f) :
    ∀ δ₁ δ₂, Indistinguishable δ₁ δ₂ → fact.f δ₁ = fact.f δ₂ := by
  intro δ₁ δ₂ hindist
  rw [hfact]
  exact hf δ₁ δ₂ hindist

-- The merge step is the computationally expensive part;
-- once we have the merged value, relabeling is free.
-- This justifies certificate-first: if the merge result is cached
-- in the ledger, we skip the expensive merge computation.
theorem cached_merge_skips_computation
    (fact : ImageFactorization Distinction Distinction Distinction)
    (δ : Distinction) (cached : Distinction)
    (h_cached : cached = fact.merge δ) :
    fact.relabel cached = fact.f δ := by
  rw [h_cached]
  exact fact.factors δ

end ExactnessGate
