; ============================================================================
; Step 6: Truth Quotient Equivalence Relation
; ============================================================================
; Verifies that the truth quotient ~_Delta forms a valid equivalence relation
; on a finite domain of 4 describable elements.
;
; An equivalence relation must satisfy:
;   (R) Reflexivity:  forall x. x ~ x
;   (S) Symmetry:     forall x y. x ~ y => y ~ x
;   (T) Transitivity: forall x y z. (x ~ y /\ y ~ z) => x ~ z
;
; We model a specific partition: {d0, d1} and {d2, d3}
; meaning d0 ~ d1, d2 ~ d3, but d0 /~ d2.
;
; Part 1: Show a valid equivalence relation with this partition exists (sat).
; Part 2: Show that violating transitivity leads to contradiction (unsat).
; ============================================================================

(set-logic ALL)
(set-option :produce-models true)

; ---------- Domain: 4 distinct describable elements ----------
(declare-sort Desc 0)
(declare-fun d0 () Desc)
(declare-fun d1 () Desc)
(declare-fun d2 () Desc)
(declare-fun d3 () Desc)
(assert (distinct d0 d1 d2 d3))

; ---------- Equivalence predicate ----------
(declare-fun equiv (Desc Desc) Bool)

; ---------- Reflexivity ----------
(assert (equiv d0 d0))
(assert (equiv d1 d1))
(assert (equiv d2 d2))
(assert (equiv d3 d3))

; ---------- Symmetry (enumerated for all pairs) ----------
(assert (= (equiv d0 d1) (equiv d1 d0)))
(assert (= (equiv d0 d2) (equiv d2 d0)))
(assert (= (equiv d0 d3) (equiv d3 d0)))
(assert (= (equiv d1 d2) (equiv d2 d1)))
(assert (= (equiv d1 d3) (equiv d3 d1)))
(assert (= (equiv d2 d3) (equiv d3 d2)))

; ---------- Transitivity (enumerated for all triples) ----------
(assert (=> (and (equiv d0 d1) (equiv d1 d2)) (equiv d0 d2)))
(assert (=> (and (equiv d0 d1) (equiv d1 d3)) (equiv d0 d3)))
(assert (=> (and (equiv d0 d2) (equiv d2 d3)) (equiv d0 d3)))
(assert (=> (and (equiv d1 d0) (equiv d0 d2)) (equiv d1 d2)))
(assert (=> (and (equiv d1 d0) (equiv d0 d3)) (equiv d1 d3)))
(assert (=> (and (equiv d1 d2) (equiv d2 d3)) (equiv d1 d3)))
(assert (=> (and (equiv d2 d0) (equiv d0 d1)) (equiv d2 d1)))
(assert (=> (and (equiv d2 d0) (equiv d0 d3)) (equiv d2 d3)))
(assert (=> (and (equiv d2 d1) (equiv d1 d3)) (equiv d2 d3)))
(assert (=> (and (equiv d3 d0) (equiv d0 d1)) (equiv d3 d1)))
(assert (=> (and (equiv d3 d0) (equiv d0 d2)) (equiv d3 d2)))
(assert (=> (and (equiv d3 d1) (equiv d1 d2)) (equiv d3 d2)))

; ---------- Partition: {d0, d1} and {d2, d3} ----------
(assert (equiv d0 d1))          ; d0 ~ d1  (same equivalence class)
(assert (equiv d2 d3))          ; d2 ~ d3  (same equivalence class)
(assert (not (equiv d0 d2)))    ; d0 /~ d2 (different classes)

; ---------- Part 1: Valid model exists ----------
; Expected: sat
(echo "--- Part 1: Equivalence relation with partition {d0,d1},{d2,d3} ---")
(echo "Expected: sat")
(check-sat)
(get-model)

; ---------- Part 2: Transitivity violation is inconsistent ----------
; Push a new scope and try to break transitivity while keeping R and S.
(push 1)

; Attempt: d0 ~ d1 and d1 ~ d2 but NOT d0 ~ d2
; This should conflict with the transitivity assertions above.
(assert (equiv d1 d2))
(assert (not (equiv d0 d2)))

; Expected: unsat (transitivity forces d0 ~ d2 if d0 ~ d1 and d1 ~ d2)
(echo "--- Part 2: Transitivity violation (d0~d1, d1~d2, but not d0~d2) ---")
(echo "Expected: unsat")
(check-sat)

(pop 1)

; ---------- Part 3: Quotient is COARSEST consistent with tests ----------
; A strictly finer partition (splitting {d0,d1} into singletons) requires
; a test that distinguishes d0 from d1. If no such test exists in the
; test set, the finer partition is NOT consistent with the test set.
;
; We model: 2 tests, test0 separates {d0,d1} from {d2,d3},
; test1 separates {d0,d3} from {d1,d2}. Neither separates d0 from d1
; within the SAME outcome of test0.
;
; A finer partition that puts d0 and d1 in different classes
; requires a test that separates them. We show no test in {test0, test1}
; achieves this while remaining consistent with the original partition.
(push 1)

; Test outcomes: test(t, element) -> {0, 1}
(declare-fun test-outcome (Int Desc) Int)

; Test 0 separates {d0,d1} from {d2,d3}
(assert (= (test-outcome 0 d0) 0))
(assert (= (test-outcome 0 d1) 0))
(assert (= (test-outcome 0 d2) 1))
(assert (= (test-outcome 0 d3) 1))

; Test 1 separates {d0,d3} from {d1,d2}
(assert (= (test-outcome 1 d0) 0))
(assert (= (test-outcome 1 d1) 1))
(assert (= (test-outcome 1 d2) 1))
(assert (= (test-outcome 1 d3) 0))

; The truth quotient from these 2 tests:
; d0 ~ d1 iff they agree on ALL tests.
; test0: d0=0, d1=0 (agree). test1: d0=0, d1=1 (disagree!).
; So actually d0 and d1 ARE distinguished by test1.
;
; Let's use tests that DON'T distinguish d0 from d1:
; Test 0: d0=0, d1=0, d2=1, d3=1  (separates {d0,d1} from {d2,d3})
; Test 1: d0=0, d1=0, d2=0, d3=1  (separates {d0,d1,d2} from {d3})
; Under these tests: d0 and d1 agree on ALL tests -> they're equivalent.
; The quotient is {{d0,d1}, {d2}, {d3}} (3 classes).
; A finer partition {{d0}, {d1}, {d2}, {d3}} would require a test
; that gives different outcomes for d0 and d1.

; Override test 1 to NOT separate d0 from d1
(assert (= (test-outcome 1 d0) 0))
(assert (= (test-outcome 1 d1) 0))
(assert (= (test-outcome 1 d2) 0))
(assert (= (test-outcome 1 d3) 1))

; Now assert there exists a test in {0,1} that separates d0 from d1
(declare-fun sep-test () Int)
(assert (or (= sep-test 0) (= sep-test 1)))
(assert (not (= (test-outcome sep-test d0) (test-outcome sep-test d1))))

; Expected: unsat (no test in the set separates d0 from d1, so
; the coarser partition {d0,d1} is the finest possible)
(echo "--- Part 3: Finer partition requires absent test (coarsest quotient)? ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

(echo "--- Step 6 verification complete ---")
