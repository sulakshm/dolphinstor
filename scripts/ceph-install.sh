#!/bin/bash

mkdir -p $HOME/my-cluster
cd $HOME/my-cluster

echo "1. Preparing for ceph deployment"
ceph-deploy --username cephadm new demo-master-0
echo "osd pool default size = 2" >> ceph.conf
echo "osd pool default pg num = 16" >> ceph.conf
echo "osd pool default pgp num = 16" >> ceph.conf
echo "public network = `cat /opt/nodes/admin.private`/16" >> ceph.conf

echo "2. Installing ceph components"
ceph-deploy --username cephadm install --release hammer demo-admin

for node in `cat /opt/nodes/masters`
do
    ceph-deploy --username cephadm install $node
done

for node in `cat /opt/nodes/minions`
do
    ceph-deploy --username cephadm install $node
done

echo "3. Add monitor and gather the keys"
ceph-deploy --username cephadm mon create-initial

echo "4. Create OSD directory on each minions"
i=0
OSD=""
for node in `cat /opt/nodes/minions`
do
    ssh $node sudo mkdir -p /var/local/osd$i
    OSD="$OSD $node:/var/local/osd$i"
    i=$[i+1]
done

echo "5. Prepare OSD on minions - $OSD"
ceph-deploy --username cephadm osd prepare $OSD

echo "6. Activate OSD on minions"
ceph-deploy --username cephadm osd activate $OSD

echo "7. Copy keys to all nodes"
ceph-deploy --username cephadm admin demo-admin 
for node in `cat /opt/nodes/masters`
do
    ceph-deploy --username cephadm admin $node
done

for node in `cat /opt/nodes/minions`
do
    ceph-deploy --username cephadm admin $node
done

echo "8. Set permission on keyring"
sudo chmod +r /etc/ceph/ceph.client.admin.keyring

