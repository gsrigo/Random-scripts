#!/usr/bin/env bash

#This script assumes that the root partition exists and it's using LVM!!

#Global Info about disks and LVM
ROOTLV=$(ls -l /dev/mapper/*root | awk '{print $9}')
ROOTVG=$(vgdisplay | grep "VG Name" | awk '{print $3}')
#DEVDISKS=$(fdisk -l | grep -o '/dev/sd[b-z]')
DISKS=$(ls /dev/sd* | grep -v '[0-9]')

#fdisk to to initialize partition 1 and create an lvm disk type
fdisk_options(){
echo n
echo p
echo 1
echo
echo
echo t
echo 8e
echo w
}

#Main
#Check on all disks and initialize the ones that do not have partitions.
# if the initialization is successful, the script adds the partition number 1
#and proceeds with extending the root partition.
for disk in $(echo ${DISKS[@]}); do
    newdisk=$(ls ${disk}* | grep '[0-5]')
    
    if [ -z "$newdisk" ]; then
        fdisk_options | fdisk $disk &> /dev/null
        
        if [ $? -eq 0 ]; then
            part="1"
            initdisk="$disk$part"
            pvcreate $initdisk
            vgextend $ROOTVG $initdisk
            lvextend -l +100%FREE $ROOTLV
        
            if [ $? -eq 0 ]; then
                resize2fs $ROOTLV
                echo "DONE!"
            else
                echo "something failed with LVM pvcreate or vgextend"
            fi
        
        else
            "disk failed to initialized, issue with fdisk"
        fi
    else
        echo "$disk has a partition. No new disks on system"
    fi
done
