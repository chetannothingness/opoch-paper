# Phase 2B: Appendix Improvements

**Scope:** Improved LaTeX text for `appendices/full-derivation.tex`, `appendices/open-questions.tex`, and `appendices/verification.tex`, addressing all Phase 1A findings.

**Rules followed:**
- All `\label{}`, `\ref{}`, `\cite{}`, theorem environments, and mathematical content preserved exactly.
- Only proofs and surrounding prose modified where flagged.
- Theorem statements unchanged.
- Consistent formatting maintained.

---

## 1. `appendices/full-derivation.tex` --- Improved Sections

### 1.1 Step 2: Self-Delimiting Syntax (add honest qualification)

**REPLACE** the `\forcing{...}` block in Step 2's proof (lines 101--104) with:

```latex
\forcing{Any non-self-delimiting encoding creates an A0-violating
ambiguity.  Self-delimitation is the minimal constraint that eliminates
it.  The specific encoding $\SdMap(s) = 1^{|s|}0s$ is the simplest such
construction; other prefix-free encodings (e.g., Elias delta, Elias gamma)
are computably isomorphic and yield the same quotient structure.  The forced
content is the \emph{prefix-free property}, not the particular map---the
choice of canonical representative is a gauge freedom (formalized at
Step~12).}
```

### 1.2 Step 4: Endogenous Tests (add honest qualification)

**REPLACE** the `\forcing{...}` block in Step 4's proof (lines 230--235) with:

```latex
\forcing{Any subset of $\Del^*$ that is not closed under $\ClMin$ contains
a pair $(\tau_1, \tau_2)$ whose composition is a valid test but is
excluded---creating an A0-violating distinction.  The least fixed point
is the minimal set avoiding this.  The enumeration order is forced
\emph{within the paper's model class}: given $\SdMap$ as the canonical
encoding (Step~2), length-then-lexicographic order is the simplest
computable enumeration requiring no external scheduling channel.  Other
computable enumerations (e.g., dovetailing by program length) yield the
same test set $\Del^*$ and are isomorphic under reindexing; the forced
content is the existence of a canonical, endogenous, computable enumeration,
not the specific index assignment.}
```

### 1.3 Step 5: Ledger as Multiset and the Diamond Law (add honest qualification)

**REPLACE** the `\forcing{...}` block in Step 5's proof (line 293--295) with:

```latex
\forcing{Any mutable record allows A0 violations via witness destruction.
Append-only is the minimal persistence guarantee.  Multiset structure
(order-erasure for causally independent entries) is forced \emph{within
the paper's model class of pure, non-disturbing tests}: when test outcomes
do not depend on execution order, the temporal ordering of independent
events is untestable, hence is gauge.  This is a modeling restriction,
not a consequence of A0 alone---non-commuting tests (as in quantum
mechanics) are consistent with witnessability but require an ordered or
partially ordered ledger.  The quantum extension is discussed in
Appendix~\ref{app:oq:quantum}.}
```

### 1.4 Step 8: Observer Collapse and Entropic Time (add honest qualification)

**REPLACE** the `\forcing{...}` block in Step 8's proof (lines 457--458) with:

```latex
\forcing{Reversing a ledger entry would destroy a witness (Step~5).
Time \emph{is} the irreversibility of record formation.  A0 forces monotone
refinement of the truth quotient under accumulated evidence; the specific
time increment $\Del\Tim = \log(|\text{fiber}_{\mathrm{pre}}| /
|\text{fiber}_{\mathrm{post}}|)$ is the canonical information-theoretic
measure of refinement (Shannon, 1948), forced within the paper's model
class up to monotone reparametrization.  Any strictly monotone function of
fiber shrinkage encodes the same irreversibility; the logarithmic form is
canonical because it is additive under independent refinements.}
```

### 1.5 Step 9: Entropy and Budget (add honest qualification)

**REPLACE** the `\forcing{...}` block in Step 9's proof (lines 491--494) with:

```latex
\forcing{An expanding test set would require an expanding budget, which
would require infinite resources at some finite time---violating A0's
finiteness requirement.  The specific entropy functional
$S(\Ledger) = \log |\TQ{\Ledger}|$ is the canonical choice within the
paper's finite-cardinality model; alternative resource measures (space,
communication complexity) and entropy-like functionals (R\'{e}nyi entropy,
min-entropy) yield structurally analogous frameworks.  The forced content
is the monotone shrinkage of the feasible test set under budget consumption,
not the specific entropy formula.}
```

### 1.6 Step 10: Energy Ledger (add honest qualification)

**REPLACE** the first paragraph of Step 10's proof (lines 501--513) with:

