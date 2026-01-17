# Gemini Code Assistant Context

This document provides a comprehensive overview of the `lia-fedora` project, intended to be used as a primary context source for the Gemini AI assistant.

## Project Overview

This project is a template for building a custom, bootable, Fedora-based operating system image using `bootc`. It leverages the principles of the [Universal Blue](https://universal-blue.org/) project to create a personalized, container-native OS.

The core idea is to define the entire OS as a container image, starting from a base image (like Fedora Silverblue) and adding customizations (packages, configurations, scripts) on top. This container image can then be used to generate bootable disk images (ISO, QCOW2) or to directly switch a running `bootc-enabled` system to this new custom image.

### Key Technologies

- **`bootc`**: The primary tool for managing and creating bootable OS images from OCI/Docker containers.
- **`Podman`**: The container engine used to build the OCI container image.
- **`Just`**: A command runner used to simplify common development tasks. The `Justfile` in the root is the entry point for all local build and run commands.
- **GitHub Actions**: Used for Continuous Integration to automatically build and publish the container and disk images.
- **`rpm-ostree` / `dnf5`**: The underlying package management technology for the Fedora-based immutable OS.

---

## Building and Running

All local commands should be executed via the `just` command runner.

### Container Image

- **Local Build**: To build the main container image locally:
  ```bash
  just build
  ```
  This will build an image named `localhost/lia-fedora:latest`.

- **CI/CD Build**: The container image is automatically built and pushed to `ghcr.io/pwfraley/lia-fedora` by the GitHub Actions workflow in `.github/workflows/build.yml`.

### Bootable Disk Images

The project can generate various types of bootable disk images. The configuration for these is in the `disk_config/` directory.

- **Build QCOW2 (for VMs)**:
  ```bash
  just build-qcow2
  ```

- **Build ISO (for installation)**:
  ```bash
  just build-iso
  ```

- **Run in a VM**: To test the generated QCOW2 image in a QEMU virtual machine:
  ```bash
  just run-vm-qcow2
  ```

---

## Project Structure & Customization

- **`Containerfile`**: This is the main definition for the OS image. It specifies the base image (`FROM`) and runs the primary customization script.
- **`build_files/build.sh`**: This is where most customizations happen. You can add, remove, or configure software and system settings here.
  - **Package Management**: Uses `dnf5` to install RPM packages.
  - **Systemd Services**: Services can be enabled with `systemctl enable`.
- **`Justfile`**: Defines all the local development commands (`build`, `run-vm-qcow2`, `lint`, etc.). The `image_name` variable at the top should be kept in sync with the repository name.
- **`disk_config/*.toml`**: These files configure the layout and installer behavior of the generated bootable disk images (`iso.toml` for ISOs, `disk.toml` for others).
- **`.github/workflows/`**: Contains the CI/CD pipeline definitions.
  - `build.yml`: Builds and pushes the primary container image to GHCR.
  - `build-disk.yml`: Builds the `qcow2` and `iso` disk images.

---

## Development Conventions

- **Linting**: Run `shellcheck` on all shell scripts:
  ```bash
  just lint
  ```
- **Formatting**: Format all shell scripts using `shfmt`:
  ```bash
  just format
  ```
