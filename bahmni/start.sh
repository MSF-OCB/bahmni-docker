#!/bin/bash -e

source ./config.sh

function restart_openmrs_delayed() {
  sleep 90
  service openmrs restart
}

ansible-playbook -i ${INVENTORY} /ansible/bahmni_start.yml

case $1 in
active)
  ${BAHMNI} start
  #${BAHMNI} update-config
  ${BAHMNI} setup-mysql-replication
  ${BAHMNI} setup-postgresql-replication

  restart_openmrs_delayed &

  tail -F /var/log/openmrs/openmrs.log /var/log/bahmni-lab/bahmni-lab.log /var/log/bahmni-reports/bahmni-reports.log
  ;;
passive)
  tail -F /var/log/mysqld.log
  ;;
*)
  echo 'Use "active" or "passive" as parameter.'
  exit 1

esac