```latex
\begin{proof}
Each test $\tau$ consumes resources: at minimum, the execution steps
required by $\UTM$ to evaluate $\tau$ (Step~3 established that costs are
positive integers $c(\tau) \geq 1$).  A0's finiteness requirement demands
that these costs be finitely recorded.  Landauer's principle
\citep{landauer1961}---that erasing one bit of information requires
dissipating at least $k_B T \ln 2$ of energy---provides a physical
interpretation of this cost, but the forcing argument does not depend on
Landauer's principle.  What A0 forces is the existence of a cost ledger
tracking resource expenditure per test; the identification of abstract cost
units with thermodynamic energy is an interpretive bridge to physics, not a
derivational dependency.  Bennett \citep{bennett1973} showed that
computation can in principle be logically reversible, but A0's append-only
ledger (Step~5) makes the framework's record formation irreversible by
design.  The energy bound requires only the monotonicity of fiber shrinkage
(Step~8), which is already established.  Each test either refines the
quotient (gaining information, consuming budget) or leaves it unchanged
(zero information gain, but still consuming at least the encoding cost of
$\tau$).
```

### 1.7 Step 11: Operational Nothingness (FIX internal inconsistency --- CRITICAL)

**REPLACE** the entire proof of Step 11 (lines 540--560) with:

```latex
\begin{proof}
As $B_{\mathrm{spent}}(\Tim) \to B$, the remaining budget
$B_{\mathrm{rem}} = B - B_{\mathrm{spent}}(\Tim)$ shrinks.  Since all
tests have positive integer cost $c(\tau) \geq 1$ (Step~3), the feasible
test set at time $\Tim$ is:
\[
  \Del(\Tim) \;=\; \bigl\{\, \tau \in \Del^* \;\bigm|\;
    c(\tau) \leq B_{\mathrm{rem}}(\Tim) \,\bigr\}.
\]
When $B_{\mathrm{rem}} < \min_{\tau \in \Del^*} c(\tau)$---that is, when
the remaining budget is insufficient to execute any test in $\Del^*$---the
feasible test set becomes empty: $\Del(\Tim_{\max}) = \varnothing$.  No
further refinement of the truth quotient is possible, because no affordable
separator test remains within budget.  At this point:
\[
  \TQ{\Ledger(\Tim_{\max})} = \TQ{\Ledger(\Tim_{\max} - 1)}.
\]
We call this state \emph{operational nothingness}:
\[
  \opnoth \;:\quad \text{no affordable test remains---the budget horizon
  has been reached.}
\]
Unlike $\noth$ (absolute nothingness, Step~0), $\opnoth$ occurs \emph{within}
a universe that has structure; it is the horizon of that structure's
resolvability given the available resources.

\forcing{Finite budget $\Rightarrow$ finite test sequence $\Rightarrow$
terminal state where no further test is affordable.  $\opnoth$ is the
unique terminal state under A0: it is reached when no separator test can be
executed within the remaining budget, not when ``only constant tests
exist'' (a framing that would conflict with the positive-cost requirement
$c(\tau) \geq 1$).}
\end{proof}
```

### 1.8 Step 14: Exactness Gate and Split Law (add honest qualification)

**REPLACE** the `\forcing{...}` block at the end of Step 14's proof (lines 694--697) with:

```latex
\forcing{The Split Law is a standard image-factorization theorem applied to
the truth quotient; its validity is a mathematical fact independent of A0.
The certificate-first ordering of the exactness gate is forced within the
paper's model class by budget-dominance: any policy that searches for a
separator when a certificate already exists in $\Ledger$ is strictly
dominated (it wastes budget on a test whose outcome is already determined).
A0-compliance alone does not force certificate-first ordering---a wasteful
but A0-compliant policy could check certificates last---but budget-optimality
(itself motivated by A0's finiteness requirement) does.}
```

### 1.9 Step 15: Myhill--Nerode Congruence (add honest qualification)

**REPLACE** the `\forcing{...}` block at the end of Step 15's proof (lines 743--746) with:

```latex
\forcing{Maintaining a distinction between states $s$ and $s'$ when all
futures agree would violate A0 (the distinction has no future witness).
The Myhill--Nerode quotient is the coarsest partition consistent with
A0, hence is forced within the paper's model class.  The specific
indistinguishability criterion---``no continuation of the test sequence can
distinguish''---uses all possible futures as the separator class; coarser
criteria (e.g., bounded-horizon futures) or finer criteria (e.g.,
strategy-equivalence under a fixed policy class) yield alternative
congruences that are also A0-compatible.  The choice of all-futures
equivalence is the canonical (coarsest) option.}
```

### 1.10 Step 18: Deterministic Solver / Bellman Minimax (add honest qualification)

**REPLACE** the `\forcing{...}` block at the end of Step 18's proof (lines 910--915) with:

```latex
\forcing{Any policy that does not minimize worst-case cost can be dominated
by one that does, \emph{in the absence of a prior distribution over test
outcomes}.  A dominated policy wastes budget on tests that leave larger
fibers than necessary, potentially causing $\OMEGA$ where $\UNIQUE$ was
achievable.  The Bellman minimax is the unique non-dominated
\emph{prior-free} policy.  When a prior over outcomes is available,
a Bayesian (expected-cost) Bellman recursion is equally A0-compatible
and may outperform minimax on average; the choice between prior-free
and Bayesian formulations is a modeling commitment, not a consequence of
A0 alone.  The minimax formulation is adopted here as the conservative
default that requires no distributional assumptions beyond A0.}
```

