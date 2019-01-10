#!/bin/bash

# Thanks to @kylesferrazza on GitHub for the base of this dot file!
# Check him out at https://www.kylesferrazza.com

################################################################################
# SECTION 0                                                                    #
# -----------------------------------------------------------------------------#
# Meta-script initialization                                                   #
################################################################################

# Fail immediately if something goes wrong.
set -e

# Keep reference of time started
START_TIME=$SECONDS

# Don't run as root!
if [ "$(id -u)" == "0" ]; then
  echo "
Do not run this with sudo.
If this was a fresh install, consider adding a new user:

  useradd -m -g [init_group] -G [additional_groups] -s [login_shell] [username]

For example, this is a standard single-user config:

  useradd -m -g wheel edward
  passwd edward
"
  exit 1
fi

# Enable ntp and wait for sync
sudo timedatectl set-ntp true
sleep 1s

# Force refresh of gpg keys in case of date time issues
sudo pacman-key --populate archlinux

# Force refresh of DBs and install git and reflector, if not present.
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
  --protocol https \
  --sort rate \
  --save /etc/pacman.d/mirrorlist

# Remove extraneous file.
sudo rm -f /etc/pacman.d/mirrorlist.pacnew

################################################################################
# SECTION 1                                                                    #
# -----------------------------------------------------------------------------#
# User home directories                                                        #
################################################################################

# Standard user dirs
mkdir "$HOME/Downloads"
mkdir "$HOME/Music"
mkdir "$HOME/Pictures"
mkdir "$HOME/Videos"

mkdir -p "$HOME/Documents/repos"
mkdir -p "$HOME/Documents/school"

# Some soft links so I can just cd from my home directory
ln -s "$HOME/Documents/repos" "$HOME/repos"
ln -s "$HOME/Documents/school" "$HOME/school"
ln -s "$HOME/repos/dotfiles" "$HOME/dotfiles"

mkdir -p "$HOME/.config"
mkdir -p "$HOME/.gnupg"
chmod 700 "$HOME/.gnupg"

# TODO: complete

################################################################################
# SECTION 2                                                                    #
# -----------------------------------------------------------------------------#
# Packages to install                                                          #
################################################################################

