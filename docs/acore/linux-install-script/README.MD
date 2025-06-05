### AzerothCore Installation Script

This folder contains a Bash script that automates the setup and installation of `AzerothCore`.


### Usage:
```bash
sudo chmod +x ac-install.sh
```
```bash
sudo ./ac-install.sh 
```

### Post Installation
Important!

Before You run it as a service complete AzerothCore database installation,
run ```./worldserver``` and allow it to update Your database for the first time.

Your binaries are here:
```
server/azerothcore/env/dist/bin/worldserver
server/azerothcore/env/dist/bin/authserver
```

Your config files are in:

```
server/azerothcore/env/dist/etc/
server/azerothcore/env/dist/etc/modules
```


```bash
sudo systemctl restart authserver
sudo systemctl restart worldserver
```

