#!/bin/bash
echo "🔍 Checking for EXIF metadata in content images..."

STRIP_MODE=0

for arg in "$@"; do
  if [[ "$arg" == "--strip" ]]; then
    STRIP_MODE=1
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
  METADATA=$(exiftool "$file" | grep -v 'Directory\|File Name\|File Size\|File Type')
  if [[ -n "$METADATA" ]]; then
    echo "⚠️  Metadata found in: $file"
    echo "$METADATA"
    HAS_EXIF=1
    if [[ "$STRIP_MODE" -eq 1 ]]; then
      echo "🧹 Removing EXIF metadata from: $file"
      exiftool -all= -overwrite_original "$file"
    fi
  fi
done < <(find ./content -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \))

if [[ "$STRIP_MODE" -eq 0 ]]; then
  if [ "$HAS_EXIF" -eq 1 ]; then
    echo "❌ Aborting: Some images contain EXIF metadata."
    exit 1
  else
    echo "✅ No EXIF metadata found."
  fi
else
  echo "✅ EXIF metadata removal complete."
fi