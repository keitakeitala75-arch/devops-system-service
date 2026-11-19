#!/bin/bash
# Rollback script for devops-system-service
# Restores a previous known-working container release and verifies health.

set -euo pipefail

ROLLBACK_IMAGE="${1:-devops-service:ffc8ce2}"
CONTAINER_NAME="devops-container"
PORT=5000
MAX_RETRIES=10
RETRY_DELAY=1

echo "========================================="
echo " Starting DevOps Service Rollback"
echo " Target Image: $ROLLBACK_IMAGE"
echo " Time: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
echo "========================================="

# 1. Stop and remove the current container if it exists
if docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
    echo "[1/4] Stopping existing container '$CONTAINER_NAME'..."
    docker stop "$CONTAINER_NAME" >/dev/null
    echo "[2/4] Removing container '$CONTAINER_NAME'..."
    docker rm "$CONTAINER_NAME" >/dev/null
else
    echo "[1/4] No existing container named '$CONTAINER_NAME' found to stop."
    echo "[2/4] Skipping removal."
fi

# 2. Deploy rollback container
echo "[3/4] Launching rollback container with image '$ROLLBACK_IMAGE'..."
docker run -d \
    --name "$CONTAINER_NAME" \
    -p "${PORT}:${PORT}" \
    --restart unless-stopped \
    "$ROLLBACK_IMAGE"

# 3. Verify application health
echo "[4/4] Verifying health endpoint (http://localhost:${PORT}/health)..."
SUCCESS=false
for i in $(seq 1 "$MAX_RETRIES"); do
    if RESPONSE=$(curl -sf "http://localhost:${PORT}/health" 2>/dev/null); then
        echo "  [OK] Health check passed on attempt $i:"
        echo "  $RESPONSE"
        SUCCESS=true
        break
    fi
    echo "  Waiting for service to become ready (attempt $i/$MAX_RETRIES)..."
    sleep "$RETRY_DELAY"
done

if [ "$SUCCESS" = true ]; then
    echo
    echo "========================================="
    echo " Rollback completed successfully!"
    echo " Active Container:"
    docker ps --filter "name=$CONTAINER_NAME" --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}"
    echo "========================================="
    exit 0
else
    echo
    echo "========================================="
    echo " [ERROR] Rollback health check failed!"
    echo " Container logs:"
    docker logs --tail 20 "$CONTAINER_NAME"
    echo "========================================="
    exit 1
fi
