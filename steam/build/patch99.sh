#!/bin/bash
echo
echo "-----------------------------------------"
echo "RUNNING ADDITIONAL BATOCERA CONTY PATCHES"
echo "-----------------------------------------"
echo
#--------------------------------------------------------------------------------------------
# prepare/preload
#	echo -e "\n\n\nfixing nvidia ld.so.cache"
#		rm /usr/bin/prepare 2>/dev/null
#		rm /usr/bin/preload 2>/dev/null
#			wget -q --tries=30 -O /usr/bin/prepare "https://github.com/trashbus99/profork/raw/master/steam/build/prepare.sh"
#				dos2unix /usr/bin/prepare 2>/dev/null 
#					cp /usr/bin/prepare /usr/bin/preload 2>/dev/null
#--------------------------------------------------------------------------------------------
#fix for nvidia lutris
#	echo -e "\n\n\nfixing lutris"
#		mkdir -p /opt 2>/dev/null 
#		rm -rf /opt/lutris 2>/dev/null
#		cd /opt
#			git clone https://github.com/lutris/lutris
#			sed -i 's,os.geteuid() == 0,os.geteuid() == 888,g' /opt/lutris/lutris/gui/application.py 2>/dev/null
#			cp $(which lutris) /usr/bin/lutris-git 2>/dev/null
#			rm $(which lutris) 2>/dev/null
#			  wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /usr/bin/lutris https://github.com/trashbus99/profork/raw/master/steam/build/lutris.sh
#				  dos2unix /usr/bin/lutris 2>/dev/null
#--------------------------------------------------------------------------------------------
# add ~/.bashrc&profile env
	echo -e "\n\n\nfixing .bashrc and .profile"
		rm ~/.bashrc
			echo '#!/bin/bash' >> ~/.bashrc
			echo 'ulimit -H -n 819200 && ulimit -S -n 819200 && sysctl -w fs.inotify.max_user_watches=8192000 vm.max_map_count=2147483642 fs.file-max=8192000 >/dev/null 2>&1' >> ~/.bashrc
			echo 'export XDG_CURRENT_DESKTOP=XFCE' >> ~/.bashrc
			echo 'export DESKTOP_SESSION=XFCE' >> ~/.bashrc
			echo 'export DISPLAY=:0.0' >> ~/.bashrc
			echo 'export GDK_SCALE=1' >> ~/.bashrc
			echo 'export USER=root' >> ~/.bashrc
				dos2unix ~/.bashrc 2>/dev/null
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
# fix borked faudio repo
	echo -e "\n\n\nfixing faudio staging"
		yes "Y" | pacman -S gstreamer
		yes "Y" | pacman -S faudio
			cd /tmp/
				f=/tmp/lib32faudio.pkg.tar.zst
				#link=https://builds.garudalinux.org/repos/chaotic-aur/x86_64/lib32-faudio-tkg-git-24.02.r0.g38e9da7-1-x86_64.pkg.tar.zst
				link=https://github.com/trashbus99/profork/raw/master/steam/build/lib32-faudio-tkg-git.pkg.tar.zst
					wget -q --show-progress --tries=30 -O "$f" "$link"
					yes "Y" | pacman -U "$f" --overwrite='*' && rm "$f"
			cd ~/
#--------------------------------------------------------------------------------------------
# fix samba collisions 
	echo -e "\n\n\nfixing samba"
		rm /usr/bin/samba* 2>/dev/null
		rm /usr/bin/smb* 2>/dev/null
		rm -rf ~/build 2>/dev/null
#--------------------------------------------------------------------------------------------
# purge baloo 
	echo -e "\n\n\npurging baloo"
		rm /bin/baloo* 2>/dev/null &
		rm /usr/bin/baloo* 2>/dev/null &
		rm /usr/lib/baloo* 2>/dev/null &
		rm -rf  /usr/include/KF6/Baloo 2>/dev/null &
		rm $(which baloo_file_extractor) 2>/dev/null &
		rm -rf /etc/xdg/autostart/baloo* 2>/dev/null &
		rm -rf /var/lib/pacman/local/baloo* 2>/dev/null &
		rm -rf $(find /usr/lib | grep baloo) 2>/dev/null &
		rm $(find /usr/share/doc | grep baloo) 2>/dev/null &
		rm $(find /usr/share/locale | grep baloo) 2>/dev/null &
		rm -rf /usr/share/qlogging-categories6/baloo* 2>/dev/null &
		rm -rf /usr/share/dbus-1/interfaces/org.kde.baloo* 2>/dev/null &
			wait
#--------------------------------------------------------------------------------------------
# add basic pacman support
	echo -e "\n\n\nadding basic pacman support"
		mkdir -p /opt/pacman/lib /opt/pacman/cache 2>/dev/null
	 	cp -r /etc/pacman* /opt/pacman/ 2>/dev/null
	 	cp -r /var/lib/pacman/* /opt/pacman/lib/ 2>/dev/null
		cp -r /var/cache/pacman/* /opt/pacman/cache/ 2>/dev/null  
			p=/usr/bin/pacman
			mv "$(which pacman)" "/usr/bin/realpacman" 2>/dev/null
				echo '#!/bin/bash' >> $p
				echo 'if [[ "$(echo "${@}" | grep overwrite)" = "" ]]; then' >> $p
				echo '  realpacman "${@}" ' >> $p
				echo 'else' >> $p
				echo '  realpacman "${@}" ' >> $p
				echo 'fi' >> $p
				echo 'exit 0' >> $p
					dos2unix $p 2>/dev/null && chmod 777 $p 2>/dev/null
#--------------------------------------------------------------------# --------------------------------------------------------------------------------------------

#------------------------

# rootpatch makepkg
	sed -i 's,EUID == 0,EUID == 8888,g' $(which makepkg) 2>/dev/null
#--------------------------------------------------------------------------------------------
	rm $f 2>/dev/null
	rm $h 2>/dev/null
		ldconfig
			echo
			echo
			echo "--------"
			echo "  DONE"
			echo "--------"
			echo
			echo
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
# 
#--------------------------------------------------------------------------------------------
exit 0
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
#
# obsolete:
