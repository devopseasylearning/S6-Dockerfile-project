# Use ARG to allow the user to specify the base image tag at build time
ARG BASE_IMAGE_TAG=20.04

# Use the desired Ubuntu base image
FROM ubuntu:${BASE_IMAGE_TAG}

# Set the company as the image maintainer
LABEL maintainer="DEVOPS EASY LEARNING"

# Install required packages
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
    go

# Set the default working directory
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
RUN mkdir -p /root/REPOS/GIT /BUILDER/K8S /BUILDER/FRONTEND

# Open port range from 80 to 6000 (excluding 3030, 4878, 4596)
RUN ufw allow 80:6000/tcp && ufw deny 3030 4878 4596 && ufw --force enable

# Copy repositories to /root/REPOS/GIT
COPY --chown=root:root . /root/REPOS/GIT/

# Copy K8S backend and frontend directory
COPY --chown=root:root K8S /BUILDER/K8S/
COPY --chown=root:root frontend /BUILDER/FRONTEND/

# Create a user called "builder" and make it the default user
RUN useradd -ms /bin/bash builder
USER builder

# Set the entry command
CMD ["/bin/bash"]
