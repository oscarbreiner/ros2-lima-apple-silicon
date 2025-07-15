#!/bin/bash
set -e

echo "🛠️  Updating package index..."
sudo apt update -y

echo "📦 Installing base dependencies..."
sudo apt install -y \
  curl gnupg2 lsb-release software-properties-common \
  locales net-tools vim git build-essential

echo "🌍 Setting locale..."
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

echo "🔑 Adding ROS 2 GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | \
  sudo tee /etc/apt/keyrings/ros-archive-keyring.gpg >/dev/null

echo "🛤️ Adding ROS 2 Humble repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/ros-archive-keyring.gpg] \
  http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

echo "📦 Installing ROS 2 Humble Desktop..."
sudo apt update -y
sudo apt install -y ros-humble-desktop

echo "🔧 Sourcing ROS in bashrc..."
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
source ~/.bashrc

echo "📦 Installing rosdep..."
sudo apt install -y python3-rosdep
sudo rosdep init || echo "rosdep already initialized"
rosdep update

echo "✅ ROS 2 Humble installation complete."
