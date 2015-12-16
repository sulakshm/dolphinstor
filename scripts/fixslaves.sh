#!/bin/bash
NODES=""
i=0

mkdir -p /opt/nodes
chmod 0755 /opt/nodes

rm -f /opt/nodes/minions*

for ip in "$@"
do
    NODE="demo-minion-$i"
    sed -i "/$NODE/d" /etc/hosts
    echo "$ip $NODE" >> /etc/hosts
    echo $NODE >> /opt/nodes/minions
    echo "$ip" >> /opt/nodes/minions.ip
    sed -i "/$NODE/,+1d" /etc/ssh/ssh_config
    NODES="$NODES $NODE"
    i=$[i+1]
done

echo "Host $NODES" >> /etc/ssh/ssh_config
echo "  StrictHostKeyChecking no" >> /etc/ssh/ssh_config
