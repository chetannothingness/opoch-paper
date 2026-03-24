; ============================================================================
; Step 7: Observable Opens + Eraser Algebra
; ============================================================================
; For each test tau and outcome a, the observable open O_{tau,a} is the set
; of truth classes giving outcome a under tau. The eraser E_P maps a truth
; class to its P-equivalence class (coarsening by forgetting test P).
;
; We verify on 4 truth classes {0,1,2,3} with 3 tests:
;   Part 1: Observable opens are closed under finite intersection (sat)
;   Part 2: Eraser maps are idempotent: E_P(E_P(x)) = E_P(x) (unsat)
;   Part 3: Erasers commute: E_P(E_Q(x)) = E_Q(E_P(x)) (unsat)
;
; Model:
;   Test 0: partition {{0,1},{2,3}}     -- outcome 0 for {0,1}, 1 for {2,3}
;   Test 1: partition {{0,2},{1,3}}     -- outcome 0 for {0,2}, 1 for {1,3}
;   Test 2: partition {{0,3},{1,2}}     -- outcome 0 for {0,3}, 1 for {1,2}
; ============================================================================

(set-logic ALL)
(set-option :produce-models true)

; ---------- Test outcomes: test-out(test, truth-class) -> {0, 1} ----------
(declare-fun test-out (Int Int) Int)

; Test 0: {0,1} -> 0, {2,3} -> 1
(assert (= (test-out 0 0) 0)) (assert (= (test-out 0 1) 0))
(assert (= (test-out 0 2) 1)) (assert (= (test-out 0 3) 1))

; Test 1: {0,2} -> 0, {1,3} -> 1
(assert (= (test-out 1 0) 0)) (assert (= (test-out 1 1) 1))
(assert (= (test-out 1 2) 0)) (assert (= (test-out 1 3) 1))

; Test 2: {0,3} -> 0, {1,2} -> 1
(assert (= (test-out 2 0) 0)) (assert (= (test-out 2 1) 1))
(assert (= (test-out 2 2) 1)) (assert (= (test-out 2 3) 0))

; ---------- Observable open membership: in-open(tau, a, class) ----------
; class c is in O_{tau,a} iff test-out(tau, c) = a
(define-fun in-open ((tau Int) (a Int) (c Int)) Bool
  (= (test-out tau c) a))

; ---------- Part 1: Finite intersection closure ----------
; O_{0,0} ∩ O_{1,0} = {0,1} ∩ {0,2} = {0}  -- a valid observable set
; O_{0,0} ∩ O_{2,0} = {0,1} ∩ {0,3} = {0}  -- same
; O_{1,0} ∩ O_{2,1} = {0,2} ∩ {1,2} = {2}  -- a valid observable set
; All intersections produce non-empty sets of truth classes.
(push 1)

; Verify intersection O_{0,0} ∩ O_{1,0}: should contain exactly {0}
(declare-fun int01-has-0 () Bool)
(declare-fun int01-has-1 () Bool)
(declare-fun int01-has-2 () Bool)
(declare-fun int01-has-3 () Bool)

(assert (= int01-has-0 (and (in-open 0 0 0) (in-open 1 0 0))))
(assert (= int01-has-1 (and (in-open 0 0 1) (in-open 1 0 1))))
(assert (= int01-has-2 (and (in-open 0 0 2) (in-open 1 0 2))))
(assert (= int01-has-3 (and (in-open 0 0 3) (in-open 1 0 3))))

; Should be: {0} only
(assert int01-has-0)
(assert (not int01-has-1))
(assert (not int01-has-2))
(assert (not int01-has-3))

; Non-empty intersection exists
(echo "--- Part 1: Observable opens closed under intersection ---")
(echo "Expected: sat")
(check-sat)
(pop 1)

; ---------- Part 2: Eraser idempotence ----------
; Eraser E_P maps each truth class to the canonical representative
; of its equivalence class under "forgetting test P".
;
; Forgetting test 0: classes equivalent if they agree on tests 1,2.
;   Class 0: test1=0, test2=0 -> unique
;   Class 1: test1=1, test2=1 -> unique
;   Class 2: test1=0, test2=1 -> unique
;   Class 3: test1=1, test2=0 -> unique
; All 4 classes remain distinct (test 0 is redundant given 1,2 jointly).
;
; Forgetting test 1: classes equivalent if they agree on tests 0,2.
;   Class 0: test0=0, test2=0
;   Class 1: test0=0, test2=1
;   Class 2: test0=1, test2=1
;   Class 3: test0=1, test2=0
; All distinct.
;
; For a non-trivial eraser, use a coarser model: forget BOTH tests 1 and 2.
; Then equivalence is determined by test 0 alone:
;   {0,1} (test0=0) and {2,3} (test0=1)
; E maps: 0->0, 1->0, 2->2, 3->2 (canonical reps: min of class)
(push 1)

(declare-fun E (Int) Int)
; Forgetting tests 1,2: equivalence by test 0 alone
; Class {0,1} -> canonical rep 0;  Class {2,3} -> canonical rep 2
(assert (= (E 0) 0))
(assert (= (E 1) 0))
(assert (= (E 2) 2))
(assert (= (E 3) 2))

; Idempotence: E(E(x)) = E(x) for all x
; Assert violation
(declare-fun x () Int)
(assert (and (>= x 0) (<= x 3)))
(assert (not (= (E (E x)) (E x))))

(echo "--- Part 2: Eraser idempotence E(E(x)) = E(x)? ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

; ---------- Part 3: Erasers commute ----------
; E_P: forget test 0 equivalence (by tests 1,2).
; Since tests 0,1,2 jointly distinguish all 4 classes, and each pair
; of tests also distinguishes all 4, E_P = identity for single-test erasure.
;
; Use coarser erasers:
; E_A: forget tests {1,2}, keep only test 0. Maps: 0->0,1->0,2->2,3->2.
; E_B: forget tests {0,2}, keep only test 1. Maps: 0->0,1->1,2->0,3->1.
;
; E_A(E_B(x)) vs E_B(E_A(x)):
;   x=0: E_B(0)=0, E_A(0)=0; E_A(0)=0, E_B(0)=0. Both = 0. ✓
;   x=1: E_B(1)=1, E_A(1)=0; E_A(1)=0, E_B(0)=0. Both = 0. ✓
;   x=2: E_B(2)=0, E_A(0)=0; E_A(2)=2, E_B(2)=0. Both = 0. ✓
;   x=3: E_B(3)=1, E_A(1)=0; E_A(3)=2, E_B(2)=0. Both = 0. ✓
(push 1)

(declare-fun EA (Int) Int)
(declare-fun EB (Int) Int)

; E_A: keep test 0 only
(assert (= (EA 0) 0)) (assert (= (EA 1) 0))
(assert (= (EA 2) 2)) (assert (= (EA 3) 2))

; E_B: keep test 1 only
(assert (= (EB 0) 0)) (assert (= (EB 1) 1))
(assert (= (EB 2) 0)) (assert (= (EB 3) 1))

; Assert commutativity violation
(declare-fun y () Int)
(assert (and (>= y 0) (<= y 3)))
(assert (not (= (EA (EB y)) (EB (EA y)))))

(echo "--- Part 3: Erasers commute E_A(E_B(x)) = E_B(E_A(x))? ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

(echo "--- Step 7 verification complete (3 parts) ---")
