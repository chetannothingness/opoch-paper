# Phase 2A Writing Improvements (Journal-Submission Polish)

This file contains revised LaTeX for the requested core sections. Each block is intended to replace the full contents of the corresponding `.tex` file.

## sections/abstract.tex

```latex
% =============================================================================
% Abstract
% =============================================================================

\begin{abstract}
We present \Opoch{}, a framework that derives a constrained notion of structural reality from a single admissibility criterion: \textbf{Witnessability (A0)}, which states that a distinction is admissible if and only if a finite witness procedure can separate it.

Starting from $\noth$ (Nothingness, the state carrying zero information), we give a 21-step derivation that, within the paper's model class, is forced up to computable isomorphism. The derivation yields three primitives, $\Del$ (tests), $\Pit$ (truth), and $\Tim$ (time), together with an operational apparatus for witnessable reasoning: (i) a carrier set $\Carrier$ with finite slice $\FinSlice$ and self-delimiting syntax $\SdMap$, (ii) executability primitives (total evaluator, decoder, cost functional), (iii) an endogenous test algebra $\Del^*$ with canonical enumeration $\CanEnum$, (iv) an irreversible time ledger $\Tim$ with a cost accounting layer $\EnergyLedger$, (v) a truth quotient $\TQ{\cdot}$ equipped with observable-open topology $\ObsOpen$, eraser algebra $\Eraser$, and self-generating fixed point $\mathrm{sim}^*$, (vi) gauge invariance under encoding permutations, (vii) a Myhill--Nerode congruence $\MNcong$ inducing separator geometry ($\SepDist$, curvature, hardness), (viii) Bellman-optimal test-selection dynamics, and (ix) a self-hosting closure ($\SelfHost = \mathcal{K}$).

These components assemble into the \emph{\Opoch{} Kernel}, which accepts a compiled finite contract $\Contract$ and terminates in exactly one of three states: $\UNIQUE$ (verified answer with witness and receipt), $\OMEGA$ (unknown, returning the minimal separator test required for resolution), or $\UNSAT$ (claim rejected with counter-witness). Every output carries a replay-verifiable SHA-256 receipt chain via a self-delimiting binary interface.

We demonstrate the kernel on multi-agent path-finding (MAPF) in a $25 \times 25$ warehouse benchmark with 8~robots and 24~jobs, achieving a $6.5\times$ wall-clock speedup over the GreyOrange industrial baseline with mathematically guaranteed zero collisions and zero deadlocks. We provide a three-point self-audit of the derivation's invariances and verify selected algebraic properties on finite models via the Z3 SMT solver.
\end{abstract}
```

## sections/introduction.tex

