FROM centos:6
MAINTAINER ehealthsupport@brussels.msf.org

#RUN yum install -y epel-release && \
#    yum update -y && \
#    yum clean all

RUN yum install -y epel-release && \
    yum install -y sudo \
                   crontabs \
                   python \
                   p7zip \
                   rsync && \
    yum clean all

COPY config.sh /
COPY ansible/ /ansible/
COPY artifacts/ /tmp/artifacts/
COPY install.sh /tmp/

ARG impl_file_suffix
COPY inventory_${impl_file_suffix} /inventory

RUN bash -e /tmp/install.sh

COPY start.sh /

# https://vsupalov.com/docker-build-time-env-values/
ENV impl_file_suffix=$impl_file_suffix

