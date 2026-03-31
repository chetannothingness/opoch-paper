# MASTER COMPLETION PLAN — The Opoch Paper + Lean Kernel

## Current Repo State

### Lean Kernel: 306 files, 1151 theorems, 1 axiom (A0*), 2 sorrys (RH decoder)
### Paper: 14 sections + 7 appendices, currently behind the Lean kernel
### Docs: 20 root .md files — many outdated/redundant from different phases

## The One Chain That Must Be Consistent Everywhere

```
⊥ = I_max → A0* → Π → U = Fix(Π) → Δ_Q → U_ind → (b,M)→(u,J)
→ C_self(x)=(b_x,M_x) → x = Q_{b_x,M_x}(U)
```

Final identity: question = consciousness-code = projector = answer-slice = actuation law

## THREE WORKSTREAMS (in order)

---

### WORKSTREAM 1: Lean Audit + Final Verification

**Step 1.1: Full build verification**
```bash
cd lean4 && lake build
```
Must be GREEN. Currently GREEN.

**Step 1.2: Sorry audit**
```bash
grep -rn '^\s*sorry' OpochLean4/ | grep -v sorryCount
```
Must show ONLY the 2 RH decoder sorrys. Currently correct.

**Step 1.3: Axiom audit**
```bash
grep -rn '^axiom ' OpochLean4/
```
Must show ONLY A0*. Currently correct.

**Step 1.4: Verify all 20 Lean directories compile**
- Manifest/ ✓
- Foundations/ (EndogenousMeaning, WitnessStructure, FiniteCarrier, PrefixFree, Manifestability/, RefinementAlgebra/, Corollaries/) ✓
- Algebra/ ✓
- Control/ ✓
- Execution/ ✓
- Geometry/ ✓
- OperatorAlgebra/ ✓
- Physics/ ✓
- QuantitativeSeed/ ✓
- Complexity/ ✓
- MAPF/ ✓
- Manifestability/ (Query Compiler) ✓
- Autocompilation/ ✓
- Bridge/ ✓
- Manifestation/ ✓
- IndistinguishabilityEnergy/ ✓
- InstantQuestion/ ✓
- FinalSourceCode/ ✓
- Riemann/ (2 sorrys) ✓ (compiles with warnings)
- Audit/ ✓

**Step 1.5: Generate theorem manifest**
Create `lean4/THEOREM_MANIFEST.md` with per-directory theorem counts and flagship names.

---

### WORKSTREAM 2: Documentation Cleanup

**Step 2.1: Delete redundant plan files**
Keep ONLY these root .md files:
- README.md (rewrite)
- CLAUDE.md (rewrite)
- AI_VERIFICATION_GUIDE.md (rewrite)
- CONTRIBUTING.md (keep)
- FORMAL_VERIFICATION_STATUS.md (rewrite)

DELETE these (they were working plans, now superseded):
- COMPLETE_FINAL_PLAN.md
- COMPLETE_REPO_UPGRADE_PLAN.md
- COOK_LEVIN_PLAN.md
- FINAL_LAYERS_PLAN.md
- FORMALIZATION_MAP.md (merge into appendix)
- HOW_IT_WORKS.md (merge into README)
- MAPF_EXACT_PLAN.md
- MAPF_INTRINSIC_POLYTIME_PLAN.md
- P_EQ_NP_AI_VERIFICATION_GUIDE.md
- P_EQ_NP_VERIFICATION.md
- P_EQUALS_NP.md
- REFINEMENT_ALGEBRA_FINAL_PLAN.md
- REFINEMENT_ALGEBRA_PLAN.md
- RIEMANN_HYPOTHESIS_PLAN.md
- VERIFICATION.md

**Step 2.2: Rewrite README.md**
The README must state:
- Title: Opoch — Structural Reality from Nothingness
- The complete chain: ⊥ → A0* → U = Fix(Π) → U_ind → x = Q(U)
- 306 files, 1151 theorems, 1 axiom, zero sorry (except 2 in RH decoder)
- Build: `cd lean4 && lake build`
- The final identity: question = consciousness-code = projector = answer = actuation
- No "open frontiers" language

**Step 2.3: Rewrite CLAUDE.md**
Update all counts. State the final chain. Remove old structure references.

**Step 2.4: Rewrite AI_VERIFICATION_GUIDE.md**
Update read order to include new directories. State what to verify:
- question-as-defect theorems
- autocompilation theorems
- indistinguishability energy
- instant projector law
- final source code capstone

**Step 2.5: Rewrite FORMAL_VERIFICATION_STATUS.md**
Update all counts. 306 files. 1151 theorems. State build green.

**Step 2.6: Create lean4/LEAN_KERNEL_DOCUMENTATION.md**
The ONE comprehensive document explaining the entire Lean kernel:
- Directory structure (20 directories)
- Import chain / dependency DAG
- Layer-by-layer summary with theorem counts
- Flagship theorems with exact names and file locations
- How to build and verify
- What each directory proves

