#!/bin/bash

for host in {tc-prod1,tc-prod2,test,db,rp,tools} 
do virsh domifaddr $host | grep vnet | awk '{ print $4 }' | awk -F/ -v HOST="$host" '{ print $1 " " HOST}' 
done
