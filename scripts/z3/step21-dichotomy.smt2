; ============================================================================
; Step 21: UNIQUE / OMEGA / UNSAT Exhaustive Trichotomy
; ============================================================================
; The Null-State Logic kernel produces exactly one of three terminal states:
;
;   UNIQUE (+1): Exactly one surviving answer  |W| = 1
;   OMEGA   (0): Multiple surviving answers    |W| > 1
;   UNSAT  (-1): No surviving answers          |W| = 0
;
; These three cases are:
;   (a) Mutually exclusive: no two can hold simultaneously
;   (b) Exhaustive: at least one must hold
;
; We model this on a surviving answer set W with up to 6 elements.
; ============================================================================

(set-logic ALL)
(set-option :produce-models true)

; ---------- Surviving answer set as membership predicates ----------
(declare-fun w0 () Bool)
(declare-fun w1 () Bool)
(declare-fun w2 () Bool)
(declare-fun w3 () Bool)
(declare-fun w4 () Bool)
(declare-fun w5 () Bool)

; ---------- Cardinality ----------
(declare-fun card () Int)
(assert (= card (+ (ite w0 1 0) (ite w1 1 0) (ite w2 1 0)
                   (ite w3 1 0) (ite w4 1 0) (ite w5 1 0))))

; ---------- Three cases ----------
(declare-fun is-UNIQUE () Bool)
(declare-fun is-OMEGA () Bool)
(declare-fun is-UNSAT () Bool)

(assert (= is-UNIQUE (= card 1)))
(assert (= is-OMEGA  (> card 1)))
(assert (= is-UNSAT  (= card 0)))

; ---------- Part 1: UNIQUE case exists ----------
(push 1)
(assert is-UNIQUE)

; Expected: sat (e.g., exactly one element true)
(echo "--- Part 1: UNIQUE case (|W| = 1) ---")
(echo "Expected: sat")
(check-sat)
(get-model)
(pop 1)

; ---------- Part 2: OMEGA case exists ----------
(push 1)
(assert is-OMEGA)

; Expected: sat (e.g., two or more elements true)
(echo "--- Part 2: OMEGA case (|W| > 1) ---")
(echo "Expected: sat")
(check-sat)
(get-model)
(pop 1)

; ---------- Part 3: UNSAT case exists ----------
(push 1)
(assert is-UNSAT)

; Expected: sat (all elements false)
(echo "--- Part 3: UNSAT case (|W| = 0) ---")
(echo "Expected: sat")
(check-sat)
(get-model)
(pop 1)

; ---------- Part 4: Mutual exclusivity ----------
; No two cases can be true simultaneously.

; UNIQUE and OMEGA
(push 1)
(assert is-UNIQUE)
(assert is-OMEGA)
; Expected: unsat (card=1 and card>1 is impossible)
(echo "--- Part 4a: UNIQUE and OMEGA simultaneously ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

; UNIQUE and UNSAT
(push 1)
(assert is-UNIQUE)
(assert is-UNSAT)
; Expected: unsat (card=1 and card=0 is impossible)
(echo "--- Part 4b: UNIQUE and UNSAT simultaneously ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

; OMEGA and UNSAT
(push 1)
(assert is-OMEGA)
(assert is-UNSAT)
; Expected: unsat (card>1 and card=0 is impossible)
(echo "--- Part 4c: OMEGA and UNSAT simultaneously ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

; ---------- Part 5: Exhaustiveness ----------
; Assert NONE of the three cases holds.
(push 1)
(assert (not is-UNIQUE))
(assert (not is-OMEGA))
(assert (not is-UNSAT))

; Expected: unsat (cardinality must be 0, 1, or >1 -- these cover all of N)
(echo "--- Part 5: No case holds (exhaustiveness) ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

; ---------- Part 6: The three cases partition all possibilities ----------
; Assert exactly one of the three holds (tautology check).
(push 1)
; Exactly one: (A xor B xor C) and not (A and B) and not (A and C) and not (B and C)
(assert (not (or (and is-UNIQUE (not is-OMEGA) (not is-UNSAT))
                 (and (not is-UNIQUE) is-OMEGA (not is-UNSAT))
                 (and (not is-UNIQUE) (not is-OMEGA) is-UNSAT))))

; Expected: unsat (the partition is always true)
(echo "--- Part 6: Exactly-one partition holds ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

(echo "--- Step 21 verification complete ---")
