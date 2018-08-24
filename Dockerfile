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

COPY artifacts/certs/ /tmp/artifacts/certs/
COPY stage1/ /ansible/
COPY stage1.sh /tmp/
COPY artifacts/bahmni-playbooks/ /tmp/artifacts/bahmni-playbooks/
COPY config.sh /

ARG BAHMNI_IMPL_NAME
COPY inventories/inventory_${BAHMNI_IMPL_NAME} /inventory

ARG BAHMNI_TIMEZONE
ARG BAHMNI_INSTALLER_URL
ARG BAHMNI_IMPLEMENTATION_REPO
ARG BAHMNI_IMPLEMENTATION_BRANCH
ARG BAHMNI_POSTGRES_PRESENT
RUN bash -e /tmp/stage1.sh

COPY stage2/ /ansible/
COPY stage2.sh /tmp/
COPY artifacts/keys/ /tmp/artifacts/keys/
COPY artifacts/omods/ /tmp/artifacts/omods/
COPY artifacts/misc/ /tmp/
COPY start.sh /

# Disable caching by copying a changing file into /dev/null.
# Use "date > marker" to update the file.
# This is to force the git repo for the config to be cloned every time.
COPY marker* /dev/null

RUN bash -e /tmp/stage2.sh

# https://vsupalov.com/docker-build-time-env-values/