### 1.11 Step 19: Self-Hosting and Replay (add honest qualification)

**REPLACE** the `\forcing{...}` block at the end of Step 19's proof (lines 953--955) with:

```latex
\forcing{Self-hosting is consistent with A0 and is the natural closure
condition ensuring that the kernel's own structure lies within its
verification scope.  However, A0 does not \emph{logically require}
self-hosting: a kernel verified by an external agent would also satisfy
A0, provided each derivation step has a witness.  Self-hosting is forced
within the paper's model class by the closed-universe assumption (no
external oracle or verifier is available), which is itself a commitment
of the framework rather than a consequence of A0 alone.  The self-hosting
property is analogous to the Kleene recursion theorem
\citep{kleene1952}: a total recursive function can compute its own index.}
```

### 1.12 Step 20: Binary Interface (add honest qualification)

**REPLACE** the `\forcing{...}` block at the end of Step 20's proof (lines 1000--1003) with:

```latex
\forcing{Any encoding that is not self-delimiting reintroduces the
ambiguity of Step~2.  Any encoding that requires external metadata (frame
headers, delimiters not part of the payload) violates the closed-universe
assumption.  The forced content is a self-describing binary interface;
$\SdMap$ is the simplest canonical representative, unique up to computable
isomorphism (the same gauge freedom as Step~2).}
```

### 1.13 Step 21: Final Chain (QUALIFY per Phase 1A --- CRITICAL)

**REPLACE** the entire proof of Step 21 (lines 1010--1041) with:

```latex
\begin{proof}
Each link in the chain has been established as a theorem in
Sections~\ref{sec:derivation:law}--\ref{sec:derivation:solver}:
Steps~0--21 form an acyclic dependency graph (\cref{fig:derivation-dag})
with no circular dependencies, and each step's forcing argument has been
given above.

The derivation rests on two declared external commitments:
\begin{enumerate}[nosep]
  \item The Church--Turing thesis (Step~3), which identifies A0's
        ``finite procedure'' with ``total computable function.''
  \item The paper's modeling commitments: pure non-disturbing tests
        (Step~5, enabling commutativity), prior-free worst-case
        optimization (Step~18, selecting minimax), and the closed-universe
        assumption (Steps~2, 19, 20, requiring self-delimitation and
        self-hosting).
\end{enumerate}
Given these commitments, the chain is forced end-to-end: each step is the
unique A0-compliant continuation of its predecessors, canonical up to
computable isomorphism.  Many links admit gauge freedom in their specific
form (e.g., the choice of prefix-free encoding at Step~2, the enumeration
order at Step~4, the entropy formula at Step~9), but the \emph{structural
content}---the quotient, the groupoid, the metric, the Bellman
recursion---is invariant under these representational choices.

The chain begins at $\noth$ (no structure) and terminates at $\opnoth$
(no remaining affordable tests)---a circuit from nothingness through forced
structure back to operational nothingness.

The three-point audit (\cref{sec:demonstration}) confirms:
\begin{enumerate}[nosep]
  \item \emph{Hidden Chooser Test:} At each step, no alternative
        A0-compliant continuation exists (or the alternative is
        isomorphic to the derived one), given the paper's modeling
        commitments.
  \item \emph{Encoding Invariance:} Re-executing the derivation under any
        computably isomorphic encoding produces the same quotient structure.
  \item \emph{Distinguishability Equivalence:} No false merges (objects
        merged that a test could separate) and no false splits (objects
        kept apart that no test can separate).
\end{enumerate}

Z3 verification (Appendix~C) confirms the finite-model properties:
equivalence relation axioms, groupoid axioms, monotone fiber shrinkage,
image factorization, Myhill--Nerode congruence, metric axioms, Bellman
well-definedness, fixed-point consistency, and trichotomy exhaustiveness.

\forcing{The chain is forced end-to-end given A0, the Church--Turing
thesis, and the paper's modeling commitments.  Removing any link either
(a)~violates A0, (b)~loses the self-hosting property, or (c)~creates an
unwitnessable gap.  The derivation is canonical up to computable
isomorphism: representational choices (encoding, enumeration order, entropy
formula) are gauge freedoms that do not alter the quotient structure.}
\end{proof}
```

### 1.14 Verification Summary (update to reflect honest qualifications)

**REPLACE** the verification summary subsection (lines 1133--1141) with:

