#!/bin/bash
NODES=""
i=0
for ip in "$@"
do
    echo "$ip demo-master-$i" >> /etc/hosts
    NODES="$NODES demo-master-$i"
    i=$[i+1]
done

echo "Host $NODES" >> /etc/ssh/ssh_config
echo "  StrictHostKeyChecking no" >> /etc/ssh/ssh_config
