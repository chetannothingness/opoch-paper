; ============================================================================
; Step 19: Self-Hosting Fixed Point  Y(K) = K
; ============================================================================
; The kernel K is a fixed point of the self-application operator Y:
;   Y(K) = K
; meaning the system can verify itself using its own rules.
;
; We model K as a function from queries (Int) to answers (Int),
; and Y as a higher-order operator that transforms kernels.
; The fixed-point condition requires Y(K)(q) = K(q) for all queries.
;
; Additionally, we verify:
;   - K is idempotent: K(K(q)) = K(q)  (applying the kernel twice = once)
;   - K is a retraction: K . K = K
;
; Finite model: 4 queries, 4 possible answers.
; ============================================================================

(set-logic ALL)
(set-option :produce-models true)

; ---------- Kernel K: maps queries {0,1,2,3} to answers {0,1,2,3} ----------
(declare-fun K (Int) Int)

; ---------- Operator Y: transforms a kernel into another kernel ----------
; Y is modeled as a function that takes a kernel-output and produces an answer.
; For the fixed-point, Y(K)(q) must equal K(q).
; We model Y applied to K as a separate function:
(declare-fun YK (Int) Int)

; ---------- Fixed-point condition: Y(K) = K ----------
; For all queries in {0,1,2,3}:
(assert (= (YK 0) (K 0)))
(assert (= (YK 1) (K 1)))
(assert (= (YK 2) (K 2)))
(assert (= (YK 3) (K 3)))

; ---------- Y's definition: Y applies the kernel to verify its own output ----------
; Y(K)(q) = K(K(q))  -- self-application: run K, then verify with K
(assert (= (YK 0) (K (K 0))))
(assert (= (YK 1) (K (K 1))))
(assert (= (YK 2) (K (K 2))))
(assert (= (YK 3) (K (K 3))))

; ---------- Part 1: Fixed point exists ----------
; Combined: K(q) = K(K(q)) for all q -- this means K is idempotent.
; Any idempotent function satisfies this.

; Expected: sat
(echo "--- Part 1: Self-hosting fixed point Y(K) = K ---")
(echo "Expected: sat")
(check-sat)
(get-model)

; ---------- Part 2: Idempotency is forced ----------
; The fixed-point condition Y(K)=K with Y(K)(q)=K(K(q)) forces K(K(q))=K(q).
; Let's verify: assert K is NOT idempotent for some query.
(push 1)
(assert (or (not (= (K (K 0)) (K 0)))
            (not (= (K (K 1)) (K 1)))
            (not (= (K (K 2)) (K 2)))
            (not (= (K (K 3)) (K 3)))))

; Expected: unsat (idempotency is forced by the fixed-point condition)
(echo "--- Part 2: Non-idempotent kernel? ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

; ---------- Part 3: K's range is a subset of K's fixed points ----------
; For any q, K(K(q)) = K(q) means K(q) is a fixed point of K.
; So img(K) subset fix(K). Let's verify: if v is in img(K), then K(v) = v.
(push 1)
; There exists q such that K(K(q)) != K(q)
; (This is the same as Part 2, rephrased as range-fixed-point.)
(declare-fun q () Int)
(assert (or (= q 0) (= q 1) (= q 2) (= q 3)))
(assert (not (= (K (K q)) (K q))))

; Expected: unsat
(echo "--- Part 3: Image of K not in fixed points of K? ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

; ---------- Part 4: Concrete non-trivial fixed point ----------
; Show K can be non-identity: K(0)=0, K(1)=0, K(2)=2, K(3)=2
; (projection onto {0, 2})
(push 1)
(assert (= (K 0) 0))
(assert (= (K 1) 0))
(assert (= (K 2) 2))
(assert (= (K 3) 2))

; Expected: sat (this is idempotent: K(K(0))=K(0)=0, K(K(1))=K(0)=0, etc.)
(echo "--- Part 4: Concrete non-trivial idempotent kernel ---")
(echo "Expected: sat")
(check-sat)
(get-model)
(pop 1)

(echo "--- Step 19 verification complete ---")
