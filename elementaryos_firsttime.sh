#!/usr/bin/env bash


#Clean up
echo "system is cleaning up unnecessary stuff..."
apt purge -y epiphany-browser epiphany-browser-data



#Donwloading ppas
echo "downloading necessary ppas for cool stuff"

add-apt-repository ppa:philip.scott/elementary-tweaks -y 
#apt-add-repository ppa:ansible/ansible -y 
add-apt-repository ppa:umang/indicator-stickynotes -y 
apt-add-repository ppa:numix/ppa -y 
#apt-add-repository ppa:cubic-wizard/release -y 
add-apt-repository ppa:eugenesan/ppa -y



#Installing stuff
echo "Installing a list of software I use..."
apt -y install elementary-tweaks zenity tlp tlp-rdw firefox gdebi libreoffice gnome-system-monitor flashplugin-installer pepperflashplugin-nonfree transmission wine openssh-server evolution numix-icon-theme-circle gnome-disk-utility cifs-utils remmina simplenotes keepassx

echo " "
echo "installing other stuff"
apt -y install openjdk-8-jre openjdk-8-jdk ubuntu-restricted-extras libavcodec-extra ffmpeg


echo "installing chrome..."
apt -y install libxss1 libappindicator1 libindicator7
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb
apt -y install -f
rm google-chrome*.deb

echo "install spotify"
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410 -y
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
apt update && apt -y install spotify-client
#Patching and rebooting if necessary
echo "System is updating...."
apt update && apt -y install software-properties-common && apt upgrade -y && apt -y autoremove

#rebooting 
if [ -e /var/run/reboot-required ];then
    echo "system is going to reboot now..."
    reboot
fi


echo "....whoa....done!"
