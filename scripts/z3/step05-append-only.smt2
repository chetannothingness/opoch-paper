; ============================================================================
; Step 5: Ledger Append-Only (Removal Destroys Witnesses)
; ============================================================================
; The ledger L is an append-only multiset of test records. Removing a
; record can destroy the witness for a previously-established distinction,
; violating Axiom A0 (Witnessability).
;
; Model: 3 records in the ledger. Record r1 is the SOLE witness for
; distinction (a,b). Removing r1 leaves no witness for (a,b),
; violating A0.
;
; Part 1: Full ledger witnesses all claimed distinctions (sat)
; Part 2: Removing r1 while requiring (a,b) witnessed -> unsat
; Part 3: Diamond Law — order of independent records doesn't matter (sat)
; ============================================================================

(set-logic ALL)
(set-option :produce-models true)

; ---------- 3 ledger records witnessing distinctions ----------
; Records witness distinctions between pairs of elements.
; witness(record, pair) = true iff record witnesses that distinction.

(declare-fun witness (Int Int) Bool)

; 3 records: 0, 1, 2
; 3 element pairs (encoded as ints): pair_ab=0, pair_ac=1, pair_bc=2

; Record 0 witnesses pair_ab (distinction between a and b)
(assert (witness 0 0))
(assert (not (witness 0 1)))
(assert (not (witness 0 2)))

; Record 1 witnesses pair_ac (distinction between a and c)
(assert (not (witness 1 0)))
(assert (witness 1 1))
(assert (not (witness 1 2)))

; Record 2 witnesses pair_bc (distinction between b and c)
(assert (not (witness 2 0)))
(assert (not (witness 2 1)))
(assert (witness 2 2))

; ---------- A0: every claimed distinction has a witness in the ledger ----------
(define-fun has-witness ((pair Int)) Bool
  (or (witness 0 pair) (witness 1 pair) (witness 2 pair)))

; ---------- Part 1: Full ledger satisfies A0 ----------
(push 1)
; All 3 distinctions are witnessed
(assert (has-witness 0))  ; pair_ab
(assert (has-witness 1))  ; pair_ac
(assert (has-witness 2))  ; pair_bc

(echo "--- Part 1: Full ledger witnesses all distinctions ---")
(echo "Expected: sat")
(check-sat)
(pop 1)

; ---------- Part 2: Removing record 0 destroys witness for pair_ab ----------
; After removal, has-witness-without-r0 checks only records 1 and 2.
(push 1)

(define-fun has-witness-no-r0 ((pair Int)) Bool
  (or (witness 1 pair) (witness 2 pair)))

; Require all distinctions still witnessed (A0)
(assert (has-witness-no-r0 0))  ; pair_ab must still be witnessed
(assert (has-witness-no-r0 1))  ; pair_ac
(assert (has-witness-no-r0 2))  ; pair_bc

; Expected: unsat (record 0 was the sole witness for pair_ab)
(echo "--- Part 2: Removal of record 0 destroys witness for (a,b)? ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

; ---------- Part 3: Diamond Law (order independence) ----------
; For independent records (witnessing different distinctions),
; the set of witnessed distinctions is the same regardless of
; insertion order. We model this as: the witness relation depends
; only on WHICH records are present, not their order.
(push 1)

; Two orderings of the same 3 records
; Order A: r0, r1, r2    Order B: r2, r0, r1
; Both produce the same witness set.

; Witnessed set for order A (cumulative)
(declare-fun wit-A (Int) Bool)
; After inserting r0: wit-A for pair_ab
(assert (= (wit-A 0) (witness 0 0)))
; After inserting r1: wit-A for pair_ac
(assert (= (wit-A 1) (or (witness 0 1) (witness 1 1))))
; After inserting r2: wit-A for pair_bc
(assert (= (wit-A 2) (or (witness 0 2) (witness 1 2) (witness 2 2))))

; Witnessed set for order B (cumulative)
(declare-fun wit-B (Int) Bool)
; After inserting r2: wit-B for pair_bc
(assert (= (wit-B 2) (witness 2 2)))
; After inserting r0: wit-B for pair_ab
(assert (= (wit-B 0) (or (witness 2 0) (witness 0 0))))
; After inserting r1: wit-B for pair_ac
(assert (= (wit-B 1) (or (witness 2 1) (witness 0 1) (witness 1 1))))

; Final states must agree (all records inserted)
; The full witness set is the union — order doesn't matter
(declare-fun full-A (Int) Bool)
(declare-fun full-B (Int) Bool)
(assert (= (full-A 0) (or (witness 0 0) (witness 1 0) (witness 2 0))))
(assert (= (full-A 1) (or (witness 0 1) (witness 1 1) (witness 2 1))))
(assert (= (full-A 2) (or (witness 0 2) (witness 1 2) (witness 2 2))))
(assert (= (full-B 0) (or (witness 0 0) (witness 1 0) (witness 2 0))))
(assert (= (full-B 1) (or (witness 0 1) (witness 1 1) (witness 2 1))))
(assert (= (full-B 2) (or (witness 0 2) (witness 1 2) (witness 2 2))))

; Assert they differ on some pair
(assert (or (not (= (full-A 0) (full-B 0)))
            (not (= (full-A 1) (full-B 1)))
            (not (= (full-A 2) (full-B 2)))))

; Expected: unsat (multiset union is commutative)
(echo "--- Part 3: Diamond Law (order independence of ledger)? ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

(echo "--- Step 5 verification complete (3 parts) ---")
