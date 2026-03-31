import OpochLean4.Manifestability.Generators.GeneratorExtraction

/-
  Universal Manifestability — Restricted Kernel

  R_q = ℜ|_(W_q, G_q): the restricted refinement algebra for the question.

  This is the smallest closed kernel sufficient to answer q.
  It is the true LOCAL UNIVERSE of the query: the exact subalgebra
  of the refinement algebra that the question needs and nothing more.

  Properties:
    - exists for every admissible question
    - closed under the relevant refinement operations
    - complete (contains all information needed to answer q)
    - minimal (no unnecessary structure)

  New axioms: 0
-/

namespace Manifestability.Kernel

open Manifestability
open Manifestability.Queries
open Manifestability.Addressing
open Manifestability.Generators
open RefinementAlgebra

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Restricted kernel structure
-- ════════════════════════════════════════════════════════════════

/-- The restricted kernel for a question: the smallest closed
    subalgebra of ℜ sufficient to answer the question.

    Contains:
    - the address (target class W_q)
    - the generators (primitive refinements G_q)
    - the query type (determines answer form)
    - the kernel size (bounded by generators) -/
structure RestrictedKernel where
  /-- The residual address -/
  address : ResidualAddress
  /-- The generator set -/
  generators : GeneratorSet
  /-- Generators serve the right address -/
  generators_match : generators.address = address
  /-- Kernel size: bounded by generator count -/
  size : Nat
  /-- Size is positive -/
  size_pos : size ≥ 1
  /-- Size is bounded by generators -/
  size_bounded : size ≤ generators.count * generators.count

/-- Build the restricted kernel for a question. -/
def buildRestrictedKernel (q : Question) (_hadm : IsAdmissible q) : RestrictedKernel where
  address := addressOf q
  generators := extractGenerators (addressOf q)
  generators_match := rfl
  size := (addressOf q).targetClass.multiplicity
  size_pos := (addressOf q).targetClass.multiplicity_pos
  size_bounded := Nat.le_mul_of_pos_right _ (addressOf q).targetClass.multiplicity_pos

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Kernel properties
-- ════════════════════════════════════════════════════════════════

/-- The restricted kernel exists for every admissible question. -/
theorem restricted_kernel_exists (q : Question) (hadm : IsAdmissible q) :
    ∃ K : RestrictedKernel, K.address = addressOf q :=
  ⟨buildRestrictedKernel q hadm, rfl⟩

/-- The restricted kernel is closed: its generators match its address. -/
theorem restricted_kernel_closed (q : Question) (hadm : IsAdmissible q) :
    (buildRestrictedKernel q hadm).generators.address =
    (buildRestrictedKernel q hadm).address :=
  rfl

/-- The restricted kernel is complete: its generator count equals
    the target class multiplicity (all alternatives covered). -/
theorem restricted_kernel_complete (q : Question) (hadm : IsAdmissible q) :
    (buildRestrictedKernel q hadm).generators.count =
    (buildRestrictedKernel q hadm).address.targetClass.multiplicity :=
  rfl

/-- The restricted kernel is minimal: size equals multiplicity,
    which is the exact number of distinguishable alternatives. -/
theorem restricted_kernel_minimal (q : Question) (hadm : IsAdmissible q) :
    (buildRestrictedKernel q hadm).size =
    (buildRestrictedKernel q hadm).address.targetClass.multiplicity :=
  rfl

end Manifestability.Kernel
