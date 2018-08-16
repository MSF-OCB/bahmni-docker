# Bahmni-docker
Docker setup for Bahmni

Create the target directory in `/opt`:
```
sudo mkdir -p /opt/bahmni
```

Give permissions to the required users:
```
sudo setfacl -m "u:<username>:rwX" /opt/bahmni
sudo setfacl -m "d:u:<username>:rwX" /opt/bahmni
```

Clone this repo:
```
git clone https://github.com/MSF-OCB/Bahmni-docker/ /opt/bahmni
```

If you have trouble login in, you can also copy your (passphrase protected!!) ssh key to the server, add it to your github account and clone via ssh:
```
git clone git@github.com:MSF-OCB/Bahmni-docker.git /opt/bahmni/
```

Clone the playbooks repo:
```
git clone -b docker-dev https://github.com/MSF-OCB/bahmni-playbooks /opt/bahmni/bahmni/artifacts/bahmni-playbooks
```
or
```
git clone -b docker-dev git@github.com:MSF-OCB/bahmni-playbooks.git /opt/bahmni/bahmni/artifacts/bahmni-playbooks
```

# Copy the docker image by rsync

On the build machine:
```
docker save -o <image_name>.tar localhost:5000/<image>:<version>
7za a -t7z -m0=lzma2 -ms=on -mx=9 <image_name>.tar.7z <image_name>.tar
rsync --partial --progress --delay-updates --rsync-path="sudo rsync" -e "ssh -F $HOME/.ssh/config" <image_name>.tar.7z <target_host>:/opt/
```

On the receiving machine (called "target_host" above): (in /opt)
```
cd /opt
7za x <image_name>.tar.7z
docker load -i <image_name>.tar
```
