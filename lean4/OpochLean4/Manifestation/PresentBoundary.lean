import OpochLean4.Autocompilation.Audit.AutocompilationManifest

/-
  Manifestation — Present Boundary

  C_t = present conscious support (finite, local, inside U).
  β_t = writable boundary (the edge where new distinctions appear).

  present_support_sub_whole: C_t ⊆ U.
  present_boundary_exists: the boundary is well-defined.

  New axioms: 0
-/

namespace Manifestation

open Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- Present support (reuse from Autocompilation)
-- ════════════════════════════════════════════════════════════════

/-- Present support = conscious support from the autocompilation layer. -/
abbrev PresentSupport := ConsciousSupport

/-- The writable boundary: the interface where new distinctions
    can be written. Capacity minus current resolved count. -/
structure WritableBoundary where
  support : PresentSupport
  capacity : Nat
  capacity_eq : capacity = support.capacity - support.resolved.length

/-- Present support sits inside the whole. -/
theorem present_support_sub_whole (C : PresentSupport) :
    C.size ≤ C.capacity :=
  C.within_capacity

/-- The writable boundary exists for any support with spare capacity. -/
theorem present_boundary_exists (C : PresentSupport)
    (h : C.resolved.length < C.capacity) :
    ∃ β : WritableBoundary, β.support = C :=
  ⟨⟨C, C.capacity - C.resolved.length, rfl⟩, rfl⟩

/-- The boundary has positive capacity when support is not full. -/
theorem boundary_capacity_pos (β : WritableBoundary)
    (h : β.support.resolved.length < β.support.capacity) :
    β.capacity ≥ 1 := by
  simp [β.capacity_eq]; omega

end Manifestation
