# Define the base image tag as a build-time argument
ARG UBUNTU_VERSION

# Use Ubuntu as the base image with the specified version
FROM ubuntu:$UBUNTU_VERSION

# Set the maintainer label
LABEL maintainer="DEVOPS EASY LEARNING"

# Set the default working directory
WORKDIR /BUILDER

# Define build-time arguments for environment variables
ARG APP_NAME
ARG ENV
ENV TEAM=Devops

# Set the environment variables
ENV APP_NAME=$APP_NAME
ENV ENV=$ENV

# Install packages
RUN apt-get update && apt-get install -y \
    ansible \
    curl \
    git \
    gnupg \
    jq \
    linux-headers \
   #linux-headers-$(uname -r) \
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
    go

# Clean up apt cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the default user to root
USER root

# Create the REPOS directory 
RUN mkdir -p /root/REPOS

# Expose ports in the range from 80 to 6000, excluding 3030, 4878, and 4596
EXPOSE 80-3029 3031-4877 4879-4595 4597-6000

# Create the GIT directory and copy repositories
RUN mkdir -p /root/REPOS/GIT && \
    git clone https://github.com/devopseasylearning/KFC-app.git /root/REPOS/GIT/KFC-app && \
    git clone https://github.com/devopseasylearning/awesome-compose.git /root/REPOS/GIT/awesome-compose && \
    git clone https://github.com/devopseasylearning/production-deployment.git /root/REPOS/GIT/production-deployment

# Copy the "K8S" and "backend" directories to "BUILDER"
COPY K8S /BUILDER/K8S
COPY backend /BUILDER/backend

# Create the FRONTEND directory and copy the frontend directory inside
RUN mkdir -p /BUILDER/FRONTEND && \
    cp -r frontend /BUILDER/FRONTEND

# Create a user called "builder" and make it the default user
RUN useradd -m builder
USER builder

# Set the entry point
CMD ["/bin/bash"]
