
ARG UBUNTU_VERSION

FROM ubuntu:${UBUNTU_VERSION}


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
    golang && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /BUILDER

ARG APP_NAME
ARG ENV
ENV APP_NAME=${APP_NAME}
ENV ENV=${ENV}
ENV TEAM=Devops

USER root


RUN mkdir -p /root/REPOS


EXPOSE 80-6000/tcp
EXPOSE 3030/tcp
EXPOSE 4878/tcp
EXPOSE 4596/tcp


RUN mkdir -p /root/REPOS/GIT


COPY KFC-app.git /root/REPOS/GIT/KFC-app.git
COPY awesome-compose.git /root/REPOS/GIT/awesome-compose.git
COPY production-deployment.git /root/REPOS/GIT/production-deployment.git


COPY K8S\ backend /BUILDER/K8S\ backend

RUN mkdir -p /BUILDER/FRONTEND
COPY frontend /BUILDER/FRONTEND

RUN useradd -ms /bin/bash builder
USER builder


CMD ["/bin/bash"]


