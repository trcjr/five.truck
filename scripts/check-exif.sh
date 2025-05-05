#!/bin/bash
# Usage:
#   ./scripts/check-exif.sh [--strip] [--ci]
#   --strip : remove EXIF metadata from matching files
#   --ci    : output tabular summary for CI environments

echo "🔍 Checking for EXIF metadata in content images..."

STRIP_MODE=0
CI_MODE=0

for arg in "$@"; do
  if [[ "$arg" == "--strip" ]]; then
    STRIP_MODE=1
  elif [[ "$arg" == "--ci" ]]; then
    CI_MODE=1
  fi
done

if [[ "$STRIP" == "1" ]]; then
  STRIP_MODE=1
fi

if [[ "$STRIP_MODE" -eq 1 ]]; then
  echo "✂️  Strip mode enabled: EXIF metadata will be removed from matching files."
fi

HAS_EXIF=0
while IFS= read -r file; do
  echo ""
  echo "🖼️  Scanning file: $file"
  METADATA=$(exiftool "$file")

  # Categories
  HIGH=$(echo "$METADATA" | grep -E 'GPS|Serial|Owner|Latitude|Longitude')
  MEDIUM=$(echo "$METADATA" | grep -E 'Make|Model|Software|Create Date|Modify Date')
  LOW=$(echo "$METADATA" | grep -E 'Image Width|Image Height|MIME Type|Encoding Process|Y Cb Cr Sub Sampling')

  if [[ -n "$HIGH" || -n "$MEDIUM" ]]; then
    HAS_EXIF=1  # Set only when medium or high risk metadata is detected

    if [[ "$CI_MODE" -eq 1 ]]; then
      echo "Level | Field | Value"
      echo "------|-------|------"
      echo "$HIGH" | sed 's/^\(.*\) *: */🔴 High | \1 | /'
      echo "$MEDIUM" | sed 's/^\(.*\) *: */🟠 Medium | \1 | /'
      echo "$LOW" | sed 's/^\(.*\) *: */🟢 Low | \1 | /'
    else
      [[ -n "$HIGH" ]] && echo "🔴 High Risk Metadata:" && echo "$HIGH"
      [[ -n "$MEDIUM" ]] && echo "🟠 Medium Risk Metadata:" && echo "$MEDIUM"
      [[ -n "$LOW" ]] && echo "🟢 Low Risk Metadata:" && echo "$LOW"
    fi

    if [[ "$STRIP_MODE" -eq 1 ]]; then
      echo "🧹 Removing EXIF metadata from: $file"
      exiftool -all= -overwrite_original "$file"
    fi
  else
    echo "✅ No significant EXIF metadata found."
  fi
done < <(find ./content -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \))

if [[ "$STRIP_MODE" -eq 0 ]]; then
  if [ "$HAS_EXIF" -eq 1 ]; then
    echo ""
    echo "❌ Aborting: Some images contain EXIF metadata."
    exit 1
  else
    echo "✅ No EXIF metadata found."
  fi
else
  echo "✅ EXIF metadata removal complete."
fi