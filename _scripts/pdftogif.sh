#!/usr/bin/env bash
#
# pdftogif.sh
# Convert a multi-page PDF into:
#   - an animated GIF (all pages)
#   - a PNG preview (first page)
#
# Requires: ghostscript (gs), ImageMagick (convert)
#
# Example:
#   ./pdftogif.sh slides.pdf MyPresentation
#

set -euo pipefail

# -----------------------
# configuration defaults
# -----------------------
DPI=48
GIF_DELAY=100   # centiseconds (100 = 1s per frame)

# -----------------------
# helpers
# -----------------------
usage() {
  cat <<EOF
Usage:
  $(basename "$0") <input.pdf> <output_name>

Creates:
  <output_name>.gif   Animated GIF of all pages
  <output_name>.png   PNG preview of the first page

Example:
  cd images/pubpic
  ../../_scripts/pdftogif.sh \\
    ../../assets/presentations/B_Kundu-PyHEP23_Cppyy_CppInterOp.pdf \\
    BKPyHEPDev2023

Requirements:
  - ghostscript (gs)
  - ImageMagick (convert)
EOF
}

die() {
  echo "Error: $*" >&2
  exit 1
}

check_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "'$1' is not installed or not in PATH"
}

# -----------------------
# argument parsing
# -----------------------
if [[ $# -ne 2 ]]; then
  usage
  exit 1
fi

SLIDES_PDF="$1"
PRES_ID="$2"

[[ -f "$SLIDES_PDF" ]] || die "Input PDF not found: $SLIDES_PDF"

# -----------------------
# dependency checks
# -----------------------
check_cmd gs
check_cmd convert

# -----------------------
# temp working directory
# -----------------------
WORK_DIR="$(mktemp -d "${TMPDIR:-/tmp}/pdftogif.XXXXXX")"

cleanup() {
  rm -rf "$WORK_DIR"
}
trap cleanup EXIT

# -----------------------
# PDF → PNGs
# -----------------------
echo "Rendering PDF pages to PNGs…"

gs -dSAFER -dQUIET -dNOPAUSE -dBATCH \
   -sDEVICE=pngalpha \
   -sOutputFile="$WORK_DIR/%03d.png" \
   -r"$DPI" \
   -dTextAlphaBits=4 \
   -dGraphicsAlphaBits=4 \
   -dUseCIEColor \
   -dUseTrimBox \
   "$SLIDES_PDF"

# -----------------------
# PNGs → GIF
# -----------------------
echo "Creating animated GIF: ${PRES_ID}.gif"

convert -delay "$GIF_DELAY" \
        "$WORK_DIR"/*.png \
        "${PRES_ID}.gif"

# -----------------------
# first page preview
# -----------------------
cp "$WORK_DIR/001.png" "${PRES_ID}.png"

# -----------------------
# done
# -----------------------
echo "Done."
echo "  → ${PRES_ID}.gif"
echo "  → ${PRES_ID}.png"
