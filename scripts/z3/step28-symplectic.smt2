; ============================================================================
; Step 28: Symplectic Form Properties
; ============================================================================
; Given a metric g and complex structure J, the symplectic form is:
;   omega(X, Y) = g(X, JY)
;
; For a valid symplectic form, we need:
;   (S1) Skew-symmetry: omega(X, Y) = -omega(Y, X)
;   (S2) Non-degeneracy: for all X != 0, there exists Y s.t. omega(X,Y) != 0
;        Equivalently: det(omega) != 0
;
; Model: 4D space. g = Id (identity metric). J = block-diagonal [[0,-1],[1,0]].
;
; omega(e_i, e_j) = g(e_i, J*e_j) = (J*e_j)_i = J(i,j)
; (since g = Id, g(e_i, v) = v_i)
;
; So omega = J as a matrix:
;   omega = [[0, -1, 0, 0],
;            [1,  0, 0, 0],
;            [0,  0, 0, -1],
;            [0,  0, 1,  0]]
;
; We verify:
;   Part 1: omega is skew-symmetric (sat)
;   Part 2: omega is non-degenerate (det != 0) (sat)
;   Part 3: Skew-symmetry violation impossible for omega = g(., J.) (unsat)
; ============================================================================

(set-logic ALL)
(set-option :produce-models true)

; ---------- Complex structure J (same as step 27) ----------
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

; ---------- Symplectic form: omega(i,j) = sum_k g(i,k) * J(k,j) ----------
; Since g = Id: omega(i,j) = J(i,j)
(declare-fun omega (Int Int) Int)

; Compute omega = g * J = Id * J = J
(assert (= (omega 0 0) (+ (* (g 0 0) (J 0 0)) (* (g 0 1) (J 1 0)) (* (g 0 2) (J 2 0)) (* (g 0 3) (J 3 0)))))
(assert (= (omega 0 1) (+ (* (g 0 0) (J 0 1)) (* (g 0 1) (J 1 1)) (* (g 0 2) (J 2 1)) (* (g 0 3) (J 3 1)))))
(assert (= (omega 0 2) (+ (* (g 0 0) (J 0 2)) (* (g 0 1) (J 1 2)) (* (g 0 2) (J 2 2)) (* (g 0 3) (J 3 2)))))
(assert (= (omega 0 3) (+ (* (g 0 0) (J 0 3)) (* (g 0 1) (J 1 3)) (* (g 0 2) (J 2 3)) (* (g 0 3) (J 3 3)))))

(assert (= (omega 1 0) (+ (* (g 1 0) (J 0 0)) (* (g 1 1) (J 1 0)) (* (g 1 2) (J 2 0)) (* (g 1 3) (J 3 0)))))
(assert (= (omega 1 1) (+ (* (g 1 0) (J 0 1)) (* (g 1 1) (J 1 1)) (* (g 1 2) (J 2 1)) (* (g 1 3) (J 3 1)))))
(assert (= (omega 1 2) (+ (* (g 1 0) (J 0 2)) (* (g 1 1) (J 1 2)) (* (g 1 2) (J 2 2)) (* (g 1 3) (J 3 2)))))
(assert (= (omega 1 3) (+ (* (g 1 0) (J 0 3)) (* (g 1 1) (J 1 3)) (* (g 1 2) (J 2 3)) (* (g 1 3) (J 3 3)))))

(assert (= (omega 2 0) (+ (* (g 2 0) (J 0 0)) (* (g 2 1) (J 1 0)) (* (g 2 2) (J 2 0)) (* (g 2 3) (J 3 0)))))
(assert (= (omega 2 1) (+ (* (g 2 0) (J 0 1)) (* (g 2 1) (J 1 1)) (* (g 2 2) (J 2 1)) (* (g 2 3) (J 3 1)))))
(assert (= (omega 2 2) (+ (* (g 2 0) (J 0 2)) (* (g 2 1) (J 1 2)) (* (g 2 2) (J 2 2)) (* (g 2 3) (J 3 2)))))
(assert (= (omega 2 3) (+ (* (g 2 0) (J 0 3)) (* (g 2 1) (J 1 3)) (* (g 2 2) (J 2 3)) (* (g 2 3) (J 3 3)))))

