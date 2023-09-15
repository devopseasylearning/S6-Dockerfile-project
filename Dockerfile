# Use the official Ubuntu as the base image with ARG for version tag
ARG UBUNTU_VERSION=latest
FROM ubuntu:${UBUNTU_VERSION}

# Set the maintainer label
LABEL maintainer="DEVOPS EASY LEARNING"

# Install required packages
RUN apt-get update && apt-get install -y \
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
    go && \
    rm -rf /var/lib/apt/lists/*

# Set the default working directory
WORKDIR /BUILDER

# Create environment variables
ARG APP_NAME
ARG ENV
ENV APP_NAME=${APP_NAME} ENV=${ENV} TEAM=Devops

# Set the default user to root
USER root

# Create directories and open ports
RUN mkdir -p /root/REPOS/GIT && \
    mkdir -p /BUILDER/K8S/backend && \
    mkdir -p /BUILDER/FRONTEND && \
    mkdir -p /root/REPOS/GIT && \
    apt-get update && \
    apt-get install -y ufw && \
    ufw allow 80:6000/tcp && \
    ufw delete allow 3030/tcp && \
    ufw delete allow 4878/tcp && \
    ufw delete allow 4596/tcp && \
    ufw --force enable

# Copy repositories
COPY ./KFC-app.git /root/REPOS/GIT/
COPY ./awesome-compose.git /root/REPOS/GIT/
COPY ./production-deployment.git /root/REPOS/GIT/

# Copy K8S backend and frontend
COPY ./K8S/backend /BUILDER/K8S/backend
COPY ./frontend /BUILDER/FRONTEND

# Create a user "builder" and set it as the default user
RUN useradd -ms /bin/bash builder
USER builder


# Set the command to run when the container starts
CMD ["/bin/bash"]
