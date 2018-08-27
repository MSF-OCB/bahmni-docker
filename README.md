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
IMG="<img name>:<version>"
HOST="<target_host>"
docker save localhost:5000/${IMG} | 7za a -t7z -m0=lzma2 -ms=on -mx=9 -si ${IMG}.tar.7z
eval $(ssh-agent)
false; while [ $? -ne 0 ]; do rsync --partial --delay-updates --progress --rsync-path="sudo rsync" -e "ssh -F $HOME/.ssh/config" ${IMG}.tar.7z ${HOST}:/opt/; done
```

On the receiving machine (called "target_host" above): (in /opt)
```
cd /opt
7za x -so <img name>-<version>.tar.7z | docker load
```

To copy between the active and the passive, copy your (passphrase protected!!) private key onto the sending server and run:
```
rsync --partial --delay-updates --progress --rsync-path="sudo rsync" -e "ssh -i .ssh/id_ec" /opt/<img name>-<version>.tar.7z bahmni-passive.msf.org:/opt/
```
Or use `bahmni.msf.org` as host name for the other direction.
