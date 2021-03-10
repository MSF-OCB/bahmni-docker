# Bahmni-docker
Clone the bahmni-docker-compose repo:
```
git clone https://github.com/MSF-OCB/bahmni-docker-compose/ bahmni
```

Clone this repo:
```
cd bahmni
git clone https://github.com/MSF-OCB/Bahmni-docker/ bahmni
```
Clone the playbooks repo:
```
git clone -b docker-dev-0.xx https://github.com/MSF-OCB/bahmni-playbooks bahmni/artifacts/bahmni-playbooks
```

Create a dummy environment file with `vim .env` with the following content:
```
image_name=bahmni_test
image_version=0
bahmni_implementation_name=none
bahmni_openelis_enabled=false
bahmni_reports_enabled=true
bahmni_skip_backups=true
bahmni_installer_url=https://dl.bintray.com/bahmni/rpm/rpms/bahmni-installer-0.91-89.noarch.rpm
bahmni_implementation_repo=https://github.com/msf-ocb/karachi-bahmni-config
bahmni_implementation_branch=master
```

Put dummy key files in place:
```
touch bahmni/artifacts/keys/bahmni_key
touch bahmni/artifacts/keys/bahmni_key.pub
```
Download the patched webservices module:
```
curl https://dl.bintray.com/openmrs/omod/webservices.rest-2.24.0.omod -o bahmni/artifacts/misc/webservices.rest-2.24.0.omod
```

Build an image by running
```
docker-compose -f docker-compose.yml -f docker-compose.build.yml build
```

