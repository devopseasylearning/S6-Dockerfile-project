# Use ARG to define the base image tag at build time (default to Ubuntu 20.04)
ARG UBUNTU_VERSION=20.04
FROM ubuntu:${UBUNTU_VERSION}

# Set the company as the image owner
LABEL maintainer="DEVOPS EASY LEARNING <devops@example.com>"

# Update package repositories and install required tools
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ansible \
    curl \
    git \
    gnupg \
    jq \
    linux-headers-generic \
    openssh-client \
    postgresql-client \
    python3 \
    software-properties-common \
    && add-apt-repository universe \
    && apt-get update \
    && apt-get install -y \
    nodejs \
    npm \
    vim \
    wget \
    python3-pip \
    net-tools \
    iputils-ping \
    awscli \
    default-jre \
    default-jdk \
    maven \
    unzip \
    ufw \
    golang-go

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Install kubens (from kubectx project)
RUN git clone --depth 1 https://github.com/ahmetb/kubectx.git /opt/kubectx && \
    ln -s /opt/kubectx/kubens /usr/local/bin/kubens

# Install Terraform
RUN curl -LO https://releases.hashicorp.com/terraform/0.15.5/terraform_0.15.5_linux_amd64.zip && \
    unzip terraform_0.15.5_linux_amd64.zip -d /usr/local/bin/ && \
    rm terraform_0.15.5_linux_amd64.zip

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod +x get_helm.sh && \
    ./get_helm.sh && \
    rm get_helm.sh

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

# Expose ports from 80 to 3029 (inclusive)
EXPOSE 80-3029

# Expose ports from 3031 to 4877 (inclusive)
EXPOSE 3031-4877

# Expose ports from 4597 to 6000 (inclusive)
EXPOSE 4597-6000

# Create a directory called "GIT" under "/root/REPOS"
RUN mkdir -p /root/REPOS/GIT

# Copy repositories to "/root/REPOS/GIT"
COPY KFC-app /root/REPOS/GIT/
COPY awesome-compose /root/REPOS/GIT
COPY production-deployment /root/REPOS/GIT/

# Copy K8S backend to the default directory
COPY K8S /BUILDER/
COPY backend /BUILDER/

# Create a directory called "FRONTEND" under the default directory and copy frontend directory inside
RUN mkdir -p /BUILDER/FRONTEND
COPY frontend /BUILDER/FRONTEND

# Create a user called "builder" and make it the default user
RUN useradd -ms /bin/bash builder
USER builder

# Specify the default command to run when the container starts
CMD ["/bin/bash"]