#!/bin/bash
# Full build pipeline for Opoch paper
set -e

cd "$(dirname "$0")/.."

echo "=== Opoch Paper Build Pipeline ==="
echo ""

# Step 1: First LaTeX pass
echo "[1/4] First LaTeX pass..."
pdflatex -interaction=nonstopmode -halt-on-error main.tex > /dev/null 2>&1

# Step 2: BibTeX
echo "[2/4] BibTeX pass..."
bibtex main > /dev/null 2>&1

# Step 3: Second LaTeX pass (resolve references)
echo "[3/4] Second LaTeX pass..."
pdflatex -interaction=nonstopmode -halt-on-error main.tex > /dev/null 2>&1

# Step 4: Third LaTeX pass (final)
echo "[4/4] Final LaTeX pass..."
pdflatex -interaction=nonstopmode -halt-on-error main.tex > /dev/null 2>&1

echo ""
echo "=== Build complete: main.pdf ==="
echo "Pages: $(pdfinfo main.pdf 2>/dev/null | grep Pages | awk '{print $2}' || echo 'unknown')"
echo ""

# Check for warnings
WARNINGS=$(grep -c "Warning" main.log 2>/dev/null || echo "0")
UNDEFINED=$(grep -c "undefined" main.log 2>/dev/null || echo "0")
echo "Warnings: $WARNINGS"
echo "Undefined references: $UNDEFINED"

if [ "$UNDEFINED" -gt 0 ]; then
  echo ""
  echo "Undefined references:"
  grep "undefined" main.log 2>/dev/null | head -10
fi
