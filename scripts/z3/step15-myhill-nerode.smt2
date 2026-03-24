; ============================================================================
; Step 15: Myhill-Nerode Right Congruence
; ============================================================================
; The Myhill-Nerode theorem states that a language is regular iff it has
; finitely many equivalence classes under the right congruence:
;   s ~ s'  implies  s.a ~ s'.a   for all input symbols a
;
; This models the finite-state recognizer forced by describability:
; if two descriptions are indistinguishable by all continuations,
; they must be in the same equivalence class.
;
; We model a finite monoid with 3 states and 2 input symbols,
; verify the congruence property, and show non-congruence is inconsistent.
; ============================================================================

(set-logic ALL)
(set-option :produce-models true)

; ---------- States: 0, 1, 2 ----------
; ---------- Input symbols: 0 (a), 1 (b) ----------

; Transition function: delta(state, symbol) -> state
(declare-fun delta (Int Int) Int)

; ---------- Transition table (a concrete DFA) ----------
; State 0: delta(0,a)=1, delta(0,b)=0
; State 1: delta(1,a)=2, delta(1,b)=0
; State 2: delta(2,a)=2, delta(2,b)=1   (accepting state)
(assert (= (delta 0 0) 1))
(assert (= (delta 0 1) 0))
(assert (= (delta 1 0) 2))
(assert (= (delta 1 1) 0))
(assert (= (delta 2 0) 2))
(assert (= (delta 2 1) 1))

; ---------- Equivalence relation on states ----------
(declare-fun cong (Int Int) Bool)

; Reflexivity
(assert (cong 0 0))
(assert (cong 1 1))
(assert (cong 2 2))

; Symmetry
(assert (= (cong 0 1) (cong 1 0)))
(assert (= (cong 0 2) (cong 2 0)))
(assert (= (cong 1 2) (cong 2 1)))

; ---------- Right congruence property ----------
; If cong(s, s') then cong(delta(s, a), delta(s', a)) for all a in {0, 1}
; Enumerate for all state pairs and both symbols:

; For symbol 0 (a):
(assert (=> (cong 0 1) (cong (delta 0 0) (delta 1 0))))  ; cong(0,1) => cong(1,2)
(assert (=> (cong 0 2) (cong (delta 0 0) (delta 2 0))))  ; cong(0,2) => cong(1,2)
(assert (=> (cong 1 0) (cong (delta 1 0) (delta 0 0))))  ; cong(1,0) => cong(2,1)
(assert (=> (cong 1 2) (cong (delta 1 0) (delta 2 0))))  ; cong(1,2) => cong(2,2) [trivial]
(assert (=> (cong 2 0) (cong (delta 2 0) (delta 0 0))))  ; cong(2,0) => cong(2,1)
(assert (=> (cong 2 1) (cong (delta 2 0) (delta 1 0))))  ; cong(2,1) => cong(2,2) [trivial]

; For symbol 1 (b):
(assert (=> (cong 0 1) (cong (delta 0 1) (delta 1 1))))  ; cong(0,1) => cong(0,0) [trivial]
(assert (=> (cong 0 2) (cong (delta 0 1) (delta 2 1))))  ; cong(0,2) => cong(0,1)
(assert (=> (cong 1 0) (cong (delta 1 1) (delta 0 1))))  ; cong(1,0) => cong(0,0) [trivial]
(assert (=> (cong 1 2) (cong (delta 1 1) (delta 2 1))))  ; cong(1,2) => cong(0,1)
(assert (=> (cong 2 0) (cong (delta 2 1) (delta 0 1))))  ; cong(2,0) => cong(1,0)
(assert (=> (cong 2 1) (cong (delta 2 1) (delta 1 1))))  ; cong(2,1) => cong(1,0)

; ---------- Part 1: Valid congruence model ----------
; The trivial congruence (only reflexive pairs) should work.
; Expected: sat
(echo "--- Part 1: Right congruence on 3-state DFA ---")
(echo "Expected: sat")
(check-sat)
(get-model)

; ---------- Part 2: Non-congruence is unsat ----------
; Try to make 0 ~ 2 but NOT delta(0,a) ~ delta(2,a)
; i.e., cong(0,2)=true but cong(delta(0,0), delta(2,0)) = cong(1,2) = false
(push 1)
(assert (cong 0 2))
(assert (not (cong (delta 0 0) (delta 2 0))))  ; not cong(1, 2)

; Expected: unsat (right congruence forces cong(1,2) when cong(0,2))
(echo "--- Part 2: Violate right congruence (cong(0,2) but not cong(1,2)) ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

; ---------- Part 3: Transitivity emerges from congruence ----------
; If cong(0,1) and cong(1,2), does cong(0,2) hold?
; With the given DFA, let's check:
; cong(0,1) forces cong(1,2) via symbol a [delta(0,0)=1, delta(1,0)=2]
; cong(1,2) forces cong(0,1) via symbol b [delta(1,1)=0, delta(2,1)=1, so cong(0,1)]
; This creates a chain: all states would be congruent.
; Let's verify: assert cong(0,1) and cong(1,2) but NOT cong(0,2).
; With the congruence propagation, this should be unsat.
(push 1)
; Add transitivity requirement
(assert (=> (and (cong 0 1) (cong 1 2)) (cong 0 2)))
(assert (=> (and (cong 0 2) (cong 2 1)) (cong 0 1)))
(assert (=> (and (cong 1 0) (cong 0 2)) (cong 1 2)))

(assert (cong 0 1))
(assert (cong 1 2))
(assert (not (cong 0 2)))

; Expected: unsat (transitivity forces cong(0,2))
(echo "--- Part 3: Transitivity forced by congruence chain ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

; ---------- Part 4: Coarsest right-congruence (Myhill-Nerode) ----------
; Try to merge two states that are DISTINGUISHABLE (accept differently
; under some continuation) and show it violates right-congruence.
;
; In our DFA: state 2 is accepting, states 0 and 1 are not.
; So states 0 and 2 are distinguishable (different acceptance).
; Merging them (cong(0,2)=true) forces cong(1,2) via symbol a
; (since delta(0,0)=1, delta(2,0)=2, so cong(0,2) => cong(1,2)).
; Then cong(1,2) forces cong(0,1) via symbol b
; (since delta(1,1)=0, delta(2,1)=1, so cong(1,2) => cong(0,1)).
; So all states merge. But if we also assert state 2 is accepting
; and state 0 is not, this is a contradiction.
(push 1)

; Acceptance predicate: only state 2 is accepting
(declare-fun accept (Int) Bool)
(assert (not (accept 0)))
(assert (not (accept 1)))
(assert (accept 2))

; Congruence must respect acceptance: cong(s,s') => (accept(s) = accept(s'))
(assert (=> (cong 0 1) (= (accept 0) (accept 1))))
(assert (=> (cong 0 2) (= (accept 0) (accept 2))))
(assert (=> (cong 1 2) (= (accept 1) (accept 2))))

; Try to merge states 0 and 2 (a strictly coarser congruence)
(assert (cong 0 2))

; Expected: unsat (merging distinguishable states violates acceptance)
(echo "--- Part 4: Coarser congruence merges distinguishable states? ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

(echo "--- Step 15 verification complete ---")
