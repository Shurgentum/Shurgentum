FROM ubuntu:latest

# ! Arguments must be provided to corretly build this image
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
RUN apt-get -y install net-tools sudo


# Add new semi-privileged user
RUN useradd --create-home ${remoteuser}
RUN adduser ${remoteuser} sudo
# RUN echo "${remoteuser}:${remoteuserpassoword}" | chpasswd
RUN echo ${remoteuser}:${remoteuserpassword} | chpasswd
RUN usermod -s /bin/bash ${remoteuser}

# Force user to change password after login
RUN passwd --expire ${remoteuser}


CMD [ "/usr/sbin/sshd", "-D"]
