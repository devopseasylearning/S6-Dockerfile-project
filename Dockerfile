#Set up ARG variable to allow user to specify tag version at build time
ARG UBUNTU_VERSION=latest

#Use the specified tag version for base image. If a user specifies a different tag version, then 'latest' will be overriden.
FROM ubuntu:${UBUNTU_VERSION}

#set the company DEVOPS EASY LEARNING  as the sole owner of the image
LABEL maintainer="DEVOPS EASY LEARNING"

# Install required packages
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
    golang-go

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Install kubens
RUN curl -LO "https://github.com/ahmetb/kubectx/releases/latest/download/kubens" && \
    chmod +x kubens && \
    mv kubens /usr/local/bin/

# Install terraform
RUN curl -LO "https://releases.hashicorp.com/terraform/0.15.5/terraform_0.15.5_linux_amd64.zip" && \
    unzip terraform_0.15.5_linux_amd64.zip && \
    chmod +x terraform && \
    mv terraform /usr/local/bin/

# Install helm
RUN curl -LO "https://get.helm.sh/helm-v3.7.1-linux-amd64.tar.gz" && \
    tar -xvf helm-v3.7.1-linux-amd64.tar.gz && \
    chmod +x linux-amd64/helm && \
    mv linux-amd64/helm /usr/local/bin/ && \
    rm -rf helm-v3.7.1-linux-amd64.tar.gz linux-amd64

WORKDIR /BUILDER

ARG APP_NAME
ARG ENV
ENV APP_NAME=${APP_NAME}
ENV ENV=${ENV}
ENV TEAM=Devops

USER root

RUN mkdir -p /root/REPOS

RUN ufw allow 80:6000/tcp \
    ufw delete allow 3030/tcp \
    ufw delete allow 4878/tcp \
    ufw delete allow 4596/tcp \
    ufw --force enable

RUN mkdir -p /root/REPOS/GIT && \
    git clone https://github.com/devopseasylearning/KFC-app.git /root/REPOS/GIT \
    git clone https://github.com/devopseasylearning/awesome-compose.git /root/REPOS/GIT  \
    git clone https://github.com/devopseasylearning/production-deployment.git /root/REPOS/GIT
    
COPY K8S backend /BUILDER
RUN mkdir -p /BUILDER/FRONTEND && \
    cp -rf frontend /BUILDER/FRONTEND \
    useradd -m -s /bin/bash builder 

USER builder

CMD ["/bin/bash"]
