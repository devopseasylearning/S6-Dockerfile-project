
# Use a base image specified by the user at build time
ARG BASE_IMAGE
FROM $BASE_IMAGE
# Set the company label
LABEL maintainer="DEVOPS EASY LEARNING"
# Update the package lists and install the desired packages
RUN apt-get update && apt-get install -y \
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
    go \
    && rm -rf /var/lib/apt/lists/*
# Set the default working directory to "/BUILDER"
WORKDIR /BUILDER
# Set default values for environment variables
ENV TEAM=Devops
# Allow users to set the APP_NAME and ENV variables at build time
ARG APP_NAME
ARG ENV
# Set the environment variables
ENV APP_NAME=$APP_NAME
ENV ENV=$ENV
# Set the default user to "root"
USER root
# Create the "REPOS" directory under the root user's home directory
RUN mkdir -p /root/REPOS
# Expose the port range from 80 to 6000, excluding ports 3030, 4878, and 4596
EXPOSE 80-3029 3031-4877 4879-4595 4597-6000
# Create the "GIT" directory under the "REPOS" directory
RUN mkdir -p /root/REPOS/GIT
# Clone the specified repositories into the "GIT" directory
WORKDIR /root/REPOS/GIT

RUN git clone https://github.com/devopseasylearning/KFC-app.git && \
    git clone https://github.com/devopseasylearning/awesome-compose.git && \
    git clone https://github.com/devopseasylearning/production-deployment.git
# Set the default working directory to "/BUILDER"
WORKDIR /BUILDER
COPY  K8S .
COPY backend .
# Create the "FRONTEND" directory under the default directory "/BUILDER"
RUN mkdir -p /BUILDER/FRONTEND
# Copy the "frontend" directory to the "FRONTEND" directory
COPY frontend /BUILDER/FRONTEND
# Create a user called "builder" and set it as the default user
RUN useradd -ms /bin/bash builder
# Set the default user to "builder"
USER builder
# Set the default user's home directory to "/home/builder"
WORKDIR /home/builder
# Set the default command to run when the container starts
CMD ["/bin/bash"]

