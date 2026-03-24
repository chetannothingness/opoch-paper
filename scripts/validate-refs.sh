#!/bin/bash
# Validate that all \cite{} commands have matching refs.bib entries
set -e

cd "$(dirname "$0")/.."

echo "=== Citation Validation ==="
echo ""

# Extract all citation keys from .tex files
CITED=$(grep -roh '\\cite[tp]*{[^}]*}' sections/ appendices/ main.tex 2>/dev/null \
  | sed 's/\\cite[tp]*{//g; s/}//g' \
  | tr ',' '\n' \
  | sed 's/^ *//; s/ *$//' \
  | sort -u)

# Extract all bib entry keys from refs.bib
DEFINED=$(grep '^@' refs.bib \
  | sed 's/@[a-zA-Z]*{//; s/,$//' \
  | sort -u)

echo "Citations found in .tex files:"
echo "$CITED" | wc -l | tr -d ' '
echo ""

echo "Entries in refs.bib:"
echo "$DEFINED" | wc -l | tr -d ' '
echo ""

# Find missing
MISSING=""
for key in $CITED; do
  if ! echo "$DEFINED" | grep -q "^${key}$"; then
    MISSING="$MISSING $key"
  fi
done

if [ -z "$MISSING" ]; then
  echo "All citations resolved."
else
  echo "MISSING citations (in .tex but not in refs.bib):"
  for key in $MISSING; do
    echo "  - $key"
  done
  exit 1
fi

# Find unused
echo ""
echo "Unused bib entries (in refs.bib but not cited):"
UNUSED=0
for key in $DEFINED; do
  if ! echo "$CITED" | grep -q "^${key}$"; then
    echo "  - $key"
    UNUSED=$((UNUSED + 1))
  fi
done

if [ "$UNUSED" -eq 0 ]; then
  echo "  (none)"
fi

echo ""
echo "=== Validation complete ==="
