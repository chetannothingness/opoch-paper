; ============================================================================
; Step 8: Fiber Shrinkage (Monotone Decrease of Surviving Answers)
; ============================================================================
; After each test fires, the set of surviving answers W can only shrink or
; stay the same: |W'| <= |W|. This models the irreversible information gain
; from Axiom T (time as irreversible ledger).
;
; We model a fiber (surviving answer set) as membership predicates over
; 8 elements. A test partitions the universe; after recording a test result,
; elements not matching the observation are filtered out.
;
; Part 1: Show a valid filtering exists (sat).
; Part 2: Prove |W'| > |W| is impossible under filtering (unsat).
; ============================================================================

(set-logic ALL)
(set-option :produce-models true)

; ---------- 8 elements representing possible answers ----------
(declare-fun w0-before () Bool)
(declare-fun w1-before () Bool)
(declare-fun w2-before () Bool)
(declare-fun w3-before () Bool)
(declare-fun w4-before () Bool)
(declare-fun w5-before () Bool)
(declare-fun w6-before () Bool)
(declare-fun w7-before () Bool)

(declare-fun w0-after () Bool)
(declare-fun w1-after () Bool)
(declare-fun w2-after () Bool)
(declare-fun w3-after () Bool)
(declare-fun w4-after () Bool)
(declare-fun w5-after () Bool)
(declare-fun w6-after () Bool)
(declare-fun w7-after () Bool)

; ---------- Filtering constraint: after-set is subset of before-set ----------
; An element can only survive if it was present before the test.
(assert (=> w0-after w0-before))
(assert (=> w1-after w1-before))
(assert (=> w2-after w2-before))
(assert (=> w3-after w3-before))
(assert (=> w4-after w4-before))
(assert (=> w5-after w5-before))
(assert (=> w6-after w6-before))
(assert (=> w7-after w7-before))

; ---------- Cardinality as integer sums ----------
(declare-fun count-before () Int)
(declare-fun count-after () Int)

(assert (= count-before
  (+ (ite w0-before 1 0) (ite w1-before 1 0)
     (ite w2-before 1 0) (ite w3-before 1 0)
     (ite w4-before 1 0) (ite w5-before 1 0)
     (ite w6-before 1 0) (ite w7-before 1 0))))

(assert (= count-after
  (+ (ite w0-after 1 0) (ite w1-after 1 0)
     (ite w2-after 1 0) (ite w3-after 1 0)
     (ite w4-after 1 0) (ite w5-after 1 0)
     (ite w6-after 1 0) (ite w7-after 1 0))))

; ---------- Part 1: A valid filtering scenario (some elements removed) ----------
(push 1)
; Before: 5 elements survive
(assert w0-before) (assert w1-before) (assert w2-before)
(assert w3-before) (assert w4-before)
(assert (not w5-before)) (assert (not w6-before)) (assert (not w7-before))

; After test: 3 elements remain (filtered out w2 and w3)
(assert w0-after) (assert w1-after) (assert (not w2-after))
(assert (not w3-after)) (assert w4-after)
(assert (not w5-after)) (assert (not w6-after)) (assert (not w7-after))

; Expected: sat (valid filtering with |W'|=3 <= |W|=5)
(echo "--- Part 1: Valid fiber shrinkage (5 -> 3) ---")
(echo "Expected: sat")
(check-sat)
(echo "")
(pop 1)

; ---------- Part 2: Prove growth is impossible ----------
; Assert that after filtering, the count is STRICTLY greater.
; Under subset constraint, this must be unsat.
(push 1)
(assert (> count-after count-before))

; Expected: unsat (subset can never be larger than superset)
(echo "--- Part 2: Assert |W'| > |W| under subset constraint ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

; ---------- Part 3: Verify at-least-one-removed means strict decrease ----------
(push 1)
; Before: all 8 present
(assert w0-before) (assert w1-before) (assert w2-before) (assert w3-before)
(assert w4-before) (assert w5-before) (assert w6-before) (assert w7-before)

; At least one element is removed by the test
(assert (or (and w0-before (not w0-after))
            (and w1-before (not w1-after))
            (and w2-before (not w2-after))
            (and w3-before (not w3-after))
            (and w4-before (not w4-after))
            (and w5-before (not w5-after))
            (and w6-before (not w6-after))
            (and w7-before (not w7-after))))

; Assert count did NOT decrease (i.e., count-after >= count-before)
; Under subset + at-least-one-removed, this should be unsat.
(assert (>= count-after count-before))

; Expected: unsat (if at least one removed, strict decrease is forced)
(echo "--- Part 3: At-least-one-removed implies strict decrease ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

(echo "--- Step 8 verification complete ---")
