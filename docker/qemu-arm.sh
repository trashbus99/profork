#!/bin/bash

BACKTITLE="Docker QEMU-ARM Virtual Machine Setup"
architecture=$(uname -m)
ISO_DIR="$HOME/qemu-arm"

# Check architecture (optional: ARM host might be fine)
if [ "$architecture" != "x86_64" ] && [ "$architecture" != "aarch64" ]; then
    dialog --title "Architecture Error" --msgbox "Unsupported CPU architecture: $architecture" 10 50
    clear
    exit 1
fi

# Docker check and install
if ! command -v docker &>/dev/null || ! docker info &>/dev/null; then
    dialog --title "Docker" --infobox "Docker not found. Installing..." 8 50
    sleep 2
    curl -L https://github.com/trashbus99/profork/raw/master/docker/install.sh | bash
    if ! command -v docker &>/dev/null || ! docker info &>/dev/null; then
        dialog --title "Error" --msgbox "Docker install failed. Please install it manually." 10 50
        clear
        exit 1
    fi
fi

# Check KVM support
if [ ! -e /dev/kvm ]; then
    dialog --title "KVM Error" --msgbox "KVM not available. Enable virtualization in BIOS and ensure /dev/kvm exists." 10 50
    clear
    exit 1
fi

mkdir -p "$ISO_DIR"

# Port setup
is_port_in_use() { ss -tuln | grep -q ":$1 "; }
find_next_available_port() {
    local port=$1
    while is_port_in_use $port; do port=$((port + 1)); done
    echo $port
}

VM_PORT=8006
if is_port_in_use $VM_PORT; then
    VM_PORT=$(find_next_available_port $VM_PORT)
fi

VM_PORT=$(dialog --stdout --inputbox "Enter the VM access port [Default: $VM_PORT]:" 8 45 "$VM_PORT") || exit
clear

# BOOT selection
BOOT_CHOICE=$(dialog --stdout --menu "Choose how to boot the ARM VM:" 12 60 3 \
  1 "Predefined OS Template (e.g. Alpine, Ubuntu, etc.)" \
  2 "Enter a direct download URL (ARM .iso or .img)" \
  3 "Use your own ISO/Image from ~/qemu-arm") || exit
clear

case "$BOOT_CHOICE" in
  1)
    BOOT=$(dialog --stdout --menu "Select an ARM OS template:" 20 60 14 \
      alpine "Alpine Linux" \
      ubuntu "Ubuntu Desktop" \
      ubuntus "Ubuntu Server" \
      debian "Debian" \
      fedora "Fedora" \
      arch "Arch Linux" \
      kali "Kali Linux" \
      nixos "NixOS" \
      rocky "Rocky Linux" \
      alma "Alma Linux" \
      suse "OpenSUSE" \
      oracle "Oracle Linux" \
      gentoo "Gentoo" \
      cachy "CachyOS") || exit
    USE_LOCAL_IMAGE=0
    ;;
  2)
    BOOT=$(dialog --stdout --inputbox "Enter direct download URL for ARM ISO or IMG:" 8 60) || exit
    USE_LOCAL_IMAGE=0
    ;;
  3)
    mapfile -t ISO_FILES < <(find "$ISO_DIR" -maxdepth 1 -type f \( -iname "*.iso" -o -iname "*.img" -o -iname "*.qcow2" \))
    if [ ${#ISO_FILES[@]} -eq 0 ]; then
      dialog --msgbox "No ISO or IMG files found in $ISO_DIR." 8 50
      clear
      exit 1
    fi
    ISO_MENU=()
    for f in "${ISO_FILES[@]}"; do ISO_MENU+=("$f" "$(basename "$f")"); done
    LOCAL_ISO=$(dialog --stdout --menu "Select a local ARM image:" 20 70 10 "${ISO_MENU[@]}") || exit
    USE_LOCAL_IMAGE=1
    ;;
esac
clear

# Resources
RAM_SIZE=$(dialog --stdout --inputbox "Enter RAM size (e.g. 4G):" 8 45 "2G") || exit
CPU_CORES=$(dialog --stdout --inputbox "Enter CPU cores (e.g. 2):" 8 45 "2") || exit
DISK_SIZE=$(dialog --stdout --inputbox "Enter Disk size (e.g. 16G):" 8 45 "16G") || exit

# VGA / resolution
USE_VGA=$(dialog --stdout --yesno "Enable virtio-gpu support for higher display resolutions?" 6 60 && echo "virtio-gpu" || echo "")

# Boot mode
BOOT_MODE=$(dialog --stdout --menu "Boot mode:" 10 50 2 \
  uefi "UEFI (default)" \
  legacy "Legacy BIOS") || exit

# Debug
DEBUG=$(dialog --stdout --yesno "Enable QEMU debug logs?" 6 40 && echo "Y" || echo "N")

clear

# Build Docker command
DOCKER_CMD="docker run -d \
  --name qemu_vm_arm \
  -e RAM_SIZE=\"$RAM_SIZE\" \
  -e CPU_CORES=\"$CPU_CORES\" \
  -e DISK_SIZE=\"$DISK_SIZE\" \
  -e DEBUG=\"$DEBUG\" \
  -e BOOT_MODE=\"$BOOT_MODE\" \
  -p $VM_PORT:8006 \
  --device=/dev/kvm \
  --device=/dev/net/tun \
  --cap-add NET_ADMIN \
  -v \"$ISO_DIR:/storage\" \
  --stop-timeout 120"

[ -n "$USE_VGA" ] && DOCKER_CMD+=" -e VGA=\"$USE_VGA\""
[ "$USE_LOCAL_IMAGE" -eq 1 ] && DOCKER_CMD+=" -v \"$LOCAL_ISO:/boot.iso\"" || DOCKER_CMD+=" -e BOOT=\"$BOOT\""
DOCKER_CMD+=" qemux/qemu-arm"

# Launch
eval "$DOCKER_CMD"

MSG="ARM QEMU VM is running!

Access it via browser:
  http://localhost:$VM_PORT

Resources:
  RAM: $RAM_SIZE
  CPU: $CPU_CORES
  Disk: $DISK_SIZE
  VGA: $USE_VGA

Disk Image: $ISO_DIR
You can manage this container via Docker CLI or Portainer."

dialog --title "ARM VM Launched" --msgbox "$MSG" 20 60
clear

