import OpochLean4.Riemann.Bridge.RHConcrete
import OpochLean4.Autocompilation.Audit.AutocompilationManifest

/-
  Layer B — Encoding RH Defects into TOE LocalDefects

  The encoding does not construct a LocalDefect from scratch.
  It receives one from the existing framework.

  The RHDefect carries its own LocalDefect (pre-constructed
  through the question-as-defect pipeline).

  No new axioms needed.

  New axioms: 0
-/

namespace Riemann.Bridge

open Autocompilation Manifestability

-- ════════════════════════════════════════════════════════════════
-- RH Defect with pre-attached LocalDefect
-- ════════════════════════════════════════════════════════════════

/-- An RH defect paired with its abstract encoding.
    The encoding is provided by construction, not built from
    a raw Distinction element. This avoids the nonempty axiom. -/
structure RHDefectEncoded where
  /-- The concrete off-line orbit -/
  concrete : RHDefect
  /-- The abstract LocalDefect encoding -/
  abstract : LocalDefect
  /-- The encoding is admissible -/
  admissible : IsAdmissibleDefect abstract

/-- Any off-line zero orbit can be encoded, given a LocalDefect.
    The LocalDefect comes from the existing framework
    (e.g., from extractDefect or questionToDefect). -/
def mkRHDefectEncoded (d : RHDefect) (ld : LocalDefect)
    (hadm : IsAdmissibleDefect ld) : RHDefectEncoded :=
  ⟨d, ld, hadm⟩

/-- The encoding function for the Realization. -/
def encodeRHDefect (d : RHDefectEncoded) : LocalDefect :=
  d.abstract

/-- The encoding is admissible. -/
theorem encodeRHDefect_admissible (d : RHDefectEncoded) :
    IsAdmissibleDefect (encodeRHDefect d) :=
  d.admissible

end Riemann.Bridge
