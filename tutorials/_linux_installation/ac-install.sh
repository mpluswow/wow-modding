#!/bin/bash

# Function to print messages in different colors
print_in_color() {
  case $2 in
    "yellow") echo -e "\033[1;33m$1\033[0m" ;; # Yellow
    "green") echo -e "\033[1;32m$1\033[0m" ;;  # Green
    "red") echo -e "\033[1;31m$1\033[0m" ;;    # Red
    *) echo "$1" ;;                            # Default color
  esac
}

# Print initial message
print_in_color "AzerothCore & Modules Linux installation script." "yellow"

# Ask user if they want to begin installation
read -p "$(print_in_color "Do you want to begin installation? (Yes/No): " "yellow")" user_input

# Exit if user says no
if [[ $user_input != "Yes" && $user_input != "yes" ]]; then
  echo "Installation aborted."
  exit 0
fi

# Ask user if they want to install dependencies
read -p "$(print_in_color "Do you want to install all dependencies? (Yes/No): " "yellow")" install_deps

if [[ $install_deps == "Yes" || $install_deps == "yes" ]]; then
  # Update package list and install dependencies
  sudo apt-get update
  if sudo apt-get install -y git cmake make gcc g++ clang libmysqlclient-dev libssl-dev libbz2-dev libreadline-dev libncurses-dev mysql-server libboost-all-dev; then
    print_in_color "Dependencies installed successfully." "green"
  else
    print_in_color "Failed to install dependencies." "red"
    exit 1
  fi
else
  echo "Skipping dependencies installation."
fi

# Wait for 2 seconds before proceeding
sleep 2

# Clone AzerothCore and modules
print_in_color "Cloning AzerothCore and Modules" "yellow"
if git clone https://github.com/azerothcore/azerothcore-wotlk.git --branch master --single-branch ~/azerothcore-source && \
   git clone https://github.com/azerothcore/mod-eluna.git ~/azerothcore-source/modules/mod-eluna; then
  print_in_color "AzerothCore and modules cloned successfully." "green"
else
  print_in_color "Failed to clone AzerothCore or modules." "red"
  exit 1
fi

# Wait for 2 seconds before proceeding
sleep 2

# Print message for compilation and installation
print_in_color "Compilation and installation." "yellow"

# Create build directory
mkdir -p ~/azerothcore-server
cd ~/azerothcore-server

# Run CMake with the specified options
if cmake ../ -DCMAKE_INSTALL_PREFIX=$HOME/azerothcore-source/env/dist/ -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DWITH_WARNINGS=1 -DTOOLS_BUILD=all -DSCRIPTS=static -DMODULES=static; then
  print_in_color "CMake configuration successful." "green"
else
  print_in_color "CMake configuration failed." "red"
  exit 1
fi

# Check number of CPU cores and start build
cpu_cores=$(nproc --all)
if make -j "$cpu_cores"; then
  print_in_color "Build completed successfully." "green"
else
  print_in_color "Build failed." "red"
  exit 1
fi

# Install the compiled binaries
if make install; then
  print_in_color "AzerothCore installed successfully." "green"
else
  print_in_color "AzerothCore installation failed." "red"
  exit 1
fi
