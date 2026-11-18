#!/bin/bash
# Server setup script for devops-system-service
# Creates a service user, sets permissions,
# configures the firewall, and shows system resources.

set -e

APP_USER="devops"
APP_DIR="/opt/devops-system-service"
APP_PORT=5000

# 1. Create a system user for the app (no login shell)
if ! id "$APP_USER" &>/dev/null; then
  sudo useradd --system --create-home --shell /usr/sbin/nologin "$APP_USER"
  echo "User $APP_USER created"
fi

# 2. Create app directory and set ownership and permissions
sudo mkdir -p "$APP_DIR"
sudo chown -R "$APP_USER":"$APP_USER" "$APP_DIR"
sudo chmod 750 "$APP_DIR"

# 3. Configure the firewall (allow SSH and the app port)
sudo ufw allow OpenSSH
sudo ufw allow "$APP_PORT"/tcp
sudo ufw --force enable
sudo ufw status

# 4. Show system resources
echo "Disk usage:"
df -h /
echo "Memory usage:"
free -h
