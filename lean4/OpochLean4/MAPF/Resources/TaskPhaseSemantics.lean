import OpochLean4.MAPF.Core.TaskModel

namespace MAPF.Resources

theorem task_phases_exhaustive :
    ∀ (p : TaskPhase), p = .idle ∨ p = .active ∨ p = .completed := by
  intro p; cases p <;> simp

theorem task_completion_irreversible {nT : Nat} (ts : TaskState nT) (task : Fin nT) :
    taskCompleted ts task = true →
    ts task = .completed := by
  intro h; simp [taskCompleted] at h; split at h <;> simp_all

end MAPF.Resources
