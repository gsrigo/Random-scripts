#!/usr/bin/env bash

#This script will add the necessary info/files in order for $USER to have access to the client host.

USER="ansible"
DIR="/home/$USER/.ssh/"
ID_RSA_PUB="ssh-rsa blahblah"

#Creating a user
create_user()
{
if [ ! "$(id -u $USER 2> /dev/null)" ]; then
	if [ -f /etc/lsb-release ]; then
		useradd -m -d /home/$USER -s /bin/bash $USER &&
		echo "User created"
	
	elif [ -f /etc/redhat-release ]; then
                useradd -m -d /home/$USER -s /bin/bash $USER &&
                echo "User created"
	fi
else
	echo "User exists. Checking ssh folder..."
fi
}

#Creating ssh dir and copying the ssh key
create_ssh_dir()
{
if [ ! -f "$DIR"/authorized_keys ]; then
        mkdir -p $DIR
	touch $DIR/authorized_keys       
        chown -R $USER $DIR
        chmod 644 $DIR/authorized_keys
	echo $ID_RSA_PUB > $DIR/authorized_keys &&
	echo "SSH Keys succesfully copied"
else
	echo "SSH folder already exists.Please check you have the apporpiate keys"
fi
}


#Adding an entry to the sudoers file for passwordless sudo of this user
passwordless_access()
{
	#sed -i '/includedir/s/^#//g' /etc/sudoers
	echo "$USER	ALL = NOPASSWD: ALL" > /etc/sudoers.d/$USER	
}

#Running...
create_user
create_ssh_dir
passwordless_access