# [Group Name] PKG1 PKG2 ...PKGN
# Installs a group of packages. The group name is required, but is not used.
# Group Name is just a inline way for the maintainer to know what package group
# is being modified.
function installgroup {
  # First input is the title of the group, we can skip it.
  if (( $# != 1 )); then
    shift
    trizen -Syyu --needed --noconfirm --noinfo --noedit "$@"
    sudo -v
  else
  echo "The install script is malformed.
The following line has an incorrect number of parameters:

    installgroup $*
"
  fi
}

# CLI Packages
installgroup CORE linux-headers acpi ntp
installgroup AUDIO pulseaudio pulseaudio-alsa alsa-utils pavucontrol \
  pulseaudio-bluetooth pulseaudio-jack qjackctl
installgroup NET networkmanager networkmanager-openvpn network-manager-applet \
  openvpn
installgroup TOOLS powertop nmap neofetch htop tree stow p7zip xclip openssh \
  neovim bat
installgroup TEX pandoc texlive-most texstudio
installgroup SHELL zsh oh-my-zsh zsh-syntax-highlighting zsh-theme-powerlevel9k
installgroup FUN cowsay fortune-mod wtf thefuck

# GUI Packages
installgroup FONTS ttf-ms-fonts ttf-opensans ttf-roboto noto-fonts \
  powerline-fonts-git ttf-font-awesome-4 ttf-fira-code ttf-dejavu \
  noto-fonts-emoji
installgroup XORG xorg-server xorg-xinit light xorg-xkill xorg-xinput \
  xorg-xmodmap xterm xss-lock-git xorg-xset xbindkeys wmctrl xdotool xdg-utils \
  unclutter-xfixes-git perl-file-mimeinfo capitaine-cursors
installgroup DESKTOP i3-gaps-next-git libreoffice dunst rofi maim mpv feh \
  mpv-mpris kitty synergy libinput libinput-gestures code
installgroup RICE compton polybar betterlockscreen
# try running xss-lock; if you're missing libasan, install i3-color-git
installgroup WEB chromium qbittorrent
installgroup MESSAGING slack-desktop
installgroup PDF zathura zathura-pdf-mupdf

# Languages
installgroup JAVA openjdk8-doc openjdk8-src jdk8-openjdk \
  intellij-idea-ue-bundled-jre
installgroup JS nodejs yarn nvm
installgroup PY python # No need for pip, python3 comes with pip
installgroup GOOGLELANG dart go

# Packages that often break; installed in section n+1
# wget and xdg-utils are an opt (but not really) dep of discord.
TRY_PKGS="wget xdg-utils discord"

# Packages that are proprietary; installed in section n+1
PROPRIETARY="spotify unrar"

################################################################################
# SECTION 3                                                                    #
# -----------------------------------------------------------------------------#
# Configuration                                                                #
################################################################################

# specify home directory just in case it's not run from home dir.
stow -t ~ dunst git gtk3 i3 kitty neofetch polybar rofi zsh libinput-gestures \
  x compton ssh scripts

# will throw division by 0 error, that's ok
betterlockscreen -u ~/.lockbg.png -b 0

# mpv-mpris
mkdir -p "$HOME/.config/mpv/scripts"
ln -s /usr/lib/mpv/mpris.so "$HOME/.config/mpv/scripts/mpris.so"

# Set root and current users to use zsh as shell
sudo chsh "$USER" -s "$(command -v zsh)"
sudo chsh root -s "$(command -v  zsh)"

# Generate SSH keys
ssh-keygen -t ed25519 -N '' -f "~/.ssh/code@eddie.sh"
ssh-keygen -N '' -f "~/.ssh/id_rsa" # In case ed25519 key fails.

# libinput-gestures requirement
sudo gpasswd -a $USER input
libinput-gestures-setup autostart

# Enable reflector timer
sudo systemctl enable reflector.timer
sudo cp unstowables/reflector-timer/reflector.conf \
  /usr/share/reflector-time/reflector.conf

# Systemd configurations
sudo cp unstowables/systemd/logind.conf /etc/systemd/
sudo cp unstowables/systemd/system/* /etc/systemd/system/

sudo systemctl enable powertop

################################################################################
# SECTION 4                                                                    #
# -----------------------------------------------------------------------------#
# Services                                                                     #
################################################################################

# Networking
sudo systemctl enable NetworkManager
sudo systemctl enable NetworkManager-dispatcher

# NTP daemon
sudo systemctl enable ntpd

# Mouse support in tty (gpm)
sudo systemctl enable gpm

# TODO: add in cron job for updating mirrors

################################################################################
# SECTION n+1                                                                  #
# -----------------------------------------------------------------------------#
# Extra things                                                                 #
################################################################################

# Accepts a String and a list of packages. The first param describes the group
# of packages to the user, while the remainder of the arugments specify the
# packages to install.
function extrapkgs {
  echo "
Do you want to install $1?
Packages include:

    ${*:2}
"
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) trizen -Syyu --needed --noconfirm --noinfo --noedit "${*:2}"; break;;
      No ) break;;
    esac
  done
}

extrapkgs "known-problematic packages" "$TRY_PKGS"
extrapkgs "proprietary software" "$PROPRIETARY"
extrapkgs "fun software" "$FUN"

TIME_DIFF=${$SECONDS-$START_TIME}

echo "Total install time: ${$TIME_DIFF / 3600}hrs ${($TIME_DIFF / 60) % 60}min ${$TIME_DIFF % 60}sec"

echo "Please note that the following tasks must be completed independently:"
echo "\GPG Key generation and addition to respective remote servers"

echo "Please restart now to complete installation."
echo "Reboot now?"
select yn in "Yes" "no"; do
  case $yn in
    Yes ) systemctl reboot; break;;
    No )  break;;
  esac
done
