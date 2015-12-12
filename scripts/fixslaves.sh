#!/bin/bash
NODES=""
i=0

mkdir -p /opt/nodes
chmod 0755 /opt/nodes

for ip in "$@"
do
    NODE="demo-minion-$i"
    echo "$ip $NODE" >> /etc/hosts
    echo $NODE >> /opt/nodes/minions
    echo "$ip" >> /opt/nodes/minions.ip
    NODES="$NODES $NODE"
    i=$[i+1]
done

echo "Host $NODES" >> /etc/ssh/ssh_config
echo "  StrictHostKeyChecking no" >> /etc/ssh/ssh_config
