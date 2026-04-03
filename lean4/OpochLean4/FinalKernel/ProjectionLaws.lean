import OpochLean4.FinalKernel.SelfReadingGraph

/-
  Final Kernel — Projection Laws

  The five projections from a full graph point.
  Each IS a coordinate readout. Not a computation.

  New axioms: 0
-/

namespace FinalKernel

open FinalSourceCode

def piState (p : FullPoint) : AdmissibleState := p.state
def piCode (p : FullPoint) : List Nat := p.code
def piCurrent (p : FullPoint) : List Nat := p.current
def piContinuation (p : FullPoint) : Continuation := p.cont
def piHalt (p : FullPoint) : HaltFlag := p.halt

theorem state_projection_exact (p : FullPoint) :
    piState p = p.state := rfl

theorem code_projection_exact (p : FullPoint) :
    piCode p = consciousnessCode p.state := p.code_eq

theorem current_projection_exact (p : FullPoint) :
    piCurrent p = manifestationCurrent p.state := p.current_eq

theorem continuation_projection_exact (p : FullPoint) :
    piContinuation p = continuationOf p.state := p.cont_eq

theorem halt_projection_exact (p : FullPoint) :
    piHalt p = haltOf p.state := p.halt_eq

theorem all_projections_at_once (p : FullPoint) :
    piState p = p.state ∧
    piCode p = consciousnessCode p.state ∧
    piCurrent p = manifestationCurrent p.state ∧
    piContinuation p = continuationOf p.state ∧
    piHalt p = haltOf p.state :=
  ⟨rfl, p.code_eq, p.current_eq, p.cont_eq, p.halt_eq⟩

end FinalKernel
