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
ARG DEBIAN_FRONTEND=noninteractive
ENV TEAM=Devops

# Set the environment variables
ENV APP_NAME=$APP_NAME
ENV ENV=$ENV

# Install packages
RUN apt-get update && apt-get install -y \
    #ansible \
    curl \
    git \
    gnupg \
    jq \
    #linux-headers \
    linux-headers-generic \
    openssh-client \
    postgresql-client \
    python3 \
    #kubectl \
    #kubens \
    nodejs \
    npm \
    vim \
    wget \
    python3-pip \
    net-tools \
    iputils-ping \
    #terraform \
    awscli \
    default-jre \
    default-jdk \
    maven \
    #helm \
    unzip \
    ufw \
    #go
    golang

## INTALL ANSIBLE:
RUN apt install software-properties-common -y
RUN add-apt-repository --yes --update ppa:ansible/ansible
RUN apt install ansible -y

## INTALL TERRAFORM
# Download Terraform
RUN curl -O "https://releases.hashicorp.com/terraform/0.15.5/terraform_0.15.5_linux_amd64.zip"

# Unzip and move Terraform to /usr/local/bin
RUN unzip terraform_0.15.5_linux_amd64.zip && \
    mv terraform /usr/local/bin/
# Clean up downloaded zip file
RUN rm terraform_0.15.5_linux_amd64.zip

## INSTALL HELM
# Download the Helm installation script
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod +x get_helm.sh
# Install Helm
RUN ./get_helm.sh
# Clean up the installation script
RUN rm get_helm.sh

## INSTALL KUBECTL
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

## INSTALL KUBENS
RUN curl -LO https://github.com/ahmetb/kubectx/releases/download/v0.9.4/kubectx && \
    chmod +x kubectx && \
    mv kubectx /usr/local/bin/


# Clean up apt cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the default user to root
USER root

# Create the REPOS directory 
RUN mkdir -p /root/REPOS

# Expose ports in the range from 80 to 6000, excluding 3030, 4878, and 4596
EXPOSE 80-3029 3031-4595 4597-4877 4879-6000

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

