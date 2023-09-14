FROM ubuntu:20.04
# Set the company label
LABEL maintainer="DEVOPS EASY LEARNING"
# Update package lists and install the specified packages
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
    go

# Clean up the package cache to reduce image size
RUN apt-get clean
# Set the default working directory
WORKDIR /BUILDER

# Create environment variables
ARG APP_NAME
ARG ENV
ENV APP_NAME=${APP_NAME} ENV=${ENV} TEAM=Devops

# Set the default user to root
USER root

# Create a directory called "REPOS" under the root user's home directory
RUN mkdir -p /root/REPOS

# Open port range from 80 to 6000 excluding 3030, 4878, and 4596
RUN ufw allow 80:6000/tcp && ufw deny 3030/tcp && ufw deny 4878/tcp && ufw deny 4596/tcp && ufw --force enable

# Create a directory called "GIT" under "/root/REPOS"
RUN mkdir -p /root/REPOS/GIT

# Copy repositories to the "GIT" directory
COPY \
    https://github.com/devopseasylearning/KFC-app.git \
   https://github.com/devopseasylearning/awesome-compose.git \
    https://github.com/devopseasylearning/production-deployment.git \
    /root/REPOS/GIT/

# Copy directory "K8S backend" under the default directory
COPY K8S\ backend /BUILDER/

# Create a directory called "FRONTEND" under the default directory and copy the "frontend" directory inside
RUN mkdir -p /BUILDER/FRONTEND
COPY frontend /BUILDER/FRONTEND

# Create a user called "builder" and set as the default user
RUN useradd -ms /bin/bash builder
USER builder

# Define the command to run when the container starts
CMD ["/bin/bash"]
