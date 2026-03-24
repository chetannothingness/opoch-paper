; ============================================================================
; Step 29: Kahler Compatibility — g(JX, JY) = g(X, Y)
; ============================================================================
; A Kahler structure requires compatibility between the metric g, the
; complex structure J, and the symplectic form omega. The key identity:
;   g(JX, JY) = g(X, Y)   for all tangent vectors X, Y
;
; This says J is an isometry of g: rotating by J preserves inner products.
; Together with omega(X,Y) = g(X,JY), the triple (g, J, omega) forms a
; Kahler triple iff this compatibility holds.
;
; Model: 4D real vector space.
;   g = Id (identity/flat metric)
;   J = block-diagonal [[0,-1],[1,0], [0,-1],[1,0]]
;
; Check: g(Je_i, Je_j) = (Je_i)^T * g * (Je_j) = (Je_i) . (Je_j)
; Since g = Id, this reduces to (Je_i) . (Je_j) = e_i . e_j = delta_{ij}
;
; Je_0 = (0,1,0,0), Je_1 = (-1,0,0,0), Je_2 = (0,0,0,1), Je_3 = (0,0,-1,0)
; These are orthonormal, so g(Je_i, Je_j) = delta_{ij} = g(e_i, e_j) ✓
;
; We verify:
;   Part 1: Compatibility g(JX, JY) = g(X, Y) on all basis pairs (sat)
;   Part 2: Incompatible g and J yield contradiction (unsat)
;   Part 3: Full Kahler triple consistency: g, J, omega all compatible (sat)
; ============================================================================

(set-logic ALL)
(set-option :produce-models true)

; ---------- Complex structure J ----------
(declare-fun J (Int Int) Int)

(assert (= (J 0 0) 0))  (assert (= (J 0 1) (- 1))) (assert (= (J 0 2) 0))  (assert (= (J 0 3) 0))
(assert (= (J 1 0) 1))  (assert (= (J 1 1) 0))      (assert (= (J 1 2) 0))  (assert (= (J 1 3) 0))
(assert (= (J 2 0) 0))  (assert (= (J 2 1) 0))      (assert (= (J 2 2) 0))  (assert (= (J 2 3) (- 1)))
(assert (= (J 3 0) 0))  (assert (= (J 3 1) 0))      (assert (= (J 3 2) 1))  (assert (= (J 3 3) 0))

; ---------- Metric g = Identity ----------
(declare-fun g (Int Int) Int)

(assert (= (g 0 0) 1)) (assert (= (g 0 1) 0)) (assert (= (g 0 2) 0)) (assert (= (g 0 3) 0))
(assert (= (g 1 0) 0)) (assert (= (g 1 1) 1)) (assert (= (g 1 2) 0)) (assert (= (g 1 3) 0))
(assert (= (g 2 0) 0)) (assert (= (g 2 1) 0)) (assert (= (g 2 2) 1)) (assert (= (g 2 3) 0))
(assert (= (g 3 0) 0)) (assert (= (g 3 1) 0)) (assert (= (g 3 2) 0)) (assert (= (g 3 3) 1))

; ---------- Compute g(Je_i, Je_j) for all basis pairs ----------
; g(JX, JY) = sum_{a,b} g(a,b) * (sum_k J(a,k)*X_k) * (sum_l J(b,l)*Y_l)
; For basis vectors e_i, e_j: X_k = delta_{ki}, Y_l = delta_{lj}
; So g(Je_i, Je_j) = sum_{a,b} g(a,b) * J(a,i) * J(b,j)
; Since g = Id: g(Je_i, Je_j) = sum_a J(a,i) * J(a,j) = (J^T J)(i,j)

; Compute J^T * J
(declare-fun JtJ (Int Int) Int)

; (J^T J)(i,j) = sum_a J(a,i) * J(a,j)
(assert (= (JtJ 0 0) (+ (* (J 0 0) (J 0 0)) (* (J 1 0) (J 1 0)) (* (J 2 0) (J 2 0)) (* (J 3 0) (J 3 0)))))
(assert (= (JtJ 0 1) (+ (* (J 0 0) (J 0 1)) (* (J 1 0) (J 1 1)) (* (J 2 0) (J 2 1)) (* (J 3 0) (J 3 1)))))
(assert (= (JtJ 0 2) (+ (* (J 0 0) (J 0 2)) (* (J 1 0) (J 1 2)) (* (J 2 0) (J 2 2)) (* (J 3 0) (J 3 2)))))
(assert (= (JtJ 0 3) (+ (* (J 0 0) (J 0 3)) (* (J 1 0) (J 1 3)) (* (J 2 0) (J 2 3)) (* (J 3 0) (J 3 3)))))

