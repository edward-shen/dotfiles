#!/bin/bash

# Thanks to @kylesferrazza on GitHub for the base of this dot file!
# Check him out at https://www.kylesferrazza.com

###############################################################################
# SECTION 0                                                                   #
# ----------------------------------------------------------------------------#
# Meta-script initialization                                                  #
###############################################################################

# Fail immediately if something goes wrong.
set -e

# Don't run as root!
if [ "$(id -u)" == "0" ]; then
  echo
  echo "Do not run this with sudo."
  echo "If this was a fresh install, consider adding a new user:"
  echo
  echo "  useradd -m -g [initial_group] -G [additional_groups] -s [login_shell] [username]"
  echo
  echo "For example, this is a standard single-user config:"
  echo
  echo "  useradd -m -g wheel edward"
  echo "  passwd edward"
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

# We got a lot of things to install, lets install perl-json-xs to make things
# a little faster.
trizen -Syyu --needed --noconfirm --noedit perl-json-xs

# Update our mirrors to find the fastest one.
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
mkdir -p $HOME/Documents/repos
mkdir -p $HOME/Documents/school

# Some soft links so I can just cd from my home directory
ln -s $HOME/Documents/repos ..
ln -s $HOME/Documents/school ..

mkdir -p $HOME/.config
mkdir -p $HOME/.gnupg
chmod 700 $HOME/.gnupg

# TODO complete

###############################################################################
# SECTION 2                                                                   #
# ----------------------------------------------------------------------------#
# Packages to install                                                         #
###############################################################################

# CLI Packages
CORE="linux-headers acpi ntp"
AUDIO="pulseaudio pulseaudio-alsa alsa-utils pavucontrol pulseaudio-bluetooth \
  pulseaudio-jack qjackctl"
NET="networkmanager networkmanager-openvpn network-manager-applet"
TOOLS="powertop nmap neofetch htop tree"
TEX="pandoc texlive-most"
FISH="fish"
FUN="cowsay fortune-mod wtf"

# GUI Packages
FONTS="ttf-ms-fonts ttf-opensans ttf-roboto noto-fonts powerline-fonts-git \
  ttf-font-awesome-4 ttf-fira-code ttf-dejavu noto-fonts-emoji"
XORG="xorg-server xorg-xinit light xorg-xkill xorg-xinput xorg-xmodmap xterm \
  feh xss-lock-git xorg-xset xbindkeys wmctrl xdotool xdg-utils \
  unclutter-xfixes-git perl-file-mimeinfo"
DESKTOP="i3-gaps thunar libreoffice dunst rofi scrot mpv mpv-mpris kitty \
  synergy"
RICE="compton polybar betterlockscreen"
WEB="chromium firefox qbittorrent"
MESSAGING="slack-desktop" 
INTELLIj="intellij-idea-ue-bundled-jre"

# Languages
JAVA="openjdk8-doc openjdk8-src jdk8-openjdk"
JAVASCRIPT="nodejs yarn"
PYTHON="python"

# Packages that often break; installed in section n+1
# wget and xdg-utils are an opt (but not really) dep of discord.
TRY_PKGS="code wget xdg-utils discord"

# Packages that are proprietary; installed in section n+1
PROPRIETARY="spotify"

# Groups
CLIPKG="$CORE $AUDIO $TOOLS $FISH $TEX $NET"
GUIPKG="$FONTS $XORG $DESKTOP $RICE $WEB $DISCORD_DEPS $MESSAGING"
LANGS="$JAVA $JAVASCRIPT $PYTHON"

# Installing most packages
trizen -Syyu --needed --noconfirm --noedit $CLIPKG $GUIPKG $LANGS
# Intellij is too large, clean cache and clone into home dir instead
trizen -Sc
trizen -Syyu --needed --noconfirm --noedit --clone-dir=$HOME $INTELLIJ

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

# Generate SSH key
echo -e "\n\n" | ssh-keygen

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

###############################################################################
# SECTION n+1                                                                 #
# ----------------------------------------------------------------------------#
# Extra things                                                                #
###############################################################################

echo
echo "Do you want to try to install known-problematic packages?"
echo "Packages include:"
echo
echo "  $TRY_PKGS"
echo
select yn in "Yes" "No"; do
    case $yn in
        Yes ) trizen -Syyu --needed --noconfirm --noedit $TRY_PKGS; break;;
        No ) break;;
    esac
done

echo
echo "Do you wish to install proprietary software?"
echo "Packages include:"
echo
echo "  $PROPRIETARY"
echo
select yn in "Yes" "No"; do
    case $yn in
        Yes ) trizen -Syyu --needed --noconfirm --noedit $PROPREITARY; break;;
        No ) break;;
    esac
done

echo
echo "Do you wish to install fun software?"
echo "Packages include:"
echo
echo "  $FUN"
echo
select yn in "Yes" "No"; do
    case $yn in
        Yes ) trizen -Syyu --needed --noconfirm --noedit $FUN; break;;
        No ) break;;
    esac
done

