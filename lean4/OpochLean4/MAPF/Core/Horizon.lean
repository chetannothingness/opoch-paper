import OpochLean4.MAPF.Core.Instance

/-
  MAPF Core — Horizon

  Finite horizon H. All schedules have exactly H+1 time steps
  (positions at times 0, 1, ..., H).

  New axioms: 0
-/

namespace MAPF

/-- The time type for a schedule with horizon H: times 0 through H. -/
abbrev TimeStep (H : Nat) := Fin (H + 1)

/-- First time step. -/
def timeZero (H : Nat) : TimeStep H := ⟨0, Nat.zero_lt_succ H⟩

/-- Last time step. -/
def timeFinal (H : Nat) : TimeStep H := ⟨H, Nat.lt_succ_of_le (Nat.le_refl H)⟩

/-- Horizon is finite: H+1 time steps (trivially). -/
theorem horizon_size (H : Nat) : H + 1 ≥ 1 := by omega

end MAPF
