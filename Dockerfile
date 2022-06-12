FROM python:2.7-slim-buster

RUN apt-get update && \
    apt-get install -y gcc file make libcurl4-openssl-dev libssl-dev openssh-server curl wget && \
    apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /srv

RUN echo 'root:password' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
# RUN mkdir /run/sshd
RUN service ssh start
EXPOSE 22
EXPOSE 8787
CMD ["/usr/sbin/sshd", "-D"]
