#!/bin/bash -e

source ./config.sh

ansible-playbook -i ${INVENTORY} /ansible/post_install.yml

yum clean all

rm -rf /var/log/*
rm -rf /opt/*.rpm
rm -rf /{bahmni_tmp,selinux,srv,media}
rm -rf /var/cache/yum
rm -rf /tmp/*
mkdir -p /var/log/httpd

