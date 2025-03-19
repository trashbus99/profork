#!/usr/bin/bash
# this FILE is public domain, by @ryancnelson on github, 2023
# to be used with a tarball ryan is currently providing at 
# licenses on stuff in that tarball are still their own, from the original source

## bail out if error:
set -e


mychrootdir=/userdata/system/alpine
# if mychrootdir exists, then exit
if [ -d $mychrootdir ]; then
    echo "directory $mychrootdir already exists, exiting"
    echo "if you want to start over, "
    echo "probably run something like: " 
    
    echo "umount $mychrootdir/dev"
    echo "umount $mychrootdir/proc"
    echo "umount $mychrootdir/sys"
    echo "rm -rf $mychrootdir"

    echo "and run this script again"
    exit 1
fi


mkdir -p $mychrootdir
cd $mychrootdir


# fetch the 'xpkg' aarch64 binary that we'd expect to run on your powkiddy x55
curl -L  -O https://github.com/pkgxdev/pkgx/releases/download/v1.1.1/pkgx-1.1.1+linux+aarch64.tar.xz
tar -xvf pkgx-1.1.1+linux+aarch64.tar.xz
chmod +x pkgx
./pkgx git clone https://github.com/ryancnelson/x55-jelos-alpinechroot $mychrootdir/$mychrootdir-temp

mv $mychrootdir/$mychrootdir-temp/* $mychrootdir/


mkdir -p ${mychrootdir}/dev
mkdir -p ${mychrootdir}/proc
mkdir -p ${mychrootdir}/sys

mount -o bind /dev  ${mychrootdir}/dev
mount -o bind /proc ${mychrootdir}/proc
mount -o bind /sys  ${mychrootdir}/sys

cp -L /etc/resolv.conf ${mychrootdir}/etc/resolv.conf


## i have hardcoded "http://mirror.clarkson.edu/alpine/latest-stable/main" in 
# /etc/apk/repositories , as this script is intended to work with a tarball of my 
# own creation, which is where this bit is hardcoded.
# So, do nothing re: apk here


echo now you should \'"chroot $mychrootdir /bin/bash -l "\'