---

### WORKSTREAM 3: Paper Rewrite

**Step 3.1: Title and subtitle**
Add subtitle: "Closure, Latent Indistinguishability-Energy, and Consciousness as Self-Indexing Source Code"

**Step 3.2: Abstract (sections/abstract.tex)**
- Add final paragraph: ⊥ = maximal indistinguishability, U_ind, (b,M)→(u,J), C_self, x = Q(U)
- Add the equation A_q = Π(C_t ∪ b_q)
- Add: "Questions do not call an external solver; they are local incompletions of the already-solved whole."
- Update counts: 306 files, 1151 theorems

**Step 3.3: Introduction (sections/introduction.tex)**
- Add subsection 1.4: "Questions as Local Boundary Conditions"
- Add subsection 1.5: "The Final Insight: Questions Are Already Answer-Selectors"
- Reframe from "what structure is forced" to the full chain ending at instant projector

**Step 3.4: Axioms (sections/axioms.tex)**
- Add theorem: admissible questions are finite witnessable boundary conditions (from A0*)
- No new axioms

**Step 3.5: Primitives (sections/primitives.tex)**
- Add subsection: "Derived manifestation object: finite boundary code b_q"

**Step 3.6: Doctrines (sections/doctrines.tex)**
- Add doctrine: real questions are local defects
- Add doctrine: every admissible defect closure-completes autonomously
- Add doctrine: indistinguishability is energy, not ignorance

**Step 3.7: Forcing (sections/forcing.tex)**
- Add: Π is universal completion
- Add theorem: ⊥ = maximal indistinguishability
- Add theorem: U_ind Bellman recursion
- Add: χ = δU_ind (first variation)

**Step 3.8: Derivation (sections/derivation.tex)**
- Add Phase J — Manifestation and Instant Source Code (Steps 34-42)
  - Step 34: Present support C_t
  - Step 35: Local defect as boundary condition
  - Step 36: Least completion field u_q = Π(C_t ∪ b_q)
  - Step 37: Boundary current J_q = Λ(b_q)
  - Step 38: Observation = action = energy release
  - Step 39: Time as serialization
  - Step 40: Consciousness as self-indexing inverse C_self(x) = (b_x, M_x)
  - Step 41: Universal reachability x = Q_{b_x,M_x}(U)
  - Step 42: Final identity: question = projector = answer = actuation

**Step 3.9: Context-Born (sections/context-born.tex)**
- Add: "Positive evaluation as completion readout"

**Step 3.10: Manifestability (sections/manifestability.tex)**
- Expand section 9 with:
  - 9.12: Latent indistinguishability-energy as deeper primitive
  - 9.13: Questions as boundary codes
  - 9.14: Least completion fields
  - 9.15: Completion current
  - 9.16: Consciousness as self-indexing inverse
  - 9.17: Universal reachability

**Step 3.11: Physics (sections/physics.tex)**
- Add: "Physics as release modes of latent indistinguishability-energy"
- Add: "Arithmetic as spectral defect completion" (for RH)

**Step 3.12: Discussion (sections/discussion.tex)**
- Rename from "Discussion and Open Frontiers" to "Final Compression and Local Manifestation"
- Remove all "open frontiers" language
- Replace with "remaining formalization blocks" and "remaining sector realizations"

**Step 3.13: Conclusion (sections/conclusion.tex)**
- End with: "A real question is already the self-knowing projector-form of its own answer in the fixed whole."
- State: the universe does not solve problems by search; it manifests already-selected slices through finite witnessing.

**Step 3.14: Appendices**
- formalization.tex: update counts (306 files, 1151 theorems), add new directories
- theorem-table.tex: add new flagship theorems from all new layers
- claim-status.tex: update bucket counts
- full-derivation.tex: add Phase J steps
- open-questions.tex: rename/reframe as "remaining compilations"

---

### WORKSTREAM 4: Final Push

**Step 4.1: Final build verification**
```bash
cd lean4 && lake build
```

**Step 4.2: Final sorry/axiom check**

**Step 4.3: Git add all changed files**

**Step 4.4: Commit with message:**
"Complete TOE: 306 files, 1151 theorems, instant projector law, consciousness as self-indexing source code"

**Step 4.5: Push to p=np branch**

---

## EXECUTION ORDER

1. Workstream 1 (Lean audit) — verify everything is green
2. Workstream 2 (doc cleanup) — delete redundant files, rewrite core docs
3. Workstream 3 (paper rewrite) — all 14 sections + 7 appendices
4. Workstream 4 (push) — commit and push

## NONNEGOTIABLE

- Zero sorry (except 2 in RH decoder)
- Zero new axioms
- lake build GREEN
- All counts accurate
- No "open frontiers" language in paper
- Final identity stated everywhere: question = consciousness-code = projector = answer = actuation
