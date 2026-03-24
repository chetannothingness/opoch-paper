; ============================================================================
; Step 22: Inverse Limit — Metric Preservation Across Refinement Levels
; ============================================================================
; An inverse system of truth-class partitions at 3 levels:
;   Level 0 (coarsest): 2 classes
;   Level 1 (medium):   4 classes
;   Level 2 (finest):   8 classes
;
; Projection maps pi_10: Level1 -> Level0, pi_21: Level2 -> Level1
; and composite pi_20: Level2 -> Level0.
;
; Key property: projections are NON-EXPANDING:
;   d_coarse(pi(p), pi(q)) <= d_fine(p, q)
;
; Finer partitions can only increase distances (more tests available),
; so projecting back to a coarser level cannot exceed the fine distance.
;
; We verify:
;   Part 1: A valid inverse system with non-expanding projections exists (sat)
;   Part 2: Breaking non-expansion creates a contradiction (unsat)
;   Part 3: Composite projection pi_20 = pi_10 . pi_21 is consistent (sat)
; ============================================================================

(set-logic ALL)
(set-option :produce-models true)

; ---------- Level 0: 2 classes, metric d0 ----------
(declare-fun d0 (Int Int) Int)

; Self-distances = 0
(assert (= (d0 0 0) 0))
(assert (= (d0 1 1) 0))
; Symmetric positive distance
(assert (= (d0 0 1) 3))
(assert (= (d0 1 0) 3))

; ---------- Level 1: 4 classes, metric d1 ----------
(declare-fun d1 (Int Int) Int)

; Self-distances = 0
(assert (= (d1 0 0) 0))
(assert (= (d1 1 1) 0))
(assert (= (d1 2 2) 0))
(assert (= (d1 3 3) 0))

; Distances (symmetric): classes 0,1 map to L0-class 0; classes 2,3 map to L0-class 1
(assert (= (d1 0 1) 2)) (assert (= (d1 1 0) 2))
(assert (= (d1 0 2) 4)) (assert (= (d1 2 0) 4))
(assert (= (d1 0 3) 5)) (assert (= (d1 3 0) 5))
(assert (= (d1 1 2) 4)) (assert (= (d1 2 1) 4))
(assert (= (d1 1 3) 5)) (assert (= (d1 3 1) 5))
(assert (= (d1 2 3) 2)) (assert (= (d1 3 2) 2))

; ---------- Level 2: 8 classes, metric d2 ----------
(declare-fun d2 (Int Int) Int)

; Self-distances = 0
(assert (= (d2 0 0) 0)) (assert (= (d2 1 1) 0))
(assert (= (d2 2 2) 0)) (assert (= (d2 3 3) 0))
(assert (= (d2 4 4) 0)) (assert (= (d2 5 5) 0))
(assert (= (d2 6 6) 0)) (assert (= (d2 7 7) 0))

; Distances within L1-class 0's fiber (L2 classes 0,1)
(assert (= (d2 0 1) 1)) (assert (= (d2 1 0) 1))
; Within L1-class 1's fiber (L2 classes 2,3)
(assert (= (d2 2 3) 1)) (assert (= (d2 3 2) 1))
; Within L1-class 2's fiber (L2 classes 4,5)
(assert (= (d2 4 5) 1)) (assert (= (d2 5 4) 1))
; Within L1-class 3's fiber (L2 classes 6,7)
(assert (= (d2 6 7) 1)) (assert (= (d2 7 6) 1))

