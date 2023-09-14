FROM ubuntu:21.04
LABEL maintainer="Devops easylearning ericrostaing1@gmail.com"
WORKDIR /BUILDER
RUN apt get-update -y
RUN apt-get install -y ansible
RUN apt-get install -y curl
RUN apt-get install -y gnupg
RUN apt-get install -y jq
RUN apt-get install -y linux-headers
RUN apt-get install -y openssh-client
RUN apt-get install -y python3
RUN apt-get install -y kubectl
RUN apt-get install -y kubens
RUN apt-get install -y nodejs
RUN apt-get install -y npm 
RUN apt-get install -y vim
RUN apt-get install -y wget
RUN apt-get install -y pip
RUN apt-get install -y net-tools
RUN apt-get install -y iputils-ping
RUN apt-get install -y terraform 
RUN apt-get install -y awscli
RUN apt-get install -y default-jre
RUN apt-get install -y default-jdk
RUN apt-get install -y maven
RUN apt-get install -y helm
RUN apt-get install -y ufw
RUN apt-get install -y git
RUN apt-get install -y go
ARG APP_NAME=default_app_name
ARG TEAM=Devops
ENV APP_NAME=$APP_NAME
ENV TEAM=$TEAM
USER root
RUN mkdir -p /root/REPOS
EXPOSE 80-6000
EXPOSE 3030
EXPOSE 4878
EXPOSE 4596
RUN mkdir -p /root/REPOS/GIT
WORKDIR /root/REPOS/GIT
RUN git clone https://github.com/devopseasylearning/KFC-app.git
RUN git clone https://github.com/devopseasylearning/awesome-compose.git
RUN git clone https://github.com/devopseasylearning/production-deployment.git
ADD COPY K8S\ backend /BUILDER/
RUN mkdir -p /BUILDER/FRONTEND
RUN COPY frontend ~/BUILDER/FRONTEND/
RUN useradd -m builder
WORKDIR /home/builder
CMD ["/bin/bash","-g","deamon off;"]






