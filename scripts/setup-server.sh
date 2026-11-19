#!/bin/bash
# Server setup script for devops-system-service

set -euo pipefail

APP_USER="devops-service"
APP_GROUP="devops"
APP_DIR="/opt/devops-system-service"
APP_PORT=5000

# Private network must be supplied by the administrator.
if [[ -z "${ALLOWED_SUBNET:-}" ]]; then
    echo "ERROR: Set ALLOWED_SUBNET before running this script."
    exit 1
fi

# Check required commands and existing group.
for cmd in useradd ufw; do
    command -v "$cmd" >/dev/null || {
        echo "ERROR: $cmd is not installed."
        exit 1
    }
done

if ! getent group "$APP_GROUP" >/dev/null; then
    echo "ERROR: Group $APP_GROUP does not exist."
    exit 1
fi

# Create service user if it does not exist.
if ! id "$APP_USER" >/dev/null 2>&1; then
    sudo useradd --system --create-home \
        --gid "$APP_GROUP" \
        --shell /usr/sbin/nologin "$APP_USER"
    echo "Service user created."
fi

# Configure application directory.
sudo mkdir -p "$APP_DIR"
sudo chown "$APP_USER":"$APP_GROUP" "$APP_DIR"
sudo chmod 750 "$APP_DIR"

# Protect SSH before configuring the firewall.
sudo ufw allow OpenSSH

# Add private-network access to application port.
sudo ufw allow from "$ALLOWED_SUBNET" \
    to any port "$APP_PORT" proto tcp

# Enable UFW only after SSH rule is added.
sudo ufw --force enable
sudo ufw status

# Display system resources.
echo "Disk usage:"
df -h /

echo "Memory usage:"
free -h

echo "Server setup completed."
