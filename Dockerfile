FROM ubuntu:20.04

# Update the package lists and install Ansible
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Winnipeg
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
    ufw \
    unzip \
    golang-go && \
    rm -rf /var/lib/apt/lists/*


RUN curl -LO "https://dl.k8s.io/release/v1.21.5/bin/linux/amd64/kubectl"
RUN chmod +x kubectl
RUN mv kubectl /usr/local/bin/


RUN git clone https://github.com/ahmetb/kubectx.git ~/.kubectx


RUN curl -fsSL -o terraform.zip https://releases.hashicorp.com/terraform/1.5.6/terraform_1.5.6_linux_amd64.zip
RUN unzip terraform.zip

RUN chmod +x terraform

RUN mv terraform /usr/local/bin/


RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
RUN chmod +x get_helm.sh
RUN ./get_helm.sh


WORKDIR /BUILDER    

ARG APP_NAME=DevopsDockerfile
ARG ENV=Ubuntu
ENV TEAM=Devops

USER 0

RUN mkdir /root/REPOS

#EXPOSE 80:6000 

EXPOSE 80-3029
EXPOSE 3031-4595
EXPOSE 4597-4877
EXPOSE 4879-6000




RUN mkdir /root/REPOS/GIT

RUN git clone https://github.com/devopseasylearning/KFC-app.git /root/REPOS/GIT/KFC-app
RUN git clone https://github.com/devopseasylearning/awesome-compose.git /root/REPOS/GIT/awesome-compose
RUN git clone https://github.com/devopseasylearning/production-deployment.git /root/REPOS/GIT/production-deployment

COPY ./K8S /BUILDER/K8S
COPY ./backend /BUILDER/backend

RUN mkdir FRONTEND

COPY ./frontend /BUILDER/FRONTEND

RUN useradd builder
USER builder

CMD ["/bin/bash"]

