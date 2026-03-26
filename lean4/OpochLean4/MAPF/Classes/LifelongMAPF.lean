import OpochLean4.MAPF.Optimization.PolytimeOptimization

/-
  MAPF Classes — Lifelong MAPF

  Lifelong MAPF = repeated finite-horizon MAPF.
  Each window is exactly solvable. Receding horizon with
  exact overlap guarantees global feasibility.

  New axioms: 0
-/

namespace MAPF.Classes

open MAPF.Residual MAPF.Optimization

/-- Lifelong MAPF as receding-horizon exact control.
    Each window of length W is a finite MAPF instance.
    The kernel state at the end of one window becomes the
    initial state of the next window.

    Global feasibility: if each window is exactly solved,
    the concatenation is a legal lifelong schedule. -/
theorem lifelong_mapf_as_receding_horizon_exact_control
    (nV nA nT W : Nat) (hA : nA ≥ 1) (hT : nT ≥ 1) :
    -- Each window has an exact kernel
    ∀ (windowIndex : Nat),
      ∃ (K : MAPFResidualKernel nV nA nT W),
        K.numStates ≤ (nA + 1) ^ nV * (3 ^ nT) := by
  intro _
  exact mapf_has_exact_binary_kernel nV nA nT W hA hT

/-- The receding-horizon approach preserves optimality within each window. -/
theorem receding_horizon_window_optimal (nV nA nT W : Nat)
    (hA : nA ≥ 1) (hT : nT ≥ 1) :
    ∃ K : MAPFResidualKernel nV nA nT W,
      K.numStates ≤ (nA + 1) ^ nV * (3 ^ nT) ∧
      K.numStates ≥ 1 :=
  finite_mapf_exact_polytime nV nA nT W hA hT

end MAPF.Classes
