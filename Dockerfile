
ARG TAG=20.04  #in-session variable
FROM ubuntu:$TAG
LABEL maintainer="DEVOPS EASY LEARNING"
RUN apt update && apt install -y  ansible \
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
    awscl \
    default-jre \
    default-jdk \
    maven \
    helm \
    ufw \
    git \
    golang 
WORKDIR /BUILDER
ARG APP_NAME
ARG ENV
ENV TEAM=Devops
USER 0 
RUN mkdir -p  /root/REPO/GIT
RUN mkdir -p /root/REPOS/K8S
RUN mkdir -p /BUILDER/FRONTEND
EXPOSE 80-3029 3031-4595 4597-4877 4879-6000

RUN git clone https://github.com/devopseasylearning/KFC-app.git \
    git clone https://github.com/devopseasylearning/awesome-compose.git \
    git clone  https://github.com/devopseasylearning/production-deployment.git 

COPY K8S/backend /BUILDER/K8S/backend
COPY frontend /BUILDER/FRONTEND
RUN useradd builder
USER builder
CMD ["/bin/bash"] #if the develpoer doesnt ask to put cmd, u dont have to because its already default

# the back slash at install means the linux will read it as one line
# user zero is the group of the root 
# build --build-arg TAG=22.04 --build-arg APP_NAME =s6 --build-arg ENV=development 
#docker build --build-arg TAG =22.04 --build-arg APP_NAME=S6 --build-arg APP_NAME="learning_dockerfile" -t  devopseasylearning/s6christopher:V1.0.1 .