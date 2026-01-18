#!/usr/bin/bash

set -eoux pipefail

echo "::group:: ===$(basename "$0")==="

echo ":: Installing Fedora Extensions"
dnf5 install -y gnome-shell-extension-pop-shell gnome-shell-extension-user-theme

echo ":: Building Extensions"
echo $(ls usr/share/gnome-shell/extensions)

# Install tooling
# dnf5 -y install glib2-devel meson sassc cmake dbus-devel

# Build Extensions

# Alphabetical App Grid
git clone https://github.com/stuarthayhurst/alphabetical-grid-extension.git ./AlphabeticalAppGrid@stuarthayhurst
cd AlphabeticalAppGrid@stuarthayhurst
make build
echo $(ls build)
unzip ./build/AlphabeticalAppGrid@stuarthayhurst.shell-extension.zip /usr/share/gnome-shell/extensions
cd ..
echo $(ls usr/share/gnome-shell/extensions)
glib-compile-schemas /usr/share/gnome-shell/extensions/AlphabeticalAppGrid@stuarthayhurst/shemas/
rm -rf AlphabeticalAppGrid@stuarthayhurst

# make -C /usr/share/gnome-shell/extensions/AlphabeticalAppGrid@stuarthayhurst
# unzip -o /usr/share/gnome-shell/extensions/AlphabeticalAppGrid@stuarthayhurst/build/AlphabeticalAppGrid@stuarthayhurst.shell-extension.zip -d /usr/share/gnome-shell/extensions/AlphabeticalAppGrid@stuarthayhurst
# glib-compile-schemas --strict /usr/share/gnome-shell/extensions/AlphabeticalAppGrid@stuarthayhurst/schemas
# rm -rf /usr/share/gnome-shell/extensions/AlphabeticalAppGrid@stuarthayhurst/build


# Blur My Shell
# make -C /usr/share/gnome-shell/extensions/blur-my-shell@aunetx
# unzip -o /usr/share/gnome-shell/extensions/blur-my-shell@aunetx/build/blur-my-shell@aunetx.shell-extension.zip -d /usr/share/gnome-shell/extensions/blur-my-shell@aunetx
# glib-compile-schemas --strict /usr/share/gnome-shell/extensions/blur-my-shell@aunetx/schemas
# rm -rf /usr/share/gnome-shell/extensions/blur-my-shell@aunetx/build

# Dash to Dock
# make -C /usr/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com
# glib-compile-schemas --strict /usr/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas

# GSConnect (commented out until G49 support)
# meson setup --prefix=/usr /usr/share/gnome-shell/extensions/gsconnect@andyholmes.github.io /usr/share/gnome-shell/extensions/gsconnect@andyholmes.github.io/_build
# meson install -C /usr/share/gnome-shell/extensions/gsconnect@andyholmes.github.io/_build --skip-subprojects
# GSConnect installs schemas to /usr/share/glib-2.0/schemas and meson compiles them automatically

# Logo Menu
# xdg-terminal-exec is required for this extension as it opens up terminals using that script
# install -Dpm0755 -t /usr/bin /usr/share/gnome-shell/extensions/logomenu@aryan_k/distroshelf-helper
# install -Dpm0755 -t /usr/bin /usr/share/gnome-shell/extensions/logomenu@aryan_k/missioncenter-helper
# glib-compile-schemas --strict /usr/share/gnome-shell/extensions/logomenu@aryan_k/schemas

# Search Light
# glib-compile-schemas --strict /usr/share/gnome-shell/extensions/search-light@icedman.github.com/schemas

rm /usr/share/glib-2.0/schemas/gschemas.compiled
glib-compile-schemas /usr/share/glib-2.0/schemas

# Cleanup
# dnf5 -y remove glib2-devel meson sassc cmake dbus-devel
rm -rf /usr/share/gnome-shell/extensions/tmp

echo "::endgroup::"
