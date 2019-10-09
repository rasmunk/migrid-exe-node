FROM centos:centos7

ARG USER=mig
ARG FUSE_GID=599
ARG DEV_MODE=1

USER root
WORKDIR /root

RUN yum update -y \
	&& yum install -yq epel-release

RUN yum install -y \
	openssh \
	openssh-server \
	fuse \
	fuse-sshfs \
	iputils \
	net-tools \
	bind-utils

RUN echo -e "\n\n\n" | ssh-keygen -t rsa -N '' \
	&& ln -s /root/.ssh/id_rsa /etc/ssh/ssh_host_rsa_key

# Require only regular rsa key for sshd
RUN sed 's/HostKey \/etc\/ssh\/ssh_host_ecdsa_key/#HostKey \/etc\/ssh\/ssh_host_ecdsa_key/g' -i /etc/ssh/sshd_config \
	&& sed 's/HostKey \/etc\/ssh\/ssh_host_ed25519_key/#HostKey \/etc\/ssh\/ssh_host_ed25519_key/g' -i /etc/ssh/sshd_config

# If def mode, disable StrictHostKeyChecking ssh checking
RUN if [ $DEV_MODE -eq 0 ]; then sed 's/#   StrictHostKeyChecking ask/StrictHostKeyChecking no/g' -i /etc/ssh/ssh_config; fi

RUN adduser $USER
USER $USER
WORKDIR /home/$USER

RUN echo -e "\n\n\n" | ssh-keygen -t rsa -N ''

USER root
WORKDIR /root

# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]


CMD ["/usr/sbin/sshd", "-D"]
