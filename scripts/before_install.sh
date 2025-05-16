#!/bin/bash
set -e

echo "Stopping Puma service if running..."
systemctl stop puma.service || true

echo "Backing up current app directory..."
if [ -d /app ]; then
  mv /app /app_backup_$(date +%s)
fi