```latex
\subsection{Verification Summary}

\begin{itemize}[nosep]
  \item \textbf{Steps 0--21}: All forcing arguments validated within the
        paper's model class.  Each step follows necessarily from its
        predecessors given A0, the Church--Turing thesis, and the declared
        modeling commitments (pure non-disturbing tests, prior-free
        optimization, closed-universe assumption).
  \item \textbf{Step 3 (Executability)}: The forcing argument is valid
        \emph{given} the Church--Turing thesis.  The thesis itself is
        meta-mathematical and explicitly declared.
  \item \textbf{Gauge freedoms}: Steps~2, 4, 8, 9, and 20 involve
        representational choices (encoding, enumeration order, entropy
        formula) that are canonical up to computable isomorphism.  The
        quotient structure is invariant under these choices.
  \item \textbf{Modeling commitments}: Steps~5 (commutativity), 18
        (minimax), and 19 (self-hosting) are forced within the paper's
        model class; alternative modeling choices (ordered ledger,
        Bayesian optimization, external verification) yield structurally
        analogous but distinct frameworks.
  \item \textbf{Z3 verification}: 9 steps verified on finite models
        (see Appendix~\ref{app:z3}).
  \item \textbf{Honest limitation}: Infinite-domain mechanization
        deferred to future work (Lean/Coq).
\end{itemize}
```

---

## 2. `appendices/open-questions.tex` --- Improved Sections

### 2.1 Halting Problem Section (make budget-relative totality explicit)

**REPLACE** the entire `\subsection{The Halting Problem and the Total Evaluator}` (lines 129--158) with:

```latex
\subsection{The Halting Problem and the Total Evaluator}
\label{app:oq:halting}

The halting problem establishes that no algorithm can decide whether an
arbitrary Turing machine halts.  Step~3 postulates a total evaluator
where $\UTM(\tau, x)$ halts for all $\tau, x$.

\paragraph{Resolution.}
The total evaluator operates only on $\Del^*$ (the set of \emph{total}
tests).  Membership in $\Del^*$ is undecidable in general (by Rice's
theorem \citep{rice1953}), but the framework sidesteps this via
\emph{budget-relative totality on the finite slice}:

\begin{enumerate}[nosep]
  \item \textbf{Budget-relative totality.}  A test $\tau$ is
        \emph{budget-total} if $\UTM(\tau, x)$ halts within budget $B$
        for every $x \in \FinSlice$.  Because $\FinSlice$ is finite
        (Step~1) and $B$ is a fixed positive integer, budget-totality
        is a \emph{decidable} property: enumerate all $x \in \FinSlice$
        (finitely many), run $\UTM(\tau, x)$ for at most $B$ steps on
        each, and check whether all executions halt.
  \item \textbf{TIMEOUT as first-class outcome.}  Tests that do not halt
        within budget return $\mathrm{TIMEOUT} \in A$, which is a
        well-defined outcome in the test's outcome alphabet---not an
        undefined state or a semantic gap.  The evaluator is therefore
        \emph{total by construction}: every input produces a well-defined
        output within finite time, where $\mathrm{TIMEOUT}$ is one such
        output.
  \item \textbf{Constructive enumeration.}  The canonical enumeration
        $\CanEnum$ (Step~4) is constructive: enumerate candidate programs
        of increasing $\SdMap$-length, execute each on all inputs within
        the current budget, and include only those that are budget-total.
        Tests that are total on unbounded domains but exceed budget on some
        $x \in \FinSlice$ are simply infeasible and excluded from
        $\Del(\Tim)$.
\end{enumerate}

The key insight is that A0's finiteness requirement (every witness must
terminate within finite budget) converts the undecidable question ``does
$\tau$ halt on all inputs?'' into the decidable question ``does $\tau$
halt on all inputs in $\FinSlice$ within budget $B$?''  This is not an
approximation or workaround---it is the correct formalization of A0's
operational semantics: only budget-feasible tests are admissible, and
budget-feasibility is decidable.

\paragraph{Status.}
\textbf{No conflict with the halting problem.}  The framework operates
with budget-relative totality on the finite slice, which is decidable.
$\mathrm{TIMEOUT}$ is a first-class outcome, not an error or gap.
Tests that might not halt on unbounded inputs are simply infeasible
(cost exceeds budget) and are excluded from $\Del(\Tim)$.
```

### 2.2 Quantum Mechanics Section (strengthen honest concession about Step 5)

**REPLACE** the entire `\subsection{Quantum Mechanics and Non-Commuting Observables}` (lines 46--71) with:

