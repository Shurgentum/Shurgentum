#! Warning! Following implementation is not fully tested for security! Do not give access to untrusted third-party 
#? Needs connection to host docker deameon to include pseudo "dind" functionality
#? to use pseudo dind enter following command:
#* docker container run -it -p [PORT]:22 -v /var/run/docker.sock:/var/run/docker.sock [IMAGENAME]

#! Warning! Following implementation causes serious security flaw! Do not give access to untrusted third-party 
#? To launch "true" dind --privileged flag need to be specified
#? to use true dind enter following command:
#* docker container run -it -p [PORT]:22 --privileged [IMAGENAME]

#? to use dind inner docker deamon need to be lauched
#? in orded to do that enter following command inside a container
#* dockerd &> dockerd-logfile &

FROM ubuntu:latest


ARG remoteuser=remoteuser
ARG remoteuserpassword=remoteuserpassword

# Update to latest
RUN apt-get update && apt-get -y upgrade

# Setting up ssh service
RUN apt-get -y install openssh-server openssh-client
RUN mkdir /var/run/sshd
RUN sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

EXPOSE 22

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Installing other packages
RUN apt-get -y install net-tools sudo curl


# Add new semi-privileged user
RUN useradd --create-home ${remoteuser}
RUN adduser ${remoteuser} sudo
# RUN echo "${remoteuser}:${remoteuserpassoword}" | chpasswd
RUN echo ${remoteuser}:${remoteuserpassword} | chpasswd
RUN usermod -s /bin/bash ${remoteuser}


# Install docker
RUN curl -fsSL https://get.docker.com | sh
RUN usermod -aG docker ${remoteuser}


# Force user to change password after login
RUN passwd --expire ${remoteuser}


CMD ["/usr/sbin/sshd", "-D"]
