FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install minimal prerequisites
RUN apt-get update && apt-get install -y \
    bash \
    build-essential \
    curl \
    file \
    git \
    procps \
    sudo \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Create test user with sudo access
RUN useradd -m -s /bin/bash test && \
    echo "test ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to test user
USER test
WORKDIR /home/test

# Set up SSH directory (will be mounted)
RUN mkdir -p ~/.ssh && chmod 700 ~/.ssh

# Default shell
SHELL ["/bin/bash", "-c"]

CMD ["/bin/bash"]
