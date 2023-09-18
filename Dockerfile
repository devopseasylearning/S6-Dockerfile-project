# Use ARG to define a build-time argument for the base image tag
ARG BASE_IMAGE_TAG=latest

# Use the base image with the specified tag
FROM ubuntu:${BASE_IMAGE_TAG}

# Set the default user to root
USER root

# Set a default value for BASE_IMAGE_TAG if not provided during build
ARG BASE_IMAGE_TAG=latest

# Define build-time arguments for APP_NAME and ENV
ARG APP_NAME
ARG ENV

# Set environment variables based on the build-time arguments
ENV APP_NAME=$APP_NAME
ENV ENV=$ENV

# Set a default value for TEAM
ENV TEAM=Devops

# When building the Docker image, users can provide values for APP_NAME and ENV using the --build-arg flag as follows:
#docker build --build-arg APP_NAME=myapp --build-arg ENV=production --build-arg TEAM=Devops-t my-custom-image:1.0 .

# Set the default working directory to "BUILDER"
WORKDIR /BUILDER

# Create the "REPOS" directory under the root user's home directory
RUN mkdir -p /root/REPOS

# Create the "GIT" directory under the "REPOS" directory
RUN mkdir -p /root/REPOS/GIT

#create a directory called FRONTEND under the default directory
RUN mkdir FRONTEND

# Copy frontend directory inside FRONTEND
COPY ../frontend ./FRONTEND

# Clone the specified repositories into the "GIT" directory
RUN git clone https://github.com/devopseasylearning/KFC-app.git /root/REPOS/GIT/KFC-app && \
    git clone https://github.com/devopseasylearning/awesome-compose.git /root/REPOS/GIT/awesome-compose && \
    git clone https://github.com/devopseasylearning/production-deployment.git /root/REPOS/GIT/production-deployment


# Copy the "K8S backend"
COPY ../K8S .
COPY ../backend . 

# When the image is being built, kindly remember to specify the tag image version, else the build will be
# reverted to the latest ubuntu version specified in line 8. You can do this tag specification by adding
# the tag variable during your image build  by using the below example as follows;
# docker build --build-arg BASE_IMAGE_TAG=20.04 -t my-custom-image:1.0 .

# Metadata indicating the image maintainer
LABEL maintainer="DEVOPS EASY LEARNING <contact@devopseasylearning.com>"

# Update the package list and install essential packages
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
    python3-pip \
    wget \
    net-tools \
    iputils-ping \
    && apt-get clean

# Enable the firewall
RUN ufw --force enable

# Allow ports 80 to 6000 and exclude ports 3030, 4878, and 4596
RUN ufw allow 80:6000/tcp && \
    ufw delete allow 3030/tcp && \
    ufw delete allow 4878/tcp && \
    ufw delete allow 4596/tcp


# Install Node.js and npm
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean

# Install kubectl and kubens
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/ && \
    curl -LO https://github.com/ahmetb/kubectx/releases/download/v0.9.1/kubens && \
    chmod +x kubens && \
    mv kubens /usr/local/bin/

# Install Vim and Terraform
RUN apt-get install -y vim && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && \
    apt-get install -y terraform && \
    apt-get clean

# Install AWS CLI
RUN curl "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

# Install default JRE and JDK, Maven, Helm, UFW, Git, Go
RUN apt-get install -y default-jre default-jdk maven helm ufw git golang && \
    apt-get clean

# Clone the specified repositories into the "GIT" directory
RUN git clone https://github.com/devopseasylearning/KFC-app.git /root/REPOS/GIT/KFC-app && \
    git clone https://github.com/devopseasylearning/awesome-compose.git /root/REPOS/GIT/awesome-compose && \
    git clone https://github.com/devopseasylearning/production-deployment.git /root/REPOS/GIT/production-deployment


# Cleanup
RUN rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get clean

# Create a user named "builder" and make him as the default user
RUN useradd -ms /bin/bash builder

# Set the default user to "builder"
USER builder

# Set the default/first command to be "/bin/bash" to run when the container starts
CMD ["/bin/bash"]