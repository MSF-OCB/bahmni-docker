FROM centos:centos6.9
MAINTAINER ehealthsupport@brussels.msf.org

# TODO install all repos and packages (mysql, postgres, python deps, ...
#  maybe even bahmni rpms) in this step already to make the next layer
#  smaller and have less downloads in the next layer.
RUN yum clean all && \
    yum install -y epel-release && \
    yum update -y && \
    yum clean all

# https://stackoverflow.com/questions/26279207/installing-pip-using-easy-install

COPY ansible/ /tmp/ansible/

WORKDIR /tmp/ansible

RUN yum install -y \
      sudo \
      python \
      python-pip \
      python-setuptools \
      ansible \
      p7zip \
      rsync \
    && \
    ansible-playbook -v bahmni_install.yml && \
    bahmni -i local --ansible_rpm_url "/ansible-2.4.2.0-1.el6.noarch" install && \
    bahmni -i local --ansible_rpm_url "/ansible-2.4.2.0-1.el6.noarch" --implementation_play=/var/www/bahmni_config/playbooks/all.yml install-impl && \
    rm -rf /tmp/ansible/artifacts && \
    rm -rf /tmp/ansible/variables.yml && \
    rm -rf /var/log/* \
    yum clean all

COPY ansible2 /tmp/ansible2

WORKDIR /tmp/ansible2

CMD ansible-playbook -v bahmni_launch.yml && tail -f /var/log/openmrs/openmrs.log

