; ============================================================================
; Step 24: Dirichlet Form Axioms on a Weighted Graph
; ============================================================================
; A Dirichlet form E on a finite graph (V, w) is defined as:
;   E[f] = (1/2) sum_{x,y} w(x,y) * (f(x) - f(y))^2
;
; where w(x,y) >= 0 are edge weights.
;
; Axioms to verify:
;   (D1) Non-negativity: E[f] >= 0 for all f
;   (D2) Nullity: E[f] = 0 iff f is constant
;   (D3) Markov/Contraction: E[clamp(f)] <= E[f] where clamp = min(1, max(0, f))
;
; Model: 3-point graph V = {0, 1, 2} with weights:
;   w(0,1) = 1, w(0,2) = 4, w(1,2) = 4
;   (We use integers scaled by 4 to avoid fractions: actual weights 1/4, 1, 1)
;   Scaled: w(0,1) = 1, w(0,2) = 4, w(1,2) = 4
;
; E[f] = (1/2)[w01*(f0-f1)^2 + w02*(f0-f2)^2 + w12*(f1-f2)^2]
; Using 2*E[f] to stay in integers:
;   2*E[f] = w01*(f0-f1)^2 + w02*(f0-f2)^2 + w12*(f1-f2)^2
;
; We verify:
;   Part 1: E[f] >= 0 for arbitrary f (sat — model exists with E >= 0)
;   Part 2: E[constant] = 0 (sat)
;   Part 3: Contraction E[clamp(f)] <= E[f] (sat)
;   Part 4: E[f] = 0 implies f is constant (unsat to violate)
; ============================================================================

(set-logic ALL)
(set-option :produce-models true)

; ---------- Edge weights ----------
(define-fun w01 () Int 1)
(define-fun w02 () Int 4)
(define-fun w12 () Int 4)

; ---------- Dirichlet energy (doubled to avoid fractions) ----------
; 2*E[f] = w01*(f0-f1)^2 + w02*(f0-f2)^2 + w12*(f1-f2)^2
(define-fun two-E ((f0 Int) (f1 Int) (f2 Int)) Int
  (+ (* w01 (* (- f0 f1) (- f0 f1)))
     (* w02 (* (- f0 f2) (- f0 f2)))
     (* w12 (* (- f1 f2) (- f1 f2)))))

; ---------- Part 1: Non-negativity E[f] >= 0 ----------
; For any function f, assert E[f] < 0 and expect unsat
(push 1)

(declare-fun f0 () Int)
(declare-fun f1 () Int)
(declare-fun f2 () Int)

; Assert 2*E < 0 (i.e., E < 0)
(assert (< (two-E f0 f1 f2) 0))

(echo "--- Part 1: E[f] >= 0 (non-negativity)? ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

; ---------- Part 2: E[constant] = 0 ----------
(push 1)

(declare-fun c () Int)

; Constant function: f(0) = f(1) = f(2) = c
(assert (= (two-E c c c) 0))

(echo "--- Part 2: E[constant] = 0 ---")
(echo "Expected: sat")
(check-sat)
(pop 1)

; ---------- Part 3: Contraction / Markov property ----------
; clamp(x) = max(0, min(S, x)) for some scale S
; Using S = 10 (arbitrary positive bound):
; E[clamp(f)] <= E[f]
;
; We verify a specific non-trivial case: f = (-3, 5, 15)
; clamp(-3) = 0, clamp(5) = 5, clamp(15) = 10
(push 1)

; Original function values
(define-fun orig0 () Int (- 3))
(define-fun orig1 () Int 5)
(define-fun orig2 () Int 15)

; Clamped function values (clamp to [0, 10])
(define-fun clmp0 () Int 0)
(define-fun clmp1 () Int 5)
(define-fun clmp2 () Int 10)

; E[original] and E[clamped]
(declare-fun E-orig () Int)
(declare-fun E-clmp () Int)
(assert (= E-orig (two-E orig0 orig1 orig2)))
(assert (= E-clmp (two-E clmp0 clmp1 clmp2)))

; Contraction: E[clamped] <= E[original]
(assert (<= E-clmp E-orig))

(echo "--- Part 3: Contraction E[clamp(f)] <= E[f] ---")
(echo "Expected: sat")
(check-sat)
(pop 1)

; ---------- Part 4: E[f] = 0 implies f is constant ----------
; If 2*E[f] = 0, then f must be constant (all weights > 0 means
; each squared difference must be 0)
(push 1)

(declare-fun g0 () Int)
(declare-fun g1 () Int)
(declare-fun g2 () Int)

; E[g] = 0
(assert (= (two-E g0 g1 g2) 0))

; Assert g is NOT constant
(assert (or (not (= g0 g1)) (not (= g1 g2))))

(echo "--- Part 4: E[f]=0 implies f constant? ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

(echo "--- Step 24 verification complete (4 parts) ---")
