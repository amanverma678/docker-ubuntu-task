#!/usr/bin/env bash
# ------------------------------------------------------------------------
# Script to install Docker on Ubuntu 22.04
#
# This script installs Docker without user interaction.
# ------------------------------------------------------------------------

# Function to handle errors
error_exit() {
  echo ""
  echo "Docker installation failed."
  exit 1
}

# Fix Docker sources list if malformed
fix_docker_sources() {
  if [ -f /etc/apt/sources.list.d/docker.list ]; then
    echo "Fixing Docker sources list..."
    sed -i 's|deb \[arch=amd64 signed-by=/etc/apt/keyrings/docker.asc\] https://download.docker.com/linux/ubuntu  stable|deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu stable main|' /etc/apt/sources.list.d/docker.list || error_exit
    echo "Fixed Docker sources list."
  fi
}

# Update package list and install prerequisites
echo ""
echo "Updating package list and installing prerequisites..."
apt-get update && apt-get install -y ca-certificates curl software-properties-common || error_exit

# Add Docker's official GPG key
echo ""
echo "Adding Docker's official GPG key..."
install -m 0755 -d /etc/apt/keyrings || error_exit
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc || error_exit
chmod a+r /etc/apt/keyrings/docker.asc || error_exit

# Add the Docker repository to Apt sources
echo ""
echo "Adding Docker repository to Apt sources..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null || error_exit

# Fix Docker sources list if it exists
fix_docker_sources

# Update package list
echo ""
echo "Updating package list..."
apt-get update || error_exit

# Install Docker
echo ""
echo "Installing Docker..."
apt-get install -y docker-ce docker-ce-cli containerd.io || error_exit

echo ""
echo "Docker installation completed successfully."
