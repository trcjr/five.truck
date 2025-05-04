#!/bin/bash
echo "🔍 Checking for EXIF metadata in content images..."

HAS_EXIF=0
while IFS= read -r file; do
  METADATA=$(exiftool "$file" | grep -v 'Directory\|File Name\|File Size\|File Type')
  if [[ -n "$METADATA" ]]; then
    echo "⚠️  Metadata found in: $file"
    echo "$METADATA"
    HAS_EXIF=1
  fi
done < <(find ./content -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \))

if [ "$HAS_EXIF" -eq 1 ]; then
  echo "❌ Aborting: Some images contain EXIF metadata."
  exit 1
else
  echo "✅ No EXIF metadata found."
fi