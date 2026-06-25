#!/usr/bin/env bash

set -e

# this matters, path to whisper..
WHISPER_HOME="/home/jaideep/whisper.cpp"

MODEL="$WHISPER_HOME/models/ggml-small-q8_0.bin"
WHISPER="$WHISPER_HOME/build/bin/whisper-cli"

if [ $# -ne 1 ]; then
    echo "Usage: totext <audio-file>"
    exit 1
fi

INPUT="$1"

if [ ! -f "$INPUT" ]; then
    echo "Error: file not found: $INPUT"
    exit 1
fi

BASENAME="$(basename "$INPUT")"
NAME="${BASENAME%.*}"
OUT="${NAME}.txt"

START=$SECONDS

"$WHISPER" \
    -m "$MODEL" \
    --beam-size 1 \
    --best-of 1 \
    --temperature 0 \
    "$INPUT" > "$OUT"

echo "Created: $OUT"
echo "Time taken: $((SECONDS - START))s"
