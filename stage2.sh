#!/bin/bash -e

yum install -y git python-netaddr
pip install --upgrade jinja2

source ./config.sh

ansible-playbook -i ${INVENTORY} /ansible/post_install.yml

if [ -f ${IMPL_SPEC_PLAYBOOK} ]; then
  ${BAHMNI} --implementation_play=${IMPL_SPEC_PLAYBOOK} install-impl
fi

yum remove -y git
yum clean all

# For the replication to work, active and passive need a different server uuid
# We delete the file with the auto-generated server uuid so that it gets
# regenerated on the next run when we start the image with an empty volume.
rm -rf /var/lib/mysql/auto.cnf

rm -rf /var/log/*
rm -rf /var/run/*
rm -rf /opt/*.rpm
rm -rf /{bahmni_tmp,selinux,srv,media}
rm -rf /var/cache/yum
rm -rf /tmp/*
mkdir -p /var/log/httpd
mkdir -p /var/run/httpd

