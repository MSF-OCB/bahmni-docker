#!/bin/bash -e

yum install -y git

source ./config.sh

${BAHMNI} stop
ansible-playbook -i ${INVENTORY} /ansible/bahmni_stop.yml

ansible-playbook -i ${INVENTORY} /ansible/post_install.yml

#ansible-playbook -i ${INVENTORY} /ansible/bahmni_start.yml
#${BAHMNI} update-config
#ansible-playbook -i ${INVENTORY} /ansible/bahmni_stop.yml

if [ -f ${IMPL_SPEC_PLAYBOOK} ]; then
  ${BAHMNI} --implementation_play=${IMPL_SPEC_PLAYBOOK} install-impl
fi

yum remove -y git
yum clean all

rm -rf /var/log/*
rm -rf /opt/*.rpm
rm -rf /{bahmni_tmp,selinux,srv,media}
rm -rf /var/cache/yum
rm -rf /tmp/*
mkdir -p /var/log/httpd

