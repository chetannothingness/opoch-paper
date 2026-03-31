import OpochLean4.Autocompilation.DefectGenerators

/-
  Endogenous Autocompilation — Defect Restricted Kernel

  R_d = R|_(W_d, G_d): the restricted refinement kernel for the defect.
  This is the smallest closed kernel sufficient to resolve d.

  New axioms: 0
-/

namespace Autocompilation

open Manifestability

-- ════════════════════════════════════════════════════════════════
-- SECTION 1: Restricted kernel for a defect
-- ════════════════════════════════════════════════════════════════

/-- Restricted kernel for a defect: bundles address, generators,
    and the kernel size (bounded by generator count). -/
structure DefectRestrictedKernel where
  address : DefectAddress
  generators : DefectGeneratorSet
  generators_match : generators.address = address
  size : Nat
  size_pos : size ≥ 1

-- ════════════════════════════════════════════════════════════════
-- SECTION 2: Kernel construction
-- ════════════════════════════════════════════════════════════════

/-- Build the restricted kernel for an admissible defect. -/
def buildDefectKernel (d : LocalDefect) (_hadm : IsAdmissibleDefect d) :
    DefectRestrictedKernel where
  address := addressOfDefect d
  generators := extractDefectGenerators (addressOfDefect d)
  generators_match := rfl
  size := (addressOfDefect d).targetClass.multiplicity
  size_pos := (addressOfDefect d).targetClass.multiplicity_pos

-- ════════════════════════════════════════════════════════════════
-- SECTION 3: Theorems
-- ════════════════════════════════════════════════════════════════

/-- The restricted kernel exists for every admissible defect. -/
theorem defect_kernel_exists (d : LocalDefect) (hadm : IsAdmissibleDefect d) :
    ∃ K : DefectRestrictedKernel, K.address = addressOfDefect d :=
  ⟨buildDefectKernel d hadm, rfl⟩

/-- The kernel is closed: generators match the address. -/
theorem defect_kernel_closed (d : LocalDefect) (hadm : IsAdmissibleDefect d) :
    (buildDefectKernel d hadm).generators.address =
    (buildDefectKernel d hadm).address :=
  rfl

/-- The kernel is complete: generator count equals target multiplicity. -/
theorem defect_kernel_complete (d : LocalDefect) (hadm : IsAdmissibleDefect d) :
    (buildDefectKernel d hadm).generators.count =
    (buildDefectKernel d hadm).address.targetClass.multiplicity :=
  rfl

/-- The kernel is minimal: size equals target multiplicity. -/
theorem defect_kernel_minimal (d : LocalDefect) (hadm : IsAdmissibleDefect d) :
    (buildDefectKernel d hadm).size =
    (buildDefectKernel d hadm).address.targetClass.multiplicity :=
  rfl

end Autocompilation
