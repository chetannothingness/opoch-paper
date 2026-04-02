import OpochLean4.InstantKernel.NormalForm

/-
  InstantKernel/ARC -- Concrete ARC Observation History Syntax

  The ARC observation history as a concrete normalizable term.

  New axioms: 0
-/

namespace InstantKernel.ARC

-- ================================================================
-- ARC-specific syntax
-- ================================================================

/-- A single ARC frame: grid of pixel values + legal actions. -/
structure ArcFrame where
  pixels : List (List Nat)
  width : Nat
  height : Nat
  legalActions : List Nat


/-- The ARC observation history: the complete present support. -/
structure ArcObsHistory where
  frames : List ArcFrame
  gameId : String
  levelIdx : Nat


/-- Encode an ARC observation history as a QCode term. -/
def encodeArcHistory (h : ArcObsHistory) : QCode :=
  .tagged ("arc:" ++ h.gameId ++ ":" ++ toString h.levelIdx)
    (.history (h.frames.map fun f =>
      .atom (.nat f.width)))

end InstantKernel.ARC
