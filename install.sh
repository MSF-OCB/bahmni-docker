#!/bin/bash -e

yum install -y python-pip ansible git

source ./config.sh

ansible-playbook -i ${INVENTORY} /ansible/bahmni_install.yml
${BAHMNI} install
if [ -f ${IMPL_SPEC_PLAYBOOK} ]; then
  ${BAHMNI} --implementation_play=${IMPL_SPEC_PLAYBOOK} install-impl
fi


${BAHMNI} stop
ansible-playbook -i ${INVENTORY} /ansible/bahmni_stop.yml

yum remove -y git
yum clean all

rm -rf /var/log/*
rm -rf /opt/*.rpm
rm -rf /{bahmni_tmp,selinux,srv,media}
rm -rf /var/cache/yum
rm -rf /tmp/*
mkdir -p /var/log/httpd

