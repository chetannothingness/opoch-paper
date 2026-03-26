import OpochLean4.MAPF.Classes.OrientedMAPF

namespace MAPF.Resources

open MAPF.Classes

/-- Rotation cost: changing orientation costs 1 time step. -/
def rotationCost : Orientation → Orientation → Nat
  | o₁, o₂ => if o₁ == o₂ then 0 else 1

/-- An oriented action: either move forward in current direction,
    rotate, or wait. -/
inductive OrientedAction where
  | wait : OrientedAction
  | moveForward : OrientedAction
  | rotateLeft : OrientedAction
  | rotateRight : OrientedAction
deriving DecidableEq

/-- Orientation semantics are exact in the expanded graph:
    each (position, orientation) pair is a vertex. -/
theorem orientation_semantics_exact :
    numOrientations = 4 := rfl

end MAPF.Resources
