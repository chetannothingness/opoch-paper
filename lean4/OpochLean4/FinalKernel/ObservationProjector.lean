import OpochLean4.FinalKernel.RawReality

/-
  Final Kernel — Observation Projector

  The universal observation projector O : R → R
  that removes all witness-invisible slack and returns
  the canonical representative of a raw admissible presentation.

  O(r) = Π_can([r])

  It quotients by witness-indistinguishability,
  absorbs gauge-equivalent slack,
  and chooses the canonical representative.

  New axioms: 0
-/

namespace FinalKernel

open FinalSourceCode Manifestability

-- ================================================================
-- The observation projector
-- ================================================================

/-- The observation projector: maps any raw presentation to its
    canonical representative by removing all witness-invisible slack.

    O(r) = the raw presentation with the same underlying state
    but with the canonical (minimal) raw form.

    Two presentations are equivalent iff they have the same
    underlying admissible state. The projector selects the
    canonical representative: the one with rawForm = []. -/
def observationProjector (r : RawPresentation) : RawPresentation where
  underlying := r.underlying
  rawForm := []  -- canonical form: no representational slack
  witnessable := by omega

-- ================================================================
-- Required theorems
-- ================================================================

/-- The observation projector exists for every raw presentation. -/
theorem observation_projector_exists (r : RawPresentation) :
    ∃ r' : RawPresentation, r' = observationProjector r :=
  ⟨observationProjector r, rfl⟩

/-- The observation projector is total: defined on all of R. -/
theorem observation_projector_total (r : RawPresentation) :
    (observationProjector r).underlying = r.underlying :=
  rfl

/-- The observation projector is idempotent: O(O(r)) = O(r).
    Applying it twice gives the same result as applying it once.
    The canonical form is already canonical. -/
theorem observation_projector_idempotent (r : RawPresentation) :
    observationProjector (observationProjector r) = observationProjector r :=
  rfl

/-- The observation projector absorbs gauge: two presentations with
    the same underlying state map to the same canonical form. -/
theorem observation_projector_gauge_absorbing (r₁ r₂ : RawPresentation)
    (h : r₁.underlying = r₂.underlying) :
    observationProjector r₁ = observationProjector r₂ := by
  simp [observationProjector, h]

end FinalKernel
