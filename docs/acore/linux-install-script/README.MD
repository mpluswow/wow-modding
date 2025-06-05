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
run ```./worldserver``` in ```server/azerothcore/env/dist/bin/```.

Allow AzerothCore to populate Your database and wait for it to finish.

When database installation is finished kill worldserver by pressing ```ctrl+c```.

Now start Services:

```bash
sudo systemctl start authserver
sudo systemctl start worldserver
```

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




