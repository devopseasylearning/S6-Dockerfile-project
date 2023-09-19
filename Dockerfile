ARG UBUNTU_VERSION=20.04 
FROM ubuntu:${UBUNTU_VERSION} 
LABEL ="DEVOPS EASY LEARNING" 
# Install the required packages
RUN apt-get update && apt-get install -y \
    ansible \
    curl \
    git \
    gnupg \
    jq \
    linux-headers-generic \
    openssh-client \
    postgresql-client \
    python3 \
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
    ufw \
    go
    
    # Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Install kubens (from kubectx project)
RUN git clone --depth 1 https://github.com/ahmetb/kubectx.git /opt/kubectx && \
    ln -s /opt/kubectx/kubens /usr/local/bin/kubens

# Install Terraform
RUN curl -LO https://releases.hashicorp.com/terraform/0.15.5/terraform_0.15.5_linux_amd64.zip && \
    unzip terraform_0.15.5_linux_amd64.zip -d /usr/local/bin/ && \
    rm terraform_0.15.5_linux_amd64.zip

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod +x get_helm.sh && \
    ./get_helm.sh && \
    rm get_helm.sh


# Set the default directory to "BUILDER"
WORKDIR /BUILDER

# Create environment variables APP_NAME and ENV, to be set by the user at build time
ARG APP_NAME
ARG ENV
ENV APP_NAME=${APP_NAME} ENV=${ENV} TEAM=Devops

# Set the default user to "root"
USER root

# Create the "REPOS" directory and "GIT" directory inside it
RUN mkdir -p /root/REPOS/GIT

# Copy repositories into the GIT directory
RUN git clone https://github.com/devopseasylearning/KFC-app.git /root/REPOS/GIT/KFC-app \
    && git clone https://github.com/devopseasylearning/awesome-compose.git /root/REPOS/GIT/awesome-compose \
    && git clone https://github.com/devopseasylearning/production-deployment.git /root/REPOS/GIT/production-deployment

# Copy K8S backend to default directory
COPY K8S_backend /BUILDER/K8S_backend

# Create FRONTEND directory and copy frontend directory inside
RUN mkdir -p /BUILDER/FRONTEND \
    && cp -r frontend /BUILDER/FRONTEND

# Create user "builder" and set it as default user
RUN useradd -m builder
USER builder

# Expose ports 80 to 6000, excluding 3030, 4878, 4596
EXPOSE 80-6000
EXPOSE 3030 4878 4596

# Command to run when the container starts
CMD ["/bin/bash"]

