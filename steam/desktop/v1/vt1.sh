#!/bin/bash
#------------------------------------------------
conty=/userdata/system/pro/steam/conty.sh
#------------------------------------------------
export DISPLAY=:1
batocera-mouse show
killall -9 steam steamfix steamfixer 2>/dev/null
#------------------------------------------------
"$conty" \
        --bind /userdata/system/containers/storage /var/lib/containers/storage \
        --bind /userdata/system/flatpak /var/lib/flatpak \
        --bind /userdata/system/etc/passwd /etc/passwd \
        --bind /userdata/system/etc/group /etc/group \
        --bind /var/run/nvidia /var/run/nvidia \
        --bind /userdata/system /home/batocera \
        --bind /sys/fs/cgroup /sys/fs/cgroup \
        --bind /userdata/system /home/root \
        --bind /userdata/system /home \
        --bind /etc/fonts /etc/fonts \
        --bind /userdata /userdata \
        --bind /newroot /newroot \
        --bind / /batocera \
bash -c 'prepare && ulimit -c unlimited && sysctl -w fs.inotify.max_user_watches=8192000 vm.max_map_count=2147483642 fs.file-max=8192000 >/dev/null 2>&1 && export LANG=en_US.UTF-8 && export LC_ALL=en_US.UTF-8 && dbus-run-session xfce4-session --display=:1 '"${@}"''
#------------------------------------------------
# batocera-mouse hide
#------------------------------------------------

