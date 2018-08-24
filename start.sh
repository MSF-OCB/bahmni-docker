#!/bin/bash -e

source ./config.sh

# Function to cleanly stop the container
function teardown {
  ${BAHMNI} stop || true
  ansible-playbook -i ${INVENTORY} /ansible/bahmni_stop.yml
  exit 0
}

# Properly trap the SIGTERM signal to cleanly stop the docker container
# Make sure this script is running as PID 1 in the container!
#trap teardown SIGTERM

# Make a file to source from cron scripts to have the bahmni specific env vars available
printenv | egrep "^BAHMNI" | sed 's/^\(.*\)$/export \1/g' | tee /cron_env.sh

ansible-playbook -i ${INVENTORY} /ansible/bahmni_start.yml

case $1 in
"active")
  case $2 in
  "true" | "True" | "yes" | "Yes" | "false" | "False" | "no" | "No")
    ;;
  *)
    echo "Accepted values for second parameter: true, True, yes, Yes, false, False, no, No. "
    exit 1
  esac

  CONFIG_UPDATED_FILE="/config_updated"
  if [ ! -f ${CONFIG_UPDATED_FILE} ]; then
    ${BAHMNI} update-config
    touch ${CONFIG_UPDATED_FILE}
  fi

  ${BAHMNI} start

  tail -F /var/log/openmrs/openmrs.log /var/log/bahmni-lab/bahmni-lab.log /var/log/bahmni-reports/bahmni-reports.log
  ;;
"passive")
  tail -F /var/log/mysqld.log
  ;;
*)
  echo 'Use "active" or "passive" as first argument.'
  exit 1

esac

