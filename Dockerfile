ARG Ubuntu=latest
FROM Ubuntu:${latest}

LABEL maintainer ="DEVOPS EASY LEARNING"

#updating package repository and installing packages
RUN apt-get update && \
apt-get install -y ansible curl git gnupg jq linux-headers 
RUN apt-get update && \
apt-get install -y openssh-client postgresql-client python3 kubectl kubens nodejs
RUN apt-get update && \
apt-get install -y npm vim wget pip net-tools iputils-ping terraform awscli default-jre
RUN apt-get update && \
apt-get install -y default-jdk maven helm ufw git go

#setting default directory
RUN mkdir BUILDER
WORKDIR /BUILDER
#Creating an environment Variable to be entered by user during build time
ARG APP_NAME
ARG ENV
#Setting default values 
ARG APP_NAME=Dockerproj
ARG ENV=Ubuntimaj
#setting environment variable 
ENV APP_NAME=${Dockerproj}
ENV ENV=${Ubuntimaj}
ENV TEAM=Devops

#Setting default user as root
USER root
#creating a directory called REPOS under the root user home dir
RUN mkdir -p /root/REPOS
#opening port range and exlusing 3 specific ports
RUN ufw allow 80:6000
RUN ufw deny 3030 4878 4596
#Creating a directory called GIT
RUN mkdir -p /root/REPOS/GIT
#copying repositiories 
RUN git clone https://github.com/devopseasylearning/KFC-app.git
RUN git clone https://github.com/devopseasylearning/awesome-compose.git 
RUN git clone https://github.com/devopseasylearning/production-deployment.git

COPY K8S /BUILDER/
RUN mkdir /BUILDER/FRONTEND
COPY frontend /BUILDER/FRONTEND
RUN useradd builder 
USER builder
#running the first command when the conatiner starts
CMD /bin/bash
