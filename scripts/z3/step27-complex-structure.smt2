; ============================================================================
; Step 27: Complex Structure — J^2 = -Id on 4D Real Vector Space
; ============================================================================
; An almost-complex structure J on a 2n-dimensional real vector space
; satisfies J^2 = -Id. This is the algebraic encoding of "multiplication
; by i" on each complex plane in the tangent space.
;
; Model: 4D real vector space (n=2 complex dimensions).
; J is block-diagonal with 2x2 blocks:
;   J = [[0, -1, 0, 0],
;        [1,  0, 0, 0],
;        [0,  0, 0, -1],
;        [0,  0, 1,  0]]
;
; J^2 should equal:
;   [[-1, 0, 0, 0],
;    [0, -1, 0, 0],
;    [0, 0, -1, 0],
;    [0, 0, 0, -1]] = -Id
;
; We verify:
;   Part 1: J^2 = -Id for the block-diagonal structure (sat)
;   Part 2: J^2 = +Id and J^2 = -Id simultaneously is contradictory (unsat)
;   Part 3: det(J) = 1 (J is orientation-preserving) (sat)
; ============================================================================

(set-logic ALL)
(set-option :produce-models true)

; ---------- 4x4 matrix J ----------
(declare-fun J (Int Int) Int)

; Block 1: [[0, -1], [1, 0]]
(assert (= (J 0 0) 0))  (assert (= (J 0 1) (- 1)))
(assert (= (J 1 0) 1))  (assert (= (J 1 1) 0))

; Off-diagonal blocks = 0
(assert (= (J 0 2) 0))  (assert (= (J 0 3) 0))
(assert (= (J 1 2) 0))  (assert (= (J 1 3) 0))
(assert (= (J 2 0) 0))  (assert (= (J 2 1) 0))
(assert (= (J 3 0) 0))  (assert (= (J 3 1) 0))

; Block 2: [[0, -1], [1, 0]]
(assert (= (J 2 2) 0))  (assert (= (J 2 3) (- 1)))
(assert (= (J 3 2) 1))  (assert (= (J 3 3) 0))

; ---------- Compute J^2 = J * J ----------
; (J^2)_{ik} = sum_j J_{ij} * J_{jk}
(declare-fun J2 (Int Int) Int)

; Compute all 16 entries of J^2
; Row 0: J2(0,k) = J(0,0)*J(0,k) + J(0,1)*J(1,k) + J(0,2)*J(2,k) + J(0,3)*J(3,k)
(assert (= (J2 0 0) (+ (* (J 0 0) (J 0 0)) (* (J 0 1) (J 1 0)) (* (J 0 2) (J 2 0)) (* (J 0 3) (J 3 0)))))
(assert (= (J2 0 1) (+ (* (J 0 0) (J 0 1)) (* (J 0 1) (J 1 1)) (* (J 0 2) (J 2 1)) (* (J 0 3) (J 3 1)))))
(assert (= (J2 0 2) (+ (* (J 0 0) (J 0 2)) (* (J 0 1) (J 1 2)) (* (J 0 2) (J 2 2)) (* (J 0 3) (J 3 2)))))
(assert (= (J2 0 3) (+ (* (J 0 0) (J 0 3)) (* (J 0 1) (J 1 3)) (* (J 0 2) (J 2 3)) (* (J 0 3) (J 3 3)))))

; Row 1
(assert (= (J2 1 0) (+ (* (J 1 0) (J 0 0)) (* (J 1 1) (J 1 0)) (* (J 1 2) (J 2 0)) (* (J 1 3) (J 3 0)))))
(assert (= (J2 1 1) (+ (* (J 1 0) (J 0 1)) (* (J 1 1) (J 1 1)) (* (J 1 2) (J 2 1)) (* (J 1 3) (J 3 1)))))
(assert (= (J2 1 2) (+ (* (J 1 0) (J 0 2)) (* (J 1 1) (J 1 2)) (* (J 1 2) (J 2 2)) (* (J 1 3) (J 3 2)))))
(assert (= (J2 1 3) (+ (* (J 1 0) (J 0 3)) (* (J 1 1) (J 1 3)) (* (J 1 2) (J 2 3)) (* (J 1 3) (J 3 3)))))

