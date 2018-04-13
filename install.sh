#!/bin/bash

# Thanks to @kylesferrazza on GitHub for the base of this dot file!
# Check him out at https://www.kylesferrazza.com

###############################################################################
# SECTION 0                                                                   #
# ----------------------------------------------------------------------------#
# Meta-script initialization                                                  #
###############################################################################

# Fail immediately if something goes wrong
set -e

# Don't run as root!
if [ "$(id -u)" == "0" ]; then
  echo
  echo "Do not run this with sudo."
  echo "If this was a fresh install, consider adding a new user:"
  echo
  echo "  useradd -m -g [initial_group] -G [additional_groups] -s [login_shell] [username]"
  echo
  exit 1
fi

# Force refresh of dbs and install git and reflector, if not present
yes | sudo pacman -Syyu --needed git reflector

# Install trizen if not already installed
if [! -f /usr/bin/trizen ]; then
  git clone https://aur.archlinux.org/trizen.git
  pushd trizen
  yes | makepkg -sri
  popd
  rm -rf trizen
fi

echo "Reflection in progress; finding best mirror..."
sudo reflector \
  --latest 5 \
  --protocol http \
  --protocol https \
  --sort rate \
  --save /etc/pacman.d/mirrorlist

###############################################################################
# SECTION 1                                                                   #
# ----------------------------------------------------------------------------#
# User home directories                                                       #
###############################################################################
