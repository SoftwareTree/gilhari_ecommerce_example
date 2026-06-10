#!/bin/bash

set -euo pipefail

# Ensure environment is set
source "$(dirname "$0")/setEnvironment.sh"

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$ROOT_DIR/config"

# Auto-detect environment and choose appropriate config
if [ -n "${DOCKER_CONTAINER:-}" ] || [ -f /.dockerenv ] || [ -n "${GILHARI_DOCKER_MODE:-}" ]; then
  CONFIG_FILE="$CONFIG_DIR/ecommerce_template_postgres_docker.config"
  echo "🐳 Docker environment detected, using Docker config"
else
  CONFIG_FILE="$CONFIG_DIR/ecommerce_template_postgres.config"
  echo "💻 Local environment detected, using local config"
fi

if [ ! -f "$CONFIG_FILE" ]; then
  echo "ERROR: Config not found: $CONFIG_FILE" >&2
  exit 1
fi

echo "Running JDX reverse engineering for PostgreSQL using $CONFIG_FILE"

# Run from the config directory (some JDX tools emit outputs relative to config location)
LOG_DIR="$ROOT_DIR/logs"
mkdir -p "$LOG_DIR"
(
  cd "$CONFIG_DIR"
  java -DJX_HOME="$JX_HOME" -Djdbc.drivers=org.postgresql.Driver -Djava.security.policy="$JX_HOME/config/java2.security.policy" \
    com.softwaretree.jdxtools.JDXSchema -reverseEng -IGNORE_WARNINGS "$(basename "$CONFIG_FILE")" \
    2>&1 | tee "$LOG_DIR/jdx_reverse.log"
)

echo "Reverse engineering complete. Organizing outputs..."

# Ensure target directories exist
mkdir -p "$(dirname "$0")/config" "$(dirname "$0")/src"

# Move .revjdx produced either in project root or in config/ into config/
find "$(dirname "$0")" -maxdepth 1 -type f -name "*.revjdx" -exec mv -f {} "$(dirname "$0")/config/" \;
find "$CONFIG_DIR" -maxdepth 1 -type f -name "*.revjdx" -exec mv -f {} "$(dirname "$0")/config/" \;

# Determine package root from config and move generated Java package tree into src/
PKG_DOTS=$(awk '/^JDX_OBJECT_MODEL_PACKAGE/{print $2}' "$CONFIG_FILE" | tr -d '\r')
if [ -n "$PKG_DOTS" ]; then
  PKG_PATH=${PKG_DOTS//./\/}
  TOP_DIR=$(printf "%s\n" "$PKG_PATH" | cut -d'/' -f1)
  if [ -d "$TOP_DIR" ]; then
    # Move top-level package directory (e.g., com) into src preserving structure
    rm -rf "$(dirname "$0")/src/$TOP_DIR"
    mv -f "$TOP_DIR" "$(dirname "$0")/src/"
  elif [ -d "$CONFIG_DIR/$TOP_DIR" ]; then
    rm -rf "$(dirname "$0")/src/$TOP_DIR"
    mv -f "$CONFIG_DIR/$TOP_DIR" "$(dirname "$0")/src/"
  fi
fi

# As a fallback, move any top-level *.java into src/
find "$(dirname "$0")" -maxdepth 1 -type f -name "*.java" -exec mv -f {} "$(dirname "$0")/src/" \;
find "$CONFIG_DIR" -maxdepth 1 -type f -name "*.java" -exec mv -f {} "$(dirname "$0")/src/" \;

echo "Outputs organized: .revjdx in config/, Java sources in src/."


