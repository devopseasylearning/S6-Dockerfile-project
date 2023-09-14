
# Define the base image tag version at build time
ARG UBUNTU_VERSION=20.04

# Use Ubuntu as the base image with the specified version
FROM ubuntu:${UBUNTU_VERSION}

# Set the image maintainer/owner
LABEL maintainer="DEVOPS EASY LEARNING"

# Install required packages
RUN apt-get update && apt-get install -y \
    ansible \
    curl \
    git \
    gnupg \
    jq \
    linux-headers\
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

# Set the default directory
WORKDIR /BUILDER

# Create environment variables (APP_NAME and ENV) defined at build time
ARG APP_NAME
ARG ENV
ENV APP_NAME=$APP_NAME
ENV ENV=$ENV
ENV TEAM=Devops

# Set the default user to root
USER root

# Create the REPOS directory under the root user's home directory
RUN mkdir -p /root/REPOS

# Open port range from 80 to 6000 (excluding 3030, 4878, 4596)
EXPOSE 80-6000/tcp
EXPOSE 3030/tcp
EXPOSE 4878/tcp
EXPOSE 4596/tcp

# Create a directory called GIT under REPOS and copy repositories
RUN mkdir -p /root/REPOS/GIT && \
    git clone https://github.com/devopseasylearning/KFC-app.git /root/REPOS/GIT/KFC-app && \
    git clone https://github.com/devopseasylearning/awesome-compose.git /root/REPOS/GIT/awesome-compose && \
    git clone https://github.com/devopseasylearning/production-deployment.git /root/REPOS/GIT/production-deployment

# Copy K8S and backend directory under the default directory
COPY K8S backend /BUILDER/

# Create a directory called FRONTEND under the default directory and copy frontend directory inside
RUN mkdir -p /BUILDER/FRONTEND && \
    cp -rf frontend /BUILDER/FRONTEND

# Create a user called "builder" and make it the default user
RUN useradd -ms /bin/bash builder
USER builder
WORKDIR /home/builder

# Specify the command to run when the container starts
CMD ["/bin/bash"]
