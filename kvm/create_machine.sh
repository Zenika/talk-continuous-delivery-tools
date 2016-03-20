#!/bin/bash

display_usage() { 
	echo -e "\nUsage:\n$0 nom-machine \n" 
	} 

if [  $# -le 0 ] 
	then 
		display_usage
		exit 1
	fi 

vmname=$1

create_disk() {
	qemu-img create -f qcow2 -b $PWD/templates/wily-server-cloudimg-amd64-disk1.img vms/$vmname.img 8G
}

create_files() {
	envsubst < templates/meta-data > build/meta-data
	envsubst < templates/vm_template.xml > build/vm.xml
	cp templates/user-data build/user-data
}

create_iso() {
	genisoimage -output isos/$vmname.iso -volid cidata -joliet -rock build/user-data build/meta-data
}

create_vm() {
	virsh create build/vm.xml
}

cleanup() {
	rm -f build/*
}

export vmname 

create_disk
create_files
create_iso
create_vm
cleanup

echo "$vmname : done"


