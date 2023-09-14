ARG UBUNTU_VERSION=20.04
FROM ubuntu:20.04 
LABEL maintainer="DEVOPS EASY LEARNING <contact@devopseasylearning.com>"
WORKDIR /BUILDER
RUN apt-get update && apt-get install -y \
    ansible \
    curl \
    git \
    gnupg \
    jq \
    linux-headers \
    openssh-client \
    postgresql-client \
    python3 \
    kubectl \
    kubens \
    nodejs \
    npm \                   
    vim \
    wget \
    pip \
    net-tools \
    iputils-ping \
    terraform \
    awscli \
    default-jre \
    default-jdk \
    maven \
    helm \
    ufw \
    git \
    go \
    && rm -rf /var/lib/apt/lists/*


# Create environment variables that can be set at build time
ARG APP_NAME
ARG ENV
ENV APP_NAME=$APP_NAME
ENV ENV=$ENV
ENV TEAM=Devops

USER root

# Set environment variables
ENV PORTS="80-6000"
ENV EXCLUDE_PORTS="3030,4878,4596"

# Install necessary tools and create directories
RUN apt-get update && apt-get install -y \
    net-tools \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /root/REPOS/GIT \
    && mkdir -p /K8S/backend \
    && mkdir -p /default/FRONTEND \
    && useradd -m builder

# Open ports
RUN ufw allow ${PORTS}/tcp
RUN ufw delete allow ${EXCLUDE_PORTS}/tcp

# Copy repositories to /root/REPOS/GIT
COPY KFC-app.git /root/REPOS/GIT/KFC-app.git
COPY awesome-compose.git /root/REPOS/GIT/awesome-compose.git
COPY production-deployment.git /root/REPOS/GIT/production-deployment.git

# Switch to the builder user
USER builder

# Set the default working directory
WORKDIR /home/builder

CMD ["/bin/bash"]
