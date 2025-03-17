#!/bin/bash

dialog --msgbox "Portmaster will be installed to ports. It will usually launch on the second launch attempt.\n\nGame compatibility varies." 10 60
cd /userdata/system
rm -f Install.Full.PortMaster.sh
wget https://github.com/PortsMaster/PortMaster-GUI/releases/download/2025.03.07-1324/Install.Full.PortMaster.sh
chmod +x Install.Full.PortMaster.sh
(./Install.Full.PortMaster.sh)
rm Install.Full.PortMaster.sh
dialog --msgbox "Portmaster is installed to ports. Refresh/update the gamelist. It will usually launch on the second launch attempt. You may need to force close it if it hangs on the portmaster logo on first launch.\n\nGame compatibility varies." 10 60

echo "Install finished - You should see a new entry in ports after rebooting. It usually launches on the second attempt. You may need to force close it if it hangs on the portmaster logo on first launch"

