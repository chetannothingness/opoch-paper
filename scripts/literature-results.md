# Literature Review Results for Opoch Paper

**Generated:** 2026-02-20
**Method:** Web search fallback (synsc CLI unavailable due to Bash permission restriction)
**Scope:** Citations for the 13 new mathematical objects in the Opoch paper derivation

---

## Note on Method

The `synsc` CLI at `/Users/dharamveerchouhan/.nvm/versions/node/v20.19.5/bin/synsc` could not be executed because Bash execution was denied in this session. All results below were obtained via web search as a fallback. Results should be cross-checked against primary sources before inclusion in the paper.

---

## 1. Observable Topology in Constructive Math

### Key Findings

The Opoch paper's truth quotient (Step 5) and test algebra relate directly to the programme of **observable topology**, where open sets correspond to testable/semidecidable predicates. The key intellectual lineage runs: Scott (1970) -> Smyth (1983) -> Abramsky (1987/1991) -> Vickers (1989) -> Escardo (2004) -> Sambin (1987, formal topology).

- **Scott topology** treats open sets as properties that are "eventually observable" -- a directed supremum lands in an open set iff some finite approximation already does. This mirrors A0's requirement that distinctions be finitely witnessable.
- **Smyth (1983)** established that topological concepts (especially open sets as observable properties) are foundational to computer science, connecting power domains to predicate transformers.
- **Abramsky (1991)** synthesized domain theory, operational semantics, and logic via Stone duality, with the underlying logic being geometric (the logic of observable properties).
- **Vickers (1989)** presented topology starting from the "logic of finite observations," using locale theory -- pointfree topology motivated by computability.
- **Escardo (2004)** formalized the dictionary: data type = topological space, semidecidable property = open set, computable function = continuous map.
- **Sambin (1987)** initiated formal topology as a predicative, constructive approach to pointfree topology aligned with Martin-Lof type theory.

### BibTeX Entries

```bibtex
@techreport{scott1970,
  author    = {Scott, Dana S.},
  title     = {Outline of a Mathematical Theory of Computation},
  institution = {Oxford University Computing Laboratory},
  year      = {1970},
  note      = {Also in: Proceedings of the Fourth Annual Princeton Conference
               on Information Sciences and Systems, pp. 169--176}
}

@inproceedings{smyth1983,
  author    = {Smyth, Michael B.},
  title     = {Power Domains and Predicate Transformers: A Topological View},
  booktitle = {Automata, Languages and Programming (ICALP 1983)},
  series    = {Lecture Notes in Computer Science},
  volume    = {154},
  pages     = {662--675},
  publisher = {Springer},
  year      = {1983}
}

@article{abramsky1991,
  author  = {Abramsky, Samson},
  title   = {Domain Theory in Logical Form},
  journal = {Annals of Pure and Applied Logic},
  volume  = {51},
  number  = {1--2},
  pages   = {1--77},
  year    = {1991}
}

@book{vickers1989,
  author    = {Vickers, Steven},
  title     = {Topology via Logic},
  series    = {Cambridge Tracts in Theoretical Computer Science},
  number    = {5},
  publisher = {Cambridge University Press},
  year      = {1989}
}

@article{escardo2004,
  author  = {Escard{\'o}, Mart{\'\i}n H{\"o}tzel},
  title   = {Synthetic Topology of Data Types and Classical Spaces},
  journal = {Electronic Notes in Theoretical Computer Science},
  volume  = {87},
  pages   = {21--156},
  year    = {2004},
  publisher = {Elsevier}
}

@incollection{sambin1987,
  author    = {Sambin, Giovanni},
  title     = {Intuitionistic Formal Spaces --- A First Communication},
  booktitle = {Mathematical Logic and its Applications},
  editor    = {Skordev, D.},
  publisher = {Plenum},
  address   = {New York},
  pages     = {187--204},
  year      = {1987}
}
```

### Recommended for Paper

Add references to **Smyth (1983)**, **Abramsky (1991)**, **Vickers (1989)**, and **Escardo (2004)** in Section 2.1 (Type Theory and Constructive Mathematics) or a new subsection on Observable Topology. The truth quotient's connection to Scott topology and observational equivalence strengthens the paper's constructive foundations significantly.

---

## 2. Myhill-Nerode Theorem and Behavioral Equivalence