```latex
\subsection{Quantum Mechanics and Non-Commuting Observables}
\label{app:oq:quantum}

The current framework assumes that the outcomes of causally independent
tests do not depend on execution order (Diamond Law, Step~5).  This
assumption is a \emph{modeling restriction}, not a consequence of A0
alone: non-commuting tests are fully consistent with witnessability, but
they require a richer ledger structure than the multiset adopted in Step~5.
Quantum observables, which do not commute in general ($[A, B] \neq 0$),
are the canonical example of tests whose outcomes depend on measurement
order.

\paragraph{Scope of the restriction.}
The commutativity assumption enters at Step~5 and propagates to:
\begin{itemize}[nosep]
  \item Step~5: the ledger is a multiset (order-erased) rather than a
        sequence or partially ordered set.
  \item Step~7: the eraser algebra satisfies unconditional commutativity
        ($e_{\tau_1} \circ e_{\tau_2} = e_{\tau_2} \circ e_{\tau_1}$ for
        all $\tau_1, \tau_2$), which would hold only for commuting pairs
        in the non-commutative extension.
\end{itemize}
The remainder of the derivation---carrier, syntax, executability,
entropic time, gauge, Myhill--Nerode, separator geometry, Bellman
dynamics, self-hosting---is structurally independent of the commutativity
assumption and carries over to the non-commutative extension.

\paragraph{Extension path.}
Replace the multiset ledger (Step~5) with an \emph{ordered} (or partially
ordered) ledger in which the order of non-commuting tests matters.  The
truth quotient becomes order-dependent, and the Diamond Law applies only
to commuting pairs:
\[
  e_{\tau_1} \circ e_{\tau_2} = e_{\tau_2} \circ e_{\tau_1}
  \quad\text{iff}\quad [\tau_1, \tau_2] = 0.
\]

\paragraph{Status.}
\textbf{Not currently handled; acknowledged as a modeling restriction.}
The commutativity of Step~5 is derived within the framework's model class
(pure, non-disturbing tests whose outcomes are independent of execution
order), not from A0 alone.  Extension to non-commuting tests is a natural
future direction that preserves the framework's core structure while
requiring modifications to the ledger, truth quotient, and eraser algebra.
```

### 2.3 Declared vs. Derived Assumptions Table (reclassify commutativity)

**REPLACE** the entire assumptions table and surrounding text (lines 193--225) with:

```latex
\subsection{Declared vs.\ Derived Assumptions---Honest Inventory}
\label{app:oq:assumptions}

\Cref{tab:assumptions} provides a complete inventory of all assumptions
in the derivation, distinguishing between axioms, declared external
assumptions, modeling commitments, derived consequences, and background
mathematics.

\begin{table}[ht]
\centering
\small
\caption{Complete assumption inventory for the 21-step derivation.}
\label{tab:assumptions}
\begin{tabular}{@{}clcll@{}}
\toprule
\textbf{\#} & \textbf{Assumption} & \textbf{Step} & \textbf{Status} & \textbf{Justification} \\
\midrule
1 & Witnessability (A0) & 0 & Axiom & Foundational---the only law \\
2 & Church--Turing thesis & 3 & Declared & Meta-mathematical, widely accepted \\
3 & Finite slice $\FinSlice$ & 1 & Derived & Forced by A0's finiteness \\
4 & Totality of $\UTM$ on $\Del^*$ & 3 & Derived & Forced by A0 (budget-relative totality) \\
5 & Positive integer costs & 3 & Derived & Cost $=$ execution steps $\geq 1$ \\
6 & Determinism of kernel & 18 & Derived & Canonical enumeration $+$ Bellman argmin \\
7 & Commutativity of tests & 5 & \textbf{Modeling} & Derived under the framework's \\
  &                          &   & \textbf{commitment} & pure non-disturbing test model; \\
  &                          &   &                      & not forced by A0 alone \\
8 & Prior-free optimization & 18 & \textbf{Modeling} & Minimax is the unique non-dominated \\
  &                          &    & \textbf{commitment} & prior-free policy; Bayesian \\
  &                          &    &                      & alternatives are A0-compatible \\
9 & Closed-universe assumption & 2, 19, 20 & \textbf{Modeling} & No external oracle or verifier; \\
  &                            &           & \textbf{commitment} & forces self-delimitation \& \\
  &                            &           &                      & self-hosting \\
10 & Basic set theory (ZFC) & --- & Background & Standard mathematical foundations \\
\bottomrule
\end{tabular}
\end{table}

\noindent
Of these ten items, the derivation has one axiom (A0), one declared
external assumption (the Church--Turing thesis), three modeling
commitments (commutativity, prior-free optimization, closed universe),
four derived consequences, and one background assumption.  The three
modeling commitments are not arbitrary---each is the canonical or
conservative choice within its respective design space---but they are
commitments rather than theorems of A0.  Alternative choices
(non-commuting tests, Bayesian optimization, externally verified
derivation) yield structurally analogous but distinct frameworks.
```

---

## 3. `appendices/verification.tex` --- Improved Text

**REPLACE** the entire file content with the following more precise and formal version:

