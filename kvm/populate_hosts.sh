#!/bin/bash

for host in {tc-prod-1,tc-prod-2,test,db,rp,ci-tools} 
do virsh domifaddr $host | grep vnet | awk '{ print $4 }' | awk -F/ -v HOST="$host" '{ print $1 " " HOST}' 
done
