# Use the latest PyTorch image as base
FROM ubuntu


# Install vim
RUN apt-get update && apt-get install -y vim iputils-ping iproute2 sudo openssh-server

# Create user and set password for user and root user
RUN  useradd -rm --create-home -s /bin/bash -g root -G sudo -u 1000 cs744 && \
    echo 'cs744:cs744' | chpasswd && \
    echo 'root:cs744' | chpasswd
#RUN echo 'root:cs744' | chpasswd
    

# Set working directory to root's home

# Set up configuration for SSH
RUN mkdir /var/run/sshd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile

# Expose the SSH port
EXPOSE 22

# Run SSH

# Copy authorized_keys file into the container

ENTRYPOINT service ssh restart && bash

WORKDIR /home/cs744

CMD ["/usr/sbin/sshd", "-D"]
