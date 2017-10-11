#!/usr/bin/env bash

#This script joins new VMs to the landscape server and it resides on the 

landscape_config(){

#Chanage tag accordingly!!!

/usr/bin/landscape-config --silent \
--computer-title "$(hostname)" \
--ssl-public-key=/etc/ssl/certs/landscape_key.pem \
--account-name standalone -p jhuapl-landscape \
--script-users=ALL \
--url https://apl-landscape.jhuapl.edu/message-system \
--ping-url http://apl-landscape.jhuapl.edu/ping \
--tags=generic
}

ISINSTALLED="/usr/bin/landscape-client"
ISHOSTBASE=$(hostname)
CONFFILE="/etc/landscape/client.conf"

if [[ ${ISHOSTBASE,,} = *base* ]]; then
        exit 1

elif [ -e $CONFFILE ] && [ -e $ISINSTALLED ]; then
        cat /dev/null > $CONFFILE
        landscape_config
else
        apt update
        apt -y install landscape-client
        if [ $? -eq 0 ]; then
                landscape_config
                rm -f /etc/init.d/aplfirstboot
        else
                echo "Landscape client package could not be installed"
                exit 1
        fi
fi
