; ============================================================================
; Dependency DAG Acyclicity Verification
; ============================================================================
; Encodes all 30 steps (0-29) and their declared dependencies from the
; derivation summary table. Verifies:
;   Part 1: A valid topological ordering exists (sat)
;   Part 2: No cycle exists — removing a back-edge creates contradiction (unsat)
;   Part 3: Every step is reachable from Step 0 (unsat if unreachable)
;
; Dependencies (from paper Table 1):
;   0: ---           8: 5,6,7       16: 4,6,15      24: 22,23,16
;   1: 0             9: 5,8         17: 6,12        25: 24,8
;   2: 1            10: 8,9         18: 9,14,16     26: 24,22
;   3: 1,2          11: 8,9,10      19: 3,5,6,18    27: 18,26,8
;   4: 1,2,3        12: 6,9         20: 2,19        28: 26,27,5
;   5: 1,2,3,4      13: 6,8,12      21: 0..20,22..29 29: 26,27,28
;   6: 1,2,3,4,5    14: 5,6,13      22: 16,9,7
;   7: 4,5,6        15: 4,6,12      23: 22,12
; ============================================================================

(set-logic ALL)
(set-option :produce-models true)

; ---------- Topological order: topo(step) -> Int ----------
; For a valid DAG, there exists an assignment topo such that
; for every edge (j -> i), topo(j) < topo(i).
(declare-fun topo (Int) Int)

; Step 0: no dependencies
; Step 1: depends on 0
(assert (< (topo 0) (topo 1)))

; Step 2: depends on 1
(assert (< (topo 1) (topo 2)))

; Step 3: depends on 1, 2
(assert (< (topo 1) (topo 3)))
(assert (< (topo 2) (topo 3)))

; Step 4: depends on 1, 2, 3
(assert (< (topo 1) (topo 4)))
(assert (< (topo 2) (topo 4)))
(assert (< (topo 3) (topo 4)))

; Step 5: depends on 1, 2, 3, 4
(assert (< (topo 1) (topo 5)))
(assert (< (topo 2) (topo 5)))
(assert (< (topo 3) (topo 5)))
(assert (< (topo 4) (topo 5)))

; Step 6: depends on 1, 2, 3, 4, 5
(assert (< (topo 1) (topo 6)))
(assert (< (topo 2) (topo 6)))
(assert (< (topo 3) (topo 6)))
(assert (< (topo 4) (topo 6)))
(assert (< (topo 5) (topo 6)))

; Step 7: depends on 4, 5, 6
(assert (< (topo 4) (topo 7)))
(assert (< (topo 5) (topo 7)))
(assert (< (topo 6) (topo 7)))

; Step 8: depends on 5, 6, 7
(assert (< (topo 5) (topo 8)))
(assert (< (topo 6) (topo 8)))
(assert (< (topo 7) (topo 8)))

; Step 9: depends on 5, 8
(assert (< (topo 5) (topo 9)))
(assert (< (topo 8) (topo 9)))

; Step 10: depends on 8, 9
(assert (< (topo 8) (topo 10)))
(assert (< (topo 9) (topo 10)))

; Step 11: depends on 8, 9, 10
(assert (< (topo 8) (topo 11)))
(assert (< (topo 9) (topo 11)))
(assert (< (topo 10) (topo 11)))

; Step 12: depends on 6, 9
(assert (< (topo 6) (topo 12)))
(assert (< (topo 9) (topo 12)))

; Step 13: depends on 6, 8, 12
(assert (< (topo 6) (topo 13)))
(assert (< (topo 8) (topo 13)))
(assert (< (topo 12) (topo 13)))

; Step 14: depends on 5, 6, 13
(assert (< (topo 5) (topo 14)))
(assert (< (topo 6) (topo 14)))
(assert (< (topo 13) (topo 14)))

; Step 15: depends on 4, 6, 12
(assert (< (topo 4) (topo 15)))
(assert (< (topo 6) (topo 15)))
(assert (< (topo 12) (topo 15)))

; Step 16: depends on 4, 6, 15
(assert (< (topo 4) (topo 16)))
(assert (< (topo 6) (topo 16)))
(assert (< (topo 15) (topo 16)))

; Step 17: depends on 6, 12
(assert (< (topo 6) (topo 17)))
(assert (< (topo 12) (topo 17)))