(assert (= (omega 3 0) (+ (* (g 3 0) (J 0 0)) (* (g 3 1) (J 1 0)) (* (g 3 2) (J 2 0)) (* (g 3 3) (J 3 0)))))
(assert (= (omega 3 1) (+ (* (g 3 0) (J 0 1)) (* (g 3 1) (J 1 1)) (* (g 3 2) (J 2 1)) (* (g 3 3) (J 3 1)))))
(assert (= (omega 3 2) (+ (* (g 3 0) (J 0 2)) (* (g 3 1) (J 1 2)) (* (g 3 2) (J 2 2)) (* (g 3 3) (J 3 2)))))
(assert (= (omega 3 3) (+ (* (g 3 0) (J 0 3)) (* (g 3 1) (J 1 3)) (* (g 3 2) (J 2 3)) (* (g 3 3) (J 3 3)))))

; ---------- Part 1: Skew-symmetry omega(i,j) = -omega(j,i) ----------
(push 1)

; Check all 6 independent pairs (i<j) and diagonal
; Diagonal must be 0
(assert (= (omega 0 0) 0))
(assert (= (omega 1 1) 0))
(assert (= (omega 2 2) 0))
(assert (= (omega 3 3) 0))

; Off-diagonal: omega(i,j) = -omega(j,i)
(assert (= (omega 0 1) (- (omega 1 0))))
(assert (= (omega 0 2) (- (omega 2 0))))
(assert (= (omega 0 3) (- (omega 3 0))))
(assert (= (omega 1 2) (- (omega 2 1))))
(assert (= (omega 1 3) (- (omega 3 1))))
(assert (= (omega 2 3) (- (omega 3 2))))

(echo "--- Part 1: omega is skew-symmetric ---")
(echo "Expected: sat")
(check-sat)
(pop 1)

; ---------- Part 2: Non-degeneracy (det(omega) != 0) ----------
; For 4x4 skew-symmetric matrix, det = Pf^2 where Pf is the Pfaffian.
; omega = [[0,-1,0,0],[1,0,0,0],[0,0,0,-1],[0,0,1,0]]
; Pfaffian = omega(0,1)*omega(2,3) - omega(0,2)*omega(1,3) + omega(0,3)*omega(1,2)
;          = (-1)*(-1) - 0*0 + 0*0 = 1
; det = Pf^2 = 1
(push 1)

(declare-fun pf () Int)
(assert (= pf (+ (- (* (omega 0 1) (omega 2 3))
                    (* (omega 0 2) (omega 1 3)))
                 (* (omega 0 3) (omega 1 2)))))

(declare-fun detOmega () Int)
(assert (= detOmega (* pf pf)))

; Assert non-degeneracy
(assert (not (= detOmega 0)))

(echo "--- Part 2: omega is non-degenerate (det != 0) ---")
(echo "Expected: sat")
(check-sat)
(pop 1)

; ---------- Part 3: Skew-symmetry violation impossible (unsat) ----------
; Given g symmetric and J with J^T = -J (which holds for our J),
; omega = gJ is skew-symmetric: omega^T = J^T g^T = -J g = -(gJ) = -omega
; (using g = Id so g^T = g and gJ = Jg).
; Assert omega(i,j) != -omega(j,i) for some i,j: should be unsat.
(push 1)

(declare-fun i () Int)
(declare-fun j () Int)
(assert (and (>= i 0) (<= i 3)))
(assert (and (>= j 0) (<= j 3)))
(assert (not (= i j)))

; Assert skew-symmetry violation
(assert (not (= (omega i j) (- (omega j i)))))

(echo "--- Part 3: Skew-symmetry violation possible? ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

(echo "--- Step 28 verification complete (3 parts) ---")
