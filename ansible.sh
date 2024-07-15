#!/usr/bin/env bash
# ------------------------------------------------------------------------
# Script to install Ansible or Ansible-Core on Ubuntu 22.04
#
# This script installs the specified Ansible package without user interaction.
# ------------------------------------------------------------------------

# Function to handle errors
error_exit() {
  echo ""
  echo "Ansible installation failed."
  exit 1
}

# Set the package name
PACKAGE_NAME="ansible" # Change to "ansible-core" if desired

# Function to fix Docker sources list if malformed
fix_docker_sources() {
  if [ -f /etc/apt/sources.list.d/docker.list ]; then
    echo "Fixing Docker sources list..."
    sed -i '/^deb .*docker.*$/d' /etc/apt/sources.list.d/docker.list || error_exit
    echo "Removed malformed Docker entry from sources list."
  fi
}

# Fix Docker sources list if it exists
fix_docker_sources

# Check if Ansible is already installed
echo ""
echo "Checking if Ansible is already installed..."
if hash ansible 2>/dev/null; then
  echo "Ansible is already installed."
  exit 0
fi

# Update package list and install prerequisites
echo ""
echo "Updating package list and installing prerequisites..."
apt update && apt install -y software-properties-common python3-venv || error_exit

# Create a virtual environment for Ansible
echo ""
echo "Creating a virtual environment for Ansible..."
python3 -m venv ~/ansible-env || error_exit

# Activate the virtual environment
echo ""
echo "Activating the virtual environment..."
source ~/ansible-env/bin/activate || error_exit

# Install Ansible or Ansible-Core
echo ""
echo "Installing $PACKAGE_NAME..."
pip install $PACKAGE_NAME || error_exit

echo ""
echo "$PACKAGE_NAME installation completed successfully."

# Instructions for using Ansible
echo ""
echo "To use Ansible, activate the virtual environment with:"
echo "source ~/ansible-env/bin/activate"

# Instructions for upgrading
echo ""
echo "To upgrade Ansible, run:"
echo "source ~/ansible-env/bin/activate && pip install --upgrade $PACKAGE_NAME"

# Instructions for installing extra dependencies
echo ""
echo "To install additional Python dependencies, use:"
echo "source ~/ansible-env/bin/activate && pip install <package-name>"
