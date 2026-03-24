# Contributing to the Opoch Paper

## Branch Naming

- `feat/description` — new content, sections, figures
- `fix/description` — corrections, typos, proof fixes
- `refactor/description` — restructuring without content changes
- `docs/description` — README, comments, non-paper docs

## Workflow

1. Create a branch from `main`
2. Make your changes
3. Build and verify (see checks below)
4. Open a PR with a description of what changed and why
5. Request review from at least one co-author

## Required Checks Before Pushing

### 1. Full build must pass

```bash
make
```

Zero errors, zero undefined references. Check `main.log` for any `\ref` warnings.

### 2. Z3 proofs must pass (9/9)

```bash
scripts/z3/run-all.sh
```

Run this after any changes to axioms, derivation steps, or formal claims.

### 3. Citations must validate

```bash
./scripts/validate-refs.sh
```

## Commit Guidelines

- One logical change per commit when possible
- Use clear commit messages: `fix: correct Step 14 forcing argument`, `feat: add lattice QCD comparison to experiments`
- When editing a section, keep changes scoped to that section's file

## Page Count

The paper is ~78 pages. If your change significantly affects page count (more than +/- 2 pages), discuss with co-authors before merging.

## Content Rules

- Every claim needs a witness or explicit gap — never guess
- A0 is the only axiom. Do not introduce additional axioms
- Church-Turing thesis is corroboration, not a premise
- GreyOrange references stay anonymized as "B0" / "industrial baseline"
- Follow the label conventions in CLAUDE.md (`sec:`, `thm:`, `def:`, etc.)

## Review Checklist

- [ ] `make` builds with zero errors
- [ ] `scripts/z3/run-all.sh` — 20/20 pass
- [ ] No undefined `\ref` warnings in `main.log`
- [ ] `./scripts/validate-refs.sh` passes
- [ ] Page count within expected range (~78pp)
- [ ] New labels follow naming conventions
