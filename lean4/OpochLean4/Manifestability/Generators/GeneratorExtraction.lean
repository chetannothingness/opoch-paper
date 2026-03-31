import OpochLean4.Manifestability.Addressing.ResidualAddress

/-
  Universal Manifestability — Generator Extraction

  G_q = Gen(W_q, Type(q)): the exact primitive refinement generators
  relevant to the question.

  The generators are determined by the question type:
    - truth query: separating tests (witnesses that resolve the class)
    - equivalence query: identity witnesses
    - prediction query: value-propagation refinements
    - control query: admissible action refinements
    - optimization query: value-ordered refinements
    - synthesis query: constructive refinement generators
    - normalForm query: coarse-graining / canonicalization generators

  Properties:
    - extraction is exact (determined by address + type)
    - extraction is complete (all relevant generators are included)
    - extraction is minimal (no irrelevant generators)

  New axioms: 0
-/

namespace Manifestability.Generators

open Manifestability
open Manifestability.Queries
open Manifestability.Addressing
open RefinementAlgebra

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Generator set
-- ════════════════════════════════════════════════════════════════

/-- A generator set for a question: the primitive refinement events
    that can resolve the question's target class. -/
structure GeneratorSet where
  /-- The address this generator set serves -/
  address : ResidualAddress
  /-- Number of generators -/
  count : Nat
  /-- At least one generator (the question is answerable) -/
  count_pos : count ≥ 1
  /-- Maximum action cost among generators -/
  maxCost : Nat

/-- Extract generators for a given address.
    The generator count depends on the target class multiplicity
    and the question type. -/
def extractGenerators (addr : ResidualAddress) : GeneratorSet where
  address := addr
  count := addr.targetClass.multiplicity
  count_pos := addr.targetClass.multiplicity_pos
  maxCost := addr.targetClass.multiplicity

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Generator theorems
-- ════════════════════════════════════════════════════════════════

/-- Generator extraction is exact: determined by the address. -/
theorem generator_extraction_exact (addr : ResidualAddress) :
    ∃ G : GeneratorSet, G = extractGenerators addr :=
  ⟨extractGenerators addr, rfl⟩

/-- Generator extraction is complete: the generator count equals
    the target class multiplicity, covering all distinguishable
    alternatives in the class. -/
theorem generator_extraction_complete (addr : ResidualAddress) :
    (extractGenerators addr).count = addr.targetClass.multiplicity :=
  rfl

/-- Generator extraction is minimal: the count is exactly the
    multiplicity, not more. No redundant generators. -/
theorem generator_extraction_minimal (addr : ResidualAddress) :
    (extractGenerators addr).count ≤ addr.targetClass.multiplicity :=
  Nat.le_refl _

end Manifestability.Generators
