#!/bin/bash

ceph osd pool create blkdocker 16 16

# create a comma separated list of masters
MONITORS=$(printf ",%s" `cat /opt/nodes/masters.ip`)
MONITORS=${MONITORS:1}

# Initialize config on both plugins and test top level path
for NODE in plugins test; do 
  etcdctl set /$NODE/dolphinstor/config/global "{\"defaultCtl\":\"dsCeph\", \"volumeCtrls\":[\"dsCeph\", \"dsRam\", \"dsLocal\"}"
  etcdctl set /$NODE/dolphinstor/config/dsCeph "{\"pool\":\"blkdocker\", \"monitors\":[\"$MONITORS\"]}"
done