### Key Findings

The truth quotient (Step 5) -- where descriptions indistinguishable by all tests are identified -- is structurally identical to the **Myhill-Nerode equivalence**. Two strings are Myhill-Nerode equivalent iff no continuation (test/future) distinguishes them. The number of equivalence classes equals the number of states in the minimal DFA.

- **Myhill (1957)**: "Finite automata and the representation of events." WADC Tech. Rep. 57-264.
- **Nerode (1958)**: "Linear automata transformations." Proc. Amer. Math. Soc., 9, 541--544.
- **Park (1981)**: "Concurrency and automata on infinite sequences." Proc. 5th GI Conference. Introduced bisimulation.
- **Milner (1989)**: "Communication and Concurrency." Prentice-Hall. Extended bisimulation theory for CCS.

The Opoch truth quotient generalizes Myhill-Nerode from regular languages to arbitrary computable test algebras. The "fiber" is the equivalence class, and fiber shrinkage (Step 8) corresponds to state-space refinement.

### BibTeX Entries

```bibtex
@techreport{myhill1957,
  author      = {Myhill, John},
  title       = {Finite Automata and the Representation of Events},
  institution = {Wright Air Development Center},
  number      = {WADC TR 57-264},
  year        = {1957}
}

@article{nerode1958,
  author  = {Nerode, Anil},
  title   = {Linear Automaton Transformations},
  journal = {Proceedings of the American Mathematical Society},
  volume  = {9},
  number  = {4},
  pages   = {541--544},
  year    = {1958}
}

@inproceedings{park1981,
  author    = {Park, David},
  title     = {Concurrency and Automata on Infinite Sequences},
  booktitle = {Proceedings of the 5th GI-Conference on Theoretical Computer Science},
  series    = {Lecture Notes in Computer Science},
  volume    = {104},
  pages     = {167--183},
  publisher = {Springer},
  year      = {1981}
}

@book{milner1989,
  author    = {Milner, Robin},
  title     = {Communication and Concurrency},
  publisher = {Prentice Hall},
  year      = {1989},
  address   = {New York}
}
```

### Recommended for Paper

Add a paragraph in Section 2.1 or create a new subsection noting that the truth quotient is a generalization of Myhill-Nerode equivalence. Reference **Nerode (1958)** for the original theorem and **Milner (1989)** / **Park (1981)** for the extension to bisimulation in concurrent systems.

---

## 3. Information Geometry: Fisher Metric and Separator Geometry

### Key Findings

The Opoch kernel's test selection over hypothesis spaces has deep connections to **information geometry**. The Bellman-optimal separator (Step 14) operates in a space where the "distance" between surviving answer classes is determined by the cost of the cheapest distinguishing test -- this is structurally analogous to the Fisher-Rao distance.

- **Rao (1945)**: "Information and the accuracy attainable in the estimation of statistical parameters." Bull. Calcutta Math. Soc., 37, 81--91. Introduced the Fisher-Rao metric (Riemannian metric on probability distributions using Fisher information).
- **Amari (1985)**: "Differential-Geometrical Methods in Statistics." Springer LNCS 28. Developed information geometry with dual affine connections.
- **Amari & Nagaoka (2000)**: "Methods of Information Geometry." AMS Translations of Mathematical Monographs 191. The definitive modern treatment.
- **Chentsov (1982)**: "Statistical Decision Rules and Optimal Inference." AMS. Proved the Fisher metric is the unique Riemannian metric invariant under sufficient statistics (up to rescaling).

Chentsov's uniqueness theorem is particularly relevant: it shows the Fisher metric is *forced* by invariance requirements, mirroring how the Opoch derivation forces structure from A0.

### BibTeX Entries