```latex
\section{Three-Point Audit Protocol}
\label{app:verification}

The verification system implements a structured audit for every claim
produced by the kernel.  This appendix provides formal definitions of
each audit component, specifies their composition into a four-point
verification protocol (three conceptual tests plus Z3 finite-model
checking), and documents the protocol's application to all 21 derivation
steps.

\subsection{Audit Components: Formal Definitions}

\begin{definition}[Hidden Chooser Test (HC)]
\label{def:hc}
Let $s_i$ be derivation step $i$ with input state $I_i$ (the conclusions
of all predecessor steps) and output $O_i$.  The Hidden Chooser Test
verifies that $O_i$ is uniquely determined by $I_i$ and A0:
\[
  \mathrm{HC}(s_i) = \mathrm{PASS} \quad\iff\quad
  \forall\, O' \neq O_i:\;
  O' \text{ is either A0-violating or isomorphic to } O_i.
\]
Formally, ``isomorphic'' means there exists a computable bijection
$\phi \colon O_i \to O'$ such that $\phi$ preserves all quotient-level
properties (truth classes, fiber structure, test outcomes).  A step
\emph{passes HC} if no non-isomorphic A0-compliant alternative exists.
A step \emph{passes HC with qualification} (denoted $\checkmark^\dagger$)
if the uniqueness holds given an explicitly declared external commitment
(e.g., the Church--Turing thesis).
\end{definition}

\begin{definition}[Encoding Invariance Check (EI)]
\label{def:ei}
Let $\Carrier_1$ and $\Carrier_2$ be two carrier representations with
computable bijection $\phi \colon \Carrier_1 \to \Carrier_2$.  Let
$\Ledger_2 = \{(\phi \circ \tau \circ \phi^{-1},\; a) \mid
(\tau, a) \in \Ledger_1\}$ be the induced ledger under $\phi$.  The
Encoding Invariance Check verifies:
\[
  \mathrm{EI}(C, w, \phi) = \mathrm{PASS} \quad\iff\quad
  \TQ{\Ledger_1} \cong \TQ{\Ledger_2},
\]
where $\cong$ denotes isomorphism of quotient structures (preserving
equivalence classes and their separator distances).  This check must hold
for all $\phi \in \gauge$ (the gauge groupoid of Step~12).  EI is the
gauge invariance test applied to the derivation itself: it confirms that
no derivation step depends on a particular bit-level encoding.
\end{definition}

\begin{definition}[Distinguishability Equivalence (DE)]
\label{def:de}
The Distinguishability Equivalence check verifies bidirectional
consistency of A0 application:
\begin{align}
  \text{No false merges:}\quad &
    [x] = [y] \;\Longrightarrow\;
    \nexists\, \tau \in \Del^*:\; \UTM(\tau, x) \neq \UTM(\tau, y).
    \label{eq:no-false-merge} \\
  \text{No false splits:}\quad &
    \bigl(\forall\, \tau \in \Del^*:\; \UTM(\tau, x) = \UTM(\tau, y)\bigr)
    \;\Longrightarrow\; [x] = [y].
    \label{eq:no-false-split}
\end{align}
Equation~\eqref{eq:no-false-merge} ensures that merged objects are
genuinely indistinguishable; equation~\eqref{eq:no-false-split} ensures
that distinguishable objects are never incorrectly identified.  Together
they assert that the truth quotient $\equivL$ is the \emph{exact}
equivalence induced by the test set.
\end{definition}

\begin{definition}[Z3 Finite-Model Verification]
\label{def:z3}
For steps with verifiable algebraic properties (equivalence relations,
groupoid axioms, metric axioms, etc.), Z3 \citep{demoura2008} checks
these properties on finite models:
\begin{itemize}[nosep]
  \item \textbf{Satisfiability checks} (\texttt{sat}): confirm that a
        finite model satisfying the stated properties exists.
  \item \textbf{Unsatisfiability checks} (\texttt{unsat}): confirm that
        no finite model violating the stated properties exists (i.e., the
        property holds for all models in the finite domain).
\end{itemize}
See Appendix~\ref{app:z3} for scripts and results.

\textbf{Honest disclosure:} Satisfiability checks verify existence of a
conforming model, not universal validity.  Unsatisfiability checks are
stronger (universal over the finite domain) but do not extend to
infinite domains without additional mechanization (Lean/Coq).
\end{definition}

\subsection{Composition: Four-Point Audit Protocol}

\begin{definition}[Four-Point Audit]
\label{def:four-point}
A claim $C$ with witness $w$ \emph{passes the four-point audit} if and
only if all four components return PASS:
\begin{align}
  \mathrm{HC}(C, w) &= \mathrm{PASS}
    \tag{Hidden Chooser} \label{eq:audit-hc} \\
  \mathrm{EI}(C, w, \phi) &= \mathrm{PASS}
    \quad \forall\, \phi \in \gauge
    \tag{Encoding Invariance} \label{eq:audit-ei} \\
  \mathrm{DE}(C, w) &= \mathrm{PASS}
    \tag{Distinguishability} \label{eq:audit-de} \\
  \mathrm{Z3}(C) &= \mathrm{SAT} \;\text{or}\; \mathrm{UNSAT}^\dag
    \quad \text{(where applicable)}
    \tag{Finite-Model Check} \label{eq:audit-z3}
\end{align}
where $^\dag$ indicates negation-checking (the negation of the property
is unsatisfiable, proving the property holds universally on the finite
domain).
\end{definition}

\begin{remark}[Protocol Coverage]
The three conceptual tests (HC, EI, DE) are complementary:
\begin{itemize}[nosep]
  \item HC guards against \emph{hidden choices} (non-forced design
        decisions masquerading as theorems).
  \item EI guards against \emph{encoding dependence} (results that change
        under representation switching).
  \item DE guards against \emph{quotient errors} (incorrect merging or
        splitting of descriptions).
\end{itemize}
Together they ensure that each derivation step is forced (HC), invariant
(EI), and faithful (DE).  Z3 provides independent machine-checked
confirmation of algebraic properties on finite models.
\end{remark}

\subsection{Application to Derivation Steps}

\begin{table}[h!]
\centering
\small
\begin{tabular}{@{}clcccl@{}}
\toprule
\textbf{Step} & \textbf{Name} & \textbf{HC} & \textbf{EI} & \textbf{DE} & \textbf{Z3} \\
\midrule
0  & $\noth$ + Output Gate & \checkmark & \checkmark & \checkmark & --- \\
1  & Carrier $\Carrier$, $\FinSlice$ & \checkmark & \checkmark & \checkmark & --- \\
2  & $\SdMap$ syntax & \checkmark & \checkmark & \checkmark & --- \\
3  & Executability & $\checkmark^{\dagger}$ & \checkmark & \checkmark & --- \\
4  & $\Del^*$, $\CanEnum$ & \checkmark & \checkmark & \checkmark & --- \\
5  & Ledger $\Ledger$ & $\checkmark^{\ddagger}$ & \checkmark & \checkmark & --- \\
6  & Truth quotient $\TQ{\Ledger}$ & \checkmark & \checkmark & \checkmark & \texttt{sat} \\
7  & $\ObsOpen$, $\Eraser$, sim* & $\checkmark^{\ddagger}$ & \checkmark & \checkmark & --- \\
8  & Entropic time $\Del\Tim$ & \checkmark & \checkmark & \checkmark & \texttt{sat} \\
9  & Entropy, Budget & \checkmark & \checkmark & \checkmark & --- \\
10 & Energy $\EnergyLedger$ & \checkmark & \checkmark & \checkmark & --- \\
11 & $\opnoth$ & \checkmark & \checkmark & \checkmark & --- \\
12 & Gauge $\gauge$ & \checkmark & \checkmark & \checkmark & \texttt{sat} \\
13 & $\Epistemic$/$\Decision$ & \checkmark & \checkmark & \checkmark & --- \\
14 & $\ExactGate$ + Split & \checkmark & \checkmark & \checkmark & \texttt{sat} \\
15 & Myhill--Nerode & \checkmark & \checkmark & \checkmark & \texttt{sat} \\
16 & Separator $\SepDist$ & \checkmark & \checkmark & \checkmark & \texttt{sat} \\
17 & $\Pit$-consistency & \checkmark & \checkmark & \checkmark & --- \\
18 & Bellman minimax & $\checkmark^{\S}$ & \checkmark & \checkmark & \texttt{sat} \\
19 & Self-hosting $\SelfHost$ & $\checkmark^{\P}$ & \checkmark & \checkmark & \texttt{sat} \\
20 & Binary interface & \checkmark & \checkmark & \checkmark & --- \\
21 & Final chain & \checkmark & \checkmark & \checkmark & \texttt{sat} \\
\bottomrule
\end{tabular}
\caption{Four-point audit results for all 21 derivation steps.
$^{\dagger}$Forced modulo the Church--Turing thesis (Remark~\ref{rem:ct-localization}).
$^{\ddagger}$Forced within the paper's pure non-disturbing test model
(commutativity is a modeling commitment; see Appendix~\ref{app:oq:quantum}).
$^{\S}$Forced as the unique non-dominated prior-free policy; Bayesian
alternatives are A0-compatible when a prior is available.
$^{\P}$Forced under the closed-universe assumption (no external verifier);
external verification is A0-compatible but outside the model class.
All steps pass; qualifications are honest disclosures of modeling
commitments, not failures.}
\label{tab:audit}
\end{table}

\subsection{Receipt Chain}

Every kernel output includes a receipt chain encoded via $\SdMap$:
\begin{enumerate}[nosep]
  \item \textbf{Serialization:} Canonical JSON serialization of the
        output (sorted keys, deterministic formatting).
  \item \textbf{Hashing:} SHA-256 hash of the $\SdMap$-encoded canonical
        JSON, producing a 256-bit fingerprint.
  \item \textbf{Chaining:} Each receipt includes the hash of the previous
        receipt, forming a hash chain: $h_i = \mathrm{SHA256}(h_{i-1}
        \,\|\, \SdMap(\text{output}_i))$.
  \item \textbf{Replay:} Any party can recompute the entire chain from
        the problem specification and verify that the reproduced chain
        matches the original hashes.
\end{enumerate}

The receipt chain ensures \emph{non-repudiation}: the kernel cannot
silently change its output after the fact.  This is the computational
analogue of the ledger's append-only property (Step~5).  The chain is
\emph{deterministic}: given the same problem specification and budget,
replay produces identical hashes, confirming that the kernel's behavior
is fully reproducible.

\subsection{Self-Hosting Verification}

The self-hosting property ($\SelfHost = \mathcal{K}$, Step~19) means
the kernel can verify its own derivation.  The verification procedure
is:
\begin{enumerate}[nosep]
  \item \textbf{Encoding:} Encode each of the 21 derivation steps as a
        compiled finite contract $P_i = \langle q_i, \mathcal{A}_i,
        \mathcal{V}_i, B_i, \pi_i \rangle$, where $q_i$ is the claim,
        $\mathcal{A}_i$ the answer space, $\mathcal{V}_i$ the three-point
        audit, $B_i$ the verification budget, and $\pi_i$ the cost
        assignment.
  \item \textbf{Execution:} Run the kernel $\mathcal{K}$ on each $P_i$
        using the three-point audit (HC $+$ EI $+$ DE) as the verifier
        $\mathcal{V}_i$.
  \item \textbf{Confirmation:} Verify that all 22 executions (Steps
        0--21) produce $\UNIQUE$ (with the Church--Turing qualification at
        Step~3 and the modeling-commitment qualifications at Steps~5, 18,
        19).
  \item \textbf{Certification:} The receipt chain linking all 22
        verifications is the self-hosting certificate.  This certificate
        is itself a finite object in $\Carrier$, verifiable by replay.
\end{enumerate}

\begin{remark}[Scope of Self-Hosting]
Self-hosting is \emph{object-level} verification: the kernel checks each
derivation step's conclusion given its premises.  It does \emph{not}
verify the meta-claim ``the kernel is consistent'' or ``the audit
procedure is correct,'' which would violate G\"{o}del's second
incompleteness theorem \citep{godel1931}.  The three-point audit can
verify specific claims but cannot prove the general correctness of the
audit procedure itself.
\end{remark}
```

