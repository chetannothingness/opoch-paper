/-
  OpochLean4/Execution/BinaryInterface.lean — Step 20

  All communication is encoded via sd (self-delimiting).
  Dependencies: Foundations/PrefixFree, Execution/SelfHosting
  Assumptions: A0star only.

  The interface is complete: every finite object is encodable.
  The interface is self-describing: no external framing needed.
-/

import OpochLean4.Foundations.PrefixFree
import OpochLean4.Execution.SelfHosting

namespace BinaryInterface

-- ═══════════════════════════════════════════════════════════════
-- SECTION 1: SD-encoded communication
-- ═══════════════════════════════════════════════════════════════

-- A message is an sd-encoded binary string
structure SDMessage where
  payload : BinString
  encoded : BinString
  encoding_eq : encoded = sd payload

-- Construct an SDMessage from any binary string
def mkMessage (s : BinString) : SDMessage where
  payload := s
  encoded := sd s
  encoding_eq := rfl

-- ═══════════════════════════════════════════════════════════════
-- SECTION 2: Completeness — every finite object is encodable
-- ═══════════════════════════════════════════════════════════════

-- Every binary string can be encoded as an SDMessage
theorem interface_complete (s : BinString) :
    ∃ msg : SDMessage, msg.payload = s :=
  ⟨mkMessage s, rfl⟩

-- Every pair of binary strings can be encoded (by concatenating sd encodings)
def encodePair (s t : BinString) : BinString :=
  sd s ++ sd t

-- Helper: if two lists of equal length, when appended with suffixes, yield the same result,
-- then the two prefixes are equal and the suffixes are equal
theorem list_append_cancel {α : Type} (a b c d : List α)
    (hlen : a.length = b.length)
    (h : a ++ c = b ++ d) :
    a = b ∧ c = d := by
  induction a generalizing b with
  | nil =>
    cases b with
    | nil => exact ⟨rfl, h⟩
    | cons _ _ => simp at hlen
  | cons x xs ih =>
    cases b with
    | nil => simp at hlen
    | cons y ys =>
      simp [List.cons_append] at h
      obtain ⟨hxy, hrest⟩ := h
      simp at hlen
      have ⟨hxsys, hcd⟩ := ih ys hlen hrest
      exact ⟨by rw [hxy, hxsys], hcd⟩

-- Pairs are decodable: when payload lengths match, both components are recoverable
theorem pair_injective (s₁ t₁ s₂ t₂ : BinString)
    (hlen : s₁.length = s₂.length)
    (h : encodePair s₁ t₁ = encodePair s₂ t₂) :
    s₁ = s₂ ∧ t₁ = t₂ := by
  simp [encodePair] at h
  have hsd_len : (sd s₁).length = (sd s₂).length := by
    simp [sd_length, hlen]
  have ⟨hsd_eq, htail⟩ := list_append_cancel (sd s₁) (sd s₂) (sd t₁) (sd t₂) hsd_len h
  exact ⟨sd_injective s₁ s₂ hsd_eq, sd_injective t₁ t₂ htail⟩

-- ═══════════════════════════════════════════════════════════════
-- SECTION 3: Self-describing — no external framing needed
-- ═══════════════════════════════════════════════════════════════

-- sd encoding carries its own length: the first run of 1s tells
-- you how many data bits follow after the 0 separator.
-- This means the decoder needs no external information.

-- The length of the payload is encoded in the prefix
theorem sd_self_describing (s : BinString) :
    (sd s).length = 2 * s.length + 1 :=
  sd_length s

-- The decoder can determine message boundaries from the encoding alone
-- Proof: the prefix of 1s has length = payload length
def prefixOnesCount : BinString → Nat
  | [] => 0
  | true :: rest => 1 + prefixOnesCount rest
  | false :: _ => 0

-- Helper: prefixOnesCount of (replicate n true ++ rest)
private theorem prefixOnesCount_replicate_true (n : Nat) (rest : BinString)
    (h : rest = [] ∨ ∃ bs, rest = false :: bs) :
    prefixOnesCount (List.replicate n true ++ rest) =
    n + prefixOnesCount rest := by
  induction n with
  | zero => simp
  | succ k ih =>
    simp [List.replicate, List.cons_append, prefixOnesCount]
    omega

-- The prefix ones count of sd s equals s.length
-- (structural: the header 1^|s| has exactly |s| ones before the first false)
theorem sd_prefix_ones (s : BinString) :
    prefixOnesCount (sd s) = s.length := by
  simp only [sd]
  have := prefixOnesCount_replicate_true s.length ([false] ++ s) (Or.inr ⟨s, rfl⟩)
  simp only [List.append_assoc] at this ⊢
  rw [this]
  simp [prefixOnesCount]

-- ═══════════════════════════════════════════════════════════════
-- SECTION 4: Interface properties
-- ═══════════════════════════════════════════════════════════════

-- The empty message is valid
theorem empty_message_valid :
    (mkMessage []).encoded = [false] := rfl

-- The interface preserves distinctness: different payloads → different encodings
theorem interface_injective (s t : BinString) (h : sd s = sd t) : s = t :=
  sd_injective s t h

-- Messages compose: we can send sequences
def encodeSequence : List BinString → BinString
  | [] => []
  | s :: rest => sd s ++ encodeSequence rest

-- The encoding of an empty sequence is empty
theorem encode_nil : encodeSequence [] = [] := rfl

-- The encoding of a singleton is just sd
theorem encode_singleton (s : BinString) : encodeSequence [s] = sd s := by
  simp [encodeSequence]

end BinaryInterface
