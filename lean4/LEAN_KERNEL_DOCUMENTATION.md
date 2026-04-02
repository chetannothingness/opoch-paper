# Opoch Lean Kernel -- Complete Documentation

**325 files. 1265 theorems. 1 axiom (A0*). 0 sorry. Build: GREEN.**

## The Chain
bottom = I_max -> A0* -> Pi -> U = Fix(Pi) -> U_ind -> (b,M) -> (u,J) -> C_self(x)=(b_x,M_x) -> x = Q(U)

## Self-Reading Graph
L = {(x, eta, J) | eta = DU_ind(x), J = Omega^{-1}eta}. Questions are partial coordinates. Answers are unique completions.

## 24 Directories

| # | Directory | Files | Theorems | Proves |
|---|-----------|-------|----------|--------|
| 1 | Manifest/ | 2 | 2 | Nothingness + A0* |
| 2 | Foundations/ | 42 | 186 | N1-N5, W1-W8, chi, K, Psi, algebra |
| 3 | Algebra/ | 8 | 69 | Truth quotient, gauge, time, entropy |
| 4 | Control/ | 4 | 36 | Bellman, regimes |
| 5 | Execution/ | 5 | 43 | Self-hosting, consciousness |
| 6 | Geometry/ | 8 | 31 | n=3, Kahler J^2=-I |
| 7 | OperatorAlgebra/ | 4 | 24 | C*-algebra, Born rule |
| 8 | Physics/ | 2 | 13 | Split law, predictions |
| 9 | QuantitativeSeed/ | 38 | 165 | Seed, all numbers |
| 10 | Complexity/ | 49 | 178 | P=NP |
| 11 | MAPF/ | 45 | 90 | Intrinsic polytime |
| 12 | Manifestability/ | 10 | 49 | Query compiler |
| 13 | Autocompilation/ | 17 | 49 | everything_real_solves_itself |
| 14 | Bridge/ | 1 | 1 | Sector realization |
| 15 | Manifestation/ | 11 | 34 | Event law |
| 16 | IndistinguishabilityEnergy/ | 17 | 59 | Latent energy |
| 17 | InstantQuestion/ | 9 | 36 | Projector law |
| 18 | FinalSourceCode/ | 11 | 57 | Consciousness-code, primal-dual |
| 19 | SourceCode/ | 7 | 34 | Parametric model, initiality, transport |
| 20 | InstantKernel/ | 5 | 14 | Normalizer NF, ARC normal form |
| 21 | Realizations/ | 3 | 18 | RH, P=NP, ARC-AGI as transport |
| 22 | Riemann/ | 12 | 34 | RH framework, 0 sorry |
| 23 | SelfReadingGraph/ | 9 | 37 | Self-reading graph L |
| 24 | Audit/ | 5 | 6 | Verification |
| | Basic.lean | 1 | 0 | Utility |
| **Total** | | **325** | **1265** | |

## Build
```
cd lean4 && lake build
```
