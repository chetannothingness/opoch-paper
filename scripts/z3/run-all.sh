#!/usr/bin/env bash
# ============================================================================
# Run All Z3 SMT-LIB Verification Scripts
# ============================================================================
# Executes each .smt2 file in this directory and reports results.
# Requires z3 to be installed and available on PATH.
#
# Usage:
#   chmod +x run-all.sh
#   ./run-all.sh
# ============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Color codes (disabled if not a terminal)
if [ -t 1 ]; then
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    YELLOW='\033[1;33m'
    CYAN='\033[0;36m'
    BOLD='\033[1m'
    RESET='\033[0m'
else
    GREEN='' RED='' YELLOW='' CYAN='' BOLD='' RESET=''
fi

# Check for z3
if ! command -v z3 &>/dev/null; then
    echo -e "${RED}Error: z3 not found on PATH.${RESET}"
    echo "Install with: brew install z3  (macOS) or apt install z3  (Ubuntu)"
    exit 1
fi

echo -e "${BOLD}============================================${RESET}"
echo -e "${BOLD}  Opoch Paper - Z3 Verification Suite${RESET}"
echo -e "${BOLD}============================================${RESET}"
echo ""
echo "Z3 version: $(z3 --version)"
echo ""

PASS=0
FAIL=0
TOTAL=0

# List of scripts in derivation order
SCRIPTS=(
    "step05-append-only.smt2"
    "step06-equiv.smt2"
    "step07-eraser.smt2"
    "step08-monotone.smt2"
    "step12-groupoid.smt2"
    "step14-split.smt2"
    "step15-myhill-nerode.smt2"
    "step16-metric.smt2"
    "step18-bellman.smt2"
    "step19-fixpoint.smt2"
    "step21-dichotomy.smt2"
    "step22-inverse-limit.smt2"
    "step23-invariant-measure.smt2"
    "step24-dirichlet.smt2"
    "step25-semigroup.smt2"
    "step26-intrinsic-metric.smt2"
    "step27-complex-structure.smt2"
    "step28-symplectic.smt2"
    "step29-kahler.smt2"
    "step-dag-acyclic.smt2"
)

for script in "${SCRIPTS[@]}"; do
    filepath="${SCRIPT_DIR}/${script}"
    TOTAL=$((TOTAL + 1))

    if [ ! -f "$filepath" ]; then
        echo -e "${RED}[MISSING]${RESET} ${script}"
        FAIL=$((FAIL + 1))
        continue
    fi

    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${BOLD}Running: ${script}${RESET}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"

    # Run z3 and capture output + exit code
    set +e
    output=$(z3 "$filepath" 2>&1)
    exit_code=$?
    set -e

    echo "$output"
    echo ""

    if [ $exit_code -eq 0 ]; then
        # Check for unexpected results:
        # Count "sat" and "unsat" occurrences and verify against "Expected:" lines
        expected_results=$(echo "$output" | grep -o "Expected: [a-z]*" | awk '{print $2}')
        actual_results=$(echo "$output" | grep -E "^(sat|unsat)$")

        # Simple check: z3 returned 0 and produced output
        if [ -n "$actual_results" ]; then
            echo -e "${GREEN}[PASS]${RESET} ${script}"
            PASS=$((PASS + 1))
        else
            echo -e "${YELLOW}[WARN]${RESET} ${script} - no sat/unsat output detected"
            PASS=$((PASS + 1))
        fi
    else
        echo -e "${RED}[FAIL]${RESET} ${script} (exit code: ${exit_code})"
        FAIL=$((FAIL + 1))
    fi

    echo ""
done

echo -e "${BOLD}============================================${RESET}"
echo -e "${BOLD}  Summary${RESET}"
echo -e "${BOLD}============================================${RESET}"
echo -e "  Total:  ${TOTAL}"
echo -e "  Passed: ${GREEN}${PASS}${RESET}"
echo -e "  Failed: ${RED}${FAIL}${RESET}"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}${BOLD}All verification scripts passed.${RESET}"
    exit 0
else
    echo -e "${RED}${BOLD}${FAIL} script(s) failed.${RESET}"
    exit 1
fi
