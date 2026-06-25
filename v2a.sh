#!/usr/bin/env bash

set -e

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Usage: v2a <input-video> [output.wav]"
  exit 1
fi

INPUT="$1"

if [ ! -f "$INPUT" ]; then
  echo "Error: file not found: $INPUT"
  exit 1
fi

if [ $# -eq 2 ]; then
  OUTPUT="$2"
else
  BASENAME="$(basename "$INPUT")"
  NAME="${BASENAME%.*}"
  OUTPUT="${NAME}.wav"
fi

ffmpeg -y \
  -i "$INPUT" \
  -vn \
  -ac 1 \
  -ar 16000 \
  -sample_fmt s16 \
  "$OUTPUT"

echo "Created: $OUTPUT"
