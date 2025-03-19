#!/usr/bin/bash
# This FILE is public domain, by @ryancnelson on GitHub, 2023
# To be used with a tarball provided by Ryan.
# (Licenses on files in that tarball are still their respective owners’.)

## Bail out if error:
set -e

mychrootdir="/userdata/system/alpine"
# If mychrootdir exists, then exit
if [ -d "$mychrootdir" ]; then
    echo "Directory $mychrootdir already exists, exiting."
    echo "If you want to start over, try something like:"
    echo "umount $mychrootdir/dev"
    echo "umount $mychrootdir/proc"
    echo "umount $mychrootdir/sys"
    echo "rm -rf $mychrootdir"
    echo "Then run this script again."
    exit 1
fi

mkdir -p "$mychrootdir"
cd "$mychrootdir"

# Fetch the 'xpkg' aarch64 binary expected to run on your device.
curl -L -O https://github.com/pkgxdev/pkgx/releases/download/v1.1.1/pkgx-1.1.1+linux+aarch64.tar.xz
tar -xvf pkgx-1.1.1+linux+aarch64.tar.xz
chmod +x pkgx

# Define a temporary directory outside of mychrootdir for the clone.
temp_dir="${mychrootdir}-temp"

# Use pkgx to clone the Alpine chroot repository into the temporary directory.
./pkgx git clone https://github.com/ryancnelson/x55-jelos-alpinechroot "$temp_dir"

# Move the cloned contents into mychrootdir.
mv "$temp_dir"/* "$mychrootdir/"

# Set up necessary directories for the chroot.
mkdir -p "${mychrootdir}/dev"
mkdir -p "${mychrootdir}/proc"
mkdir -p "${mychrootdir}/sys"

mount -o bind /dev  "${mychrootdir}/dev"
mount -o bind /proc "${mychrootdir}/proc"
mount -o bind /sys  "${mychrootdir}/sys"

cp -L /etc/resolv.conf "${mychrootdir}/etc/resolv.conf"

echo "Now you should run: chroot $mychrootdir /bin/bash -l"
