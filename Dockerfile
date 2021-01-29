FROM centos:6
MAINTAINER ehealthsupport@brussels.msf.org

COPY artifacts/centos/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
RUN yum install -y wget && \
                   wget https://dl.fedoraproject.org/pub/archive/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
                   rpm -ivh epel-release-6-8.noarch.rpm && \
    yum install -y sudo \
                   crontabs \
                   python \
                   p7zip \
                   openssh-server \
                   rsync \
                   python-pip \
                   ansible && \
    yum clean all

COPY stage1/ /ansible/
COPY stage1.sh /tmp/
COPY artifacts/bahmni-playbooks/ /tmp/artifacts/bahmni-playbooks/
COPY config.sh inventory /
COPY artifacts/misc_stage1/ /opt/

ARG BAHMNI_IMPL_NAME
ARG BAHMNI_TIMEZONE
ARG BAHMNI_INSTALLER_URL
ARG BAHMNI_OPENELIS_ENABLED
ARG BAHMNI_REPORTS_ENABLED
ARG BAHMNI_OPENMRS_USERNAME
ARG BAHMNI_OPENMRS_PASSWORD
ARG BAHMNI_OPENELIS_USERNAME
ARG BAHMNI_OPENELIS_PASSWORD
ARG BAHMNI_REPORTS_USERNAME
ARG BAHMNI_REPORTS_PASSWORD

RUN bash -e /tmp/stage1.sh

COPY stage2/ /ansible/
COPY stage2.sh /tmp/
COPY artifacts/keys/ /tmp/artifacts/keys/
COPY artifacts/omods/ /tmp/artifacts/omods/
COPY artifacts/misc/ /tmp/

# Disable caching by copying a changing file. Use "date > marker" to update the file.
# This is to force the git repo for the config to be cloned every time.
# The glob means the file is optional but COPY needs to copy at least one file,
# so we add this to the copy instruction for start.sh to make sure something will always be copied.
COPY start.sh marker* /

ARG BAHMNI_IMPLEMENTATION_REPO
ARG BAHMNI_IMPLEMENTATION_BRANCH

RUN bash -e /tmp/stage2.sh

# https://vsupalov.com/docker-build-time-env-values/

