# videototext
download a video / audio


# Whisper.cpp Setup Guide (Ubuntu)

## Step 1: Install build dependencies
```bash
sudo apt update
sudo apt install -y git cmake build-essential ffmpeg
```

## Step 2: Clone whisper.cpp
```bash
git clone https://github.com/ggml-org/whisper.cpp.git
cd whisper.cpp
```

## Step 3: Build whisper.cpp
```bash
cmake -B build
cmake --build build -j$(nproc)
```

## Step 4: Download a Whisper model
```bash
./models/download-ggml-model.sh small-q8_0
```

Or choose another model:

```bash
./models/download-ggml-model.sh base-q8_0
./models/download-ggml-model.sh tiny-q8_0
./models/download-ggml-model.sh medium-q5_0
```

## Step 5: Verify the build
```bash
./build/bin/whisper-cli --help
```

## Step 6: Create a global launcher
```bash
sudo nano /usr/local/bin/totext
```

Paste:

```bash
#!/usr/bin/env bash

set -e

WHISPER_HOME="$HOME/whisper.cpp"

MODEL="$WHISPER_HOME/models/ggml-small-q8_0.bin"
WHISPER="$WHISPER_HOME/build/bin/whisper-cli"

if [ $# -ne 1 ]; then
    echo "Usage: totext <audio-file>"
    exit 1
fi

INPUT="$1"

BASENAME="$(basename "$INPUT")"
OUT="${BASENAME%.*}.txt"

"$WHISPER" \
    -m "$MODEL" \
    --beam-size 1 \
    --best-of 1 \
    --temperature 0 \
    "$INPUT" > "$OUT"

echo "Created: $OUT"
```

## Step 7: Make the script executable
```bash
sudo chmod +x /usr/local/bin/totext
```

## Step 8: Test the installation
```bash
totext sample.mp3
```

Output:

```
sample.txt
```

## Step 9: (Optional) Install libraries globally

Only needed if your build does not embed an RPATH.

```bash
sudo tee /etc/ld.so.conf.d/whisper.conf >/dev/null <<EOF
$HOME/whisper.cpp/build/src
$HOME/whisper.cpp/build/ggml/src
EOF

sudo ldconfig
```

## Step 10: Verify library loading
```bash
ldd ~/whisper.cpp/build/bin/whisper-cli
```

There should be **no** `not found` entries.

## Done!

You can now transcribe from anywhere:

```bash
cd ~/Downloads
totext meeting.mp3
```
