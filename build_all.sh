#!/bin/bash

# Complete build script for ecommerce microservice
# Handles reverse engineering, compilation, and Docker build automatically

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🚀 Complete Ecommerce Microservice Build"
echo "========================================"

# Step 1: Smart Reverse Engineering
echo "📋 Step 1: Running smart reverse engineering..."
if [ -f "$ROOT_DIR/smart_reverse_engineer.sh" ]; then
  "$ROOT_DIR/smart_reverse_engineer.sh"
else
  echo "⚠️  Smart reverse engineer not found, using standard method..."
  "$ROOT_DIR/reverse_engineer.sh"
fi

# Step 2: Compile Java Classes
echo "🔨 Step 2: Compiling Java classes..."
"$ROOT_DIR/compile.sh"

# Step 3: Build Docker Image
echo "🐳 Step 3: Building Docker image..."
docker build -t gilhari_ecommerce:1.0 .

# Step 4: Stop old container and start new one
echo "🔄 Step 4: Updating running container..."
docker stop gilhari_ecommerce_container 2>/dev/null || echo "No existing container to stop"
docker rm gilhari_ecommerce_container 2>/dev/null || echo "No existing container to remove"

echo "🚀 Step 5: Starting new container..."
docker run -d --name gilhari_ecommerce_container -p 8081:8081 gilhari_ecommerce:1.0

# Step 6: Wait and test
echo "⏳ Step 6: Waiting for service to start..."
sleep 8

echo "🧪 Step 7: Testing microservice..."
if curl -s http://localhost:8081/gilhari/v1/getObjectModelSummary/now >/dev/null; then
  echo "✅ Microservice is running successfully!"
  echo ""
  echo "🎉 Build Complete!"
  echo "=================="
  echo "🌐 Local URL:     http://localhost:8081/gilhari/v1/"
  echo "🐳 Container:    gilhari_ecommerce_container"
  echo "📊 Object Model:  http://localhost:8081/gilhari/v1/getObjectModelSummary/now"
  echo ""
  echo "🔧 Database URLs:"
  echo "   • Local:       127.0.0.1:5432/ecommerce"
  echo "   • Docker:      host.docker.internal:5432/ecommerce"
else
  echo "❌ Microservice failed to start. Check logs:"
  echo "   docker logs gilhari_ecommerce_container"
  exit 1
fi
