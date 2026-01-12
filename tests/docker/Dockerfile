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

# Set up SSH directory with correct permissions
RUN mkdir -p ~/.ssh && chmod 700 ~/.ssh && \
    ssh-keygen -t ed25519 -C "test@example.com" -f ~/.ssh/id_ed25519 -N "" && \
    ssh-keyscan github.com >> ~/.ssh/known_hosts && \
    chmod 644 ~/.ssh/known_hosts

# Default shell
SHELL ["/bin/bash", "-c"]

CMD ["/bin/bash"]
