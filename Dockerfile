FROM ubuntu

RUN apt-get update && apt-get install -y vim iputils-ping iproute2 sudo openssh-server

RUN  useradd -rm --create-home -s /bin/bash -g root -G sudo -u 1000 cs744 && \
    echo 'cs744:cs744' | chpasswd && \
    echo 'root:cs744' | chpasswd

RUN mkdir /var/run/sshd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22

RUN mkdir -p /home/cs744/.ssh
COPY authorized_keys /home/cs744/.ssh/authorized_keys
RUN chown -R cs744 /home/cs744

ENTRYPOINT service ssh restart && bash

WORKDIR /home/cs744

CMD ["/usr/sbin/sshd", "-D"]
