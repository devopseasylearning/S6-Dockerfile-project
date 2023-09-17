FROM ubuntu:20.04
ENTRYPOINT /bin/bash
RUN apt -y install ansible && \
    apt -y install curl && \
    apt -y install git && \
    apt -y install gnupg && \
    apt -y install jq && \
    apt -y install Linux-headers && \
    apt -y install openssh-client && \
    apt -y install postgresql-client && \
    apt -y python3 && \
    apt -y kubectl && \
    apt -y kubens && \
    apt -y nodejs && \
    apt -y  npm && \                       
    apt -y  vim && \
    apt -y wget && \
    apt -y pip && \
    apt -y  net-tools && \
    apt -y iputils-ping && \
    apt -y  terraform && \
    apt -y awscli && \
    apt -y default-jre && \
    apt -y default-jdk && \
    apt -y maven && \
    apt -y helm && \
    apt -y ufw && \
    apt -y go && \
    mkdir -p /root/REPOS && \
    mkdir -p /BUILDER/FRONTEND && \
WORkDIR /BUILDER
ARG APP_NAME
ARG ENV
ENV APP_NAME=${APP_NAME}
ENV ENV=${ENV}
ENV TEAM=Devops
EXPOSE 80-6000
EXPOSE 3030/tcp
EXPOSE 4878/tcp
EXPOSE 4596/tcp
USER root
ADD https://github.com/devopseasylearning/KFC-app.git /root/REPOS/GIT/KFC-app.git
ADD https://github.com/devopseasylearning/awesome-compose.git /root/REPOS/GIT/awesome-compose.git
ADD https://github.com/devopseasylearning/production-deployment.git /root/REPOS/GIT/production-deployment.git
COPY K8S_backend /BUILDER/K8S_backend
COPY frontend /BUILDER/FRONTEND