; Step 18: depends on 9, 14, 16
(assert (< (topo 9) (topo 18)))
(assert (< (topo 14) (topo 18)))
(assert (< (topo 16) (topo 18)))

; Step 19: depends on 3, 5, 6, 18
(assert (< (topo 3) (topo 19)))
(assert (< (topo 5) (topo 19)))
(assert (< (topo 6) (topo 19)))
(assert (< (topo 18) (topo 19)))

; Step 20: depends on 2, 19
(assert (< (topo 2) (topo 20)))
(assert (< (topo 19) (topo 20)))

; Step 22: depends on 16, 9, 7
(assert (< (topo 16) (topo 22)))
(assert (< (topo 9) (topo 22)))
(assert (< (topo 7) (topo 22)))

; Step 23: depends on 22, 12
(assert (< (topo 22) (topo 23)))
(assert (< (topo 12) (topo 23)))

; Step 24: depends on 22, 23, 16
(assert (< (topo 22) (topo 24)))
(assert (< (topo 23) (topo 24)))
(assert (< (topo 16) (topo 24)))

; Step 25: depends on 24, 8
(assert (< (topo 24) (topo 25)))
(assert (< (topo 8) (topo 25)))

; Step 26: depends on 24, 22
(assert (< (topo 24) (topo 26)))
(assert (< (topo 22) (topo 26)))

; Step 27: depends on 18, 26, 8
(assert (< (topo 18) (topo 27)))
(assert (< (topo 26) (topo 27)))
(assert (< (topo 8) (topo 27)))

; Step 28: depends on 26, 27, 5
(assert (< (topo 26) (topo 28)))
(assert (< (topo 27) (topo 28)))
(assert (< (topo 5) (topo 28)))

; Step 29: depends on 26, 27, 28
(assert (< (topo 26) (topo 29)))
(assert (< (topo 27) (topo 29)))
(assert (< (topo 28) (topo 29)))

; Step 21: depends on ALL (0..20 and 22..29)
(assert (< (topo 0) (topo 21)))
(assert (< (topo 1) (topo 21)))
(assert (< (topo 2) (topo 21)))
(assert (< (topo 3) (topo 21)))
(assert (< (topo 4) (topo 21)))
(assert (< (topo 5) (topo 21)))
(assert (< (topo 6) (topo 21)))
(assert (< (topo 7) (topo 21)))
(assert (< (topo 8) (topo 21)))
(assert (< (topo 9) (topo 21)))
(assert (< (topo 10) (topo 21)))
(assert (< (topo 11) (topo 21)))
(assert (< (topo 12) (topo 21)))
(assert (< (topo 13) (topo 21)))
(assert (< (topo 14) (topo 21)))
(assert (< (topo 15) (topo 21)))
(assert (< (topo 16) (topo 21)))
(assert (< (topo 17) (topo 21)))
(assert (< (topo 18) (topo 21)))
(assert (< (topo 19) (topo 21)))
(assert (< (topo 20) (topo 21)))
(assert (< (topo 22) (topo 21)))
(assert (< (topo 23) (topo 21)))
(assert (< (topo 24) (topo 21)))
(assert (< (topo 25) (topo 21)))
(assert (< (topo 26) (topo 21)))
(assert (< (topo 27) (topo 21)))
(assert (< (topo 28) (topo 21)))
(assert (< (topo 29) (topo 21)))

; ---------- Part 1: Valid topological ordering exists ----------
(echo "--- Part 1: Topological ordering of 30-step DAG ---")
(echo "Expected: sat")
(check-sat)

; ---------- Part 2: Adding a back-edge creates a cycle ----------
; If we add Step 0 depends on Step 21, this creates a cycle
; 0 -> 1 -> ... -> 21 -> 0, making topo(21) < topo(0) AND topo(0) < topo(21)
(push 1)
(assert (< (topo 21) (topo 0)))

(echo "--- Part 2: Back-edge 21->0 creates cycle? ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

; ---------- Part 3: All steps reachable from root ----------
; Step 0 has topo value 0. All other steps have topo > 0.
; This means every step is downstream of the derivation start.
(push 1)
(assert (= (topo 0) 0))

; Assert some step has topo <= 0 (other than step 0)
(declare-fun orphan () Int)
(assert (and (>= orphan 1) (<= orphan 29)))
(assert (<= (topo orphan) 0))

(echo "--- Part 3: All steps downstream of Step 0? ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

(echo "--- DAG acyclicity verification complete (3 parts) ---")
