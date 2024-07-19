# Use an official Ubuntu as a parent image
FROM ubuntu:latest

# Set environment variables to avoid some interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Define environment variables for tool versions
ENV MINIKUBE_VERSION=latest
ENV TERRAFORM_VERSION=1.0.11
ENV ANSIBLE_VERSION=4.9.0

# Update the package list & install essential packages
RUN apt-get update && apt-get install -y \
        build-essential \
        curl \
        wget \
        git \
        unzip \
        vim \
        htop \
        net-tools \
        ca-certificates \
        openssh-server \
        ufw \
        iputils-ping \
        python3 \
        python3-pip \
        sysstat \
        tar \
        gzip \
        bzip2 \
        software-properties-common \
        apt-transport-https \
        gnupg \
        zsh && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Docker, Minikube, Terraform, and Ansible
RUN apt-get update && \
    apt-get install -y ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
    curl -LO https://storage.googleapis.com/minikube/releases/${MINIKUBE_VERSION}/minikube-linux-amd64 && \
    install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64 && \
    apt-get update && \
    apt-get install -y gnupg software-properties-common && \
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && \
    apt-get install -y terraform=${TERRAFORM_VERSION} && \
    pip3 install ansible==${ANSIBLE_VERSION} && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# # Copy scripts into the image
# COPY ansible.sh docker.sh kube-install.sh terraform.sh /root/scripts/

# # Make scripts executable
# RUN chmod +x /root/scripts/*.sh

# # Run all scripts sequentially
# RUN /root/scripts/ansible.sh && \
#     /root/scripts/docker.sh && \
#     /root/scripts/kube-install.sh && \
#     /root/scripts/terraform.sh && \
#     # Clean up scripts after execution to reduce image size
#     rm -rf /root/scripts/*.sh

# Set the working directory
WORKDIR /root

# Command to keep the container running
CMD ["tail", "-f", "/dev/null"]
