#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 group install -y development-tools
dnf5 install -y chromium gnome-shell-extension-pop-shell zsh nextcloud-client kitty fastfetch neovim stow
dnf5 install -y gnome-tweaks
dnf5 install -y libreoffice libreoffice-langpack-de
dnf5 install -y distrobox
dnf5 install -y dotnet-sdk-10.0
dnf5 install -y just

tee /etc/yum.repos.d/netbird.repo <<EOF
[netbird]
name=netbird
baseurl=https://pkgs.netbird.io/yum/
enabled=1
gpgcheck=0
gpgkey=https://pkgs.netbird.io/yum/repodata/repomd.xml.key
repo_gpgcheck=1
EOF

dnf5 config-manager addrepo --from-repofile=/etc/yum.repos.d/netbird.repo
dnf5 check-update
dnf5 install -y netbird libappindicator-gtk3 libappindicator netbird-ui

rm /etc/yum.repos.d/netbird.repo


rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/vscode.repo > /dev/null

dnf5 check-update
dnf5 install -y code

rm /etc/yum.repos.d/vscode.repo

# Use a COPR Example:
#
#dnf5 -y copr enable che/nerd-fonts
#dnf5 -y install package nerd-fonts
# Disable COPRs so they don't end up enabled on the final image:
#dnf5 -y copr disable che/nerd-fonts

#### Example for enabling a System Unit File

systemctl enable rpm-ostreed-automatic.timer

### Flathub
#flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#flatpak install -y com.github.tchx84.Flatseal
#flatpak install -y com.obsproject.Studio
#flatpak install -y com.obsproject.Studio.Plugin.AdvancedMasks
#flatpak install -y com.obsproject.Studio.Plugin.BackgroundRemoval
#flatpak install -y com.obsproject.Studio.Plugin.CompositeBlur
#flatpak install -y com.obsproject.Studio.Plugin.GStreamerVaapi
#flatpak install -y com.obsproject.Studio.Plugin.Gstreamer
#flatpak install -y com.obsproject.Studio.Plugin.OBSVkCapture
#flatpak install -y com.obsproject.Studio.Plugin.SceneSwitcher
#flatpak install -y com.obsproject.Studio.Plugin.3DEffect

### SSL Certificates
cat > /etc/pki/ca-trust/source/anchors/FraleyHomeCA.crt << 'EOF'
-----BEGIN CERTIFICATE-----
MIIFmzCCA4OgAwIBAgIUFaywnjWYK0QdaPgWzsNPlTtPWmcwDQYJKoZIhvcNAQEL
BQAwXTELMAkGA1UEBhMCREUxCzAJBgNVBAgMAlNIMRAwDgYDVQQHDAdMVUVCRUNL
MQ8wDQYDVQQKDAZGcmFsZXkxHjAcBgkqhkiG9w0BCQEWD2FkbWluQGZyYWxleS5k
ZTAeFw0yNjAxMDkxODQ1MTlaFw0zNjAxMDcxODQ1MTlaMF0xCzAJBgNVBAYTAkRF
MQswCQYDVQQIDAJTSDEQMA4GA1UEBwwHTFVFQkVDSzEPMA0GA1UECgwGRnJhbGV5
MR4wHAYJKoZIhvcNAQkBFg9hZG1pbkBmcmFsZXkuZGUwggIiMA0GCSqGSIb3DQEB
AQUAA4ICDwAwggIKAoICAQDWSyyRnM+OwRijqsIyvCTwlFWRRnTbLsC0wozZRfDW
1vqtF4AhH/L6d4Kjdqf1zJ2hQf3UQYDvY9JElOXBjmatsST0zdvm0NNtYySUXAn4
IByWIKXlnP22IXVF3Jwf+DNNGXAOcbbFn6Sjqorqn4zHR7vgir09SbNsOB0LMgej
EQrDvMCvt2VRtvAuDF3RN/Xec4f6Fe0+rFfzrEDrqFOHGENrqxxXbyCSW3L98Ek3
QQFqufDxSxroKkanYjV3BJ3beo1wJqHFeDS+0EF/UJTiEffA37pSSiuEbR08YFar
BzkEkGEnbeQ29m8lP6UHbKMYmDn4MZEvUi1DC1I3hDUSkaKRrsJxUTt96antn5Dr
nDmZ/2cmgyhdOHB65SPgwLOPRJybO6738/spmz2pTLaW3gTN5/NMNvJ3oZZ1lNYa
qnGn8BaEdfLIb3YFLp5H6malQtPZy1kvMoA+bvfdC2iKZ7PCdJ6vokRuxViq/8U0
/f6IDB1/8PsxgxIfswDPccDRgkOooSupKPO82VuxXU6T2Eo8msrrR+JVJClbHJF+
Q1WbUXcrJvy3wBb1QlQCBc0mfC0M4cH85lYwXritWbWlz/vWU0SHP6fGvXmMEi+g
puXMlRNMlBPxYAcMZpJk8e6siwwsEUBGRphav1XlI/7JxyxnnBQ/BrNnm9x97o4S
dwIDAQABo1MwUTAdBgNVHQ4EFgQUJpzTDJZjwuf5/ekK+5cn/aBdOWEwHwYDVR0j
BBgwFoAUJpzTDJZjwuf5/ekK+5cn/aBdOWEwDwYDVR0TAQH/BAUwAwEB/zANBgkq
hkiG9w0BAQsFAAOCAgEAaIkbsrAHzWSWtYpYKigqNs/f8S+mToA5Xqj/7g7X0l1j
AZnORZadqZCfuRavkp1zmEJhy7Bk5xvdAQ7B0mfyKaULn+kEaZOCu7xKYP+BiSMC
ejpeTXSeA5zdzUx2epauOb6nRzmDt5K0+nHMn+hVz9eAY9jVVQrDxfRo/olgw9zb
Lnv4pPK3VX/ydcMyXU+hwiZAbgmpnkuN/EDaaY6hi1eA0vKkDltaXa7MggWvevhd
wMXZ8B6xLwJ9mCoCMxo1iE4yXl3W0PhnpllbzQn7UrajnIaCP6mcYOuwJg1hMw2w
WigNZxx2RMje4gm62qxVWS4yz0IvDs87OF/ltgsaxD4yUSUfv30XTEv3KQFvxqR7
1A95x0/gxS5kIAZ7iPN8AiQ5m8HVwcWUvVQVeeM944TcPlyN7EnAc3wSBW7QMq+D
78aW+wNwfpvBuRdn5yfk1Z8p/8Pgv0zRW8ijVOPYOpHig6J5p+qIA2At844FOaeN
ftoWcUMMQpqoyZOr40e1vVenB/31GxkxeviZZmLyvVeXqr2YgU1w7EcKToVpdYlp
x8VQh5LaoMDyvv3fDgjK2zkG6rjo9TAca65ZX/XV3Pata7BNCLCDCu3DWxhIRzSC
N9upIgHMcIcOhzwPbxEguOAwvduqmrzdh1K1HnMj4UTraGHOaO7fXxGqdVFzAbI=
-----END CERTIFICATE-----
EOF

update-ca-trust
