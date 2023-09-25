# Use a user-defined base image version at build time
ARG BASE_IMAGE_VERSION
FROM ubuntu:${BASE_IMAGE_VERSION}

# Set maintainer label
LABEL maintainer="DEVOPS EASY LEARNING"

# Install necessary packages
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
    go

# Set the default directory
WORKDIR /BUILDER

# Create environment variables
ARG APP_NAME
ARG ENV
ENV APP_NAME=${APP_NAME}
ENV ENV=${ENV}
ENV TEAM=Devops

# Set the default user to root
USER root

# Create directories
RUN mkdir -p /root/REPOS/GIT \
    && mkdir -p /BUILDER/FRONTEND \
    && mkdir -p /BUILDER/K8S_BACKEND

# Open port range from 80 to 6000 excluding 3030, 4878, and 4596
EXPOSE 80-6000
EXCLUDE 3030,4878,4596

# Copy repositories to GIT directory
COPY repos/KFC-app.git /root/REPOS/GIT/KFC-app.git
COPY repos/awesome-compose.git /root/REPOS/GIT/awesome-compose.git
COPY repos/production-deployment.git /root/REPOS/GIT/production-deployment.git

# Copy K8S backend directory to the default directory
COPY K8S_backend /BUILDER/K8S_BACKEND

# Copy frontend directory to FRONTEND directory
COPY frontend /BUILDER/FRONTEND

# Create a user called "builder" and set as default user
RUN useradd -ms /bin/bash builder
USER builder

# Set the default command to run when the container starts
CMD ["/bin/bash"]



