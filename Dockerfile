# Use an official Ubuntu as a parent image
FROM ubuntu:latest

# Set environment variables to avoid some interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Copy .env file into the image
COPY .env /root/

# Install essential packages
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
    # Clean up the apt cache to reduce image size
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Source .env file to use environment variables
RUN 
    # Install Docker
    apt-get update && \
    apt-get install -y ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce=${DOCKER_VERSION} docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
    # Install Minikube
    curl -LO https://storage.googleapis.com/minikube/releases/${MINIKUBE_VERSION}/minikube-linux-amd64 && \
    install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64 && \
    # Install Terraform
    apt-get update && \
    apt-get install -y gnupg software-properties-common && \
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && \
    apt-get install -y terraform=${TERRAFORM_VERSION} && \
    # Install Ansible
    pip3 install ansible==${ANSIBLE_VERSION} && \
    # Clean up
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /root

# Command to keep the container running
CMD ["tail", "-f", "/dev/null"]