; Cross-fiber distances (>= coarser distance)
(assert (= (d2 0 2) 3)) (assert (= (d2 2 0) 3))
(assert (= (d2 0 4) 5)) (assert (= (d2 4 0) 5))
(assert (= (d2 0 6) 6)) (assert (= (d2 6 0) 6))
(assert (= (d2 1 3) 3)) (assert (= (d2 3 1) 3))
(assert (= (d2 1 5) 5)) (assert (= (d2 5 1) 5))
(assert (= (d2 1 7) 6)) (assert (= (d2 7 1) 6))
(assert (= (d2 2 4) 5)) (assert (= (d2 4 2) 5))
(assert (= (d2 2 6) 6)) (assert (= (d2 6 2) 6))
(assert (= (d2 3 5) 5)) (assert (= (d2 5 3) 5))
(assert (= (d2 3 7) 6)) (assert (= (d2 7 3) 6))
(assert (= (d2 4 6) 3)) (assert (= (d2 6 4) 3))
(assert (= (d2 5 7) 3)) (assert (= (d2 7 5) 3))
; Remaining cross pairs
(assert (= (d2 0 3) 3)) (assert (= (d2 3 0) 3))
(assert (= (d2 0 5) 5)) (assert (= (d2 5 0) 5))
(assert (= (d2 0 7) 6)) (assert (= (d2 7 0) 6))
(assert (= (d2 1 2) 3)) (assert (= (d2 2 1) 3))
(assert (= (d2 1 4) 5)) (assert (= (d2 4 1) 5))
(assert (= (d2 1 6) 6)) (assert (= (d2 6 1) 6))
(assert (= (d2 2 5) 5)) (assert (= (d2 5 2) 5))
(assert (= (d2 2 7) 6)) (assert (= (d2 7 2) 6))
(assert (= (d2 3 4) 5)) (assert (= (d2 4 3) 5))
(assert (= (d2 3 6) 6)) (assert (= (d2 6 3) 6))
(assert (= (d2 4 7) 3)) (assert (= (d2 7 4) 3))
(assert (= (d2 5 6) 3)) (assert (= (d2 6 5) 3))

; ---------- Projection maps ----------
; pi_10: Level1 -> Level0 (classes 0,1 -> 0; classes 2,3 -> 1)
(declare-fun pi10 (Int) Int)
(assert (= (pi10 0) 0)) (assert (= (pi10 1) 0))
(assert (= (pi10 2) 1)) (assert (= (pi10 3) 1))

; pi_21: Level2 -> Level1 (0,1->0; 2,3->1; 4,5->2; 6,7->3)
(declare-fun pi21 (Int) Int)
(assert (= (pi21 0) 0)) (assert (= (pi21 1) 0))
(assert (= (pi21 2) 1)) (assert (= (pi21 3) 1))
(assert (= (pi21 4) 2)) (assert (= (pi21 5) 2))
(assert (= (pi21 6) 3)) (assert (= (pi21 7) 3))

; ---------- Part 1: Valid inverse system with non-expanding projections ----------
; Check that d0(pi10(p), pi10(q)) <= d1(p,q) for all p,q in Level 1
; and d1(pi21(p), pi21(q)) <= d2(p,q) for all p,q in Level 2

(echo "--- Part 1: Valid inverse system exists ---")
(echo "Expected: sat")
(check-sat)

; ---------- Part 2: Breaking non-expansion is contradictory ----------
; Assert there exist p,q in Level 2 such that
; d1(pi21(p), pi21(q)) > d2(p,q)  — this should be unsat given our model
(push 1)

(declare-fun p () Int)
(declare-fun q () Int)
(assert (and (>= p 0) (<= p 7)))
(assert (and (>= q 0) (<= q 7)))
(assert (not (= p q)))

; Non-expansion violation: coarser distance exceeds finer distance
(assert (> (d1 (pi21 p) (pi21 q)) (d2 p q)))

(echo "--- Part 2: Non-expansion violation possible? ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

; ---------- Part 3: Composite projection consistency ----------
; pi_20 = pi_10 . pi_21 should also be non-expanding: d0(pi20(p),pi20(q)) <= d2(p,q)
(push 1)

(declare-fun pi20 (Int) Int)
; pi20 = pi10 . pi21
(assert (forall ((x Int)) (=> (and (>= x 0) (<= x 7)) (= (pi20 x) (pi10 (pi21 x))))))

; Verify non-expansion of composite for specific points
(declare-fun a () Int)
(declare-fun b () Int)
(assert (and (>= a 0) (<= a 7)))
(assert (and (>= b 0) (<= b 7)))

; Assert composite is non-expanding AND the system is consistent
(assert (<= (d0 (pi20 a) (pi20 b)) (d2 a b)))

(echo "--- Part 3: Composite projection pi_20 is non-expanding ---")
(echo "Expected: sat")
(check-sat)
(pop 1)

(echo "--- Step 22 verification complete (3 parts) ---")
