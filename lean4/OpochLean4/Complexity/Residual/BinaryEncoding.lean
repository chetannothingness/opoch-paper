import OpochLean4.Complexity.Residual.Signature
import OpochLean4.Complexity.SAT.QuotientKernel

/-
  Complexity Residual — Binary Encoding

  The residual signature has a canonical binary encoding:
  PartialAssign' = List Bool IS the binary representation.
  The quotient state QKernelState is the code of the
  unresolved future law.

  Dependencies: Signature, QuotientKernel
  New axioms: 0
-/

namespace Complexity.Residual

/-- The canonical binary encoding: partial assignments ARE binary strings.
    PartialAssign' = List Bool. The quotient QKernelState φ identifies
    binary strings that encode the same future law. -/
theorem binary_signature_exact :
    PartialAssign' = List Bool := rfl

/-- Every binary string represents a valid partial assignment prefix. -/
theorem binary_prefix_valid (bits : List Bool) :
    ∃ p : PartialAssign', p = bits := ⟨bits, rfl⟩

/-- The empty binary string is the root (undecided state). -/
theorem binary_root :
    dagAcceptsFrom φ ([] : PartialAssign') ↔ Sat φ :=
  dag_accepts_iff_sat φ

/-- Binary encoding preserves future equivalence:
    the quotient is defined purely in terms of binary prefixes. -/
theorem binary_encoding_respects_quotient (φ : CNF) :
    ∀ p₁ p₂ : List Bool,
      FutureEquiv' φ p₁ p₂ →
      (dagAcceptsFrom φ p₁ ↔ dagAcceptsFrom φ p₂) :=
  fun p₁ p₂ h => fe_preserves_sat φ p₁ p₂ h

end Complexity.Residual
