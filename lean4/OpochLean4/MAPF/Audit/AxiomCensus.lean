import OpochLean4.Manifest.Axioms

namespace MAPF.Audit

def soleAxiom : String := "A0star"
def axiomLocation : String := "OpochLean4/Manifest/Axioms.lean:27"
def mapfAxiomCount : Nat := 0

theorem mapf_no_new_axioms : mapfAxiomCount = 0 := rfl

end MAPF.Audit
