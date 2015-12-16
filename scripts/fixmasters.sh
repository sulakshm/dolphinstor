#!/bin/bash
NODES=""
i=0

mkdir -p /opt/nodes
chmod 0755 /opt/nodes

rm -f /opt/nodes/masters*

echo "etcdcluster:" > /srv/pillar/etcdcluster.sls
for ip in "$@"
do
    NODE="demo-master-$i"
    sed -i "/$NODE/d" /etc/hosts
    echo "$ip $NODE" >> /etc/hosts
    echo $NODE >> /opt/nodes/masters
    echo "$ip" >> /opt/nodes/masters.ip
    echo "  - $NODE:" >> /srv/pillar/etcdcluster.sls
    echo "     $ip" >> /srv/pillar/etcdcluster.sls

    sed -i "/$NODE/,+1d" /etc/ssh/ssh_config
    NODES="$NODES $NODE"
    i=$[i+1]
done

echo "Host $NODES" >> /etc/ssh/ssh_config
echo "  StrictHostKeyChecking no" >> /etc/ssh/ssh_config
