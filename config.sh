INVENTORY=/inventory
IMPL_SPEC_PLAYBOOK=/etc/bahmni-installer/deployment-artifacts/${BAHMNI_IMPL_NAME}_config/playbooks/all.yml
ANSIBLE_RPM_URL="/$(rpm -q ansible)"
BAHMNI="bahmni -i local --ansible_rpm_url ""${ANSIBLE_RPM_URL}"

