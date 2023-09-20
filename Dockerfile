# Define the base image tag as an ARG variable (can be set during build)
ARG BASE_IMAGE_TAG=20.04

# Use Ubuntu as the base image with the provided tag
FROM ubuntu:${BASE_IMAGE_TAG}

# Set the maintainer label
LABEL maintainer="DEVOPS EASY LEARNING"

# Installation of the following packages
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
    go \
 && rm -rf /var/lib/apt/lists/*

# Set the default working directory
WORKDIR /BUILDER

# Environment variables (APP_NAME and ENV) set at runtime
ENV TEAM=Devops

# Set the default user to root
USER root

# Create a directory called "REPOS" under the root user's home directory
RUN mkdir -p /root/REPOS

# Open port range from 80 to 6000, excluding ports 3030, 4878, and 4596
EXPOSE 80-6000
EXPOSE 3030 4878 4596

# Create a directory called "GIT" under "/root/REPOS" and copy repositories
RUN mkdir -p /root/REPOS/GIT && \
    git clone https://github.com/devopseasylearning/KFC-app.git /root/REPOS/GIT/KFC-app && \
    git clone https://github.com/devopseasylearning/awesome-compose.git /root/REPOS/GIT/awesome-compose && \
    git clone https://github.com/devopseasylearning/production-deployment.git /root/REPOS/GIT/production-deployment

# Copy "K8S backend" directory to the default directory
COPY "K8S backend" /BUILDER/

# Create a directory called "FRONTEND" under the default directory and copy "frontend" directory inside
RUN mkdir -p /BUILDER/FRONTEND && \
    cp -r frontend /BUILDER/FRONTEND

# Create a user called "builder" and make it the default user
RUN useradd -m builder
USER builder

# Specify the command to run when the container starts
CMD ["/bin/bash"]