; Row 2
(assert (= (J2 2 0) (+ (* (J 2 0) (J 0 0)) (* (J 2 1) (J 1 0)) (* (J 2 2) (J 2 0)) (* (J 2 3) (J 3 0)))))
(assert (= (J2 2 1) (+ (* (J 2 0) (J 0 1)) (* (J 2 1) (J 1 1)) (* (J 2 2) (J 2 1)) (* (J 2 3) (J 3 1)))))
(assert (= (J2 2 2) (+ (* (J 2 0) (J 0 2)) (* (J 2 1) (J 1 2)) (* (J 2 2) (J 2 2)) (* (J 2 3) (J 3 2)))))
(assert (= (J2 2 3) (+ (* (J 2 0) (J 0 3)) (* (J 2 1) (J 1 3)) (* (J 2 2) (J 2 3)) (* (J 2 3) (J 3 3)))))

; Row 3
(assert (= (J2 3 0) (+ (* (J 3 0) (J 0 0)) (* (J 3 1) (J 1 0)) (* (J 3 2) (J 2 0)) (* (J 3 3) (J 3 0)))))
(assert (= (J2 3 1) (+ (* (J 3 0) (J 0 1)) (* (J 3 1) (J 1 1)) (* (J 3 2) (J 2 1)) (* (J 3 3) (J 3 1)))))
(assert (= (J2 3 2) (+ (* (J 3 0) (J 0 2)) (* (J 3 1) (J 1 2)) (* (J 3 2) (J 2 2)) (* (J 3 3) (J 3 2)))))
(assert (= (J2 3 3) (+ (* (J 3 0) (J 0 3)) (* (J 3 1) (J 1 3)) (* (J 3 2) (J 2 3)) (* (J 3 3) (J 3 3)))))

; ---------- Part 1: J^2 = -Id (sat) ----------
(push 1)

; Assert J^2 = -Id
(assert (= (J2 0 0) (- 1))) (assert (= (J2 0 1) 0))  (assert (= (J2 0 2) 0))  (assert (= (J2 0 3) 0))
(assert (= (J2 1 0) 0))  (assert (= (J2 1 1) (- 1))) (assert (= (J2 1 2) 0))  (assert (= (J2 1 3) 0))
(assert (= (J2 2 0) 0))  (assert (= (J2 2 1) 0))  (assert (= (J2 2 2) (- 1))) (assert (= (J2 2 3) 0))
(assert (= (J2 3 0) 0))  (assert (= (J2 3 1) 0))  (assert (= (J2 3 2) 0))  (assert (= (J2 3 3) (- 1)))

(echo "--- Part 1: J^2 = -Id for block-diagonal J ---")
(echo "Expected: sat")
(check-sat)
(pop 1)

; ---------- Part 2: J^2 = +Id and J^2 = -Id simultaneously (unsat) ----------
(push 1)

; Assert J^2 = -Id (diagonal)
(assert (= (J2 0 0) (- 1)))
(assert (= (J2 1 1) (- 1)))
(assert (= (J2 2 2) (- 1)))
(assert (= (J2 3 3) (- 1)))

; Also assert J^2 = +Id (diagonal)
(assert (= (J2 0 0) 1))
(assert (= (J2 1 1) 1))
(assert (= (J2 2 2) 1))
(assert (= (J2 3 3) 1))

(echo "--- Part 2: J^2 = +Id and J^2 = -Id simultaneously? ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

; ---------- Part 3: det(J) = 1 (orientation-preserving) ----------
; For a 4x4 block-diagonal matrix with blocks [[0,-1],[1,0]]:
; det = det(block1) * det(block2) = (0*0 - (-1)*1) * (0*0 - (-1)*1) = 1 * 1 = 1
(push 1)

; Compute det of each 2x2 block
(declare-fun det1 () Int)
(declare-fun det2 () Int)
(declare-fun detJ () Int)

(assert (= det1 (- (* (J 0 0) (J 1 1)) (* (J 0 1) (J 1 0)))))
(assert (= det2 (- (* (J 2 2) (J 3 3)) (* (J 2 3) (J 3 2)))))
(assert (= detJ (* det1 det2)))

; Assert det(J) = 1
(assert (= detJ 1))

(echo "--- Part 3: det(J) = 1 (orientation-preserving) ---")
(echo "Expected: sat")
(check-sat)
(pop 1)

(echo "--- Step 27 verification complete (3 parts) ---")
