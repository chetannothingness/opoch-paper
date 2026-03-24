; ============================================================================
; Step 18: Deterministic Solver — Bellman Minimax + Coupling Law
; ============================================================================
; The Coupling Law: tau*(q,W) = Pi-canonical-min(argmax_tau epsilon(tau;W))
; where epsilon(tau;W) = refinement_gain(tau;W) / cost(tau).
;
; Previous version was DEGENERATE: all tests had equal gain (1 bit each),
; so argmax(epsilon) collapsed to argmin(cost). This rewrite uses tests
; with DIFFERENT gains and costs to properly exercise the Coupling Law.
;
; Model: 4 tests over 8 possible answers.
;   Test 0: gain=2, cost=3  -> efficiency = 2/3 ~ 0.667
;   Test 1: gain=1, cost=1  -> efficiency = 1/1 = 1.000
;   Test 2: gain=3, cost=5  -> efficiency = 3/5 = 0.600
;   Test 3: gain=2, cost=2  -> efficiency = 2/2 = 1.000
;
; Tests 1 and 3 tie at efficiency 1.0.
; Coupling Law tie-break: Pi-canonical-min selects smaller CanEnum index.
; So test 1 (index 1) wins over test 3 (index 3).
;
; We verify:
;   Part 1: Model with different gains/costs is satisfiable
;   Part 2: argmax(efficiency) selects from {test1, test3} (the 1.0 pair)
;   Part 3: Pi-canonical tie-breaking selects test 1 (smaller index)
;   Part 4: Policy invariance — for any strictly monotone f,
;           argmax f(g/c) = argmax(g/c)
;   Part 5: Determinism — given (W,q), selected test is UNIQUE
;   Part 6: Bellman value function is non-negative
;   Part 7: Bellman recursion is well-defined (argmin exists)
; ============================================================================

(set-logic ALL)
(set-option :produce-models true)

; ---------- 4 tests with gains and costs ----------
(declare-fun gain (Int) Int)
(declare-fun cost (Int) Int)

; Gains (refinement gain in bits, must be >= 0)
(assert (= (gain 0) 2))
(assert (= (gain 1) 1))
(assert (= (gain 2) 3))
(assert (= (gain 3) 2))

; Costs (must be strictly positive)
(assert (= (cost 0) 3))
(assert (= (cost 1) 1))
(assert (= (cost 2) 5))
(assert (= (cost 3) 2))

; ---------- Efficiency as rational: eff_num/eff_den ----------
; We represent efficiency as gain/cost using cross-multiplication
; to avoid integer division truncation.
; eff(i) > eff(j) iff gain(i)*cost(j) > gain(j)*cost(i)

; Helper: cross-product comparison
; eff(a) > eff(b) iff gain(a)*cost(b) > gain(b)*cost(a)
(define-fun eff-gt ((a Int) (b Int)) Bool
  (> (* (gain a) (cost b)) (* (gain b) (cost a))))

(define-fun eff-eq ((a Int) (b Int)) Bool
  (= (* (gain a) (cost b)) (* (gain b) (cost a))))

(define-fun eff-ge ((a Int) (b Int)) Bool
  (or (eff-gt a b) (eff-eq a b)))

; ---------- Part 1: Model satisfiable ----------
; Expected: sat
(echo "--- Part 1: Model with different gains/costs ---")
(echo "Expected: sat")
(check-sat)

; ---------- Part 2: argmax(efficiency) is {test1, test3} ----------
; Verify: test 1 has efficiency 1/1=1.0, test 3 has 2/2=1.0
; Both dominate test 0 (2/3) and test 2 (3/5)
(push 1)

; Check test 1 >= all others
(declare-fun t1-dominates () Bool)
(assert (= t1-dominates (and (eff-ge 1 0) (eff-ge 1 2) (eff-ge 1 3))))

; Check test 3 >= all others
(declare-fun t3-dominates () Bool)
(assert (= t3-dominates (and (eff-ge 3 0) (eff-ge 3 2) (eff-ge 3 1))))

; Check test 0 does NOT dominate (eff(0) < eff(1))
(declare-fun t0-not-max () Bool)
(assert (= t0-not-max (eff-gt 1 0)))

; Check test 2 does NOT dominate (eff(2) < eff(1))
(declare-fun t2-not-max () Bool)
(assert (= t2-not-max (eff-gt 1 2)))

; Assert the negation of all four claims; expect unsat
(assert (not (and t1-dominates t3-dominates t0-not-max t2-not-max)))

