#!/usr/bin/env bash

echo ""
echo ""
echo 'sit and chilax, patching computer...' 
echo "updating database..."
sudo apt -qq update

echo ""
echo ""
echo "upgrading computer and removing older un-needed software"
sudo apt -qq -y upgrade && sudo apt -qq -y autoremove


echo ""
echo "Patching is done!" 
echo "Removing unnecessary packages"
sudo apt -y autoremove
echo ""
echo "Done. Checking if reboot is required..."
echo ""

if [ -f /var/run/reboot-required ]; then
        zenity --question --text="Reboot is required, want to reboot now?"
        if [ $? = 0 ]; then
                sudo reboot
        else
                echo "Remember to reboot later then!" 
        fi
else
        echo "Patching is done, no need to reboot"
fi
