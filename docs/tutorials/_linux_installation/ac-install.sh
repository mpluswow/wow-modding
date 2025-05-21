#!/bin/bash

# ────────────────────────────────────────────────────────
# AzerothCore Installation Script by Dreamforge
# ────────────────────────────────────────────────────────

echo -e "
\e[38;5;214m────────────────────────────────────────────────────────\e[0m
\e[1;97m       AzerothCore Installation Script\e[0m
\e[38;5;214m────────────────────────────────────────────────────────\e[0m

\e[1;97mThis script will:\e[0m

\e[1;97m  • Update system packages
  • Install all dependencies
  • Clone AzerothCore and selected modules
  • Build and install the core
  • Download required client data
  • Copy and configure server .conf files
  • Create 'acore' MySQL user with full DB access

After installation:
  • Binaries:      ~/server/azerothcore/env/dist/bin/
  • Config files:  ~/server/azerothcore/env/dist/etc/
  • Game data:     ~/server/azerothcore/env/dist/bin/data/\e[0m

\e[38;5;214m────────────────────────────────────────────────────────\e[0m
"

# Prompt user to continue
echo -e "\e[38;5;214mDo you want to start the AzerothCore installation now? (yes/no)\e[0m"
echo
read -r USER_CONFIRM

if [[ "$USER_CONFIRM" != "yes" ]]; then
    echo -e "\n\e[38;5;214mAborted by user.\e[0m"
    exit 1
fi

# Function to display info and wait
step() {
    echo -e "\n\n\e[38;5;214m[INFO] $1\e[0m"
    sleep 3
}

# Step 1: Update Repositories
step "Updating package repositories..."
sudo apt update && sudo apt upgrade -y

# Step 2: Install Dependencies
step "Installing required dependencies..."
sudo apt-get install -y git cmake make gcc g++ clang \
    libmysqlclient-dev libssl-dev libbz2-dev libreadline-dev \
    libncurses-dev mysql-server libboost-all-dev dialog zip unzip wget

# Step 3: Create the server directory
step "Creating server directory..."
mkdir -p $HOME/server

# Step 4: Set AzerothCore code directory path
export AC_CODE_DIR=$HOME/server/azerothcore

# Step 5: Clone AzerothCore repo
step "Cloning AzerothCore core repository..."
git clone https://github.com/azerothcore/azerothcore-wotlk.git --branch master --single-branch $AC_CODE_DIR

# Step 6: Create build directory
step "Creating build directory..."
mkdir -p $AC_CODE_DIR/build

# Step 7: Ask user which modules to install
step "Select which modules you want to install. Use space to select, then press Enter."
echo

declare -A MODULES=(
    ["mod-world-chat"]="https://github.com/azerothcore/mod-world-chat"
    ["mod-ip-tracker"]="https://github.com/azerothcore/mod-ip-tracker"
    ["mod-starter-guild"]="https://github.com/azerothcore/mod-starter-guild"
    ["mod-1v1-arena"]="https://github.com/azerothcore/mod-1v1-arena"
    ["mod-npc-buffer"]="https://github.com/azerothcore/mod-npc-buffer"
    ["mod-weapon-visual"]="https://github.com/azerothcore/mod-weapon-visual"
    ["mod-transmog"]="https://github.com/azerothcore/mod-transmog"
    ["mod-breaking-news"]="https://github.com/azerothcore/mod-breaking-news-override"
    ["mod-ah-bot"]="https://github.com/azerothcore/mod-ah-bot"
    ["mod-eluna"]="https://github.com/azerothcore/mod-eluna"
    ["mod-account-mounts"]="https://github.com/azerothcore/mod-account-mounts"
    ["mod-npc-talent-template"]="https://github.com/azerothcore/mod-npc-talent-template"
    ["mod-pocket-portal"]="https://github.com/azerothcore/mod-pocket-portal"
    ["mod-npc-enchanter"]="https://github.com/azerothcore/mod-npc-enchanter"
    ["mod-racial-trait-swap"]="https://github.com/azerothcore/mod-racial-trait-swap"
    ["mod-weekend-xp"]="https://github.com/azerothcore/mod-weekend-xp"
)

if command -v dialog &> /dev/null; then
    TEMPFILE=$(mktemp)
    dialog --checklist "Select Modules" 20 60 15 \
    $(for mod in "${!MODULES[@]}"; do echo "$mod" "$mod" off; done) 2> "$TEMPFILE"
    SELECTED_MODULES=$(<"$TEMPFILE")
    rm -f "$TEMPFILE"
else
    echo -e "\n\e[38;5;214mDialog not installed. Fallback to manual module input.\e[0m"
    echo "Enter module names separated by space (e.g. mod-world-chat mod-eluna mod-ah-bot):"
    echo "Available modules:"
    for mod in "${!MODULES[@]}"; do echo " - $mod"; done
    read -r -a SELECTED_MODULES
fi

# Step 8: Clone selected modules
if [ -z "$SELECTED_MODULES" ]; then
    echo -e "\e[33m[INFO] No modules selected. Skipping module installation.\e[0m"
else
    step "Cloning selected modules..."
    mkdir -p "$AC_CODE_DIR/modules"
    for mod in ${SELECTED_MODULES[@]}; do
        REPO="${MODULES[$mod]}"
        if [ -n "$REPO" ]; then
            echo -e "\e[38;5;208m[MODULE] Cloning $mod...\e[0m"
            git clone "$REPO" "$AC_CODE_DIR/modules/$mod"
        else
            echo -e "\e[31m[WARNING] Unknown module: $mod\e[0m"
        fi
    done
fi

# Step 9: Build AzerothCore
step "Building AzerothCore..."
cd $AC_CODE_DIR/build

BUILD_CORES=$(nproc --all)
BUILD_CORES=$((BUILD_CORES - 1))

cmake ../ \
  -DCMAKE_INSTALL_PREFIX=$AC_CODE_DIR/env/dist/ \
  -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  -DWITH_WARNINGS=1 \
  -DTOOLS_BUILD=all \
  -DSCRIPTS=static \
  -DMODULES=static

make -j$BUILD_CORES
make install

# Step 10: Download and extract game data
step "Downloading and extracting game data files to bin/data..."
cd $AC_CODE_DIR/env/dist/bin/
mkdir -p data
wget -q --show-progress https://github.com/wowgaming/client-data/releases/download/v16/data.zip
unzip -q data.zip -d data
rm data.zip

# Step 11: Copy and configure worldserver.conf
step "Setting up worldserver.conf..."
cd $AC_CODE_DIR/env/dist/etc/
cp worldserver.conf.dist worldserver.conf
sed -i 's|^DataDir = "."|DataDir = "./data"|' worldserver.conf

# Step 12: Copy authserver.conf
step "Setting up authserver.conf..."
cp authserver.conf.dist authserver.conf

# Step 13: Create MySQL user and grant DB privileges
step "Creating MySQL user 'acore' with access to acore_auth, acore_characters, and acore_world..."
sudo mysql -u root <<EOF
CREATE USER IF NOT EXISTS 'acore'@'localhost' IDENTIFIED BY 'acore';
GRANT ALL PRIVILEGES ON acore_auth.* TO 'acore'@'localhost';
GRANT ALL PRIVILEGES ON acore_characters.* TO 'acore'@'localhost';
GRANT ALL PRIVILEGES ON acore_world.* TO 'acore'@'localhost';
FLUSH PRIVILEGES;
EOF

# Step 14: Create systemd services
step "Creating systemd service files for authserver and worldserver..."

INSTALL_PATH="$HOME/server/azerothcore/env/dist/bin"
RUN_USER=$(whoami)

sudo tee /etc/systemd/system/authserver.service > /dev/null <<EOF
[Unit]
Description=AzerothCore Auth Server
After=network.target mysql.service mariadb.service

[Service]
Type=simple
User=$RUN_USER
WorkingDirectory=$INSTALL_PATH
ExecStart=$INSTALL_PATH/authserver
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo tee /etc/systemd/system/worldserver.service > /dev/null <<EOF
[Unit]
Description=AzerothCore World Server
After=network.target mysql.service mariadb.service

[Service]
Type=simple
User=$RUN_USER
WorkingDirectory=$INSTALL_PATH
ExecStart=$INSTALL_PATH/worldserver
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd so it picks up the new files
sudo systemctl daemon-reexec
sudo systemctl daemon-reload

# Enable them to start on boot
sudo systemctl enable authserver
sudo systemctl enable worldserver


# Step 15: Final Message
step "AzerothCore installation complete!

To start your servers:
  
  sudo systemctl start  authserver && sudo systemctl start worldserver
  
  AzertohCore Binaries here:
  
  ~/server/azerothcore/env/dist/bin/worldserver
  ~/server/azerothcore/env/dist/bin/authserver

Edit authserver.conf and worldserver.conf files:

  ~/server/azerothcore/env/dist/etc/
"