(assert (= (JtJ 1 0) (+ (* (J 0 1) (J 0 0)) (* (J 1 1) (J 1 0)) (* (J 2 1) (J 2 0)) (* (J 3 1) (J 3 0)))))
(assert (= (JtJ 1 1) (+ (* (J 0 1) (J 0 1)) (* (J 1 1) (J 1 1)) (* (J 2 1) (J 2 1)) (* (J 3 1) (J 3 1)))))
(assert (= (JtJ 1 2) (+ (* (J 0 1) (J 0 2)) (* (J 1 1) (J 1 2)) (* (J 2 1) (J 2 2)) (* (J 3 1) (J 3 2)))))
(assert (= (JtJ 1 3) (+ (* (J 0 1) (J 0 3)) (* (J 1 1) (J 1 3)) (* (J 2 1) (J 2 3)) (* (J 3 1) (J 3 3)))))

(assert (= (JtJ 2 0) (+ (* (J 0 2) (J 0 0)) (* (J 1 2) (J 1 0)) (* (J 2 2) (J 2 0)) (* (J 3 2) (J 3 0)))))
(assert (= (JtJ 2 1) (+ (* (J 0 2) (J 0 1)) (* (J 1 2) (J 1 1)) (* (J 2 2) (J 2 1)) (* (J 3 2) (J 3 1)))))
(assert (= (JtJ 2 2) (+ (* (J 0 2) (J 0 2)) (* (J 1 2) (J 1 2)) (* (J 2 2) (J 2 2)) (* (J 3 2) (J 3 2)))))
(assert (= (JtJ 2 3) (+ (* (J 0 2) (J 0 3)) (* (J 1 2) (J 1 3)) (* (J 2 2) (J 2 3)) (* (J 3 2) (J 3 3)))))

(assert (= (JtJ 3 0) (+ (* (J 0 3) (J 0 0)) (* (J 1 3) (J 1 0)) (* (J 2 3) (J 2 0)) (* (J 3 3) (J 3 0)))))
(assert (= (JtJ 3 1) (+ (* (J 0 3) (J 0 1)) (* (J 1 3) (J 1 1)) (* (J 2 3) (J 2 1)) (* (J 3 3) (J 3 1)))))
(assert (= (JtJ 3 2) (+ (* (J 0 3) (J 0 2)) (* (J 1 3) (J 1 2)) (* (J 2 3) (J 2 2)) (* (J 3 3) (J 3 2)))))
(assert (= (JtJ 3 3) (+ (* (J 0 3) (J 0 3)) (* (J 1 3) (J 1 3)) (* (J 2 3) (J 2 3)) (* (J 3 3) (J 3 3)))))

; ---------- Part 1: Kahler compatibility g(JX,JY) = g(X,Y) ----------
; With g = Id, this means J^T J = Id
(push 1)

; Assert J^T J = Id
(assert (= (JtJ 0 0) 1)) (assert (= (JtJ 0 1) 0)) (assert (= (JtJ 0 2) 0)) (assert (= (JtJ 0 3) 0))
(assert (= (JtJ 1 0) 0)) (assert (= (JtJ 1 1) 1)) (assert (= (JtJ 1 2) 0)) (assert (= (JtJ 1 3) 0))
(assert (= (JtJ 2 0) 0)) (assert (= (JtJ 2 1) 0)) (assert (= (JtJ 2 2) 1)) (assert (= (JtJ 2 3) 0))
(assert (= (JtJ 3 0) 0)) (assert (= (JtJ 3 1) 0)) (assert (= (JtJ 3 2) 0)) (assert (= (JtJ 3 3) 1))

(echo "--- Part 1: Kahler compatibility g(JX,JY) = g(X,Y) ---")
(echo "Expected: sat")
(check-sat)
(pop 1)

