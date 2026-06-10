#!/bin/bash

# Smart reverse engineering script that automatically handles Docker vs Local environments
# This script ensures the .revjdx file always has the correct database URL

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$ROOT_DIR/config"

echo "🔧 Smart Reverse Engineering for Ecommerce Microservice"
echo "======================================================"

# Step 1: Run reverse engineering with local config
echo "📋 Step 1: Running reverse engineering with local config..."
source "$ROOT_DIR/setEnvironment.sh"

# Use local config for reverse engineering
LOCAL_CONFIG="$CONFIG_DIR/ecommerce_template_postgres.config"
if [ ! -f "$LOCAL_CONFIG" ]; then
  echo "ERROR: Local config not found: $LOCAL_CONFIG" >&2
  exit 1
fi

# Run reverse engineering
LOG_DIR="$ROOT_DIR/logs"
mkdir -p "$LOG_DIR"

(
  cd "$CONFIG_DIR"
  java -DJX_HOME="$JX_HOME" -Djdbc.drivers=org.postgresql.Driver -Djava.security.policy="$JX_HOME/config/java2.security.policy" \
    com.softwaretree.jdxtools.JDXSchema -reverseEng -IGNORE_WARNINGS "$(basename "$LOCAL_CONFIG")" \
    2>&1 | tee "$LOG_DIR/jdx_reverse.log"
)

echo "✅ Reverse engineering completed"

# Step 2: Organize outputs
echo "📁 Step 2: Organizing outputs..."

# Move .revjdx file to config/
find "$ROOT_DIR" -name "*.revjdx" -exec mv {} "$CONFIG_DIR/" \;
find "$CONFIG_DIR" -name "*.revjdx" -exec mv {} "$CONFIG_DIR/" \;

# Move Java sources to src/ with package structure
PKG_DOTS=$(awk '/^JDX_OBJECT_MODEL_PACKAGE/{print $2}' "$LOCAL_CONFIG" | tr -d '\r')
if [ -n "$PKG_DOTS" ]; then
  PKG_PATH=${PKG_DOTS//./\/}
  TOP_DIR=$(printf "%s\n" "$PKG_PATH" | cut -d'/' -f1)
  if [ -d "$TOP_DIR" ]; then
    rm -rf "$ROOT_DIR/src/$TOP_DIR"
    mv -f "$TOP_DIR" "$ROOT_DIR/src/"
  elif [ -d "$CONFIG_DIR/$TOP_DIR" ]; then
    rm -rf "$ROOT_DIR/src/$TOP_DIR"
    mv -f "$CONFIG_DIR/$TOP_DIR" "$ROOT_DIR/src/"
  fi
fi

# Fallback: move any top-level *.java into src/
find "$ROOT_DIR" -maxdepth 1 -type f -name "*.java" -exec mv -f {} "$ROOT_DIR/src/" \;
find "$CONFIG_DIR" -maxdepth 1 -type f -name "*.java" -exec mv -f {} "$ROOT_DIR/src/" \;

echo "✅ Outputs organized: .revjdx in config/, Java sources in src/"

# Step 3: Create Docker-compatible .revjdx file
echo "🐳 Step 3: Creating Docker-compatible .revjdx file..."

REVJDX_FILE="$CONFIG_DIR/ecommerce_template_postgres.config.revjdx"
if [ -f "$REVJDX_FILE" ]; then
  # Create a Docker version with host.docker.internal
  DOCKER_REVJDX="$CONFIG_DIR/ecommerce_template_postgres_docker.config.revjdx"
  
  # Copy the original and replace the database URL
  cp "$REVJDX_FILE" "$DOCKER_REVJDX"
  
  # Replace 127.0.0.1 with host.docker.internal for Docker compatibility
  if command -v sed >/dev/null 2>&1; then
    sed -i.bak 's|127\.0\.0\.1|host.docker.internal|g' "$DOCKER_REVJDX"
    rm -f "$DOCKER_REVJDX.bak"
  else
    # Fallback for systems without sed
    python3 -c "
import re
with open('$DOCKER_REVJDX', 'r') as f:
    content = f.read()
content = re.sub(r'127\.0\.0\.1', 'host.docker.internal', content)
with open('$DOCKER_REVJDX', 'w') as f:
    f.write(content)
"
  fi
  
  echo "✅ Created Docker-compatible .revjdx: $DOCKER_REVJDX"
else
  echo "⚠️  Warning: .revjdx file not found, skipping Docker version creation"
fi

# Step 4: Update gilhari_service.config to use the correct .revjdx file
echo "⚙️  Step 4: Updating service configuration..."

SERVICE_CONFIG="$ROOT_DIR/gilhari_service.config"
if [ -f "$SERVICE_CONFIG" ]; then
  # Update the service config to use the Docker version
  if command -v sed >/dev/null 2>&1; then
    sed -i.bak 's|ecommerce_template_postgres\.config\.revjdx|ecommerce_template_postgres_docker.config.revjdx|g' "$SERVICE_CONFIG"
    rm -f "$SERVICE_CONFIG.bak"
  else
    python3 -c "
import re
with open('$SERVICE_CONFIG', 'r') as f:
    content = f.read()
content = re.sub(r'ecommerce_template_postgres\.config\.revjdx', 'ecommerce_template_postgres_docker.config.revjdx', content)
with open('$SERVICE_CONFIG', 'w') as f:
    f.write(content)
"
  fi
  
  echo "✅ Updated service config to use Docker-compatible .revjdx"
else
  echo "⚠️  Warning: Service config not found"
fi

echo ""
echo "🎉 Smart Reverse Engineering Complete!"
echo "====================================="
echo "📁 Generated files:"
echo "   • Local .revjdx:    $REVJDX_FILE"
echo "   • Docker .revjdx:   $DOCKER_REVJDX"
echo "   • Java sources:     $ROOT_DIR/src/"
echo "   • Service config:   $SERVICE_CONFIG"
echo ""
echo "🚀 Ready for compilation and Docker build!"
