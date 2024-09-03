#!/bin/bash

# Step 0: Install Dependencies
echo "Installing Dependencies..."
sudo apt-get update && sudo apt-get install -y \
    git \
    cmake \
    make \
    gcc \
    g++ \
    clang \
    libmysqlclient-dev \
    libssl-dev \
    libbz2-dev \
    libreadline-dev \
    libncurses-dev \
    mysql-server \
    libboost-all-dev

# Set variables
AC_REPO="https://github.com/azerothcore/azerothcore-wotlk.git"
AC_BRANCH="master"
AC_DIR="$HOME/azerothcore-source"
BUILD_DIR="$HOME/azerothcore-server"
INSTALL_DIR="$HOME/azerothcore/env/dist"

# Module repositories
MODULES=(
    "https://github.com/azerothcore/mod-ah-bot"
    "https://github.com/azerothcore/mod-eluna"
    "https://github.com/azerothcore/mod-transmog"
)

# Step 1: Clone AzerothCore repository
echo "Cloning AzerothCore repository..."
git clone $AC_REPO --branch $AC_BRANCH --single-branch $AC_DIR

# Step 2: Clone the modules
echo "Cloning modules..."
for MODULE_REPO in "${MODULES[@]}"; do
    MODULE_NAME=$(basename $MODULE_REPO)
    MODULE_DIR="$AC_DIR/modules/${MODULE_NAME%%-*}"
    git clone $MODULE_REPO $MODULE_DIR

    # Check if the module directory has '-master' suffix and rename it
    if [ -d "${MODULE_DIR}-master" ]; then
        echo "Renaming module directory $MODULE_NAME..."
        mv "${MODULE_DIR}-master" $MODULE_DIR
    fi
done

# Step 3: Create build directory
echo "Creating build directory..."
mkdir -p $BUILD_DIR
cd $BUILD_DIR

# Step 4: Run CMake configuration
echo "Configuring build with CMake..."
cmake $AC_DIR -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DWITH_WARNINGS=1 -DTOOLS_BUILD=all -DSCRIPTS=static -DMODULES=static

# Step 5: Compile the source code
echo "Compiling the source code..."
NUM_CORES=$(nproc --all)
make -j $NUM_CORES

# Step 6: Install the compiled code
echo "Installing the compiled code..."
make install

echo "AzerothCore with modules has been successfully installed."
