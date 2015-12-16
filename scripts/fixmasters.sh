#!/bin/bash
NODES=""
i=0

mkdir -p /opt/nodes
chmod 0755 /opt/nodes


for ip in "$@"
do
    NODE="demo-master-$i"
    echo "$ip $NODE" >> /etc/hosts
    echo $NODE >> /opt/nodes/masters
    echo "$ip" >> /opt/nodes/masters.ip
    echo "  - $NODE:" >> /srv/pillar/etcdcluster.sls
    echo "     $ip" >> /srv/pillar/etcdcluster.sls
    NODES="$NODES $NODE"
    i=$[i+1]
done

echo "Host $NODES" >> /etc/ssh/ssh_config
echo "  StrictHostKeyChecking no" >> /etc/ssh/ssh_config
