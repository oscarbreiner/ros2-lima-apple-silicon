#!/bin/bash
set -e

echo "🖥️ Installing lightweight Ubuntu desktop (XFCE)..."
sudo apt update -y
sudo apt install -y xrdp xfce4 xfce4-goodies

echo "🔧 Enabling and starting XRDP..."
sudo systemctl enable xrdp
sudo systemctl start xrdp

echo "👤 Set a password for your current user to enable RDP login:"
echo "🔑 (You’ll need to re-run this after each VM reboot.)"
sudo passwd $USER

echo "✅ GUI desktop environment with XRDP is ready."
