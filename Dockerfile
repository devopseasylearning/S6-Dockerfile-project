ARG UBUNTU_VERSION=20.04
FROM ubuntu:${UBUNTU_VERSION}
LABEL maintainer="DEVOPS EASY LEARNING <devops@example.com>"
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ansible \
    curl \
    git \
    gnupg \
    jq \
    linux-headers-generic \
    openssh-client \
    postgresql-client \
    python3 \
    software-properties-common \
    && add-apt-repository universe \
    && apt-get update \
    && apt-get install -y \
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
    unzip \
    ufw \
    golang-go
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/
RUN git clone --depth 1 https://github.com/ahmetb/kubectx.git /opt/kubectx && \
    ln -s /opt/kubectx/kubens /usr/local/bin/kubens
RUN curl -LO https://releases.hashicorp.com/terraform/0.15.5/terraform_0.15.5_linux_amd64.zip && \
    unzip terraform_0.15.5_linux_amd64.zip -d /usr/local/bin/ && \
    rm terraform_0.15.5_linux_amd64.zip
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod +x get_helm.sh && \
    ./get_helm.sh && \
    rm get_helm.sh
WORKDIR /BUILDER
ARG APP_NAME
ARG ENV
ENV TEAM=Devops
USER root
RUN mkdir -p /root/REPOS
EXPOSE 80-3029
EXPOSE 3031-4877
EXPOSE 4597-6000
RUN mkdir -p /root/REPOS/GIT
COPY KFC-app /root/REPOS/GIT/
COPY awesome-compose /root/REPOS/GIT
COPY production-deployment /root/REPOS/GIT/
COPY K8S /BUILDER/
COPY backend /BUILDER/
RUN mkdir -p /BUILDER/FRONTEND
COPY frontend /BUILDER/FRONTEND
RUN useradd -ms /bin/bash builder
USER builder
CMD ["/bin/bash"]
