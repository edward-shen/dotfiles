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

# Keep reference of time started
START_TIME=$SECONDS

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
trizen -Syyu --needed --noconfirm --noinfo --noedit perl-json-xs

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

# [Group Name] PKG1 PKG2 ...PKGN
# Installs a group of packages. The group name is required, but is not used.
# Group Name is just a inline way for the maintainer to know what package group
# is being modified.
function installgroup {
  # First input is the title of the group, we can skip it.
  if (( $# != 1 )); then
    shift
    trizen -Syyu --needed --noedit --noinfo --noconfirm $@
  else
    echo "The install script is incorrectly parsed."
    echo "The following line has a incorrect number of parameters:"
    echo
    echo "    $@"
    echo
  fi
}

# CLI Packages
installgroup CORE linux-headers acpi ntp
installgroup AUDIO pulseaudio pulseaudio-alsa alsa-utils pavucontrol \
  pulseaudio-bluetooth pulseaudio-jack qjackctl
installgroup NET networkmanager networkmanager-openvpn network-manager-applet
installgroup TOOLS powertop nmap neofetch htop tree
installgroup TEX pandoc texlive-most
installgroup FISH fish
installgroup FUN cowsay fortune-mod wtf

# GUI Packages
installgroup FONTS ttf-ms-fonts ttf-opensans ttf-roboto noto-fonts \
  powerline-fonts-git ttf-font-awesome-4 ttf-fira-code ttf-dejavu \
  noto-fonts-emoji
installgroup XORG xorg-server xorg-xinit light xorg-xkill xorg-xinput \
  xorg-xmodmap xterm xss-lock-git xorg-xset xbindkeys wmctrl xdotool xdg-utils \
  unclutter-xfixes-git perl-file-mimeinfo
installgroup DESKTOP i3-gaps thunar libreoffice dunst rofi scrot mpv mpv-mpris \
  kitty synergy feh
installgroup RICE compton polybar betterlockscreen
# try running xss-lock; if you're missing libasan, install the git version of
# i3-color
# trizen -S i3-color-git
installgroup WEB chromium firefox qbittorrent
installgroup MESSAGING slack-desktop
installgroup PDF zathura zathura-pdf-mupdf

# Languages
installgroup JAVA openjdk8-doc openjdk8-src jdk8-openjdk
installgroup JS nodejs yarn
installgroup PY python # No need for pip, python3 comes with pip
installgroup GOOGLELANG dart go

# Packages that often break; installed in section n+1
# wget and xdg-utils are an opt (but not really) dep of discord.
$TRY_PKGS="code wget xdg-utils discord"

# Packages that are proprietary; installed in section n+1
$PROPRIETARY="spotify"

# Intellij is too large, clean cache and clone into a temp dir instead
trizen -Sc --noconfirm
$INTELLIj="intellij-idea-ue-bundled-jre"
mkdir trizenintellij
pushd trizenintellij
trizen -Syyu --needed --noconfirm --noinfo --noedit --clone-dir=. $INTELLIJ
popd trizenintellij
rmdir trizenintellij

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
        Yes ) trizen -Syyu --needed --noconfirm --noinfo --noedit $TRY_PKGS;
          break;;
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
        Yes ) trizen -Syyu --needed --noconfirm --noinfo --noedit $PROPRIETARY;\
          break;;
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
        Yes ) trizen -Syyu --needed --noconfirm --noinfo --noedit $FUN; break;;
        No ) break;;
    esac
done

TIME_DIFF=$(($SECONDS - START_TIME))

echo "Total install time: $(($TIME_DIFF / 3600))hrs $((($TIME_DIFF / 60) % 60))min $(($TIME_DIFF % 60))sec"