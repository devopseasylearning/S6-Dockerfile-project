## S6 DOCKERFILE PROJECT DUE NEXT CLASS

```
BEFORE YOU START WORKING ON THIS 

a- Make sure you have access to the following git repository if not request access Here:  https://docs.google.com/spreadsheets/d/1zpubMjtNEx2Nx9hNbmoMRMzpXfhInWIWBSJoQU-njwI/edit?usp=sharing
b- Create your own branch from the de develop with you prefer_name 
c- There is an empty Dockefile inside the directory all your work should be done there 
d- Once you are done with your work create a MR and assign it to 2 of your colleagues
```





```
Teams in order to remain consistant in how we deploy application at Devops easylearning I did some researches yesterday and to mimic what others companies are 
doing out there,  to easy the  hassle and stress  of application deployment, we can launch a master deployment container that contain all required packages pertinent to the 
deployment of all our application. 
The benefit of this is :
   1- a single master deployment container will be called for all application 
   2-  this will cut engineering time since we will have only once master deplyment container to mainting
   3- a single Dockerfile will be used as deployment for all application 

to make thing easy on us and to speed the build time and deployment process I have done research and opted for a very light container that will be using 
ubuntu 

here are the instruction need for the image

* the base image tag version should defined by the user at build time ( hint try to set it up with ARG )
* base image ubuntu 
* set the company DEVOPS EASY LEARNING  as the sole owner of the image
* install the following package 
   *  ansible
   *  curl
   *  git
   *  gnupg
   *  jq
   *  linux-headers
   *  openssh-client
   *  postgresql-client
   *  python3
   *  kubectl
   *  kubens
   *  nodejs
   *  npm                        
   *  vim
   *  wget
   * pip
   *  net-tools
   *  iputils-ping
   *  terraform 
   *  awscli
   * default-jre
   * default-jdk
   * maven
   * helm
   * ufw
   * git
   * go
* the default directory should be set to "BUILDER"
* create the following environment variable 
   APP_NAME    # this varibale name should be enter by the user at build time 
   ENV        # this varibale name should be enter by the user at build time 
   TEAM=Devops 
* set the default user to be "root" at this point 
* create a directory called "REPOS"  and under root user home directory
* open port range from "80 to 6000" make sure to excluse "3030 4878 4596 "
* create a directory called GIT under the REPOS  you just create above
* copy  the following repository under a directory called GIT located at "/root/REPOS"
      * https://github.com/devopseasylearning/KFC-app.git
      * https://github.com/devopseasylearning/awesome-compose.git 
      * https://github.com/devopseasylearning/production-deployment.git

* copy directy K8S backend under the default directory 
* create a directory called FRONTEND under the default directory and copy frontend directory inside 
* create a user called  "builder" and make himas the default user
* the first command to run when the container start should be "/bin/bash"
```


## HOW TO THEST THE DOCKERFILE

```
1- login to one of the school server please make sure you are not in your terminal it will not work 

2- run the following command:  
           rm -rf S6-Dockerfile-project.git  || true 

3- run the following command:   
           git clone  https://github.com/devopseasylearning/S6-Dockerfile-project.git 

4- run the following command:  
           cd S6-Dockerfile-project.git 

5- run the following command: 
          git checkout [ENTER YOUR PREFER NAME HERE]
6-  run the following command:      docker login -u devopseasylearning                
       PS: you will be prompt to enter the password if you dont know the password get it from your student account under tools section.
7-  run the following command:  
             docker build --build-arg [ENTER THE TAG ARGUMENT HERE]=22.04  \
              --build-arg APP_NAME=S6 \
              --build-arg APP_NAME="learning_dockerfile" \
              -t  devopseasylearning/[ENTER YOUR PREFER NAME HERE]:V1.0.1 .
8- run the following command: 
              docker push devopseasylearning/[ENTER YOUR PREFER NAME HERE]:V1.0.1
```