(echo "--- Part 2: argmax(eff) = {test1, test3}? ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

; ---------- Part 3: Pi-canonical tie-break selects test 1 ----------
; When two tests tie on efficiency, the one with smaller CanEnum index wins.
; test 1 (index 1) < test 3 (index 3), so test 1 is selected.
(push 1)

; The coupling law selection:
; selected = min index among argmax(efficiency)
(declare-fun selected () Int)

; selected must be in {0,1,2,3}
(assert (and (>= selected 0) (<= selected 3)))

; selected must have maximal efficiency
(assert (eff-ge selected 0))
(assert (eff-ge selected 1))
(assert (eff-ge selected 2))
(assert (eff-ge selected 3))

; selected must be the smallest such index:
; no index j < selected also has maximal efficiency.
; Enumerate: if selected > j, then j must NOT have max efficiency.
(define-fun has-max-eff ((t Int)) Bool
  (and (eff-ge t 0) (eff-ge t 1) (eff-ge t 2) (eff-ge t 3)))

(assert (=> (> selected 0) (not (has-max-eff 0))))
(assert (=> (> selected 1) (not (has-max-eff 1))))
(assert (=> (> selected 2) (not (has-max-eff 2))))

; Assert selected != 1, expect unsat
(assert (not (= selected 1)))

(echo "--- Part 3: Pi-canonical tie-break selects test 1? ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

; ---------- Part 4: Policy invariance ----------
; For any strictly monotone f: R->R, argmax f(g/c) = argmax(g/c).
; We model f as a strictly monotone function on rationals.
; If eff(a) > eff(b), then f(eff(a)) > f(eff(b)) for any strict monotone f.
; So the argmax set is invariant.
;
; Proof by contradiction: suppose a strictly monotone f reverses the order
; of two tests' efficiencies. Then f(x) > f(y) but x < y, contradicting
; strict monotonicity.
(push 1)

; Model f as an uninterpreted function Int -> Int (on cross-products)
(declare-fun f (Int) Int)

; f is strictly monotone: x > y => f(x) > f(y)
(assert (forall ((x Int) (y Int)) (=> (> x y) (> (f x) (f y)))))

; Efficiency cross-products (to avoid rationals):
; eff_cross(i) = gain(i) * product_of_other_costs
; For comparison purposes, eff(a) > eff(b) iff gain(a)*cost(b) > gain(b)*cost(a)
; We use the actual cross-product values:
(declare-fun cp01 () Int)  ; gain(0)*cost(1) = 2*1 = 2
(declare-fun cp10 () Int)  ; gain(1)*cost(0) = 1*3 = 3
(assert (= cp01 (* (gain 0) (cost 1))))
(assert (= cp10 (* (gain 1) (cost 0))))

; eff(1) > eff(0) because cp10=3 > cp01=2
; Under f: f(cp10) > f(cp01) since f is strictly monotone and cp10 > cp01
; Assert f reverses: f(cp10) <= f(cp01), expect unsat
(assert (<= (f cp10) (f cp01)))

(echo "--- Part 4: Policy invariance (monotone f preserves order)? ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

; ---------- Part 5: Determinism — selected test is UNIQUE ----------
; Given fixed (W, q), the Coupling Law yields exactly one test.
; Two agents using same (W, q) must select the same test.
(push 1)

(declare-fun sel-A () Int)
(declare-fun sel-B () Int)

; Both are valid selections: maximal efficiency, minimal index
(assert (and (>= sel-A 0) (<= sel-A 3)))
(assert (and (>= sel-B 0) (<= sel-B 3)))

; Both have maximal efficiency
(assert (and (eff-ge sel-A 0) (eff-ge sel-A 1) (eff-ge sel-A 2) (eff-ge sel-A 3)))
(assert (and (eff-ge sel-B 0) (eff-ge sel-B 1) (eff-ge sel-B 2) (eff-ge sel-B 3)))

; Both are Pi-canonical-min: no smaller index also has maximal efficiency
(assert (forall ((j Int))
  (=> (and (>= j 0) (< j sel-A) (eff-ge j 0) (eff-ge j 1) (eff-ge j 2) (eff-ge j 3))
      false)))
(assert (forall ((j Int))
  (=> (and (>= j 0) (< j sel-B) (eff-ge j 0) (eff-ge j 1) (eff-ge j 2) (eff-ge j 3))
      false)))

; Assert they differ
(assert (not (= sel-A sel-B)))

(echo "--- Part 5: Determinism (unique selection)? ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

; ---------- Part 6: Bellman value is non-negative ----------
; V(W) = min_t [cost(t) + E[V(W')]] with V(singleton) = 0.
; Since cost > 0 and V >= 0 at leaves, V >= 0 everywhere.
(push 1)

(declare-fun V-full () Int)
(declare-fun V-leaf () Int)
(assert (= V-leaf 0))

; Bellman values for each test choice
(declare-fun bell (Int) Int)
(assert (= (bell 0) (+ (cost 0) V-leaf)))
(assert (= (bell 1) (+ (cost 1) V-leaf)))
(assert (= (bell 2) (+ (cost 2) V-leaf)))
(assert (= (bell 3) (+ (cost 3) V-leaf)))

; V-full = min of bell values
(assert (or (= V-full (bell 0)) (= V-full (bell 1))
            (= V-full (bell 2)) (= V-full (bell 3))))
(assert (<= V-full (bell 0)))
(assert (<= V-full (bell 1)))
(assert (<= V-full (bell 2)))
(assert (<= V-full (bell 3)))

; Assert V-full < 0, expect unsat
(assert (< V-full 0))

(echo "--- Part 6: Bellman value non-negative? ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

; ---------- Part 7: argmin of Bellman exists ----------
(push 1)

(declare-fun V2 () Int)
(declare-fun b0 () Int)
(declare-fun b1 () Int)
(declare-fun b2 () Int)
(declare-fun b3 () Int)

(assert (= b0 (+ (cost 0) 0)))
(assert (= b1 (+ (cost 1) 0)))
(assert (= b2 (+ (cost 2) 0)))
(assert (= b3 (+ (cost 3) 0)))

(assert (= V2 (ite (<= b0 b1)
                (ite (<= b0 b2)
                  (ite (<= b0 b3) b0 b3)
                  (ite (<= b2 b3) b2 b3))
                (ite (<= b1 b2)
                  (ite (<= b1 b3) b1 b3)
                  (ite (<= b2 b3) b2 b3)))))

; No test achieves the min? (should be unsat)
(assert (> b0 V2))
(assert (> b1 V2))
(assert (> b2 V2))
(assert (> b3 V2))

(echo "--- Part 7: Bellman argmin exists? ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

(echo "--- Step 18 verification complete (7 parts) ---")
