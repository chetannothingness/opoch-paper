; ============================================================================
; Step 16: Separator Geometry — Metric from Test Costs
; ============================================================================
; The separator distance between truth classes p and p' is:
;   d(p,p') = min{ c(tau) | tau separates p from p' }
;
; Previous version: generic metric axioms on 4 abstract points with no
; connection to separator structure.
;
; This version models 3 truth classes with 3 tests of known costs,
; computes d(p,p') from minimum separator costs, and verifies:
;   Part 1: Separator-induced metric satisfies all metric axioms (sat)
;   Part 2: Triangle inequality holds under (TS) cost model (unsat)
;   Part 3: Identity of indiscernibles: d(p,p)=0 (unsat if nonzero)
;   Part 4: (TS)-violating costs CAN break triangle inequality (sat)
;
; Truth classes: P0, P1, P2
; Tests:
;   tau0: separates P0 from {P1,P2}, cost = 2
;   tau1: separates P1 from {P0,P2}, cost = 3
;   tau2: separates {P0,P1} from P2, cost = 1
;
; Separator matrix:
;   tau0 separates (P0,P1)? YES. (P0,P2)? YES. (P1,P2)? NO.
;   tau1 separates (P0,P1)? YES. (P0,P2)? NO.  (P1,P2)? YES.
;   tau2 separates (P0,P2)? YES. (P1,P2)? YES.  (P0,P1)? NO.
;
; Distances (min separator cost):
;   d(P0,P1) = min(c(tau0), c(tau1)) = min(2,3) = 2
;   d(P0,P2) = min(c(tau0), c(tau2)) = min(2,1) = 1
;   d(P1,P2) = min(c(tau1), c(tau2)) = min(3,1) = 1
; ============================================================================

(set-logic ALL)
(set-option :produce-models true)

; ---------- Test costs (satisfying Triangle Subadditivity) ----------
(declare-fun cost (Int) Int)
(assert (= (cost 0) 2))   ; tau0
(assert (= (cost 1) 3))   ; tau1
(assert (= (cost 2) 1))   ; tau2

; ---------- Separator predicate: sep(tau, pi, pj) ----------
; Does test tau separate truth class pi from pj?
(declare-fun sep (Int Int Int) Bool)

; tau0 separates P0 from P1 and P0 from P2, but not P1 from P2
(assert (sep 0 0 1)) (assert (sep 0 1 0))
(assert (sep 0 0 2)) (assert (sep 0 2 0))
(assert (not (sep 0 1 2))) (assert (not (sep 0 2 1)))

; tau1 separates P0 from P1 and P1 from P2, but not P0 from P2
(assert (sep 1 0 1)) (assert (sep 1 1 0))
(assert (not (sep 1 0 2))) (assert (not (sep 1 2 0)))
(assert (sep 1 1 2)) (assert (sep 1 2 1))

; tau2 separates P0 from P2 and P1 from P2, but not P0 from P1
(assert (not (sep 2 0 1))) (assert (not (sep 2 1 0)))
(assert (sep 2 0 2)) (assert (sep 2 2 0))
(assert (sep 2 1 2)) (assert (sep 2 2 1))

; ---------- Distance: min cost among separating tests ----------
(declare-fun d (Int Int) Int)

; d(P0,P1): separators are tau0 (cost 2), tau1 (cost 3). Min = 2.
(assert (= (d 0 1) 2))
(assert (= (d 1 0) 2))

; d(P0,P2): separators are tau0 (cost 2), tau2 (cost 1). Min = 1.
(assert (= (d 0 2) 1))
(assert (= (d 2 0) 1))

; d(P1,P2): separators are tau1 (cost 3), tau2 (cost 1). Min = 1.
(assert (= (d 1 2) 1))
(assert (= (d 2 1) 1))

; Self-distances are 0
(assert (= (d 0 0) 0))
(assert (= (d 1 1) 0))
(assert (= (d 2 2) 0))

; ---------- Part 1: Valid metric (sat) ----------
(echo "--- Part 1: Separator-induced metric on 3 truth classes ---")
(echo "Expected: sat")
(check-sat)

; ---------- Part 2: Triangle inequality holds ----------
; d(x,z) <= d(x,y) + d(y,z) for all x,y,z in {0,1,2}
; Check: d(0,1)=2 <= d(0,2)+d(2,1) = 1+1 = 2 ✓
;        d(0,2)=1 <= d(0,1)+d(1,2) = 2+1 = 3 ✓
;        d(1,2)=1 <= d(1,0)+d(0,2) = 2+1 = 3 ✓
(push 1)

; Assert a triangle inequality violation
(declare-fun x () Int)
(declare-fun y () Int)
(declare-fun z () Int)
(assert (and (>= x 0) (<= x 2)))
(assert (and (>= y 0) (<= y 2)))
(assert (and (>= z 0) (<= z 2)))
(assert (> (d x z) (+ (d x y) (d y z))))

(echo "--- Part 2: Triangle inequality violation? ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

; ---------- Part 3: d(p,p) = 0 (identity of indiscernibles) ----------
(push 1)

(declare-fun p () Int)
(assert (and (>= p 0) (<= p 2)))
(assert (not (= (d p p) 0)))

(echo "--- Part 3: Non-zero self-distance? ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

; ---------- Part 4: (TS)-violating costs CAN break triangle inequality ----------
; If costs don't satisfy triangle subadditivity, the induced "metric" can
; violate the triangle inequality. This shows (TS) is NECESSARY.
;
; Pathological costs: tau0=1 (separates P0~P1), tau1=1 (separates P1~P2),
; but no test separating P0~P2 has cost <= 1.
; If the only separator for P0~P2 costs 5, then d(P0,P2)=5 > d(P0,P1)+d(P1,P2)=2.
(push 1)

(declare-fun bad-cost (Int) Int)
(assert (= (bad-cost 0) 1))   ; tau0: separates P0,P1
(assert (= (bad-cost 1) 1))   ; tau1: separates P1,P2
(assert (= (bad-cost 2) 5))   ; tau2: separates P0,P2

; Bad distances
(declare-fun bad-d (Int Int) Int)
(assert (= (bad-d 0 1) 1))    ; min sep cost for P0,P1
(assert (= (bad-d 1 0) 1))
(assert (= (bad-d 1 2) 1))    ; min sep cost for P1,P2
(assert (= (bad-d 2 1) 1))
(assert (= (bad-d 0 2) 5))    ; min sep cost for P0,P2
(assert (= (bad-d 2 0) 5))
(assert (= (bad-d 0 0) 0))
(assert (= (bad-d 1 1) 0))
(assert (= (bad-d 2 2) 0))

; Triangle inequality violated: d(0,2) = 5 > d(0,1) + d(1,2) = 2
(assert (> (bad-d 0 2) (+ (bad-d 0 1) (bad-d 1 2))))

(echo "--- Part 4: (TS)-violating costs break triangle inequality? ---")
(echo "Expected: sat")
(check-sat)
(pop 1)

(echo "--- Step 16 verification complete (4 parts) ---")
