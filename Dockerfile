FROM centos:6
MAINTAINER ehealthsupport@brussels.msf.org

RUN yum install -y epel-release && \
    yum install -y sudo \
                   crontabs \
                   python \
                   p7zip \
                   openssh-server \
                   rsync \
                   python-pip \
                   ansible && \
    yum clean all

COPY config.sh /
COPY stage1/ /ansible/
COPY artifacts/ /tmp/artifacts/
COPY install.sh /tmp/

ARG BAHMNI_IMPL_FILE_SUFFIX
COPY inventory_${BAHMNI_IMPL_FILE_SUFFIX} /inventory

ARG BAHMNI_INSTALLER_URL
ARG BAHMNI_IMPLEMENTATION_REPO
ARG BAHMNI_IMPLEMENTATION_BRANCH
ARG BAHMNI_POSTGRES_PRESENT
RUN bash -e /tmp/install.sh

COPY stage2/ /ansible/
COPY keys /tmp/artifacts/keys/
COPY omods/ /tmp/artifacts/omods/
COPY post_install.sh /tmp/
RUN bash -e /tmp/post_install.sh

COPY start.sh /

# https://vsupalov.com/docker-build-time-env-values/

