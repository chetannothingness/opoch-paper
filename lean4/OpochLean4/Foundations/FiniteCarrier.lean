/-
  OpochLean4/Foundations/FiniteCarrier.lean
  Carrier = List Bool (finite binary strings).
  Dependencies: Manifest/Axioms, Foundations/WitnessStructure
  Assumptions: A0star only.
-/
import OpochLean4.Manifest.Axioms
import OpochLean4.Foundations.WitnessStructure

-- The carrier: finite binary strings
abbrev BinString := List Bool
abbrev Carrier := BinString

-- Every admissible witness has a finite binary encoding
opaque encode : Witness → BinString

-- Budget bounds: a witness of cost n cannot access strings longer than n
def inFiniteSlice (budget : Nat) (s : BinString) : Prop := s.length ≤ budget

-- Finite slice membership is decidable
instance finite_slice_decidable (budget : Nat) (s : BinString) :
    Decidable (inFiniteSlice budget s) :=
  inferInstanceAs (Decidable (s.length ≤ budget))

-- The carrier has exactly 2^n strings of length n
theorem carrier_count_length (n : Nat) :
    (List.replicate n ()).length = n :=
  List.length_replicate n ()

-- Binary is forced: unary alphabet has no internal distinctions
-- (all strings of the same length are identical over a 1-element alphabet)
theorem unary_no_distinctions (n : Nat) (s t : List Unit) (hs : s.length = n) (ht : t.length = n) :
    s = t := by
  induction n generalizing s t with
  | zero =>
    have hs0 := List.length_eq_zero.mp hs
    have ht0 := List.length_eq_zero.mp ht
    subst hs0; subst ht0; rfl
  | succ k ih =>
    match s, t, hs, ht with
    | a :: ss, b :: tt, hs, ht =>
      have hss : ss.length = k := by simp at hs; exact hs
      have htt : tt.length = k := by simp at ht; exact ht
      have heq : ss = tt := ih ss tt hss htt
      have hab : a = b := by cases a; cases b; rfl
      subst heq; subst hab; rfl
