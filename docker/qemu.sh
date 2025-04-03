#!/bin/bash

BACKTITLE="Docker QEMU Virtual Machine Setup"
architecture=$(uname -m)
ISO_DIR="$HOME/qemu"
NETBOOT_URL="https://boot.netboot.xyz/ipxe/netboot.xyz.iso"

# Check architecture
if [ "$architecture" != "x86_64" ]; then
    dialog --title "Architecture Error" --msgbox "This script only runs on x86_64 CPUs, not $architecture." 10 50
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

# Port selection
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

# Boot method
BOOT_CHOICE=$(dialog --stdout --menu "Choose how to boot the VM:" 12 60 3 \
  1 "Predefined OS Template (e.g. Ubuntu, Alpine, etc.)" \
  2 "Use netboot.xyz universal ISO (downloads if needed)" \
  3 "Use your own ISO/Image from ~/qemu") || exit
clear

case "$BOOT_CHOICE" in
  1)
    BOOT=$(dialog --stdout --menu "Select an OS template:" 20 60 18 \
      alpine "Alpine Linux" \
      ubuntu "Ubuntu Desktop" \
      ubuntus "Ubuntu Server" \
      debian "Debian" \
      fedora "Fedora" \
      arch "Arch Linux" \
      kali "Kali Linux" \
      mint "Linux Mint" \
      manjaro "Manjaro" \
      nixos "NixOS" \
      rocky "Rocky Linux" \
      alma "Alma Linux" \
      suse "OpenSUSE" \
      oracle "Oracle Linux" \
      tails "Tails" \
      gentoo "Gentoo" \
      kubuntu "Kubuntu" \
      xubuntu "Xubuntu" \
      cachy "CachyOS") || exit
    USE_LOCAL_IMAGE=0
    ;;
  2)
    LOCAL_ISO="$ISO_DIR/netboot.xyz.iso"
    if [ ! -f "$LOCAL_ISO" ]; then
      dialog --title "Downloading" --infobox "Downloading netboot.xyz ISO..." 6 50
      curl -L -o "$LOCAL_ISO" "$NETBOOT_URL"
    fi
    USE_LOCAL_IMAGE=1
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
    LOCAL_ISO=$(dialog --stdout --menu "Select a local image:" 20 70 10 "${ISO_MENU[@]}") || exit
    USE_LOCAL_IMAGE=1
    ;;
esac
clear

# Resources
RAM_SIZE=$(dialog --stdout --inputbox "Enter RAM size (e.g. 4G):" 8 45 "4G") || exit
CPU_CORES=$(dialog --stdout --inputbox "Enter CPU cores (e.g. 2):" 8 45 "2") || exit
DISK_SIZE=$(dialog --stdout --inputbox "Enter Disk size (e.g. 32G):" 8 45 "32G") || exit

# Disk type
DISK_TYPE=$(dialog --stdout --menu "Choose disk interface type:" 10 50 3 \
  scsi "Default (virtio-scsi)" \
  blk "Fast (virtio-blk)" \
  ide "Compatible (slow)") || exit

# Boot mode
BOOT_MODE=$(dialog --stdout --menu "Boot mode:" 10 50 2 \
  uefi "UEFI (default)" \
  legacy "Legacy BIOS") || exit

# Debug toggle
DEBUG=$(dialog --stdout --yesno "Enable debug logging?" 6 40 && echo "Y" || echo "N")

clear

# Final Docker run
DOCKER_CMD="docker run -d \
  --name qemu_vm \
  -e RAM_SIZE=\"$RAM_SIZE\" \
  -e CPU_CORES=\"$CPU_CORES\" \
  -e DISK_SIZE=\"$DISK_SIZE\" \
  -e DISK_TYPE=\"$DISK_TYPE\" \
  -e BOOT_MODE=\"$BOOT_MODE\" \
  -e DEBUG=\"$DEBUG\" \
  -p $VM_PORT:8006 \
  --device=/dev/kvm \
  --device=/dev/net/tun \
  --cap-add NET_ADMIN \
  -v \"$ISO_DIR:/storage\" \
  --stop-timeout 120"

if [ "$USE_LOCAL_IMAGE" -eq 1 ]; then
  DOCKER_CMD+=" -v \"$LOCAL_ISO:/boot.iso\""
else
  DOCKER_CMD+=" -e BOOT=\"$BOOT\""
fi

DOCKER_CMD+=" qemux/qemu"

# Execute
eval "$DOCKER_CMD"

# Final message
MSG="Your QEMU VM is running!

Access it via your browser:
  http://localhost:$VM_PORT

Resources:
  RAM: $RAM_SIZE
  CPU: $CPU_CORES
  Disk: $DISK_SIZE
  Disk Type: $DISK_TYPE
  Boot Mode: $BOOT_MODE

Files are stored in: $ISO_DIR
You can manage the container via Docker CLI or Portainer."

dialog --title "VM Launched" --msgbox "$MSG" 20 60
clear