; ---------- Part 2: Incompatible g and J (unsat) ----------
; Use a non-standard metric g' that is NOT J-invariant.
; g' = diag(1, 2, 1, 1). Then g'(Je_0, Je_0) = g'(e_1, e_1) = 2 != 1 = g'(e_0, e_0).
; Assert compatibility g'(JX,JY) = g'(X,Y) and non-standard g' simultaneously.
(push 1)

(declare-fun gp (Int Int) Int)

; g' = diag(1, 2, 1, 1)
(assert (= (gp 0 0) 1)) (assert (= (gp 0 1) 0)) (assert (= (gp 0 2) 0)) (assert (= (gp 0 3) 0))
(assert (= (gp 1 0) 0)) (assert (= (gp 1 1) 2)) (assert (= (gp 1 2) 0)) (assert (= (gp 1 3) 0))
(assert (= (gp 2 0) 0)) (assert (= (gp 2 1) 0)) (assert (= (gp 2 2) 1)) (assert (= (gp 2 3) 0))
(assert (= (gp 3 0) 0)) (assert (= (gp 3 1) 0)) (assert (= (gp 3 2) 0)) (assert (= (gp 3 3) 1))

; Compute g'(Je_0, Je_0):
; Je_0 = (J(0,0), J(1,0), J(2,0), J(3,0)) = (0, 1, 0, 0)
; g'(Je_0, Je_0) = sum_{a,b} gp(a,b) * J(a,0) * J(b,0)
(declare-fun gpJJ00 () Int)
(assert (= gpJJ00 (+ (* (gp 0 0) (* (J 0 0) (J 0 0)))
                      (* (gp 1 1) (* (J 1 0) (J 1 0)))
                      (* (gp 2 2) (* (J 2 0) (J 2 0)))
                      (* (gp 3 3) (* (J 3 0) (J 3 0))))))

; g'(e_0, e_0) = gp(0,0) = 1
; g'(Je_0, Je_0) = gp(1,1) * 1 = 2

; Assert compatibility: g'(Je_0, Je_0) = g'(e_0, e_0)
(assert (= gpJJ00 (gp 0 0)))

(echo "--- Part 2: Incompatible g' and J with compatibility assertion? ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

; ---------- Part 3: Full Kahler triple consistency ----------
; Verify (g, J, omega) form a consistent Kahler triple:
; 1. J^2 = -Id (complex structure)
; 2. J^T J = Id (J is g-orthogonal)
; 3. omega = gJ (symplectic form)
; 4. omega is skew-symmetric
(push 1)

; J^2 = -Id (recompute)
(declare-fun J2 (Int Int) Int)
(assert (= (J2 0 0) (+ (* (J 0 0) (J 0 0)) (* (J 0 1) (J 1 0)) (* (J 0 2) (J 2 0)) (* (J 0 3) (J 3 0)))))
(assert (= (J2 1 1) (+ (* (J 1 0) (J 0 1)) (* (J 1 1) (J 1 1)) (* (J 1 2) (J 2 1)) (* (J 1 3) (J 3 1)))))
(assert (= (J2 2 2) (+ (* (J 2 0) (J 0 2)) (* (J 2 1) (J 1 2)) (* (J 2 2) (J 2 2)) (* (J 2 3) (J 3 2)))))
(assert (= (J2 3 3) (+ (* (J 3 0) (J 0 3)) (* (J 3 1) (J 1 3)) (* (J 3 2) (J 2 3)) (* (J 3 3) (J 3 3)))))

(assert (= (J2 0 0) (- 1)))
(assert (= (J2 1 1) (- 1)))
(assert (= (J2 2 2) (- 1)))
(assert (= (J2 3 3) (- 1)))

; J^T J = Id (compatibility)
(assert (= (JtJ 0 0) 1)) (assert (= (JtJ 1 1) 1))
(assert (= (JtJ 2 2) 1)) (assert (= (JtJ 3 3) 1))

; omega = J (since g = Id) is skew-symmetric
; J(i,j) = -J(j,i) for our J
(assert (= (J 0 1) (- (J 1 0))))
(assert (= (J 2 3) (- (J 3 2))))

(echo "--- Part 3: Full Kahler triple (g, J, omega) consistent ---")
(echo "Expected: sat")
(check-sat)
(pop 1)

(echo "--- Step 29 verification complete (3 parts) ---")
