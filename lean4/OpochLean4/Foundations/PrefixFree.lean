/-
  OpochLean4/Foundations/PrefixFree.lean
  Self-delimitation forced by replayability.
  Dependencies: FiniteCarrier
  Assumptions: A0star only.
-/
import OpochLean4.Foundations.FiniteCarrier

-- Prefix relation on binary strings
def IsPrefix (xs ys : BinString) : Prop :=
  ∃ zs, xs ++ zs = ys

-- Proper prefix: prefix but not equal
def IsProperPrefix (xs ys : BinString) : Prop :=
  IsPrefix xs ys ∧ xs ≠ ys

-- A collection of strings is prefix-free
def PrefixFree (S : BinString → Prop) : Prop :=
  ∀ x y, S x → S y → IsProperPrefix x y → False

-- The canonical self-delimiting map: sd(s) = 1^|s| ++ [0] ++ s
def sd (s : BinString) : BinString :=
  List.replicate s.length true ++ [false] ++ s

-- sd produces strings of length 2|s| + 1
theorem sd_length (s : BinString) : (sd s).length = 2 * s.length + 1 := by
  simp [sd, List.length_append, List.length_replicate]
  omega

-- sd is injective
theorem sd_injective (s t : BinString) (h : sd s = sd t) : s = t := by
  have hlen : s.length = t.length := by
    have h3 : (sd s).length = (sd t).length := by rw [h]
    simp [sd_length] at h3
    omega
  -- Once lengths match, sd is determined by its suffix
  -- With equal lengths, the sd encoding is:
  -- replicate n true ++ [false] ++ s = replicate n true ++ [false] ++ t
  -- where n = s.length = t.length. So s = t.
  unfold sd at h
  rw [hlen] at h
  -- h : replicate t.length true ++ [false] ++ s = replicate t.length true ++ [false] ++ t
  simp [List.append_assoc] at h
  exact h

-- Concrete examples
example : sd [] = [false] := rfl
example : sd [true] = [true, false, true] := rfl
example : sd [false] = [true, false, false] := rfl
