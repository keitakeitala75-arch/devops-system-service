#!/bin/bash
# Monitoring script for devops-system-service
# Checks application health, container metrics, and host resources.

set -euo pipefail

APP_URL="${1:-http://localhost:5000}"
CONTAINER_NAME="devops-container"

echo "=== DevOps Service Monitoring Report ==="
echo "Timestamp: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
echo

# 1. Health Endpoint Verification
echo "[1/5] Checking application health at ${APP_URL}/health..."
if HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "${APP_URL}/health"); then
    if [ "$HTTP_CODE" -eq 200 ]; then
        echo "  [OK] Health check passed (HTTP 200)"
        curl -s "${APP_URL}/health"
        echo
    else
        echo "  [WARN] Health check returned HTTP status: $HTTP_CODE"
    fi
else
    echo "  [ERROR] Failed to connect to ${APP_URL}/health"
fi
echo

# 2. Service Info Verification
echo "[2/5] Checking service info at ${APP_URL}/info..."
if HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "${APP_URL}/info"); then
    if [ "$HTTP_CODE" -eq 200 ]; then
        echo "  [OK] Service info available"
        curl -s "${APP_URL}/info"
        echo
    else
        echo "  [WARN] /info returned HTTP status: $HTTP_CODE"
    fi
else
    echo "  [INFO] /info endpoint not reachable"
fi
echo

# 3. Docker Container State
echo "[3/5] Checking Docker container status ($CONTAINER_NAME)..."
if command -v docker &>/dev/null; then
    if docker ps --format '{{.Names}} (Status: {{.Status}})' | grep -q "$CONTAINER_NAME"; then
        echo "  [OK] Container is active:"
        docker ps --filter "name=$CONTAINER_NAME" --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"
    else
        echo "  [WARN] Container $CONTAINER_NAME is not currently running"
    fi
else
    echo "  [SKIP] Docker command not available in current shell"
fi
echo

# 4. Container Resource Utilization
echo "[4/5] Checking container resource utilization..."
if command -v docker &>/dev/null; then
    if docker ps -q -f name="$CONTAINER_NAME" | grep -q .; then
        docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}" "$CONTAINER_NAME"
    else
        echo "  [SKIP] Container not running; skipping container stats"
    fi
else
    echo "  [SKIP] Docker command not available"
fi
echo

# 5. Host Storage and Memory Resources
echo "[5/5] Host system resources:"
echo "--- Storage (Root Partition) ---"
df -h / | awk 'NR==1 || NR==2'
echo
echo "--- Memory Usage ---"
if command -v free &>/dev/null; then
    free -h
else
    echo "free command not available"
fi
echo
echo "=== Monitoring Check Complete ==="
