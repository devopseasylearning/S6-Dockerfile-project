# Use the specified base image tag (ARG) in the FROM instruction
ARG BASE_IMG_TAG=latest
FROM ubuntu:${BASE_IMG_TAG}

# Set the maintainer (owner) of the image
LABEL maintainer="DEVOPS EASY LEARNING <del@devopseasylearning.com>"

# Set the default user to be "root"
USER root

# Set the environment variables with user-defined values where APP_NAME and ENV defined at build time
ARG APP_NAME
ARG ENV 
ENV APP_NAME=${APP_NAME}
ENV ENV=${ENV}

# Default value for TEAM
ENV TEAM=Devops

# Update the package list and install the required packages
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
    snapd \ 
    kubectx \
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
    golang-go && \
    snap install kubectl --classic && \
    rm -rf /var/lib/apt/lists/*  

# Install Helm from the official source
ADD https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 /tmp/get-helm-3
RUN chmod +x /tmp/get-helm-3 && \
    /tmp/get-helm-3 && \
    rm /tmp/get-helm-3

# Set environment variables for Terraform package versions
ENV TERRAFORM_VERSION=0.15.5

# Install Terraform from the official source using the version variable
RUN wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -d /usr/local/bin/ && \
    rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

# Set the default directory
WORKDIR /BUILDER

# Open port range from "80 to 6000", excluding specific ports: "3030 4878 4596"
EXPOSE 80-3029 \
    3031-4877 \
    40879-4595 \
    4597-6000

# Create a directory called "REPOS" under the root user's home directory then another called "GIT" Under it
RUN mkdir -p /root/REPOS/GIT && \
    #Copy  the following repository under a directory called GIT located at "/root/REPOS"
    git clone https://github.com/devopseasylearning/KFC-app.git /root/REPOS/GIT/KFC-app && \
    git clone https://github.com/devopseasylearning/awesome-compose.git /root/REPOS/GIT/awesome-compose && \
    git clone https://github.com/devopseasylearning/production-deployment.git /root/REPOS/GIT/production-deployment

# Copy the "K8S" and "backend" directories under the default directory (BUILDER)
COPY ../k8s . 
COPY ../backend .

# Create a directory called FRONTEND under the default directory and copy frontend directory inside
RUN mkdir FRONTEND

# Copy frontend directory inside FRONTEND
COPY ../frontend ./FRONTEND

# Create a user named "builder" and make him as the default user
RUN useradd -ms /bin/bash builder

# Set the default user to "builder"
USER builder

# Set the default/first command to be "/bin/bash" to run when the container starts
CMD ["/bin/bash"]