```latex
% =============================================================================
% Section 1: Introduction
% =============================================================================

\section{Introduction}
\label{sec:introduction}

\subsection{The Question}

What is the minimal structure forced into existence by the requirement that
every distinction be witnessable?

This is not a question about engineering, artificial intelligence, or any
particular domain of application. It is a foundational question about
describable reality. If we insist, as Axiom~A0 requires, that every meaningful
distinction be backed by a finite procedure that can in fact separate it, then
some structures become unavoidable. The purpose of this paper is to identify
those structures and to make explicit which commitments are definitional and
which are derived.

The central result is a derivation that begins at $\noth$ and unfolds by
reapplying A0 to its own products. Within the paper's model class, the
derivation yields a carrier of descriptions, a self-delimiting syntax, an
endogenous algebra of tests, an append-only record of outcomes, a truth
quotient with associated topology and eraser operators, a time variable tied to
irreversible evidence accumulation, a cost accounting layer, an encoding
invariance principle, a Myhill--Nerode congruence with induced separator
geometry, a deterministic test-selection recursion, and a self-hosting closure.
These structures are not introduced as free design parameters. Rather, they
are forced up to computable isomorphism by A0 together with the paper's stated
operational reading of witnessability.

Equally important is what we do \emph{not} claim. We do not claim to derive the
specific \emph{content} of physical law, only a vocabulary and scaffolding for
reasoning under witnessability. We do not claim that every modeling choice is
eliminated under every possible formalization of A0. Our claim is narrower and
testable: given the explicit premises and conventions in \cref{sec:axioms} and
the model class studied in \cref{sec:derivation}, the resulting chain of
structures is canonical up to computable isomorphism, and the kernel built
from it enforces a deterministic trit-valued interface with replayable
receipts.

\subsection{The Witnessability Principle}

We begin from a single axiom:

\begin{quote}
\textbf{Axiom A0 (Witnessability).}  A distinction is admissible if and
only if a finite witness procedure can separate it.
\end{quote}

This axiom is not chosen for convenience. It is the weakest non-trivial
constraint one can impose. If a distinction cannot even in principle be
witnessed, then it is operationally meaningless. Wheeler's ``It from Bit''
programme \citep{wheeler1990} and Rovelli's relational quantum
mechanics \citep{rovelli1996} both point toward observer-relative,
information-theoretic foundations. A0 isolates the operational core shared by
such views and elevates it to an admissibility criterion.

The formal statement of A0 and its immediate consequences are given in
\cref{sec:axioms}.

\subsection{Key Insight: Nothingness as the Only Unfalsifiable Truth}

Nothingness, the state carrying zero information, asserting nothing, and
distinguishing nothing, is the only unfalsifiable truth. Every other claim can
in principle be tested and potentially refuted. Nothingness alone survives all
tests trivially because it makes no assertions.

This claim is meant operationally. $\noth$ is the unique state satisfying
$\Del = \varnothing$, so no tests exist, no descriptions exist, and no
distinctions are drawn. From this state, the self-application of A0 forces the
existence of at least one admissible distinction, which breaks the symmetry.
Once at least one distinction exists, the derivation proceeds step by step,
making explicit where results are unique up to computable isomorphism and
where the development depends on declared conventions.

\begin{enumerate}[label=\textbf{S\arabic*}.]
  \item $\noth$ is the unique unfalsifiable state. A trichotomous output
        gate ($\UNIQUE$/$\OMEGA$/$\UNSAT$) is forced immediately.
  \item Self-application of A0 forces the existence of at least one
        admissible distinction, breaking the symmetry of $\noth$.
  \item The carrier set $\Carrier$ of all finite binary strings is the
        unique minimal domain closed under witnessing, up to computable
        isomorphism, given the Church--Turing thesis as a declared naming
        convention \citep{church1936, turing1936}.
  \item Tests, truth, time, cost accounting, gauge invariance,
        Myhill--Nerode congruence, separator geometry, Bellman-optimal
        dynamics, and self-hosting closure emerge by applying A0 to its own
        products across the remaining derivation steps.
\end{enumerate}

The forcing claim is therefore precise. We claim canonical structure within
the explicitly stated model class and up to computable isomorphism, and we
state frontiers where additional assumptions, alternative modeling choices, or
empirical input would be required.

\subsection{Contributions}

This paper makes five contributions:

\begin{enumerate}[label=(\arabic*)]
  \item \textbf{A 21-step derivation of structural reality from $\noth$.}
        Starting from nothingness, we derive the framework's core
        vocabulary, introducing 13 new mathematical objects. The
        Church--Turing thesis is the sole explicitly declared external input,
        entering as a naming convention (\cref{sec:derivation},
        Appendix~\ref{app:derivation}).

  \item \textbf{Three forced primitives and seven doctrines.}
        The derivation isolates three primitives, $\Del$ (tests),
        $\Pit$ (truth), and $\Tim$ (time), and collects seven doctrines that
        follow from the operational reading of A0
        (\cref{sec:primitives}, \cref{sec:doctrines}).

  \item \textbf{The \Opoch{} Kernel with compiled finite contracts.}
        A deterministic, self-hosting kernel that accepts a compiled
        finite contract $\Contract$ and terminates in $\UNIQUE$,
        $\OMEGA$, or $\UNSAT$ with a replay-verifiable receipt chain
        (\cref{sec:kernel}).

  \item \textbf{Z3 formal verification.}
        Algebraic properties of 9 derivation steps are verified on
        finite models using the Z3 SMT solver
        (Appendix~\ref{app:z3}).

  \item \textbf{MAPF demonstration.}
        We instantiate the kernel on a multi-agent path-finding benchmark,
        achieving $6.5\times$ speedup over an industrial baseline with
        formally verified zero collisions
        (\cref{sec:demonstration}).
\end{enumerate}

\subsection{Paper Outline}

\Cref{sec:axioms} states the axiom and declared primitives.
\Cref{sec:primitives} introduces the three forced primitives ($\Del$,
$\Pit$, $\Tim$).
\Cref{sec:doctrines} presents the seven non-negotiable doctrines.
\Cref{sec:derivation} presents the 21-step derivation with proof sketches.
\Cref{sec:kernel} defines the \Opoch{} Kernel.
\Cref{sec:demonstration} reports experimental results on MAPF benchmarks
and the self-audit.
\Cref{sec:related} surveys the intellectual context.
\Cref{sec:discussion} provides an honest assessment of claims, limitations,
and open frontiers.
\Cref{sec:conclusion} concludes with future directions.
Appendices contain the complete derivation with full proofs, verification
protocol, Z3 scripts, experimental details, and code excerpts.
```

