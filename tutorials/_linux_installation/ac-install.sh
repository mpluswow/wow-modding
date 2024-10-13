#!/bin/bash

# Function to print messages (no colors)
print_message() {
  echo "$1"
}

# Print initial message
print_message "AzerothCore & Modules Linux installation script."

# Ask user if they want to begin installation
read -p "Do you want to begin installation? (Yes/No): " user_input

# Exit if user says no
if [[ $user_input != "Yes" && $user_input != "yes" ]]; then
  echo "Installation aborted."
  exit 0
fi

# Ask user if they want to install dependencies
read -p "Do you want to install all dependencies? (Yes/No): " install_deps

if [[ $install_deps == "Yes" || $install_deps == "yes" ]]; then
  # Update package list and install dependencies
  sudo apt-get update
  if sudo apt-get install -y git cmake make gcc g++ clang libmysqlclient-dev libssl-dev libbz2-dev libreadline-dev libncurses-dev mysql-server libboost-all-dev; then
    print_message "Dependencies installed successfully."
  else
    print_message "Failed to install dependencies."
    exit 1
  fi
else
  echo "Skipping dependencies installation."
fi

# Wait for 2 seconds before proceeding
sleep 2

# Clone AzerothCore and modules
print_message "Cloning AzerothCore and Modules"
if git clone https://github.com/azerothcore/azerothcore-wotlk.git --branch master --single-branch ~/azerothcore-source && \
   git clone https://github.com/azerothcore/mod-eluna.git ~/azerothcore-source/modules/mod-eluna; then
  print_message "AzerothCore and modules cloned successfully."
else
  print_message "Failed to clone AzerothCore or modules."
  exit 1
fi

# Wait for 2 seconds before proceeding
sleep 2

# Print message for compilation and installation
print_message "Compilation and installation."

# Create build directory
mkdir -p ~/azerothcore-server
cd ~/azerothcore-server

# Run CMake with the specified options
if cmake ../ -DCMAKE_INSTALL_PREFIX=$HOME/azerothcore-source/env/dist/ -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DWITH_WARNINGS=1 -DTOOLS_BUILD=all -DSCRIPTS=static -DMODULES=static; then
  print_message "CMake configuration successful."
else
  print_message "CMake configuration failed."
  exit 1
fi

# Check number of CPU cores and start build
cpu_cores=$(nproc --all)
if make -j "$cpu_cores"; then
  print_message "Build completed successfully."
else
  print_message "Build failed."
  exit 1
fi

# Install the compiled binaries
if make install; then
  print_message "AzerothCore installed successfully."
else
  print_message "AzerothCore installation failed."
  exit 1
fi

