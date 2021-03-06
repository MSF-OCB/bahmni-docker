#!/bin/bash -e

yum install -y git

source ./config.sh

ansible-playbook -i ${INVENTORY} /ansible/bahmni_install.yml
${BAHMNI} install

${BAHMNI} stop
ansible-playbook -i ${INVENTORY} /ansible/bahmni_stop.yml

yum clean all

rm -rf /var/log/*
rm -rf /var/run/*
rm -rf /opt/*.rpm
rm -rf /{bahmni_tmp,selinux,srv,media}
rm -rf /var/cache/yum
rm -rf /tmp/*
mkdir -p /var/log/httpd
mkdir -p /var/run/httpd