```bibtex
@article{rao1945,
  author  = {Rao, Calyampudi Radhakrishna},
  title   = {Information and the Accuracy Attainable in the Estimation of Statistical Parameters},
  journal = {Bulletin of the Calcutta Mathematical Society},
  volume  = {37},
  pages   = {81--91},
  year    = {1945}
}

@book{amari1985,
  author    = {Amari, Shun-ichi},
  title     = {Differential-Geometrical Methods in Statistics},
  series    = {Lecture Notes in Statistics},
  volume    = {28},
  publisher = {Springer-Verlag},
  address   = {New York},
  year      = {1985}
}

@book{amari2000,
  author    = {Amari, Shun-ichi and Nagaoka, Hiroshi},
  title     = {Methods of Information Geometry},
  series    = {Translations of Mathematical Monographs},
  volume    = {191},
  publisher = {American Mathematical Society},
  address   = {Providence, RI},
  year      = {2000},
  note      = {Translated from the 1993 Japanese original by Daishi Harada}
}

@book{chentsov1982,
  author    = {Chentsov, Nikolai N.},
  title     = {Statistical Decision Rules and Optimal Inference},
  series    = {Translations of Mathematical Monographs},
  volume    = {53},
  publisher = {American Mathematical Society},
  address   = {Providence, RI},
  year      = {1982},
  note      = {Translated from Russian by Lev J. Leifman}
}
```

### Recommended for Paper

Add a new subsection in Related Work: "Information Geometry and Separator Spaces." Reference **Rao (1945)** and **Chentsov (1982)** for the forced/unique nature of the Fisher metric, drawing a parallel to how A0 forces the truth quotient geometry. Reference **Amari (1985)** or **Amari & Nagaoka (2000)** for the general framework.

---

## 4. Self-Hosting Formal Systems

### Key Findings

The Opoch derivation is self-referential: A0 applies to itself (the derivation is a finite witness procedure for the claim that structure is forced). This connects to:

- **Kleene (1938/1952)**: The recursion theorem (fixed-point theorem for computable functions). Published in "Introduction to Metamathematics" (1952), North-Holland. Guarantees the existence of self-referential programs. Already cited in the paper.
- **Reynolds (1972)**: "Definitional Interpreters for Higher-Order Programming Languages." Proc. ACM Annual Conference. Coined "metacircular interpreter" and showed self-interpreters inherit evaluation strategy from the host.
- **Smith (1984)**: "Reflection and Semantics in Lisp." POPL 1984. Introduced 3-Lisp and reflective towers -- infinite towers of metacircular interpreters where each level can reify its program to the level above.
- **Rogers (1967)**: "Theory of Recursive Functions and Effective Computability." McGraw-Hill. Rogers' fixed-point theorem (generalization of Kleene's recursion theorem).

The Opoch derivation's "self-audit" (applying the framework to verify itself) is analogous to a reflective tower: the kernel can verify claims about the kernel's own derivation.

### BibTeX Entries

```bibtex
@inproceedings{reynolds1972,
  author    = {Reynolds, John C.},
  title     = {Definitional Interpreters for Higher-Order Programming Languages},
  booktitle = {Proceedings of the ACM Annual Conference},
  volume    = {2},
  pages     = {717--740},
  year      = {1972},
  publisher = {ACM}
}

@inproceedings{smith1984,
  author    = {Smith, Brian Cantwell},
  title     = {Reflection and Semantics in {Lisp}},
  booktitle = {Conference Record of the 11th ACM Symposium on Principles of Programming Languages},
  pages     = {23--35},
  year      = {1984},
  publisher = {ACM}
}

@book{rogers1967,
  author    = {Rogers, Hartley},
  title     = {Theory of Recursive Functions and Effective Computability},
  publisher = {McGraw-Hill},
  year      = {1967},
  address   = {New York}
}
```

### Recommended for Paper

Reference **Smith (1984)** on reflective towers in the Discussion section where self-audit is discussed. The connection between A0's self-application and Kleene's recursion theorem is already implicit via the `kleene1952` citation but could be made explicit.

---

## 5. Certifying Algorithms

### Key Findings

The NSL receipt system (Section 5.4) is directly related to the **certifying algorithms** programme:

- **McConnell, Mehlhorn, Naher, Schweitzer (2011)**: "Certifying Algorithms." Computer Science Review, 5(2):119--161. The definitive survey. A certifying algorithm produces, with each output, a certificate (easy-to-verify proof) that the output is correct.
- **Necula (1997)**: "Proof-Carrying Code." POPL 1997. Already cited. Producer bears cost of proof generation; consumer performs cheap verification.
- **Mehlhorn & Naher (1999)**: Pioneers of certification in the LEDA library for graph algorithms.

The NSL kernel is a certifying algorithm by construction: every output includes the receipt (witness chain) that enables independent replay verification.

### BibTeX Entries

