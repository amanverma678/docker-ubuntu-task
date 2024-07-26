#!/bin/bash

# Update and install necessary packages
sudo apt-get update
sudo apt-get install -y curl wget apt-transport-https gnupg software-properties-common
./docker.sh

# Install Terraform
TERRAFORM_VERSION="1.0.11"
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install Ansible
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y ansible

# Install Minikube
MINIKUBE_VERSION="latest"
curl -LO https://storage.googleapis.com/minikube/releases/${MINIKUBE_VERSION}/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

# Verify installations
terraform --version
ansible --version
minikube version

echo "Installation complete. Terraform, Ansible, and Minikube are installed locally."
