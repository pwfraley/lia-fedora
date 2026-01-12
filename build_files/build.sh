#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y chromium gnome-shell-extension-pop-shell zsh nextcloud-client kitty fastfetch neovim stow
dnf5 install -y libreoffice

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket

### Flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y com.github.tchx84.Flatseal
flatpak install -y com.obsproject.Studio
flatpak install -y com.obsproject.Studio.Plugin.AdvancedMasks
flatpak install -y com.obsproject.Studio.Plugin.BackgroundRemoval
flatpak install -y com.obsproject.Studio.Plugin.CompositeBlur
flatpak install -y com.obsproject.Studio.Plugin.GStreamerVaapi
flatpak install -y com.obsproject.Studio.Plugin.Gstreamer
flatpak install -y com.obsproject.Studio.Plugin.OBSVkCapture
flatpak install -y com.obsproject.Studio.Plugin.SceneSwitcher
flatpak install -y com.obsproject.Studio.Plugin.3DEffect
