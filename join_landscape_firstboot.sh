#!/usr/bin/env bash

#This script joins new VMs to the landscape server.
#Script is activated on templates with #update-rc.d aplfirstboot defaults

ISINSTALLED="/usr/bin/landscape-client"
ISHOSTBASE=$(hostname)
CONFFILE="/etc/landscape/client.conf"


release_check(){
        if [[ $(lsb_release -sc) == 'xenial' ]]; then
                echo "xenial16"

        elif [[ $(lsb_release -sc) == 'trusty' ]]; then
                echo "trusty14"
         
        elif [[ $(lsb_release -sc) == 'artful' ]]; then
                echo "artful17_10"
        
        elif [[ $(lsb_release -sc) == 'zesty' ]]; then
                echo "zesty17"

        else
                lsb_release -sc
        fi
}


landscape_config(){


        /usr/bin/landscape-config --silent \
        --computer-title "$(hostname)" \
        --ssl-public-key=/etc/ssl/certs/landscape_key.pem \
        --account-name standalone -p jhuapl-landscape \
        --script-users=ALL \
        --url https://apl-landscape.jhuapl.edu/message-system \
        --ping-url http://apl-landscape.jhuapl.edu/ping \
        --tags=$(release_check)
}

remove_script(){
        if [ $? -eq 0 ]; then
                update-rc.d -f aplfirstboot remove &>/dev/null
                rm -f /etc/init.d/aplfirstboot &>/dev/null
        else
                echo "Landscape client package could not be installed" > /tmp/landscape_error
                exit 1
        fi
}


#Main processing
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