```bibtex
@article{mcconnell2011,
  author  = {McConnell, Ross M. and Mehlhorn, Kurt and N{\"a}her, Stefan and Schweitzer, Pascal},
  title   = {Certifying Algorithms},
  journal = {Computer Science Review},
  volume  = {5},
  number  = {2},
  pages   = {119--161},
  year    = {2011},
  publisher = {Elsevier}
}
```

### Recommended for Paper

Add **McConnell et al. (2011)** to Section 2.5 (Verification Systems). The NSL kernel should be explicitly identified as a certifying algorithm. The receipt system is proof-carrying code applied to reasoning traces; McConnell et al. provide the broader algorithmic context.

---

## 6. Epistemic Logic vs. Decision Theory

### Key Findings

The Opoch framework bridges epistemic logic (what can be *known*) and decision theory (what should be *done*). The $\OMEGA$ state is both an epistemic report ("multiple answers survive") and an action directive ("here is the cheapest test to advance").

- **Hintikka (1962)**: "Knowledge and Belief: An Introduction to the Logic of the Two Notions." Cornell University Press. The seminal treatise on epistemic logic. Defines knowledge via possible-worlds semantics (model systems). For Hintikka, knowledge is justified true belief where the justification is eliminative (ruling out alternatives) -- closely parallel to $\UNIQUE$.
- **Savage (1954)**: "The Foundations of Statistics." John Wiley & Sons, 294 pp. Axiomatizes subjective expected utility, deriving probability and utility from preference orderings over acts. Savage's sure-thing principle is a decision-theoretic analog of A0 (decisions should be based on states that actually differ under the acts considered).

The Opoch kernel's minimax test selection (Step 14) is a Waldian decision procedure operating within an epistemic framework -- it does not merely report what is known but selects the optimal action to advance knowledge.

### BibTeX Entries

```bibtex
@book{hintikka1962,
  author    = {Hintikka, Jaakko},
  title     = {Knowledge and Belief: An Introduction to the Logic of the Two Notions},
  publisher = {Cornell University Press},
  year      = {1962},
  address   = {Ithaca, NY}
}

@book{savage1954,
  author    = {Savage, Leonard J.},
  title     = {The Foundations of Statistics},
  publisher = {John Wiley \& Sons},
  year      = {1954},
  address   = {New York}
}
```

### Recommended for Paper

Add a new subsection "Epistemic Logic and Decision Theory" to Related Work, or expand Section 2.4. Reference **Hintikka (1962)** for the epistemic-logic ancestor of the $\UNIQUE$/$\OMEGA$ distinction, and **Savage (1954)** for the decision-theoretic ancestor of Bellman-optimal test selection. The Opoch framework's novel contribution is fusing these: the kernel is simultaneously an epistemic engine and a decision engine.

---

## 7. Eraser Algebra and Idempotent Operations

### Key Findings

The Split Law (Step 6) factors every transformation into an information-destroying component (merge/erasure) and an information-preserving component (relabeling). This connects to:

- **Idempotent operations in lattice/domain theory**: Meet and join are idempotent by definition; the truth quotient operation $\Pi$ is idempotent ($\Pi \circ \Pi = \Pi$, Step 12).
- **Kleene Algebra with Domain** (Desharnais et al., 2003): Idempotent semirings with domain operations, connecting algebraic structures to domain-theoretic concepts.
- **Tropical semirings**: Idempotent semirings where addition is $\min$ or $\max$, used in optimization -- structurally parallel to the minimax Bellman equation.
- **Landauer's erasure principle** (already cited): The thermodynamic cost of the merge/erase component of the Split Law.
- **Bennett (1973)**: "Logical Reversibility of Computation." Already cited. Shows that computation can be made reversible (no erasure) at the cost of auxiliary storage.

The "eraser algebra" as such does not appear to be an established term in the literature. The closest formal structure is the **Rees quotient** in semigroup theory or the **reset/constant maps** in transformation monoid theory.

### BibTeX Entries

```bibtex
@article{desharnais2006,
  author  = {Desharnais, Jules and M{\"o}ller, Bernhard and Struth, Georg},
  title   = {Kleene Algebra with Domain},
  journal = {ACM Transactions on Computational Logic},
  volume  = {7},
  number  = {4},
  pages   = {798--833},
  year    = {2006}
}
```

