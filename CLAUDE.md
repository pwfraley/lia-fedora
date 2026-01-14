# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a custom bootc image repository based on the Universal Blue image-template. It creates "lia-fedora", a personalized Fedora Silverblue-based bootable container image with custom packages and configurations.

**Base Image**: `quay.io/fedora/fedora-silverblue:43`

## Architecture

### Build Process
1. **Containerfile**: Defines the image build using a multi-stage build pattern
   - Stage 1 (`ctx`): Mounts build scripts without copying them into final image
   - Stage 2: Based on Fedora Silverblue, runs build.sh, then runs bootc container lint
2. **build.sh**: Executes all customizations (package installation, system configuration)
3. **GitHub Actions**: Automatically builds and publishes images to GHCR, signs with cosign

### Disk Image Creation
The repository uses bootc-image-builder (BIB) to convert OCI container images into bootable disk images:
- **QCOW2**: Virtual machine images
- **RAW**: Raw disk images
- **ISO**: Installation ISOs with kickstart automation

Configuration files in `disk_config/`:
- `disk.toml`: Standard disk image configuration (20GB root btrfs, 1GB /boot ext4)
- `iso.toml`: ISO-specific config with kickstart that auto-switches to the custom image

## Common Commands

### Building the Container Image
```bash
just build                    # Build with default settings (lia-fedora:latest)
just build <image> <tag>     # Build with custom image name and tag
```

### Creating Bootable Disk Images
```bash
just build-qcow2             # Build QCOW2 VM image
just build-raw               # Build RAW disk image
just build-iso               # Build installation ISO

just rebuild-qcow2           # Rebuild container then create QCOW2
just rebuild-raw             # Rebuild container then create RAW
just rebuild-iso             # Rebuild container then create ISO
```

### Running Virtual Machines
```bash
just run-vm-qcow2           # Run VM from QCOW2 (uses qemu container, opens browser)
just run-vm-raw             # Run VM from RAW image
just run-vm-iso             # Run VM from ISO

just spawn-vm               # Run VM using systemd-vmspawn
just spawn-vm rebuild=1     # Rebuild image first, then spawn VM
```

Aliases: `build-vm`, `rebuild-vm`, `run-vm` all point to qcow2 variants.

### Code Quality
```bash
just lint                    # Run shellcheck on all .sh files
just format                  # Run shfmt on all .sh files
just check                   # Check Just syntax
just fix                     # Fix Just syntax
just clean                   # Remove build artifacts
```

## Customization Guide

### Adding Packages
Edit `build_files/build.sh`:
- Fedora packages: `dnf5 install -y <package>`
- Package groups: `dnf5 group install -y <group>`
- COPR repositories: Enable, install, then disable (see commented example)
- Flatpaks: Uncomment and modify flatpak install commands

### System Configuration
In `build_files/build.sh`:
- Enable systemd units: `systemctl enable <unit>`
- Add CA certificates: Append to /etc/pki/ca-trust/source/anchors/, run `update-ca-trust`
- Add custom repositories: Create repo files in /etc/yum.repos.d/

### Disk Configuration
Modify `disk_config/disk.toml` or `disk_config/iso.toml`:
- Adjust filesystem sizes (minsize)
- Change filesystem types (btrfs, ext4, xfs)
- For ISO: Update kickstart contents to point to your image

### Base Image
Change the FROM line in `Containerfile`. Consider:
- Universal Blue images: `ghcr.io/ublue-os/bazzite:stable`, `ghcr.io/ublue-os/bluefin:stable`
- Fedora base: `quay.io/fedora/fedora-bootc:42`

## Important Files

- **Containerfile**: Main build definition
- **build_files/build.sh**: All package installation and configuration (runs with set -ouex pipefail)
- **Justfile**: Build automation with configurable IMAGE_NAME (default: lia-fedora)
- **cosign.pub**: Public signing key for image verification (cosign.key is secret, never commit)
- **.github/workflows/build.yml**: CI/CD pipeline (daily at 10:05 UTC, on push, on PR)
- **.github/workflows/build-disk.yml**: Disk image generation workflow

## Development Notes

- The build.sh script runs with strict error handling (`set -ouex pipefail`)
- The Containerfile uses cache mounts for /var/cache and /var/log to speed up builds
- Images are signed with cosign and published to ghcr.io
- The ISO automatically switches to your custom image via kickstart post-install
- When adding third-party repos (like VSCode), remove the repo file at end of build.sh to keep it clean
