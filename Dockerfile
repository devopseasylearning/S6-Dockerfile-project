FROM ubuntu:20.04

# Update the package lists and install Ansible
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
    golang-go && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /BUILDER    

ARG APP_NAME=DevopsDockerfile
ARG ENV=Ubuntu
ENV TEAM=Devops

USER 0

RUN mkdir /root/REPOS

#EXPOSE 80:6000 
# Install iptables if not already installed
RUN apt-get update && apt-get install -y iptables && apt-get clean

# Create a script to configure iptables rules
RUN echo '#!/bin/bash' > /usr/local/bin/open-ports.sh && \
    echo 'for port in {80..6000}; do' >> /usr/local/bin/open-ports.sh && \
    echo '  if [ $port != 3030 ] && [ $port != 4878 ] && [ $port != 4596 ]; then' >> /usr/local/bin/open-ports.sh && \
    echo '    iptables -A INPUT -p tcp --dport $port -j ACCEPT' >> /usr/local/bin/open-ports.sh && \
    echo '    iptables -A INPUT -p udp --dport $port -j ACCEPT' >> /usr/local/bin/open-ports.sh && \
    echo '  fi' >> /usr/local/bin/open-ports.sh && \
    echo 'done' >> /usr/local/bin/open-ports.sh && \
    chmod +x /usr/local/bin/open-ports.sh


RUN /usr/local/bin/open-ports.sh 


RUN mkdir /root/REPOS/GIT

RUN git clone https://github.com/devopseasylearning/KFC-app.git /root/REPOS/GIT
RUN git clone https://github.com/devopseasylearning/awesome-compose.git /root/REPOS/GIT
RUN git clone https://github.com/devopseasylearning/production-deployment.git /root/REPOS/GIT

COPY ./K8S /BUILDER/K8S
COPY ./backend /BUILDER/backend

RUN mkdir FRONTEND

COPY ./frontend /BUILDER/FRONTEND

RUN useradd builder
USER builder

CMD ["/bin/bash"]