### Recommended for Paper

The Split Law's connection to erasure and Landauer's principle is already well-cited. Optionally add **Desharnais et al. (2006)** if discussing the algebraic structure of the merge/relabel factorization more formally. The idempotency of $\Pi$ could be explicitly connected to idempotent closure operators in domain theory.

---

## 8. Citation Verification

### Results

All four citations verified as correct:

| Citation | Status | Details |
|----------|--------|---------|
| **Bishop 1967** | VERIFIED | Errett Bishop. *Foundations of Constructive Analysis.* McGraw-Hill, New York, 1967. xiii + 370 pp. |
| **Martin-Lof 1984** | VERIFIED | Per Martin-Lof. *Intuitionistic Type Theory.* Bibliopolis, Naples, 1984. Studies in Proof Theory. |
| **Kraft 1949** | VERIFIED | Leon G. Kraft. "A Device for Quantizing, Grouping, and Coding Amplitude-Modulated Pulses." MS Thesis, MIT, 1949. |
| **Landauer 1961** | VERIFIED | Rolf Landauer. "Irreversibility and Heat Generation in the Computing Process." *IBM Journal of Research and Development,* 5(3):183--191, 1961. |

**Note on Kraft 1949:** The existing `refs.bib` entry uses `@article` for what is actually an MS thesis. Should be changed to `@mastersthesis`.

### Corrected BibTeX for Kraft

```bibtex
@mastersthesis{kraft1949,
  author  = {Kraft, Leon G.},
  title   = {A Device for Quantizing, Grouping, and Coding Amplitude-Modulated Pulses},
  school  = {Massachusetts Institute of Technology},
  year    = {1949},
  type    = {{MS} thesis}
}
```

---

## Summary: All Recommended New References

### High Priority (directly relevant to paper's mathematical objects)

| # | Reference | Relevance to Paper |
|---|-----------|-------------------|
| 1 | **Smyth (1983)** -- Power Domains and Predicate Transformers | Observable topology; open sets as testable predicates (mirrors A0) |
| 2 | **Abramsky (1991)** -- Domain Theory in Logical Form | Stone duality; geometric logic of observable properties |
| 3 | **Vickers (1989)** -- Topology via Logic | Locale theory from finite observations; constructive topology |
| 4 | **Nerode (1958)** -- Linear Automaton Transformations | Truth quotient = generalized Myhill-Nerode equivalence |
| 5 | **McConnell et al. (2011)** -- Certifying Algorithms | NSL kernel as certifying algorithm; receipt = certificate |
| 6 | **Hintikka (1962)** -- Knowledge and Belief | Epistemic logic ancestor of UNIQUE/OMEGA distinction |
| 7 | **Rao (1945)** -- Information and Accuracy | Fisher-Rao metric; geometry of hypothesis discrimination |
| 8 | **Chentsov (1982)** -- Statistical Decision Rules | Fisher metric uniqueness from invariance (parallel to A0 forcing) |

### Medium Priority (enriches related work, strengthens connections)

| # | Reference | Relevance to Paper |
|---|-----------|-------------------|
| 9 | **Savage (1954)** -- Foundations of Statistics | Decision-theoretic axiomatization; ancestor of minimax test selection |
| 10 | **Escardo (2004)** -- Synthetic Topology of Data Types | Formal dictionary: semidecidable property = open set |
| 11 | **Smith (1984)** -- Reflection and Semantics in Lisp | Reflective towers; self-audit as self-hosting |
| 12 | **Scott (1970)** -- Outline of Mathematical Theory of Computation | Domain theory foundations; continuous lattices |
| 13 | **Milner (1989)** -- Communication and Concurrency | Bisimulation as observational equivalence |
| 14 | **Amari & Nagaoka (2000)** -- Methods of Information Geometry | Information geometry framework for separator spaces |
| 15 | **Sambin (1987)** -- Intuitionistic Formal Spaces | Formal topology in constructive type theory |

### Lower Priority (optional enrichment)

| # | Reference | Relevance to Paper |
|---|-----------|-------------------|
| 16 | **Park (1981)** -- Concurrency and Automata | Original bisimulation definition |
| 17 | **Reynolds (1972)** -- Definitional Interpreters | Metacircular interpreters; self-reference |
| 18 | **Rogers (1967)** -- Theory of Recursive Functions | Fixed-point theorem generalization |
| 19 | **Desharnais et al. (2006)** -- Kleene Algebra with Domain | Algebraic structure of eraser/merge operations |
| 20 | **Amari (1985)** -- Differential-Geometrical Methods in Statistics | Original information geometry monograph |