## sections/discussion.tex

```latex
% =============================================================================
% Section: Discussion and Open Frontiers
% =============================================================================

\section{Discussion and Open Frontiers}
\label{sec:discussion}

% -------------------------------------------------------------------------
\subsection{What Is Claimed}
\label{sec:discussion:claimed}

We claim the following, and no more:

\begin{enumerate}[label=(\roman*)]
  \item \textbf{Within the paper's model class, a canonical structure is derived from A0.}
        Given the Witnessability axiom (A0), the Church--Turing thesis
        (as a declared naming convention), and standard set-theoretic
        operations, the 21-step development produces carrier, self-delimiting
        syntax, a test algebra, truth quotient, observable-open structure,
        eraser operators, time and cost accounting, gauge invariance,
        Myhill--Nerode congruence, separator geometry, Bellman recursion,
        self-hosting closure, and a binary interface. The claim of
        ``forcedness'' is to be read as ``forced up to computable
        isomorphism within the stated model class,'' rather than as a claim
        that every representational choice is eliminated under every possible
        formalization of witnessability. We provide a three-point audit of the
        intended invariances.

  \item \textbf{The \Opoch{} Kernel is deterministic and verifiable.}
        Given a well-posed compiled finite contract $\Contract$, the kernel
        terminates in $\UNIQUE$, $\OMEGA$, or $\UNSAT$ and produces a
        replay-verifiable receipt chain.

  \item \textbf{MAPF benchmarks demonstrate practical utility.}
        On the specific warehouse benchmark described in
        \cref{sec:demonstration}, the kernel achieves
        $6.5\times$ speedup over an industrial baseline with
        formally verified zero collisions.

  \item \textbf{The derivation identifies its declared inputs and modeling boundaries.}
        The presentation makes explicit where external identification is
        invoked (Church--Turing at Step~3) and where later extensions would
        require broadening the model class (for example, ordered ledgers for
        non-commuting tests).
\end{enumerate}

% -------------------------------------------------------------------------
\subsection{The Vocabulary of Physical Law}
\label{sec:discussion:physics}

The derivation produces vocabulary, carrier $\Carrier$, test
algebra $\Del$, time $\Tim$, gauge group $\gauge$, fiber
$\fiber{\cdot}$, truth quotient $\TQ{\cdot}$, that is
structurally parallel to the vocabulary of mathematical physics.
This parallel reflects a shared concern with what can be distinguished by
finite operations.

However, ``vocabulary'' is not ``theory.'' A physical theory
specifies which tests $\Del_{\mathrm{phys}}$ nature actually
admits, what their costs are, and what symmetry group relates
equivalent descriptions. The \Opoch{} framework provides the
scaffold. Specifying $\Del_{\mathrm{phys}}$ remains an open frontier.
The derivation produces the \emph{form} of physical law without
determining its \emph{content}, which requires empirical input.

% -------------------------------------------------------------------------
\subsection{The Church--Turing Naming Convention}
\label{sec:discussion:utm}

Step~3 forces the test set $\Del$ to be maximally closed under
totality-preserving composition. This maximal closure is exactly the
class of total computable functions, a mathematical theorem within the
chosen formalization. The Church--Turing thesis
\citep{church1936, turing1936} enters as a \emph{naming convention} in the
sense that it identifies the informal phrase ``finite procedure'' with a
particular formal class.

\begin{remark}
If a hypercomputational model were discovered that exceeds
Turing-computability, Step~3 would need revision. The derivation
through Step~2 would survive intact, but the carrier $\Carrier$ would
expand. The remainder of the development would proceed analogously within the
enlarged carrier.
\end{remark}

% -------------------------------------------------------------------------
\subsection{The Closed-System Assumption}
\label{sec:discussion:closed}

Step~8 (feasibility shrinkage) assumes a closed system with a finite
budget~$B$. Claims whose verification cost exceeds any available budget
remain in $\OMEGA$. The kernel reports such claims as unresolved with
a minimal separator, but it cannot promote them to $\UNIQUE$ without
additional resources. This is a direct consequence of budgeted witnessability.

% -------------------------------------------------------------------------
\subsection{Minimax vs.\ Other Optimality Criteria}
\label{sec:discussion:minimax}

Step~18 uses prior-free worst-case (minimax) test selection. If a justified
prior~$p$ over test outcomes is available, average-case (Bayesian) test
selection is equally valid:
\[
  \tau^*_{\mathrm{Bayes}} = \argmin_{\tau \in \Del_q}
    \Bigl[\pi(\tau) + \sum_{a \in \mathrm{out}(\tau)} p(a \mid \tau)\, V(\fiber{a}, t + \pi(\tau);\, q)\Bigr]
\]
The choice between minimax and Bayesian is therefore not resolved by A0.
We use minimax because it introduces no prior beyond the compiled finite
contract, and it provides a well-defined worst-case guarantee under finite
budget.

% -------------------------------------------------------------------------
\subsection{Myhill--Nerode Implications}
\label{sec:discussion:myhill-nerode}

The Myhill--Nerode congruence $\MNcong$ (Step~15) provides a minimal
state representation. States with identical futures can be merged, reducing
memory and computation. The connection to bisimulation in process algebra
suggests that multi-kernel systems can be analyzed using tools from
concurrency theory.

% -------------------------------------------------------------------------
\subsection{Separator Geometry and Hardness}
\label{sec:discussion:geometry}

The separator metric $\SepDist$ (Step~16) provides a quantitative measure
of difficulty. Regions of high curvature $\SepCurv$ correspond to
phase transitions in difficulty, where small changes in the query produce
large changes in resolution cost. This geometry is analogous in spirit to the
Fisher-Rao metric on statistical manifolds, but it is defined over
deterministic truth classes and measured in computational cost.

% -------------------------------------------------------------------------
\subsection{Open Frontiers}
\label{sec:discussion:open}

\begin{enumerate}[label=(\arabic*)]
  \item \textbf{Specifying $\Del_{\mathrm{phys}}$.}
        Which families of physical experiments should be treated as primitive
        tests, and which symmetries should be treated as gauge, so that the
        resulting $\Del_{\mathrm{phys}}$ reproduces established empirical
        constraints? Can known symmetry structure be recovered from A0 plus a
        minimal empirical input specifying an admissible test algebra?

  \item \textbf{Non-commuting tests and ordered ledgers.}
        The current presentation adopts a commutative, order-insensitive
        recording model for independent tests. Extending the ledger to an
        ordered, order-sensitive structure would allow non-commuting
        observables and test disturbance while preserving witnessability.
        Characterizing the minimal such extension, and identifying which parts
        of the derivation remain canonical, is a primary frontier.

  \item \textbf{Energy as abstract cost vs.\ physical energy.}
        The derivation forces explicit cost accounting under finite budgets.
        Interpreting this cost as thermodynamic energy invokes additional
        physical assumptions. Clarifying the boundary between abstract resource
        measures and physical energetics, and specifying conditions under which
        the Landauer correspondence is appropriate, would strengthen the link
        to physics.

  \item \textbf{Lean/Coq mechanization.}
        The Z3 verification covers finite models only. Encoding the derivation
        in a proof assistant would enable machine-checked verification of
        infinite-domain properties and make the ``forced up to isomorphism''
        claims precise.

  \item \textbf{Causal memory architecture.}
        Extending the ledger to energy-based causal memory with decay,
        stratification, and wiring rules may enable long-horizon reasoning
        with bounded memory costs.

  \item \textbf{Scaling MAPF and mapping failure modes.}
        Testing on larger grids, more agents, and continuous-space variants is
        necessary to locate the empirical frontier where guarantees remain
        practical and where computational hardness dominates.

  \item \textbf{Separator geometry as a complexity lens.}
        Can $\SepCurv$ predict computational difficulty of problem classes?
        Is there a provable connection to circuit complexity or communication
        complexity under natural embeddings?

  \item \textbf{Self-hosting depth.}
        The current self-hosting is one level of replay verification.
        Understanding whether deeper reflective towers stabilize, and which
        additional assumptions are required for such towers to be meaningful,
        remains open.
\end{enumerate}
```

