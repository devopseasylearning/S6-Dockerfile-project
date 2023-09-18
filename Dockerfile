# Create a directory called "GIT" under "/root/REPOS"
RUN mkdir -p /root/REPOS/GIT

# Copy repositories to "/root/REPOS/GIT"
COPY KFC-app /root/REPOS/GIT/
COPY awesome-compose /root/REPOS/GIT
COPY production-deployment /root/REPOS/GIT/

# Copy K8S backend to the default directory
COPY K8S /BUILDER/
COPY backend /BUILDER/

# Create a directory called "FRONTEND" under the default directory and copy frontend directory inside
RUN mkdir -p /BUILDER/FRONTEND
COPY frontend /BUILDER/FRONTEND

# Create a user called "builder" and make it the default user
RUN useradd -ms /bin/bash builder
USER builder

# Specify the default command to run when the container starts
CMD ["/bin/bash"]
