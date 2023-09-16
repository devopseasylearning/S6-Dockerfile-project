#Set up ARG variable to allow user to specify tag version at build time
ARG TAG_VERSION=latest

#Use the specified tag version for base image. If a user specifies a different tag version, then 'latest' will be overriden.
FROM ubuntu:${TAG_VERSION}

#set the company DEVOPS EASY LEARNING  as the sole owner of the image
LABEL maintainer="DEVOPS EASY LEARNING"

#Install packages
RUN apt-get update && \
    apt-get install -y \
    ansible \
    curl \
    git \
    gnupg \
    jq \
    linux-headers \
    postgresql-client \
    python3 \
    kubectl \
    kubens \
    modejs \
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
    go

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
    useradd -m builder 

USER builder

CMD ["/bin/bash"]