---

## Suggested New Related Work Subsections

Based on this review, the paper would benefit from two new subsections in Section 2:

### 2.X Observable Topology and Domain Theory

Covering: Scott (1970), Smyth (1983), Abramsky (1991), Vickers (1989), Escardo (2004). The truth quotient's connection to Scott topology, and A0's relationship to observable/semidecidable properties as open sets.

### 2.Y Information Geometry

Covering: Rao (1945), Chentsov (1982), Amari & Nagaoka (2000). The separator geometry of hypothesis spaces and the forced nature of the Fisher metric as a parallel to A0-forced structure.

The existing subsections on Epistemic Logic (Hintikka) and Certifying Algorithms (McConnell) could be added to the existing Verification Systems and Decision Theory subsections respectively.

---

## Complete BibTeX Block (All New Entries)

```bibtex
% --- Observable Topology & Domain Theory ---

@techreport{scott1970,
  author    = {Scott, Dana S.},
  title     = {Outline of a Mathematical Theory of Computation},
  institution = {Oxford University Computing Laboratory},
  year      = {1970},
  note      = {Also in: Proc. 4th Annual Princeton Conf. on Information
               Sciences and Systems, pp. 169--176}
}

@inproceedings{smyth1983,
  author    = {Smyth, Michael B.},
  title     = {Power Domains and Predicate Transformers: A Topological View},
  booktitle = {Automata, Languages and Programming (ICALP 1983)},
  series    = {Lecture Notes in Computer Science},
  volume    = {154},
  pages     = {662--675},
  publisher = {Springer},
  year      = {1983}
}

@article{abramsky1991,
  author  = {Abramsky, Samson},
  title   = {Domain Theory in Logical Form},
  journal = {Annals of Pure and Applied Logic},
  volume  = {51},
  number  = {1--2},
  pages   = {1--77},
  year    = {1991}
}

@book{vickers1989,
  author    = {Vickers, Steven},
  title     = {Topology via Logic},
  series    = {Cambridge Tracts in Theoretical Computer Science},
  number    = {5},
  publisher = {Cambridge University Press},
  year      = {1989}
}

@article{escardo2004,
  author  = {Escard{\'o}, Mart{\'\i}n H{\"o}tzel},
  title   = {Synthetic Topology of Data Types and Classical Spaces},
  journal = {Electronic Notes in Theoretical Computer Science},
  volume  = {87},
  pages   = {21--156},
  year    = {2004},
  publisher = {Elsevier}
}

@incollection{sambin1987,
  author    = {Sambin, Giovanni},
  title     = {Intuitionistic Formal Spaces --- A First Communication},
  booktitle = {Mathematical Logic and its Applications},
  editor    = {Skordev, D.},
  publisher = {Plenum},
  address   = {New York},
  pages     = {187--204},
  year      = {1987}
}

% --- Myhill-Nerode & Bisimulation ---

@techreport{myhill1957,
  author      = {Myhill, John},
  title       = {Finite Automata and the Representation of Events},
  institution = {Wright Air Development Center},
  number      = {WADC TR 57-264},
  year        = {1957}
}

@article{nerode1958,
  author  = {Nerode, Anil},
  title   = {Linear Automaton Transformations},
  journal = {Proceedings of the American Mathematical Society},
  volume  = {9},
  number  = {4},
  pages   = {541--544},
  year    = {1958}
}

@inproceedings{park1981,
  author    = {Park, David},
  title     = {Concurrency and Automata on Infinite Sequences},
  booktitle = {Proceedings of the 5th GI-Conference on Theoretical Computer Science},
  series    = {Lecture Notes in Computer Science},
  volume    = {104},
  pages     = {167--183},
  publisher = {Springer},
  year      = {1981}
}

@book{milner1989,
  author    = {Milner, Robin},
  title     = {Communication and Concurrency},
  publisher = {Prentice Hall},
  year      = {1989},
  address   = {New York}
}

% --- Information Geometry ---

@article{rao1945,
  author  = {Rao, Calyampudi Radhakrishna},
  title   = {Information and the Accuracy Attainable in the Estimation
             of Statistical Parameters},
  journal = {Bulletin of the Calcutta Mathematical Society},
  volume  = {37},
  pages   = {81--91},
  year    = {1945}
}

@book{amari1985,
  author    = {Amari, Shun-ichi},
  title     = {Differential-Geometrical Methods in Statistics},
  series    = {Lecture Notes in Statistics},
  volume    = {28},
  publisher = {Springer-Verlag},
  address   = {New York},
  year      = {1985}
}

@book{amari2000,
  author    = {Amari, Shun-ichi and Nagaoka, Hiroshi},
  title     = {Methods of Information Geometry},
  series    = {Translations of Mathematical Monographs},
  volume    = {191},
  publisher = {American Mathematical Society},
  address   = {Providence, RI},
  year      = {2000},
  note      = {Translated from the 1993 Japanese original by Daishi Harada}
}

@book{chentsov1982,
  author    = {Chentsov, Nikolai N.},
  title     = {Statistical Decision Rules and Optimal Inference},
  series    = {Translations of Mathematical Monographs},
  volume    = {53},
  publisher = {American Mathematical Society},
  address   = {Providence, RI},
  year      = {1982},
  note      = {Translated from Russian by Lev J. Leifman}
}

% --- Self-Hosting & Reflective Systems ---

@inproceedings{reynolds1972,
  author    = {Reynolds, John C.},
  title     = {Definitional Interpreters for Higher-Order Programming Languages},
  booktitle = {Proceedings of the ACM Annual Conference},
  volume    = {2},
  pages     = {717--740},
  year      = {1972},
  publisher = {ACM}
}

@inproceedings{smith1984,
  author    = {Smith, Brian Cantwell},
  title     = {Reflection and Semantics in {Lisp}},
  booktitle = {Conference Record of the 11th ACM Symposium on
               Principles of Programming Languages},
  pages     = {23--35},
  year      = {1984},
  publisher = {ACM}
}

@book{rogers1967,
  author    = {Rogers, Hartley},
  title     = {Theory of Recursive Functions and Effective Computability},
  publisher = {McGraw-Hill},
  year      = {1967},
  address   = {New York}
}

% --- Certifying Algorithms ---

@article{mcconnell2011,
  author  = {McConnell, Ross M. and Mehlhorn, Kurt and N{\"a}her, Stefan
             and Schweitzer, Pascal},
  title   = {Certifying Algorithms},
  journal = {Computer Science Review},
  volume  = {5},
  number  = {2},
  pages   = {119--161},
  year    = {2011},
  publisher = {Elsevier}
}

% --- Epistemic Logic & Decision Theory ---

@book{hintikka1962,
  author    = {Hintikka, Jaakko},
  title     = {Knowledge and Belief: An Introduction to the Logic
               of the Two Notions},
  publisher = {Cornell University Press},
  year      = {1962},
  address   = {Ithaca, NY}
}

@book{savage1954,
  author    = {Savage, Leonard J.},
  title     = {The Foundations of Statistics},
  publisher = {John Wiley \& Sons},
  year      = {1954},
  address   = {New York}
}

% --- Kleene Algebra with Domain ---

@article{desharnais2006,
  author  = {Desharnais, Jules and M{\"o}ller, Bernhard and Struth, Georg},
  title   = {Kleene Algebra with Domain},
  journal = {ACM Transactions on Computational Logic},
  volume  = {7},
  number  = {4},
  pages   = {798--833},
  year    = {2006}
}
```

---

## Correction Needed in Existing refs.bib

The entry for `kraft1949` should be changed from `@article` to `@mastersthesis`:

```bibtex
% CURRENT (incorrect type):
@article{kraft1949,
  author  = {Kraft, Leon G.},
  title   = {A Device for Quantizing, Grouping, and Coding Amplitude-Modulated Pulses},
  journal = {Master's thesis, MIT},
  year    = {1949}
}

% CORRECTED:
@mastersthesis{kraft1949,
  author  = {Kraft, Leon G.},
  title   = {A Device for Quantizing, Grouping, and Coding
             Amplitude-Modulated Pulses},
  school  = {Massachusetts Institute of Technology},
  year    = {1949},
  type    = {{MS} thesis}
}
```
