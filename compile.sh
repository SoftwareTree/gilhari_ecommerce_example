#!/bin/bash

set -euo pipefail

# Ensure environment is set
source "$(dirname "$0")/setEnvironment.sh"

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="$ROOT_DIR/src"
BIN_DIR="$ROOT_DIR/bin"

mkdir -p "$BIN_DIR"

if [ ! -d "$SRC_DIR" ]; then
  echo "ERROR: Source directory not found: $SRC_DIR" >&2
  exit 1
fi

echo "Compiling Java sources from $SRC_DIR to $BIN_DIR"

# Compile all Java sources preserving package structure
find "$SRC_DIR" -type f -name "*.java" > "$ROOT_DIR/.sources.list"

if [ ! -s "$ROOT_DIR/.sources.list" ]; then
  echo "No Java sources found to compile." >&2
  rm -f "$ROOT_DIR/.sources.list"
  exit 1
fi

javac -cp "$CLASSPATH" -d "$BIN_DIR" -target 1.8 -source 1.8 @"$ROOT_DIR/.sources.list"

rm -f "$ROOT_DIR/.sources.list"

echo "Compilation complete. Class files are in $BIN_DIR"


