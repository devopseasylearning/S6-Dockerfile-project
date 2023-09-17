ARG UBUNTU_VERSION=20.04
FROM ubuntu:${UBUNTU_VERSION}
LABEL ="DEVOPS EASY LEARNING"

# Set the default directory to "BUILDER"
WORKDIR /BUILDER

# Install the required packages
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
    ufw \
    go
    
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

# Create environment variables
ENV TEAM=Devops

# Prompt the user to enter values for APP_NAME and ENV during build
ARG APP_NAME
ARG ENV
ENV APP_NAME=$APP_NAME
ENV ENV=$ENV

# Set the default user to "root"
USER root

# Create the "REPOS" directory under root user's home directory
RUN mkdir -p /root/REPOS

# Open port range from 80 to 6000 excluding specified ports
RUN ufw allow 80:6000/tcp && \
    ufw deny 3030/tcp && \
    ufw deny 4878/tcp && \
    ufw deny 4596/tcp && \
    ufw --force enable

# Create a directory called "GIT" under "/root/REPOS"
RUN mkdir -p /root/REPOS/GIT

# Copy repositories to the "GIT" directory
RUN git clone https://github.com/devopseasylearning/KFC-app.git /root/REPOS/GIT/KFC-app && \
    git clone https://github.com/devopseasylearning/awesome-compose.git /root/REPOS/GIT/awesome-compose && \
    git clone https://github.com/devopseasylearning/production-deployment.git /root/REPOS/GIT/production-deployment

# Copy "K8S backend" directory to the default directory
COPY K8S\ backend /BUILDER/K8S\ backend

# Create a directory called "FRONTEND" and copy "frontend" directory inside
RUN mkdir -p /BUILDER/FRONTEND && \
    cp -r frontend /BUILDER/FRONTEND

# Create a user called "builder" and set it as the default user
RUN useradd -m -s /bin/bash builder
USER builder

# Define the entry point for the container
CMD ["/bin/bash"]
