ARG TAG
FROM ubuntu:$TAG
LABEL maintainer="DEVOPS EASY LEARNING"
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
    go && \ 
WORKDIR BUILDER
ARG APP-NAME 
ARG ENV
ENV APP-NAME=$APP-NAME && \
    ENV=$ENV && \  
    Teams=Devops 
USER 0
RUN mkdir REPOS
EXPOSE 80-3029 3031-4877 4879-4595 4597-6000
RUN cd REPOS && \
    mkdir GIT
    cd GIT
    wget https://github.com/devopseasylearning/KFC-app.git && \
         https://github.com/devopseasylearning/awesome-compose.git && \
         https://github.com/devopseasylearning/production-deployment.git 
RUN cd ../..
COPY K8S BUILDER/K8S && \
     backend BUILDER/backend
RUN mkdir FRONTEND && \
    cd FRONTEND 
COPY frontend BUILDER/frontend 
RUN useradd builder
USER builder
CMD ["/bin/bash"]