## sections/conclusion.tex

```latex
% =============================================================================
% Section: Conclusion
% =============================================================================

\section{Conclusion}
\label{sec:conclusion}

We have presented \Opoch{}, a framework that treats witnessability as the
criterion of meaning and uses it to derive an operational notion of structural
reality. Starting from nothingness, the only unfalsifiable state under this
criterion, we develop a 21-step chain that, within the paper's model class, is
canonical up to computable isomorphism.

The work makes four concrete contributions.

\begin{enumerate}[label=(\arabic*)]
  \item \textbf{A derivation that exposes its premises.}
        From $\noth$, applying A0 recursively yields three primitives,
        $\Del$ (tests), $\Pit$ (truth), and $\Tim$ (time), and a coherent
        apparatus for witnessable reasoning. Where the development depends on
        declared conventions, such as the Church--Turing identification at
        Step~3, this boundary is stated explicitly.

  \item \textbf{A deterministic kernel with constructive failure modes.}
        The \Opoch{} Kernel accepts a compiled finite contract $\Contract$ and
        terminates in $\UNIQUE$ with a witness, $\UNSAT$ with a counter-witness,
        or $\OMEGA$ with a minimal separator. Every run produces a SHA-256
        receipt chain that supports independent replay verification.

  \item \textbf{Verification, within scope.}
        We provide a three-point audit aimed at the derivation's invariances
        and verify selected algebraic properties on finite models via Z3.
        These checks are evidence about the stated model class, not a claim of
        mechanized proof over arbitrary infinities.

  \item \textbf{A worked instantiation on MAPF.}
        On the warehouse MAPF benchmark studied in this paper, the kernel
        yields a $6.5\times$ wall-clock speedup over the GreyOrange baseline
        with verified collision freedom and deadlock freedom.
\end{enumerate}

The guiding message is methodological rather than metaphysical. When meaning is
restricted to witnessable distinctions, many familiar structures, quotienting
by indistinguishability, invariance under untestable relabelings, and
budget-bounded decision procedures, become natural and, in the paper's formal
setting, unavoidable up to isomorphism. At the same time, the framework makes
its own limits explicit. Connecting the scaffold to the content of physics,
accommodating non-commuting tests via ordered ledgers, and mechanizing the
derivation in a proof assistant are clear next steps. By the framework's own
standard, those extensions remain at $\OMEGA$ until they are witnessed.
```
