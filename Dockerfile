# set the base image tag with ARG
ARG BASE_IMAGE_TAG=ubuntu:20.04
FROM $BASE_IMAGE_TAG

# Set the metadata for the base_image
LABEL owner= DEVOPS EASY LEARNING

# Install all required packages
RUN apt-get update && \
    apt-get install -y \
    ansible \
    curl \
    git \
    gnupg \
    jq \
    linux-headers \
    openssh-client \
    postgresql-client \
    python3 \
    kubectl \
    kubectx \
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
    go \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the default working directory to "BUILDER"
WORKDIR /BUILDER

# Create environment variables (APP_NAME and ENV) provided at build time
ARG APP_NAME
ARG ENV
ENV APP_NAME=$APP_NAME ENV=$ENV TEAM=Devops

# Set the default user to "root"
USER root

# Create the "REPOS" directory and the "GIT" subdirectory
RUN mkdir -p /root/REPOS/GIT

# Open port range from 80 to 6000 (excluding 3030, 4878, 4596)
RUN ufw allow 80:6000/tcp
    ufw delete allow 3030/tcp
    ufw delete allow 4878/tcp
    ufw delete allow 4596/tcp
    ufw --force enable

# Copy repositories to the "GIT" directory
COPY --chown=root:root https://github.com/devopseasylearning/KFC-app.git /root/REPOS/GIT/KFC-app
COPY --chown=root:root https://github.com/devopseasylearning/awesome-compose.git /root/REPOS/GIT/awesome-compose
COPY --chown=root:root https://github.com/devopseasylearning/production-deployment.git /root/REPOS/GIT/production-deployment

# Copy "K8S backend" directory to the default directory
COPY  K8S backend /BUILDER

# Create a directory called "FRONTEND" under the default directory and copy the "frontend" directory inside
RUN mkdir -p /BUILDER/FRONTEND
COPY --chown=root:root frontend /BUILDER/FRONTEND

# Create a user called "builder" and make it the default user
RUN useradd -m -s /bin/bash builder
USER builder

# Set the command to run when the container starts
CMD ["/bin/bash"]
