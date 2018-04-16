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

# Force refresh of dbs and install git and reflector, if not present.
# Also install base-devel, which is needed for trizen.
yes "" | sudo pacman -Syyu --needed git reflector base-devel

# Install trizen if not already installed
if [ ! -f /usr/bin/trizen ]; then
  git clone https://aur.archlinux.org/trizen.git
  pushd trizen
  yes | makepkg -sri
  popd
  rm -rf trizen
fi

# Update our mirrors to find the fastest one
echo "Reflection in progress..."
sudo reflector \
  --age 24 \
  --latest 5 \
  --protocol http \
  --protocol https \
  --sort rate \
  --save /etc/pacman.d/mirrorlist

# Remove extraneous file.
sudo rm -f /etc/pacman.d/mirrorlist.pacnew

###############################################################################
# SECTION 1                                                                   #
# ----------------------------------------------------------------------------#
# User home directories                                                       #
###############################################################################

mkdir -p $HOME/Downloads
mkdir -p $HOME/Documents
mkdir -p $HOME/.config
mkdir -p $HOME/.gnupg
chmod 700 $HOME/.gnupg


###############################################################################
# SECTION 2                                                                   #
# ----------------------------------------------------------------------------#
# Packages to install                                                         #
###############################################################################

# CLI Packages
CORE="linux-headers acpi ntp"
AUDIO="pulseaudio pulseaudio-alsa alsa-utils pavucontrol pulseaudio-bluetooth \
pulseaudio-jack qjackctl"
TOOLS="powertop nmap ntop neofetch htop base-devel"
TEX="pandoc texlive-most"
FISH="fish"
FUN="cowsay fortune-mod wtf"

# GUI Packages
XORG="xorg-server xorg-xinit light xorg-xkill xorg-xinput xorg-xmodmap xterm \
feh xss-lock-git xorg-xset xbindkeys wmctrl xdotool xdg-utils \
unclutter-xfixes-git perl-file-mimeinfo"
DESKTOP="i3-gaps thunar libreoffice dunst rofi scrot mpv mpv-mpris kitty"
RICE="compton polybar betterlockscreen"
WEB="chromium firefox qbittorrent"
MESSAGING="discord slack-desktop"
DEV="code intellij-idea-ue-bundled-jre"

# Languages
JAVA="openjdk8-doc openjdk8-src jdk8-openjdk"
JAVASCRIPT="nodejs yarn"
PYTHON="python"

# Shorthands
CLIPKG="$CORE $AUDIO $TOOLS $FISH $FUN $TEX"
GUIPKG="$XORG $DESKTOP $RICE $WEB $MESSAGING $DEV"
LANGS="$JAVA $JAVASCRIPT $PYTHON"

trizen -Syyu --needed --noconfirm --noedit $CLIPKG $GUIPKG $LANGS

###############################################################################
# SECTION 3                                                                   #
# ----------------------------------------------------------------------------#
# Configuration                                                               #
###############################################################################

# mpv-mpris
mkdir -p $HOME/.config/mpv/scripts
ln -s /usr/lib/mpv/mpris.so $HOME/.config/mpv/scripts/mpris.so

# Set root and current users to use fish as shell
sudo chsh $USER -s `which fish`
sudo chsh root -s `which fish`

###############################################################################
# SECTION 4                                                                   #
# ----------------------------------------------------------------------------#
# Services                                                                    #
###############################################################################

# Networking
sudo systemctl enable NetworkManager
sudo systemctl enable NetworkManager-dispatcher
sudo systemctl enable ntpd

# Mouse support in tty (gpm)
sudo systemctl enable gpm

# TODO: add in cron job for updating mirrors