FROM ubuntu:21.04
LABEL maintainer="Devops easylearning ericrostaing1@gmail.com"
WORKDIR /BUILDER

# Update the package list and install the required packages
RUN apt-get update && \
    apt-get install -y \
    ansible \
    curl \
    git \
    gnupg \
    jq \
    linux-headers-$(uname -r) \  # Install the kernel headers
    openssh-client \
    postgresql-client \
    python3 \
    kubectl \
    kubens \
    nodejs \
    npm \
    vim \
    wget \
    python3-pip \  # Install pip for Python 3
    net-tools \
    iputils-ping \
    terraform \
    awscli \
    default-jre \
    default-jdk \
    maven \
    helm \
    ufw \
    golang-go

# Clean up the package cache to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set default values for environment variables
ENV APP_NAME=${APP_NAME:-default_app_name}
ENV ENV=${ENV:-default_env}
ENV TEAM=Devops

# Print the environment variables to verify the values
RUN echo "APP_NAME: $APP_NAME"
RUN echo "ENV: $ENV"
RUN echo "TEAM: $TEAM"




ARG APP_NAME=default_app_name
ARG TEAM=Devops


# Set the default user to "root"
USER root

# Create the "REPOS" directory in the root user's home directory

RUN mkdir -p /root/REPOS

# Open the port range from 80 to 6000, excluding ports 3030, 4878, and 4596
RUN iptables -A INPUT -p tcp --dport 80:6000 -j ACCEPT && \
    iptables -D INPUT -p tcp --dport 3030 -j ACCEPT && \
    iptables -D INPUT -p tcp --dport 4878 -j ACCEPT && \
    iptables -D INPUT -p tcp --dport 4596 -j ACCEPT


# Create the "REPOS" directory in the root user's home directory
RUN mkdir -p /root/REPOS

# Create the "GIT" directory under the "REPOS" directory
RUN mkdir -p /root/REPOS/GIT

# Clone the specified GitHub repositories into the "GIT" directory
RUN git clone https://github.com/devopseasylearning/KFC-app.git /root/REPOS/GIT/KFC-app && \
    git clone https://github.com/devopseasylearning/awesome-compose.git /root/REPOS/GIT/awesome-compose && \
    git clone https://github.com/devopseasylearning/production-deployment.git /root/REPOS/GIT/production-deployment


# Copy the "K8S backend" directory from the local host into the default directory
COPY K8S\ backend /root

# Create the "FRONTEND" directory under the default directory
RUN mkdir -p /root/FRONTEND

# Copy the "frontend" directory into the "FRONTEND" directory
COPY frontend /root/FRONTEND

# Create a user called "builder"
RUN useradd -m builder

# Set "builder" as the default user
USER builder

# Set the first command to run when the container starts as "/bin/bash"
CMD ["/bin/bash"]

