# Use ARG to define the base image tag at build time (default to Ubuntu 20.04)
ARG BASE_IMAGE_TAG
FROM ubuntu:${BASE_IMAGE_TAG}

# Set the company as the image owner
LABEL maintainer="DEVOPS EASY LEARNING"

# Install the required packages
RUN apt-get update && \
    apt-get install -y \
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
ENV APP_NAME=${APP_NAME} ENV=${ENV} TEAM=Devops

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