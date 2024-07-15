# Use an official Ubuntu as a parent image
FROM ubuntu:latest

# Set environment variables to avoid some interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list, install essential packages, install AWS CLI, MySQL, JDK 17, and Jenkins
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
        gnupg && \
   
    # Clean up the apt cache to reduce image size
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy scripts into the image
COPY ansible.sh docker.sh kube-install.sh terraform.sh /root/scripts/

# Make scripts executable
RUN chmod +x /root/scripts/*.sh

# Run all scripts sequentially
RUN /root/scripts/ansible.sh && \
    /root/scripts/docker.sh && \
    /root/scripts/kube-install.sh && \
    /root/scripts/terraform.sh && \
    # Clean up scripts after execution to reduce image size
    rm -rf /root/scripts/*.sh

# Set the working directory
WORKDIR /root

# Command to keep the container running
CMD ["tail", "-f", "/dev/null"]
