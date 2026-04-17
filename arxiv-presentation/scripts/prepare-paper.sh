#!/usr/bin/env bash
# prepare-paper.sh — Extract an arxiv paper and prepare figures for presentation
#
# Usage:
#   prepare-paper.sh <input> <output-dir>
#
# <input>: path to a .tar.gz file, or an arxiv ID (e.g., 2603.15569)
# <output-dir>: directory where source/ and figures/ will be created
#
# Outputs:
#   output-dir/source/       — extracted LaTeX source files
#   output-dir/figures/      — all figures converted to PNG
#   output-dir/manifest.txt  — summary: main tex file, figure list with captions

set -euo pipefail

INPUT="$1"
OUTDIR="$2"

mkdir -p "$OUTDIR/source" "$OUTDIR/figures"

# --- Step 1: Resolve input (file path or arxiv ID) ---
if [[ -f "$INPUT" ]]; then
  TARBALL="$INPUT"
elif [[ "$INPUT" =~ ^[0-9]{4}\.[0-9]{4,5}(v[0-9]+)?$ ]]; then
  echo "Downloading arxiv paper $INPUT..."
  TARBALL="$OUTDIR/paper.tar.gz"
  wget -q "https://arxiv.org/e-print/$INPUT" -O "$TARBALL"
  echo "Downloaded to $TARBALL"
else
  echo "Error: Input must be a .tar.gz file path or an arxiv ID (e.g., 2603.15569)" >&2
  exit 1
fi

# --- Step 2: Extract ---
echo "Extracting..."
tar xzf "$TARBALL" -C "$OUTDIR/source" 2>/dev/null || {
  # Some arxiv papers are gzipped single files, not tarballs
  gunzip -c "$TARBALL" > "$OUTDIR/source/main.tex" 2>/dev/null || {
    echo "Error: Could not extract $TARBALL" >&2; exit 1
  }
}
echo "Extracted to $OUTDIR/source/"

# --- Step 3: Find main tex file ---
MAIN_TEX=""
if [[ -f "$OUTDIR/source/00README.json" ]]; then
  MAIN_TEX=$(python3 -c "
import json, sys
with open('$OUTDIR/source/00README.json') as f:
    d = json.load(f)
for s in d.get('sources', []):
    if s.get('usage') == 'toplevel':
        print(s['filename'])
        break
" 2>/dev/null)
fi

if [[ -z "$MAIN_TEX" ]]; then
  # Fallback: look for common main file names
  for candidate in main.tex paper.tex article.tex; do
    if [[ -f "$OUTDIR/source/$candidate" ]]; then
      MAIN_TEX="$candidate"
      break
    fi
  done
fi

if [[ -z "$MAIN_TEX" ]]; then
  # Last resort: find .tex file containing \begin{document}
  MAIN_TEX=$(grep -rl '\\begin{document}' "$OUTDIR/source/" --include="*.tex" 2>/dev/null | head -1 | sed "s|$OUTDIR/source/||")
fi

echo "Main tex file: ${MAIN_TEX:-NOT FOUND}"

# --- Step 4: Find and convert figures ---
FIG_COUNT=0
CONVERTED=0

# Find all image files
while IFS= read -r -d '' figpath; do
  ext="${figpath##*.}"
  ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
  basename_noext=$(basename "$figpath" ".$ext")
  # Create a flat name to avoid collisions (replace / with __)
  relpath="${figpath#$OUTDIR/source/}"
  flatname=$(echo "${relpath%.*}" | tr '/' '__')

  case "$ext_lower" in
    png|jpg|jpeg|svg|webp)
      cp "$figpath" "$OUTDIR/figures/${flatname}.${ext_lower}"
      FIG_COUNT=$((FIG_COUNT + 1))
      ;;
    pdf)
      if command -v pdftoppm &>/dev/null; then
        pdftoppm -png -r 300 -singlefile "$figpath" "$OUTDIR/figures/${flatname}" 2>/dev/null && {
          CONVERTED=$((CONVERTED + 1))
          FIG_COUNT=$((FIG_COUNT + 1))
        }
      else
        echo "Warning: pdftoppm not found, skipping PDF: $figpath" >&2
      fi
      ;;
  esac
done < <(find "$OUTDIR/source" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.pdf" -o -iname "*.svg" -o -iname "*.webp" \) -print0)

echo "Figures found: $FIG_COUNT ($CONVERTED converted from PDF)"

# --- Step 5: Extract figure captions from LaTeX ---
echo ""
echo "=== Figure captions ==="
grep -r '\\caption' "$OUTDIR/source/" --include="*.tex" 2>/dev/null | head -30 || echo "(none found)"

# --- Step 6: Write manifest ---
{
  echo "MAIN_TEX=$MAIN_TEX"
  echo "FIGURE_COUNT=$FIG_COUNT"
  echo "PDF_CONVERTED=$CONVERTED"
  echo ""
  echo "=== Figures ==="
  ls -1 "$OUTDIR/figures/" 2>/dev/null
  echo ""
  echo "=== Source files ==="
  find "$OUTDIR/source" -name "*.tex" -type f | sort | sed "s|$OUTDIR/source/||"
} > "$OUTDIR/manifest.txt"

echo ""
echo "Done. Manifest written to $OUTDIR/manifest.txt"
echo "Output directory: $OUTDIR"