---

## 4. Summary of All Changes

### `appendices/full-derivation.tex`

| Location | Change Type | Description |
|----------|-------------|-------------|
| Step 2 `\forcing{}` | Qualification | Prefix-free property is forced, specific map is gauge |
| Step 4 `\forcing{}` | Qualification | Endogenous enumeration is forced, specific order is gauge |
| Step 5 `\forcing{}` | Qualification | Commutativity is a modeling restriction, not A0-forced |
| Step 8 `\forcing{}` | Qualification | Logarithmic time is canonical but admits monotone reparametrization |
| Step 9 `\forcing{}` | Qualification | Monotone shrinkage is forced, specific entropy formula is canonical |
| Step 10 proof | Qualification | Landauer is interpretive bridge, not derivational dependency |
| Step 11 proof | **Critical fix** | Remove zero-cost inconsistency; reframe as budget exhaustion |
| Step 14 `\forcing{}` | Qualification | Split Law is mathematical fact; certificate-first is budget-dominance |
| Step 15 `\forcing{}` | Qualification | All-futures is canonical (coarsest) but alternatives are A0-compatible |
| Step 18 `\forcing{}` | Qualification | Minimax is unique non-dominated *prior-free* policy |
| Step 19 `\forcing{}` | Qualification | Self-hosting forced by closed-universe, not A0 alone |
| Step 20 `\forcing{}` | Qualification | Self-describing interface forced, specific map is gauge |
| Step 21 proof | **Critical fix** | Honest accounting of CT + modeling commitments; canonical up to iso |
| Verification Summary | Update | Reflects gauge freedoms and modeling commitments honestly |

### `appendices/open-questions.tex`

| Location | Change Type | Description |
|----------|-------------|-------------|
| Halting problem (S5.5) | Rewrite | Budget-relative totality made explicit; TIMEOUT as first-class outcome |
| Quantum mechanics (S5.2) | Rewrite | Step 5 commutativity explicitly called a modeling restriction |
| Assumptions table (S5.7) | Rewrite | Commutativity, minimax, closed-universe reclassified as modeling commitments |

### `appendices/verification.tex`

| Location | Change Type | Description |
|----------|-------------|-------------|
| Audit components | Formalization | HC, EI, DE given formal Definition environments with equations |
| Four-point composition | Formalization | Protocol composition specified as Definition with labeled equations |
| Protocol coverage | New remark | Explains complementarity of three conceptual tests |
| Audit table | Precision | Footnotes distinguish CT, commutativity, minimax, self-hosting qualifications |
| Receipt chain | Precision | Hash chaining formula made explicit |
| Self-hosting | Precision | 5-tuple encoding spelled out; scope remark clarified |
