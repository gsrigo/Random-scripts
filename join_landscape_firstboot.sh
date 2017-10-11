#!/usr/bin/env bash

#This script joins new VMs to the landscape server.
#Script is activated on templates with #update-rc.d aplfirstboot defaults

ISINSTALLED="/usr/bin/landscape-client"
ISHOSTBASE=$(hostname)
CONFFILE="/etc/landscape/client.conf"

landscape_config(){

        /usr/bin/landscape-config --silent \
        --computer-title "$(hostname)" \
        --ssl-public-key=/etc/ssl/certs/landscape_key.pem \
        --account-name standalone -p jhuapl-landscape \
        --script-users=ALL \
        --url https://apl-landscape.jhuapl.edu/message-system \
        --ping-url http://apl-landscape.jhuapl.edu/ping \
        --tags=xenial16,dev
}

remove_script(){
        if [ $? -eq 0 ]; then
                update-rc.d -f aplfirstboot remove
                rm -f /etc/init.d/aplfirstboot
        else
                echo "Landscape client package could not be installed" > /tmp/landscape_error
                exit 1
        fi
}


if [[ ${ISHOSTBASE,,} = *base* ]]; then
        exit 1

elif [ -e $CONFFILE ] && [ -e $ISINSTALLED ]; then
        cat /dev/null > $CONFFILE
        landscape_config
        remove_script

else
        apt update
        apt -y install landscape-client
	landscape_config
        remove_script
fi
