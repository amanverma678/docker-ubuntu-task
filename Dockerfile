# Use an official Ubuntu as a parent image
FROM ubuntu:latest

# Set environment variables to avoid some interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Copy .env file into the image
COPY .env /root/

# Install essential packages and tools
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
RUN set -a && . /root/.env && set +a && \
    # Install Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update && apt-get install -y docker-ce=${DOCKER_VERSION}~3-0~ubuntu-$(lsb_release -cs) && \
    # Install Kubernetes
    curl -LO "https://dl.k8s.io/release/v${KUBERNETES_VERSION}/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl && \
    # Install Terraform
    curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    # Install Ansible
    pip3 install ansible==${ANSIBLE_VERSION} && \
    # Clean up
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
