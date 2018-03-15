#!/bin/bash -e

source ./config.sh

function restart_openmrs_delayed() {
  sleep 90
  service openmrs restart
}

ansible-playbook -i ${INVENTORY} /ansible/bahmni_start.yml
${BAHMNI} start
#${BAHMNI} update-config

restart_openmrs_delayed &

