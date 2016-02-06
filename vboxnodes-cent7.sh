#!/bin/bash
# Copyright (c) 2015 Grace Thompson Rights Reserved.
# Create virtualbox VM's automatically
# Version: Centos 7.1
# Update $ISO path as needed


printUsage() {
  echo "vboxnodes-cent7.sh (vmhostname)"
  echo "Ex: vboxnodes-cent7.sh linux0101"
}

ISO="/home/gracie/iso/CentOS-7-x86_64-DVD-1511.iso"

[[ -n "$1" ]] || printUsage

echo "Setting up VM $NAME"

for NAME in $1 ; do
  cd ~
  VBoxManage createvm --name $NAME --register --ostype RedHat_64
  VBoxManage createhd --filename $NAME.vdi --size 8000
  VBoxManage modifyvm $NAME --memory 2048 --acpi on --boot1 dvd --boot2 disk \
             --nic1 hostonly --hostonlyadapter1 "vboxnet0"
  VBoxManage storagectl $NAME --name "SATA Controller" --add sata --portcount 1
  VBoxManage storageattach $NAME --storagectl "SATA Controller" \
             --port 0 --device 0 --type hdd --medium $NAME.vdi
  VBoxManage storageattach $NAME --storagectl "SATA Controller" \
             --port 1 --device 0 --type dvddrive \
             --medium $ISO

echo ""
echo "VM $NAME has been successfully created"

done
