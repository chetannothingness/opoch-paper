; ============================================================================
; Step 14: Image Factorization  f = surj . inj
; ============================================================================
; Every function f: A -> B factors through its image as:
;   f = inj . surj
; where surj: A ->> im(f)  is a surjection onto the image,
; and   inj:  im(f) >-> B  is an injection from the image into B.
;
; We verify this on a concrete function f: {0,1,2,3} -> {0,1,2,3}
; where f(0)=1, f(1)=1, f(2)=3, f(3)=3.
; Image = {1, 3}, so |im(f)| = 2.
;
; Part 1: Show the factorization exists (sat).
; Part 2: Show inj is indeed injective (no two image elements map same).
; Part 3: Show surj is indeed surjective (every image element is hit).
; ============================================================================

(set-logic ALL)
(set-option :produce-models true)

; ---------- The original function f: {0,1,2,3} -> {0,1,2,3} ----------
(declare-fun f (Int) Int)
(assert (= (f 0) 1))
(assert (= (f 1) 1))
(assert (= (f 2) 3))
(assert (= (f 3) 3))

; ---------- Image has 2 elements, we label them 0 and 1 ----------
; surj: {0,1,2,3} -> {0,1}  (surjection onto image indices)
(declare-fun surj (Int) Int)

; inj: {0,1} -> {0,1,2,3}   (injection from image indices into codomain)
(declare-fun inj (Int) Int)

; ---------- surj maps domain elements to image indices ----------
; f(0)=f(1)=1, so surj(0)=surj(1) should map to the same image index
; f(2)=f(3)=3, so surj(2)=surj(3) should map to the same image index
(assert (= (surj 0) 0))
(assert (= (surj 1) 0))
(assert (= (surj 2) 1))
(assert (= (surj 3) 1))

; ---------- inj maps image indices to actual codomain values ----------
(assert (= (inj 0) 1))   ; image index 0 -> value 1
(assert (= (inj 1) 3))   ; image index 1 -> value 3

; ---------- Factorization: f(x) = inj(surj(x)) for all x in domain ----------
(assert (= (f 0) (inj (surj 0))))
(assert (= (f 1) (inj (surj 1))))
(assert (= (f 2) (inj (surj 2))))
(assert (= (f 3) (inj (surj 3))))

; ---------- Part 1: Factorization exists ----------
; Expected: sat
(echo "--- Part 1: Image factorization f = inj . surj ---")
(echo "Expected: sat")
(check-sat)
(get-model)

; ---------- Part 2: inj is injective ----------
; If inj(a) = inj(b) then a = b (for image indices 0 and 1)
(push 1)
(assert (= (inj 0) (inj 1)))   ; assume two image elements map to same
(assert (distinct 0 1))         ; but they are distinct indices

; Expected: unsat (inj maps 0->1 and 1->3, which are distinct)
(echo "--- Part 2: inj injectivity (same output for distinct inputs?) ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

; ---------- Part 3: surj is surjective ----------
; Every image index is hit by some domain element.
(push 1)
; Assert some image index is NOT hit by any domain element
(declare-fun orphan () Int)
(assert (or (= orphan 0) (= orphan 1)))   ; orphan is a valid image index
(assert (distinct (surj 0) orphan))
(assert (distinct (surj 1) orphan))
(assert (distinct (surj 2) orphan))
(assert (distinct (surj 3) orphan))

; Expected: unsat (surj hits both 0 and 1)
(echo "--- Part 3: surj surjectivity (is any image index missed?) ---")
(echo "Expected: unsat")
(check-sat)
(pop 1)

(echo "--- Step 14 verification complete ---")
