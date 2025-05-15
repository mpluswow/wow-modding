---

# 🛠 AzerothCore Manual Installation Guide (Ubuntu/Debian)

This guide explains **each command manually**, so you can follow along without running a script. It covers:

* Dependencies
* Cloning AzerothCore and selected modules
* Building the core
* Setting up MySQL
* Creating systemd services

---

## ✅ Step 1: Update System Packages

```bash
sudo apt update && sudo apt upgrade -y
```

📌 Updates the package list and upgrades all installed packages to the latest versions.

---

## ✅ Step 2: Install Required Dependencies

```bash
sudo apt install -y git cmake make gcc g++ clang \
  libmysqlclient-dev libssl-dev libbz2-dev libreadline-dev \
  libncurses-dev mysql-server libboost-all-dev dialog zip unzip wget
```

📌 These tools and libraries are required to build AzerothCore and run MySQL.

---

## ✅ Step 3: Create a Server Directory

```bash
mkdir -p ~/server
```

📌 Creates a folder named `server` in your home directory to contain AzerothCore files.

---

## ✅ Step 4: Set Up a Variable for Code Path

```bash
export AC_CODE_DIR=~/server/azerothcore
```

📌 Defines the path to where the AzerothCore source code will be stored.

---

## ✅ Step 5: Clone the AzerothCore Repository

```bash
git clone https://github.com/azerothcore/azerothcore-wotlk.git --branch master --single-branch $AC_CODE_DIR
```

📌 Downloads the AzerothCore source code (WotLK branch) to your directory.

---

## ✅ Step 6: Create a Build Directory

```bash
mkdir -p $AC_CODE_DIR/build
```

📌 Prepares a folder for compiling the source code separately from the source.

---

## ✅ Step 7: Choose and Clone Modules (Optional)

Manually pick the modules you want:

```bash
cd $AC_CODE_DIR/modules
git clone https://github.com/azerothcore/mod-world-chat
git clone https://github.com/azerothcore/mod-eluna
# ... Add more as needed
```

📌 These add extra features to your server. If the `modules` folder doesn't exist, create it with `mkdir -p $AC_CODE_DIR/modules`.

---

## ✅ Step 8: Build AzerothCore

```bash
cd $AC_CODE_DIR/build

cmake ../ \
  -DCMAKE_INSTALL_PREFIX=$AC_CODE_DIR/env/dist/ \
  -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  -DWITH_WARNINGS=1 \
  -DTOOLS_BUILD=all \
  -DSCRIPTS=static \
  -DMODULES=static

make -j$(nproc --all)
make install
```

📌 Compiles AzerothCore using Clang. Adjust the `-j` flag depending on your CPU threads. `make install` puts the built files into `env/dist`.

---

## ✅ Step 9: Download Game Data

```bash
cd $AC_CODE_DIR/env/dist/bin/
mkdir -p data
wget https://github.com/wowgaming/client-data/releases/download/v16/data.zip
unzip data.zip -d data
rm data.zip
```

📌 This fetches and extracts required client data like maps, vmaps, and dbc files.

---

## ✅ Step 10: Configure `worldserver.conf`

```bash
cd $AC_CODE_DIR/env/dist/etc/
cp worldserver.conf.dist worldserver.conf
sed -i 's|^DataDir = "."|DataDir = "./data"|' worldserver.conf
```

📌 This sets up the main config for the world server and points it to the data files.

---

## ✅ Step 11: Configure `authserver.conf`

```bash
cp authserver.conf.dist authserver.conf
```

📌 Same as above, but for the authentication server.

---

## ✅ Step 12: Create MySQL User

```bash
sudo mysql -u root <<EOF
CREATE USER IF NOT EXISTS 'acore'@'localhost' IDENTIFIED BY 'acore';
GRANT ALL PRIVILEGES ON acore_auth.* TO 'acore'@'localhost';
GRANT ALL PRIVILEGES ON acore_characters.* TO 'acore'@'localhost';
GRANT ALL PRIVILEGES ON acore_world.* TO 'acore'@'localhost';
FLUSH PRIVILEGES;
EOF
```

📌 This creates a MySQL user called `acore` with access to the three AzerothCore databases.

---

## ✅ Step 13: Create systemd Services

🔧 Replace `$USER` with your Linux username:

```bash
INSTALL_PATH="$HOME/server/azerothcore/env/dist/bin"
RUN_USER=$(whoami)
```

Create `authserver.service`:

```bash
sudo nano /etc/systemd/system/authserver.service
```

Paste:

```ini
[Unit]
Description=AzerothCore Auth Server
After=network.target mysql.service mariadb.service

[Service]
Type=simple
User=YOUR_USERNAME
WorkingDirectory=YOUR_PATH
ExecStart=YOUR_PATH/authserver
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Create `worldserver.service`:

```bash
sudo nano /etc/systemd/system/worldserver.service
```

Paste:

```ini
[Unit]
Description=AzerothCore World Server
After=network.target mysql.service mariadb.service

[Service]
Type=simple
User=YOUR_USERNAME
WorkingDirectory=YOUR_PATH
ExecStart=YOUR_PATH/worldserver
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

📌 Replace `YOUR_USERNAME` with your Linux user and `YOUR_PATH` with `$INSTALL_PATH`.

---

## ✅ Step 14: Enable and Start Services

```bash
sudo systemctl daemon-reload
sudo systemctl enable authserver
sudo systemctl enable worldserver

sudo systemctl start authserver
sudo systemctl start worldserver
```

📌 This registers the services and starts them. They will auto-start on reboot.

---

## ✅ Done! 🎉

Your binaries are here:

```
~/server/azerothcore/env/dist/bin/worldserver
~/server/azerothcore/env/dist/bin/authserver
```

Your config files are in:

```
~/server/azerothcore/env/dist/etc/
```

To restart:

```bash
sudo systemctl restart authserver
sudo systemctl restart worldserver
```



### AzerothCore Installation Script

This folder contains a Bash script that automates the setup and installation of `AzerothCore`.

You can automatically clone Modules that You want to install. 

### Usage:
```bash
sudo chmod +x ac-install.sh
```
```bash
sudo ./ac-install.sh 
```









