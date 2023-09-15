# Use ARG to define the base image tag at build time (default to Ubuntu 20.04)
ARG UBUNTU_VERSION=20.04
FROM ubuntu:${UBUNTU_VERSION}

# Set the company as the image owner
LABEL maintainer="DEVOPS EASY LEARNING <devops@example.com>"

# Install the required packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ansible \
    curl \
    git \
    gnupg \
    jq \
    linux-headers-$(uname -r) \
    openssh-client \
    postgresql-client \
    python3 \
    kubectl \
    kubens \
    nodejs \
    npm \
    vim \
    wget \
    python3-pip \
    net-tools \
    iputils-ping \
    terraform \
    awscli \
    default-jre \
    default-jdk \
    maven \
    helm \
    ufw \
    golang-go \
    && rm -rf /var/lib/apt/lists/*

# Set the default directory
WORKDIR /BUILDER

# Create environment variables (APP_NAME and ENV) entered by the user at build time
ARG APP_NAME
ARG ENV
ENV TEAM=Devops

# Set the default user to "root"
USER root

# Create a directory called "REPOS" under the root user's home directory
RUN mkdir -p /root/REPOS

# Open port range from 80 to 6000 excluding 3030, 4878, and 4596
EXPOSE 80-3029 3031-4877 4879-4595 4597-6000

# Create a directory called "GIT" under "/root/REPOS"
RUN mkdir -p /root/REPOS/GIT

# Copy repositories to "/root/REPOS/GIT"
COPY KFC-app /root/REPOS/GIT/
COPY awesome-compose /root/REPOS/GIT/awesome-compose
COPY production-deployment /root/REPOS/GIT/production-deployment

# Copy K8S backend to the default directory
COPY K8S_backend /BUILDER/

# Create a directory called "FRONTEND" under the default directory and copy frontend directory inside
RUN mkdir -p /BUILDER/FRONTEND
COPY frontend /BUILDER/FRONTEND

# Create a user called "builder" and make it the default user
RUN useradd -ms /bin/bash builder
USER builder

# Specify the default command to run when the container starts
CMD ["/bin/bash"]
